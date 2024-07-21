sandking_epicenter_lua = {}

function sandking_epicenter_lua:OnSpellStart()
	EmitSoundOn( "Ability.SandKing_Epicenter.spell", self:GetCaster() )
end

function sandking_epicenter_lua:OnChannelFinish( bInterrupted )
	if bInterrupted then 
		StopSoundOn( "Ability.SandKing_Epicenter.spell", self:GetCaster() )
		return
	end

	local caster = self:GetCaster()
	local duration = self:GetDuration()

	caster:AddNewModifier(
		caster,
		self,
		"modifier_ability_epicenter",
		{ duration = duration }
	)

	EmitSoundOn( "Ability.SandKing_Epicenter", caster )
end

modifier_ability_epicenter = {}

function modifier_ability_epicenter:IsHidden()
	return false
end

function modifier_ability_epicenter:IsDebuff()
	return false
end

function modifier_ability_epicenter:IsPurgable()
	return false
end

function modifier_ability_epicenter:DestroyOnExpire()
	return false
end

function modifier_ability_epicenter:RemoveOnDeath()
	return false
end

function modifier_ability_epicenter:OnCreated( kv )
    local ability = self:GetAbility() 
	self.pulses = ability:GetSpecialValueFor( "epicenter_pulses" )
	self.damage = ability:GetSpecialValueFor( "epicenter_damage" )
	self.slow = ability:GetSpecialValueFor( "epicenter_slow_duration_tooltip" )

	if IsServer() then
		self.pulse = 0
		local interval = kv.duration/self.pulses

		self.damageTable = {
			attacker = self:GetParent(),
			damage = self.damage,
			damage_type = ability:GetAbilityDamageType(),
			ability = ability,
		}

		self:StartIntervalThink( interval )
	end
end

function modifier_ability_epicenter:OnIntervalThink()
	self.pulse = self.pulse + 1
	local radius = self:GetAbility():GetLevelSpecialValueFor( "epicenter_radius", self.pulse )

	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),
		self:GetParent():GetOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		0,
		false
	)

	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage(self.damageTable)

		enemy:AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_ability_epicenter_slow",
			{ duration = self.slow }
		)
	end

	self:PlayEffects( radius )

	if self.pulse>=self.pulses then
		self:Destroy()
	end
end

function modifier_ability_epicenter:PlayEffects( radius )
	local effect_cast = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_sandking/sandking_epicenter.vpcf",
		PATTACH_ABSORIGIN_FOLLOW,
		self:GetParent()
	)
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_sandking/sandking_epicenter_ring.vpcf",
		PATTACH_ABSORIGIN_FOLLOW,
		self:GetParent()
	)
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

modifier_ability_epicenter_slow = {}

function modifier_ability_epicenter_slow:IsHidden()
	return false
end

function modifier_ability_epicenter_slow:IsDebuff()
	return true
end

function modifier_ability_epicenter_slow:IsPurgable()
	return true
end

function modifier_ability_epicenter_slow:OnCreated( kv )
	self.slow = self:GetAbility():GetSpecialValueFor( "epicenter_slow" )
	self.slow_as = self:GetAbility():GetSpecialValueFor( "epicenter_slow_as" )
end

modifier_ability_epicenter_slow.OnRefresh = modifier_ability_epicenter_slow.OnCreated

function modifier_ability_epicenter_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_ability_epicenter_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_ability_epicenter_slow:GetModifierAttackSpeedBonus_Constant()
	return self.slow_as
end