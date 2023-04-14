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
        --TODO boots at the same location
        if caster.mainMeepo:HasItemInInventory("item_travel_boots_datadriven") 
            and not caster.mainMeepo:HasItemInInventory("item_power_treads")
            and not caster.mainMeepo:HasItemInInventory("item_phase_boots")
            and not caster:HasItemInInventory("item_travel_boots_datadriven") then
            caster.travelboot = caster:AddItemByName("item_travel_boots_datadriven")
        end
        if (not caster.mainMeepo:HasItemInInventory("item_travel_boots_datadriven")
            or caster.mainMeepo:HasItemInInventory("item_power_treads")
            or caster.mainMeepo:HasItemInInventory("item_phase_boots")) and caster.travelboot ~= nil then
            caster:RemoveItem(caster.travelboot)
            caster.travelboot = nil
        end
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