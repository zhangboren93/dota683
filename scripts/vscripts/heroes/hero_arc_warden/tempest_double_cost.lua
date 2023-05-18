function handleAbilityExecuted(keys)
	local caster = keys.caster
	local event_ability = keys.event_ability
	if event_ability:GetName() == "arc_warden_tempest_double" then
		local health_cost_pct = event_ability:GetSpecialValueFor("health_cost_pct")
		if health_cost_pct > 0 then
			local health_cost = caster:GetMaxHealth() * health_cost_pct / 100
			local mana_cost = caster:GetMaxMana() * health_cost_pct / 100
			caster:Script_ReduceMana(mana_cost, event_ability)
			caster:ModifyHealth(caster:GetHealth() - health_cost, event_abiliy, false, 0)
		end
		caster:SetThink(function()
			local units = Entities:FindAllByName("npc_dota_hero_arc_warden")
			for i=1,#units do
				if units[i] ~= caster and units[i]:IsTempestDouble() and not units[i]:IsIllusion() then
					local double = units[i]
					item = double:FindItemInInventory("item_hand_of_midas")
					if item ~= nil then item:EndCooldown() end
					item = double:FindItemInInventory("item_necronomicon")
					if item ~= nil then item:EndCooldown() end
					item = double:FindItemInInventory("item_necronomicon_2")
					if item ~= nil then item:EndCooldown() end
					item = double:FindItemInInventory("item_necronomicon_3")
					if item ~= nil then item:EndCooldown() end
					item = double:FindItemInInventory("item_tpscroll")
					if item ~= nil then item:EndCooldown() end
					if caster:HasItemInInventory("item_flask") then double:AddItemByName("item_flask") end
					if caster:HasItemInInventory("item_clarity") then double:AddItemByName("item_clarity") end
					if caster:HasItemInInventory("item_dust") then double:AddItemByName("item_dust") end
					return
				end
			end
		end, "double item CD", 0.1)
	end
end