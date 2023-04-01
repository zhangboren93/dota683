function cancelBurn(event)
    if not event.target:HasModifier("modifier_abyssal_underlord_firestorm_burn") then
        event.target:RemoveModifierByName("modifier_underlord_firestorm_burn_active_datadriven")
    else
	    ApplyDamage({ 
            victim = event.target, 
            attacker = event.caster, 
            damage = event.ability:GetAbilityDamage(), 
            damage_type = DAMAGE_TYPE_MAGICAL })
    end
end