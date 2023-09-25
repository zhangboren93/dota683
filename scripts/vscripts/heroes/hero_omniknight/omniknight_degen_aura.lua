--[[Author: Pizzalol
	Date: 24.03.2015.
	Checks if the target owner is the same as the caster owner]]
function DegenAura( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	local modifier = keys.modifier
	local duration = keys.duration

	-- If they are the same then apply the modifier
	if not target:HasModifier(modifier) then
		ability:ApplyDataDrivenModifier(caster, target, modifier, {Duration = duration})
	else
		local tmp_modifier = target:FindModifierByName(modifier)
		tmp_modifier:SetDuration(duration, true)
	end
end