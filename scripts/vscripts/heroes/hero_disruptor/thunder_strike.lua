function providesVision(event)
	local ability = event.ability
	local vision_duration = ability:GetSpecialValueFor("vision_duration")
	local vision_radius = ability:GetSpecialValueFor("vision_radius")
	local target = event.target
	ability:CreateVisibilityNode(target:GetAbsOrigin(), vision_radius, vision_duration)
end

function handleSpellStart(event)
	local target = event.target
	local ability = event.ability
	if target:TriggerSpellAbsorb(ability) then
		return
	end
	local caster = event.caster
	ability:ApplyDataDrivenModifier(caster, target, "modifier_thunder_strike_datadriven", {})
	target:EmitSound("Hero_Disruptor.ThunderStrike.Cast")
end
