--[[Author: Pizzalol
	Date: 10.01.2015.
	It applies a slow of a different duration depending on the time of the day]]
require("../../items/item_sphere")
function Void( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local modifier = keys.modifier

	if is_spell_blocked_by_linkens_sphere(target) then return end

	local duration_day = ability:GetLevelSpecialValueFor("duration_day", (ability:GetLevel() - 1))
	local duration_night = ability:GetLevelSpecialValueFor("duration_night", (ability:GetLevel() - 1))

	if GameRules:IsDaytime() then
		ability:ApplyDataDrivenModifier(caster, target, modifier, {duration = duration_day})
	else
		ability:ApplyDataDrivenModifier(caster, target, modifier, {duration = duration_night})
	end
	
	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = 0.1})
	ApplyDamage({victim = target, attacker = caster, damage = ability:GetAbilityDamage(), damage_type = DAMAGE_TYPE_MAGICAL})
end
