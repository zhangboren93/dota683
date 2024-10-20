require("items/item_sphere")
--[[ ============================================================================================================
	Author: Rook
	Date: February 4, 2015
	Called when the unit lands an attack on a target and the chance to Lesser Maim is successful.  Applies the
	modifier so long as the target is not a structure.
================================================================================================================= ]]
function modifier_item_heavens_halberd_datadriven_on_attack_landed_random_on_success(keys)
	if keys.target.GetInvulnCount == nil then  --If the target is not a structure.
		keys.target:EmitSound("DOTA_Item.Maim")
		keys.ability:ApplyDataDrivenModifier(keys.attacker, keys.target, "modifier_item_heavens_halberd_datadriven_lesser_maim", nil)
	end
end


--[[ ============================================================================================================
	Author: Rook
	Date: February 4, 2015
	Called when Heaven's Halberd is cast on an enemy unit.  Applies a disarm with a duration dependant on whether the
	target is melee or ranged.
	Additional parameters: keys.DisarmDurationRanged and keys.DisarmDurationMelee
================================================================================================================= ]]
function item_heavens_halberd_datadriven_on_spell_start(keys)
	keys.caster:EmitSound("DOTA_Item.HeavensHalberd.Activate")

	if is_spell_blocked_by_linkens_sphere(keys.target) then return end
	
	local duration = keys.DisarmDurationMelee
	if keys.target:IsRangedAttacker() then
		duration = keys.DisarmDurationRanged
	end
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_item_heavens_halberd_datadriven_disarm", { duration = duration })
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_disarmed", { duration = duration })
end
