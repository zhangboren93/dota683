if oracle_fortunes_end_lua == nil then
	oracle_fortunes_end_lua = class({})
end

if modifier_oracle_fortunes_end_purge_lua == nil then
	modifier_oracle_fortunes_end_purge_lua = class({})
end

function oracle_fortunes_end_lua:OnSpellStart()
	self.target				= self:GetCursorTarget()
	self.channel_sound		= "Hero_Oracle.FortunesEnd.Channel"
	self.attack_sound		= "Hero_Oracle.FortunesEnd.Attack"
	self.target_sound		= "Hero_Oracle.FortunesEnd.Target"
	self.channel_particle	= "particles/units/heroes/hero_oracle/oracle_fortune_channel.vpcf"
	self.tgt_particle		= "particles/units/heroes/hero_oracle/oracle_fortune_cast_tgt.vpcf"
	self.effect_name		= "particles/units/heroes/hero_oracle/oracle_fortune_prj.vpcf"
	self.aoe_particle_name	= "particles/units/heroes/hero_oracle/oracle_fortune_aoe.vpcf"
	self.modifier_name		= "modifier_oracle_fortunes_end_purge_lua"
	
	self:GetCaster():EmitSound(self.channel_sound)

	if self:GetCaster():GetName() == "npc_dota_hero_oracle" and RandomInt(1, 100) <= 50 then		
		self:GetCaster():EmitSound("oracle_orac_fortunesend_0"..RandomInt(1, 6))
	end

	if self.fortunes_particle then
		ParticleManager:DestroyParticle(self.fortunes_particle, false)
		ParticleManager:ReleaseParticleIndex(self.fortunes_particle)
	end
	
	self.fortunes_particle = ParticleManager:CreateParticle(self.channel_particle, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(self.fortunes_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	
	self.target_particle = ParticleManager:CreateParticle(self.tgt_particle, PATTACH_ABSORIGIN_FOLLOW, self:GetCursorTarget())
	ParticleManager:ReleaseParticleIndex(self.target_particle)
end

function oracle_fortunes_end_lua:OnChannelFinish(bInterrupted)
	self:GetCaster():StopSound(self.channel_sound)
	self:GetCaster():EmitSound(self.attack_sound)
	
	if self.fortunes_particle then
		ParticleManager:DestroyParticle(self.fortunes_particle, false)
		ParticleManager:ReleaseParticleIndex(self.fortunes_particle)
	end
	
	ProjectileManager:CreateTrackingProjectile(
	{
		Target 				= self.target,
		Source 				= self:GetCaster(),
		Ability 			= self,
		EffectName 			= self.effect_name,
		iMoveSpeed			= self:GetSpecialValueFor("bolt_speed"),
		vSourceLoc 			= self:GetCaster():GetAbsOrigin(),
		bDrawsOnMinimap 	= false,
		bDodgeable 			= false,
		bIsAttack 			= false,
		bVisibleToEnemies 	= true,
		bReplaceExisting 	= false,
		flExpireTime 		= GameRules:GetGameTime() + 10.0,
		bProvidesVision 	= false,
		iSourceAttachment	= DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		
		ExtraData =
		{
			charge_pct			= ((GameRules:GetGameTime() - self:GetChannelStartTime()) / self:GetChannelTime()),
			target_sound		= self.target_sound,
			aoe_particle_name	= self.aoe_particle_name,
			modifier_name		= self.modifier_name,
		}
	})
end

function oracle_fortunes_end_lua:OnProjectileHit_ExtraData(target, location, data)
	if target and data.charge_pct and not target:TriggerSpellAbsorb(self) then
		self:ApplyFortunesEnd(target, data.target_sound, data.aoe_particle_name, data.modifier_name, data.charge_pct)
	end
end

function oracle_fortunes_end_lua:ApplyFortunesEnd(target, target_sound, aoe_particle_name, modifier_name, charge_pct)
	local radius = self:GetSpecialValueFor("radius")
	
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), target_sound, self:GetCaster())
	
	if aoe_particle_name then
		self.aoe_particle = ParticleManager:CreateParticle(aoe_particle_name, PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(self.aoe_particle, 0, target:GetAbsOrigin())
		
		ParticleManager:SetParticleControl(self.aoe_particle, 2, Vector(radius, radius, radius))
		ParticleManager:ReleaseParticleIndex(self.aoe_particle)
	end
	
	-- "Fortune's End first applies the dispel, then the debuff, then the damage."
	target:Purge(true, false, false, false, false)
	
	-- "Always removes Fate's Edict on affected targets."
	if target:HasModifier("modifier_oracle_fates_edict") then
		target:RemoveModifierByName("modifier_oracle_fates_edict")
	end
	
	if target:HasModifier("modifier_oracle_fates_edict_allie_disarm") then
		target:RemoveModifierByName("modifier_oracle_fates_edict_allie_disarm")
	end

	if target:HasModifier("modifier_oracle_fates_edict_enemy_resist") then
		target:RemoveModifierByName("modifier_oracle_fates_edict_enemy_resist")
	end
	
	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		self.damage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControl(self.damage_particle, 1, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.damage_particle, 3, enemy:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.damage_particle)
	
		enemy:Purge(true, false, false, false, false)
		
		enemy:AddNewModifier(self:GetCaster(), self, modifier_name,
			{duration = math.max(math.min(charge_pct, 1) * self:GetSpecialValueFor("maximum_purge_duration"), self:GetSpecialValueFor("minimum_purge_duration"))
			* (1 - enemy:GetStatusResistance())})

		ApplyDamage({
			victim 			= enemy,
			damage 			= self:GetSpecialValueFor("damage"),
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		})
	end
end

-- Modifier

function modifier_oracle_fortunes_end_purge_lua:GetTexture()
	return "oracle_fortunes_end"
end

function modifier_oracle_fortunes_end_purge_lua:GetEffectName()
	return "particles/units/heroes/hero_oracle/oracle_fortune_purge.vpcf"
end

function modifier_oracle_fortunes_end_purge_lua:DeclareFunctions()
    local funcs =
    {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }
    return funcs
end

function modifier_oracle_fortunes_end_purge_lua:IsDebuff()
	return true
end

function modifier_oracle_fortunes_end_purge_lua:GetModifierMoveSpeed_Max() 
    return 0.1
end

function modifier_oracle_fortunes_end_purge_lua:GetModifierMoveSpeed_Limit()
    return 0.1
end