function handleSpellStart(event)
	local ability = event.ability
	local caster = event.caster
	local duration = ability:GetSpecialValueFor("summon_duration")
	if ability.necro1 ~= nil and IsValidEntity(ability.necro1) and ability.necro1:IsAlive() then
		ability.necro1:ForceKill(false)
		ability.necro1 = nil
	end
	if ability.necro2 ~= nil and IsValidEntity(ability.necro2) and ability.necro2:IsAlive() then
		ability.necro2:ForceKill(false)
		ability.necro2 = nil
	end
	ability.necro1 = CreateUnitByName("npc_dota_necronomicon_warrior_" .. ability:GetLevel(), caster:GetAbsOrigin(), true, caster, caster, caster:GetTeam())
	ability.necro1:SetControllableByPlayer(caster:GetPlayerID(), true)
	FindClearSpaceForUnit(ability.necro1, caster:GetAbsOrigin(), false)
	ability.necro1:GetAbilityByIndex(0):SetLevel(ability:GetLevel())
	ability.necro1:GetAbilityByIndex(1):SetLevel(ability:GetLevel())
	ability.necro1:AddNewModifier(caster, ability, "modifier_kill", { duration = duration })
	if ability:GetLevel() == 3 then
		ability.necro1:GetAbilityByIndex(2):SetLevel(ability:GetLevel())
	end

	ability.necro2 = CreateUnitByName("npc_dota_necronomicon_archer_" .. ability:GetLevel(), caster:GetAbsOrigin(), true, caster, caster, caster:GetTeam())
	ability.necro2:SetControllableByPlayer(caster:GetPlayerID(), true)
	FindClearSpaceForUnit(ability.necro2, caster:GetAbsOrigin(), false)
	ability.necro2:GetAbilityByIndex(0):SetLevel(ability:GetLevel())
	ability.necro2:GetAbilityByIndex(1):SetLevel(ability:GetLevel())
	ability.necro2:AddNewModifier(caster, ability, "modifier_kill", { duration = duration })
end
