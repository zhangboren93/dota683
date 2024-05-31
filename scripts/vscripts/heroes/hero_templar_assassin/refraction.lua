--[[Author: YOLOSPAGHETTI
	Date: April 3, 2016
	Applies the damage absorb and bonus damage modifiers to the caster]]
require("items/item_magic_stick")
function ApplyModifiers(keys)
	local caster = keys.caster
	local ability = keys.ability
	local stacks = ability:GetLevelSpecialValueFor( "instances", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	
	ProcsMagicStick(keys)
	-- Applies the damage absorb buff
	caster:AddNewModifier(caster, ability, "modifier_damage_absorb_lua", { duration = duration })
	-- Applies the bonus damage buff
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bonus_damage", {})
	-- Shows the current stacks of bonus damage
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bonus_damage_visual", {})
	caster:SetModifierStackCount("modifier_damage_absorb_lua", ability, stacks)
	caster:SetModifierStackCount("modifier_bonus_damage_visual", ability, stacks)
end

--[[Author: YOLOSPAGHETTI
	Date: April 3, 2016
	Removes a bonus damage stack]]
function RemoveBonusDamageStack(keys)
	local caster  = keys.caster
	local ability = keys. ability
	local modifier = "modifier_bonus_damage_visual"
	local stacks = caster:GetModifierStackCount(modifier, ability)
	
	-- Removes a stack from the bonus damage modifier
	caster:SetModifierStackCount(modifier, ability, stacks - 1)
	stacks = caster:GetModifierStackCount(modifier, ability)
	
	-- If all stacks are gone we remove both modifiers
	if stacks == 0 then
		caster:RemoveModifierByName(modifier)
		caster:RemoveModifierByName("modifier_bonus_damage")
	end
end
