require("../items/item_sphere")
function handleSpellStart(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local modifier_name = event.ModifierName
	if is_spell_blocked_by_linkens_sphere(target) then return end
	ability:ApplyDataDrivenModifier(caster, target, modifier_name, {})
end
