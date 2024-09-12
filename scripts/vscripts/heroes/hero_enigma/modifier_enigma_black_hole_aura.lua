modifier_enigma_black_hole_aura_lua = class({
	CheckState = function()
		return {
			[ MODIFIER_STATE_DISARMED ] = true,
			[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true,
			[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true,
			[ MODIFIER_STATE_UNSELECTABLE ] = true,
			[ MODIFIER_STATE_OUT_OF_GAME ] = true,
			[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
			[ MODIFIER_STATE_INVULNERABLE ] = true
		}
	end,
	OnCreated = function(self)
		self:StartIntervalThink(0.1)
	end,
	OnIntervalThink = function(self)
		if not IsServer() then return end
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local damage = ability:GetSpecialValueFor("damage")
		local caster = self:GetCaster()
		local units = FindUnitsInRadius(parent:GetTeamNumber(),
			parent:GetAbsOrigin(), nil, 
			400, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, true)	
		local enigma_midnight_pulse = caster:FindAbilityByName("enigma_midnight_pulse")
		for i=1,#units do
			if not units[i]:HasModifier("modifier_enigma_black_hole_pull_lua") then
				units[i]:AddNewModifier(caster, ability, "modifier_enigma_black_hole_pull_lua", {
					duration = self:GetRemainingTime(),
					centerx = parent:GetAbsOrigin().x,
					centery = parent:GetAbsOrigin().y
				})
				units[i]:AddNewModifier(caster, ability, "modifier_stunned", { duration = self:GetRemainingTime() })
			end
			local distance = (units[i]:GetAbsOrigin() - parent:GetAbsOrigin()):Length2D()
			if distance > 200 then
				damage = damage / 2
			end		
			ApplyDamage({
				attacker = caster,
				victim = units[i],
				damage = damage / 10,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = ability
			})
			if caster:HasScepter() and enigma_midnight_pulse ~= nil and enigma_midnight_pulse:GetLevel() > 0 then
				ApplyDamage({
					attacker = caster,
					victim = units[i],
					damage = units[i]:GetMaxHealth() * enigma_midnight_pulse:GetSpecialValueFor("damage_percent") / 1000,
					damage_type = DAMAGE_TYPE_PURE,
					ability = ability
				})
			end
		end
	end,
	GetEffectName = function() return "particles/units/heroes/hero_enigma/enigma_blackhole.vpcf" end,
	GetEffectAttachType = function() return PATTACH_ABSORIGIN end
})
