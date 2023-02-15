function scantrees(event)
    local target = event.target
    local ability = event.ability
    local neartrees = GridNav:IsNearbyTree(target:GetAbsOrigin(), ability:GetSpecialValueFor("radius"), false)
    if not neartrees then
        target:RemoveModifierByName("modifier_treant_natures_guise_datadriven")
        target:RemoveModifierByName("modifier_invisible")
    end
end