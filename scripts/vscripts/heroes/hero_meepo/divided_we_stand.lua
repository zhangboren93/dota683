function checkAghs(keys) 
    local caster = keys.caster
    local ability = keys.ability
    if caster.mainMeepo == nil and caster:HasScepter() and not caster:HasAbility("special_bonus_unique_meepo_5") then
        caster:AddAbility("special_bonus_unique_meepo_5")
        print("added meepo ahgs ability")
    end
    if caster.mainMeepo ~= nil then
        if caster.mainMeepo:HasScepter() then
            caster:RemoveAllModifiersOfName("modifier_dws_strength_datadriven")
            caster:RemoveAllModifiersOfName("modifier_dws_agility_datadriven")
            caster:RemoveAllModifiersOfName("modifier_dws_intellect_datadriven")
        else
            ApplyDebufModifiers(caster, ability, "modifier_dws_strength_datadriven",  
                caster.mainMeepo:GetStrength() - caster.mainMeepo:GetBaseStrength(),   "item_power_treads")
            ApplyDebufModifiers(caster, ability, "modifier_dws_agility_datadriven",   
                caster.mainMeepo:GetAgility() - caster.mainMeepo:GetBaseAgility(),     "item_power_treads")
            ApplyDebufModifiers(caster, ability, "modifier_dws_intellect_datadriven", 
                caster.mainMeepo:GetIntellect() - caster.mainMeepo:GetBaseIntellect(), "item_power_treads")
        end

        --rewrite from DOTA_IMBA meepo

        local rewrite_boots = {
            "item_travel_boots_datadriven",
            "item_tranquil_boots_datadriven",
        }

        local all_boots = {
            "item_travel_boots_datadriven",
            "item_power_treads",
            "item_arcane_boots",
            "item_phase_boots",
            "item_tranquil_boots_datadriven",
            "item_boots",
        }

        local ignore_custom_boots = false
        for _, boots in pairs(all_boots) do
            if caster:HasItemInInventory(boots) then
                ignore_custom_boots = true
                break
            end
        end

        local rewrite_found = false
        if ignore_custom_boots == false then
            local prime = caster:GetCloneSource()
            for _, boots_name in pairs(rewrite_boots) do
                prime.main_boots = nil
                for i = 0, 5 do
                    local item = prime:GetItemInSlot(i)
                    -- if a pair of boots is found, do nothing
                    if item ~= nil and item:GetAbilityName() == boots_name then
                        -- print(item:GetAbilityName().." / "..boots_name)
                        prime.main_boots = item
                        rewrite_found = true
                        break
                    end
                end
                if rewrite_found == true then
                    break
                end
            end
        end

        local found_boots = caster:GetCloneSource().main_boots
        -- Pair of boots found, do something
        if rewrite_found == true then
--			print("Boots found in main meepo:", found_boots:GetAbilityName())
            if not caster:HasItemInInventory(found_boots:GetAbilityName()) then
                local cloned_boots = caster:AddItemByName(found_boots:GetAbilityName())
                if cloned_boots and caster:HasItemInInventory(found_boots:GetAbilityName()) and cloned_boots:GetItemSlot() ~= found_boots:GetItemSlot() then
                    caster:SwapItems(cloned_boots:GetItemSlot(), found_boots:GetItemSlot())
                end
            end
        else
            for _, boots_name in pairs(rewrite_boots) do
                for slot = 0, 8 do
                    local item = caster:GetItemInSlot(slot)
                    if item and item:GetName() == boots_name then
                        caster:RemoveItem(item)
                        break
                    end
                end
            end
        end
        caster:CalculateStatBonus(true)
    end
end

function ApplyDebufModifiers(caster, ability, modifier, attribgain, treadsName)
    local existing = caster:FindAllModifiersByName(modifier)
    -- TODO treads give at most 8 all attributes
    if treadsName ~= "" and caster.mainMeepo:HasItemInInventory(treadsName) then
        attribgain = attribgain - 8 
    end
    if #existing == attribgain then
        return
    end
    caster:RemoveAllModifiersOfName(modifier)
    if attribgain > 0 then
        for i=1,attribgain do
            ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
        end
    end
end