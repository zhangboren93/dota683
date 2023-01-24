function manaBurn(event)
    local target = event.target
    local feedback_mana_burn = event.feedback_mana_burn
    local mana_burn_avail = target:GetMana()
    if mana_burn_avail > feedback_mana_burn then
        mana_burn_avail = feedback_mana_burn
    end 
    target:ReduceMana(feedback_mana_burn)
    ApplyDamage({
        victim = target,
        attacker = event.attacker,
        damage = feedback_mana_burn,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = event.ability
    })
end

function purge(event)
    local purgeable_modifier_names = {
        modifier_item_satanic_unholy = true,
        -- TODO add more purgeable modifiers here
    }

    local target = event.target
    local modifiers = target:FindAllModifiers()
	for i,v in ipairs(modifiers) do
        print(v:GetName())
        print(purgeable_modifier_names[v:GetName()])
        if purgeable_modifier_names[v:GetName()] then
            v:Destroy()
        end
    end
end