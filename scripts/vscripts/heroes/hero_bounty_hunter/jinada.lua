--[[Jinada
	Author: Pizzalol
	Date: 1.1.2015.]]
function Jinada( keys )
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(level)
	local caster = keys.caster	
	local modifierName = "modifier_jinada_datadriven"

	ability:StartCooldown(cooldown)

	caster:RemoveModifierByName(modifierName) 

	caster:SetThink(function()
		ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
		end, "bounty jinada", cooldown)	
end