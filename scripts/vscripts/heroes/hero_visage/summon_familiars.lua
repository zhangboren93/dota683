function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	if ability.familiars == nil then
		ability.familiars = {}
	else
		for i=1,#ability.familiars do
			if IsValidEntity(ability.familiars[i]) and ability.familiars[i]:IsAlive() then
				ability.familiars[i]:ForceKill(true)
			end
		end
		ability.familiars = {}
	end

	local unit_name = "npc_dota_visage_familiar" .. ability:GetLevel()
	local unit_count = 2
	if caster:HasScepter() then
		unit_count = 3
	end
	for i=1,unit_count do
		CreateUnitByNameAsync(unit_name, caster:GetAbsOrigin(), true, caster, caster, caster:GetTeam(), function(unit)
			table.insert(ability.familiars, unit)
			local stone_form = unit:FindAbilityByName("visage_summon_familiars_stone_form")
			stone_form:SetLevel(ability:GetLevel())
			stone_form:SetHidden(false)
			unit:FindAbilityByName("neutral_spell_immunity"):SetLevel(1)
			unit:FindAbilityByName("creep_hero_attack"):SetLevel(1)
			unit:AddNewModifier(caster, ability, "modifier_familiar_attack_damage_lua", {})
			unit:SetControllableByPlayer(caster:GetPlayerID(), true)
			FindClearSpaceForUnit(unit, caster:GetAbsOrigin(), false)
		end)
	end
	caster:EmitSound("Hero_Visage.SummonFamiliars.Cast")
end
