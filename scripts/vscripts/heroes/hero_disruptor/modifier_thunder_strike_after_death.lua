modifier_thunder_strike_after_death_lua = class({})

function modifier_thunder_strike_after_death_lua:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end

function modifier_thunder_strike_after_death_lua:GetEffectName()
	return "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_buff.vpcf"
end

function modifier_thunder_strike_after_death_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW 
end

function modifier_thunder_strike_after_death_lua:OnCreated()
	if not IsServer() then return end
	local duration = self:GetDuration()
	local strikesLeftNum = math.floor(duration/2) + 1
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local radius = ability:GetSpecialValueFor("radius")
	local caster = self:GetCaster()
	local damage = ability:GetAbilityDamage()
	self:GetParent():SetThink(function()
		local part = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf",
			PATTACH_ABSORIGIN, parent)
		ParticleManager:SetParticleControlEnt(part, 0, parent, PATTACH_ABSORIGIN, "attach_hitloc", Vector(0, 0, 0), false)
		ParticleManager:ReleaseParticleIndex(part)
		parent:EmitSound("Hero_Disruptor.ThunderStrike.Target")
		local units = FindUnitsInRadius(parent:GetTeam(),
			parent:GetAbsOrigin(),
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)
		for i=1,#units do
			ApplyDamage({ victim = units[i], attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
		end
		strikesLeftNum = strikesLeftNum - 1
		if strikesLeftNum > 0 then
			return 2
		end
		parent:ForceKill(false)
	end, "thunder strike interval", duration - math.floor(duration / 2) * 2)
end
