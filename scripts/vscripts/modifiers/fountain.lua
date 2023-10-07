function handleIntervalThink(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target:HasModifier("modifier_fountain_aura_buff") then
		target.lastFountainTime = GameRules:GetDOTATime(true, true)
	else
		-- TODO Check if target is out of fountain for less than 3 seconds
		if not target:HasModifier("modifier_fountain_aura_buff_datadriven") then
			-- give 3 seconds of extra fountain regen
			ability:ApplyDataDrivenModfier(caster, target, "modifier_fountain_aura_buff_datadriven", { duration = 3 })
		else
			target:RemoveModifierByName("modifier_fountain_aura_tp_persist_datadriven")
		end
	end
end
