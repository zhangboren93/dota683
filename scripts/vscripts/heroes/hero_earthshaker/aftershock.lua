--[[Author: YOLOSPAGHETTI
	Date: July 30, 2016
	Triggers an aftershock when the caster casts a spell]]
function Aftershock(keys)
	local caster = keys.caster
	local ability = keys.ability
	local aftershock_range = ability:GetLevelSpecialValueFor("aftershock_range", (ability:GetLevel() -1))
	local tooltip_duration = ability:GetLevelSpecialValueFor("tooltip_duration", (ability:GetLevel() -1))
	print(keys.event_ability:GetName())
	if not keys.event_ability:IsItem() then
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, aftershock_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		
		-- Loops through targets
		for i,unit in ipairs(units) do
			-- Applies the stun modifier to the target
			unit:AddNewModifier(caster, ability, "modifier_stunned", {Duration = tooltip_duration})
			-- Applies the damage to the target
			ApplyDamage({victim = unit, attacker = caster, damage = ability:GetAbilityDamage(), damage_type = ability:GetAbilityDamageType()})
			
			-- Renders the dirt particle around the caster
			local particle1 = ParticleManager:CreateParticle(keys.particle1, PATTACH_WORLDORIGIN, caster)
			ParticleManager:SetParticleControl(particle1, 0, Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))
			ParticleManager:SetParticleControl(particle1, 1, Vector(aftershock_range,aftershock_range,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))
			ParticleManager:SetParticleControl(particle1, 2, Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))
		
			-- Renders the ripple particle around the caster
			local particle2 = ParticleManager:CreateParticle(keys.particle2, PATTACH_WORLDORIGIN, caster)
			ParticleManager:SetParticleControl(particle2, 0, Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))
			ParticleManager:SetParticleControl(particle2, 1, Vector(aftershock_range,aftershock_range,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))
			ParticleManager:SetParticleControl(particle2, 2, Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))
		end
	end
end
