function manaBurn(event)
	local target = event.target
	local ability = event.ability
	local feedback_mana_burn = event.feedback_mana_burn
	if event.attacker:IsIllusion() and event.attacker:IsRangedAttacker() then
		return
	elseif event.target:IsMagicImmune() then
		return 
	end
	local mana_burn_avail = target:GetMana()
	if mana_burn_avail > feedback_mana_burn then
		mana_burn_avail = feedback_mana_burn
	end 
	target:Script_ReduceMana(feedback_mana_burn, ability)
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
	local caster = event.caster
	local RemovePositiveBuffs = not (target:GetTeam() == caster:GetTeam())
	local RemoveDebuffs = target:GetTeam() == caster:GetTeam()
	local BuffsCreatedThisFrameOnly = false
	local RemoveStuns = false
	local RemoveExceptions = false
	target:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
end