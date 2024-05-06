--[[Author: Pizzalol
	Date: 11.01.2015.
	It applies a different modifier depending on the time of day]]
require("../../items/item_sphere")
require("../../items/item_magic_stick")

function CripplingFear( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	ProcsMagicStick(keys)
	if is_spell_blocked_by_linkens_sphere(target) then return end

	local modifier_day = keys.modifier_day
	local modifier_night = keys.modifier_night

	if GameRules:IsDaytime() then
		ability:ApplyDataDrivenModifier(caster, target, modifier_day, {})
	else
		ability:ApplyDataDrivenModifier(caster, target, modifier_night, {})
	end
end
