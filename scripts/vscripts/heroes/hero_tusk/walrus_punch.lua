function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_tusk_walrus_punch_crit_datadriven", { duration = 1 })
	caster:PerformAttack(target, true, true, false, false, false, false, false)
end

function handleAttackLanded(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local air_time = ability:GetSpecialValueFor("air_time")
	local slow_duration = ability:GetSpecialValueFor("slow_duration")
	target:AddNewModifier(caster, ability, "modifier_stunned", { duration = air_time })
	target:AddNewModifier(caster, ability, "modifier_tusk_walrus_punch_visual_lua", { duration = 1.1 })
	ability:ApplyDataDrivenModifier(caster, target, "modifier_tusk_walrus_punch_slow_datadriven", { duration = slow_duration + air_time })
	caster:RemoveModifierByName("modifier_tusk_walrus_punch_crit_datadriven")
	target:EmitSound("Hero_Tusk.WalrusPunch.Target")
end

modifier_tusk_walrus_punch_visual_lua = class({})
function modifier_tusk_walrus_punch_visual_lua:DeclareFunctions()
	return { MODIFIER_PROPERTY_VISUAL_Z_DELTA }
end

function modifier_tusk_walrus_punch_visual_lua:GetVisualZDelta()
	local remaining_time = self:GetRemainingTime()
	if remaining_time < 0.1 then
		return 0
	elseif remaining_time < 0.6 then
		return (remaining_time - 0.1) * 2000
	else
		return (1.1 - remaining_time) * 2000
	end
end

function modifier_tusk_walrus_punch_visual_lua:IsHidden()
	return true
end

