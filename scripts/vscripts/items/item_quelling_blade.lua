item_quelling_blade_lua = class({})
function item_quelling_blade_lua:CastFilterResultTarget( target )
    if target:GetClassname() == "ent_dota_tree" then
		return UF_SUCCESS
	elseif target:GetName() == "npc_dota_ward_base" or target:GetName() == "npc_dota_ward_base_truesight" then
		return UF_SUCCESS
	elseif target:IsCreep() then
		return UF_FAIL_CREEP
	elseif target:IsBuilding() then
		return UF_FAIL_BUILDING
	elseif target:IsHero() then
		return UF_FAIL_HERO 
	else
		return UF_FAIL_CUSTOM
	end
end

function item_quelling_blade_lua:OnSpellStart()
	local target = self:GetCursorTarget()
    if target:GetClassname() == "ent_dota_tree" then
        target:CutDown(self:GetCaster():GetTeamNumber())
		return
	elseif target:GetClassname() == "dota_temp_tree" then
		--TODO emit tree kill animation
		target:Kill()
		return
    end
	--TODO require 2 count to cut down ward
    if target:GetName() == "npc_dota_ward_base" or target:GetName() == "npc_dota_ward_base_truesight" then
        target:Kill(self, self:GetCaster())
    end
end

function item_quelling_blade_lua:GetIntrinsicModifierName()
	return "modifier_item_quelling_blade_hooks_lua"
end
