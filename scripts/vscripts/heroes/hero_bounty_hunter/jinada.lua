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

--	caster:RemoveModifierByName(modifierName) 
--
--	caster:SetThink(function()
--		ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
--		end, "bounty jinada", cooldown)	
--
	local target = keys.target
	if caster:IsRealHero() and not target:IsBuilding() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_jinada_slow_datadriven", {})
	end
end

function handleAttackStart(event)
	local ability = event.ability
	local attacker = event.attacker
	local target = event.target
	if attacker:IsRealHero() and not target:IsBuilding() and ability:IsCooldownReady() and target:GetTeam() ~= attacker:GetTeam() then
		ability:ApplyDataDrivenModifier(attacker, attacker, "modifier_jinada_datadriven", {})
	else
		attacker:RemoveModifierByName("modifier_jinada_datadriven")
	end
end
