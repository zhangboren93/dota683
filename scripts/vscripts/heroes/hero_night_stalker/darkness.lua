--[[Author:Pizzalol
	Date: 11.01.2015.
	Makes it night time for the duration of Darkness]]
--[[daytime 0-2 min is 0.25-0.49
	daytime 2-4 min is 0.50-0.74
	night 0-2 min is 0.75-0.99
	night 2-4 min is 0.00-0.24

	1 second ~ 0.0020833333]]
function Darkness( keys )
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))

	-- Setting it to the middle of the night
	GameRules:BeginNightstalkerNight(duration)
end

function handleIntervalThink(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasScepter() and not GameRules:IsDaytime() then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_darkness_scepter_datadriven", {})
	end
end
