require("items/lifesteal_common")
--[[
	Author: Noya
	Date: 14.01.2015.
	Applies a Lifesteal modifier if the attacked target is not a building and not a mechanical unit
]]
function VampiricAuraApply( event )
	-- Variables
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability

	if not target:IsIllusion() and not target:IsBuilding() 
		and target:GetTeam() ~= attacker:GetTeam() then
		if not IsUnitLifeStealable(target) then return end
		local vampiric_aura = ability:GetSpecialValueFor("vampiric_aura")
		attacker:AddNewModifier(event.caster, ability, "modifier_item_lifesteal_lua", 
			{ duration = 0.03, lifesteal = vampiric_aura })
	end
end
