--[[
	Author: Noya
	Date: 20.01.2015.
	Resets the Drunken Brawler Crit timer
]]
function DrunkenBrawlerCritReset( event )
	local caster = event.caster
	local ability = event.ability
	local last_proc = ability:GetLevelSpecialValueFor( "last_proc" , ability:GetLevel() - 1 )
	
	-- Keep track of the time of this attack
	caster.last_attack = GameRules:GetGameTime()

	-- Create a timer for this attack landed, after last_proc duration, check if this was the last attack and grant a crit
	caster:SetThink(function()
		if GameRules:GetGameTime() >= caster.last_attack + last_proc then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_drunken_brawler_guaranteed_crit", nil)
		end
	end, "Resume gaurentee crit", last_proc)
	
	caster:RemoveModifierByName("modifier_drunken_brawler_guaranteed_crit")
end

-- Resets the Drunken Brawler Evasion timer
function DrunkenBrawlerDodgeReset( event )
	local caster = event.target
	local ability = event.ability
	if ability:GetName() ~= "brewmaster_drunken_brawler_datadriven" then
		ability = caster:FindAbilityByName("brewmaster_drunken_brawler_datadriven")
	end
	if ability == nil then return end

	local last_proc = ability:GetLevelSpecialValueFor( "last_proc" , ability:GetLevel() - 1 )
	
	-- Keep track of the time of this attack
	caster.last_attacked = GameRules:GetGameTime()

	-- Create a timer for this attack taken or forced to dodge, after last_proc duration, check if this was the last time attacked and grant a dodge
	caster:SetThink(function() 
		if GameRules:GetGameTime() >= caster.last_attacked + last_proc then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_drunken_brawler_guaranteed_dodge", nil)
		end
	end, "Resume garuentee dodge", last_proc)
end

function handleAttackStart(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if target:IsBuilding() then return end
	if target:GetTeam() == caster:GetTeam() then return end
	if target:GetName() == "npc_dota_unit_undying_tombstone" then return end
	if caster:HasModifier("modifier_drunken_brawler_guaranteed_crit") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_drunken_brawler_crit", {})
	end
end