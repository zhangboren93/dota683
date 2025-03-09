
function handleIntervalThink(event)
	local caster = event.caster
	local team = caster:GetTeam()
	local enemy_team = DOTA_TEAM_GOODGUYS
	local ability = event.ability
	local bonus_regen_pct = ability:GetSpecialValueFor("bonus_regen_pct")
	if team == DOTA_TEAM_GOODGUYS then
		enemy_team = DOTA_TEAM_BADGUYS
	end
	local shouldApplyPassive = false
	if caster:HasModifier("modifier_slark_shadow_dance_active_lua") then
		shouldApplyPassive = true
	elseif caster:HasModifier("modifier_slark_shadow_dance_disabled_by_neutral") then
		shouldApplyPassive = false
	elseif not IsLocationVisible(enemy_team, caster:GetAbsOrigin()) then
		shouldApplyPassive = true
	elseif caster:IsInvisible() and not caster:HasModifier("modifier_truesight") then
		shouldApplyPassive = true
	end
	if shouldApplyPassive then
		if    not caster:HasModifier("modifier_slark_shadow_dance_passive_active") 
		  and not caster:HasModifier("modifier_slark_shadow_dance_passive_activating") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_slark_shadow_dance_passive_activating", { duration = 0.5})
		end
		if caster:HasModifier("modifier_slark_shadow_dance_passive_active") then
			local health_regen = math.floor(caster:GetMaxHealth() * bonus_regen_pct)
			local modifier = caster:FindModifierByName("modifier_slark_shadow_dance_passive_active_regen")
			if modifier == nil then
				modifier = ability:ApplyDataDrivenModifier(caster, caster,
					"modifier_slark_shadow_dance_passive_active_regen", {})
			end
			modifier:SetStackCount(health_regen)
		end
	else
		if 			caster:HasModifier("modifier_slark_shadow_dance_passive_active")
			and not caster:HasModifier("modifier_slark_shadow_dance_passive_fading") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_slark_shadow_dance_passive_fading", { duration = 0.5 })
		end
	end
end

function handleAttacked(event)
	local attacker = event.attacker
	local ability = event.ability
	local caster = event.caster
	if attacker:IsNeutralUnitType()  then
		caster:RemoveModifierByName("modifier_slark_shadow_dance_passive_active")
		caster:RemoveModifierByName("modifier_slark_shadow_dance_passive_active_regen")
		ability:ApplyDataDrivenModifier(caster, caster, 
			"modifier_slark_shadow_dance_disabled_by_neutral", { duration =  2 })
	end
end

function handleActivatingDestroy(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_slark_shadow_dance_passive_active", {})
end

function handleFadingDestroy(event)
	local caster = event.caster
	caster:RemoveModifierByName("modifier_slark_shadow_dance_passive_active")
	caster:RemoveModifierByName("modifier_slark_shadow_dance_passive_active_regen")
end

function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	caster:AddNewModifier(caster, ability, "modifier_slark_shadow_dance_active_lua", { duration = 4 })
	--ability:ApplyDataDrivenModifier(caster, caster, "modifier_slark_shadow_dance_active", { duration = 4 })
	caster:EmitSound("Hero_Slark.ShadowDance")
	if caster.shadow_dance_pid ~= nil then
		ParticleManager:DestroyParticle(caster.shadow_dance_pid, false)
		caster.shadow_dance_pid = nil
	end
	
	CreateUnitByNameAsync("npc_dummy_unit", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeam(), function(unit)
		caster.shadow_dance_pid = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_shadow_dance.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:SetParticleControlEnt(caster.shadow_dance_pid, 1, unit, PATTACH_ABSORIGIN_FOLLOW, "", caster:GetAbsOrigin(), false)
		unit:AddNewModifier(caster, unit, "modifier_slark_shadow_dance_particle_lua", {})
		unit:AddNewModifier(caster, unit, "modifier_kill", { duration = 4 })
	end)
end
