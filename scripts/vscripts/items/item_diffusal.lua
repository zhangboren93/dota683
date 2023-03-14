function manaBurn(event)
    if event.attacker:IsIllusion() then
        return
    end
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
    local target = event.target
	-- Strong Dispel
	local RemovePositiveBuffs = true
	local RemoveDebuffs = false
	local BuffsCreatedThisFrameOnly = false
	local RemoveStuns = false
	local RemoveExceptions = false
	target:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
end