require("../../items/item_sphere")
--[[Author: Pizzalol
	Date: 07.02.2015.
	Checks if the current ability level is supposed to stun, if yes then stun the target]]
function PoisonTouchStun( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	local ability_level = ability:GetLevel() - 1
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local should_stun = ability:GetLevelSpecialValueFor("should_stun", ability_level)

	if should_stun == 1 then
		target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
	end
end

function handleProjectileHit(event)
	local target = event.target
	if is_spell_blocked_by_linkens_sphere(target) then return end
	target:EmitSound("Hero_Dazzle.Poison_Touch")
	local ability = event.ability
	local caster = event.caster
	ability:ApplyDataDrivenModifier(caster, target, "modifier_poison_touch_slow_1_datadriven", {})
	ability:ApplyDataDrivenModifier(caster, target, "modifier_poison_touch_debuff_datadriven", {})
	local set_time = ability:GetSpecialValueFor("set_time")
	target:SetThink(function()
		ability:ApplyDataDrivenModifier(caster, target, "modifier_poison_touch_damage_datadriven", {});
	end, "poison touch damage", set_time)
end
