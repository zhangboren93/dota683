require("../items/item_sphere")
require("../items/item_magic_stick")
function handleSpellStart(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local modifier_name = event.ModifierName

	ProcsMagicStick(event)

	if is_spell_blocked_by_linkens_sphere(target) then return end
	ability:ApplyDataDrivenModifier(caster, target, modifier_name, {})
end
