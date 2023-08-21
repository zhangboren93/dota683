modifier_item_quelling_blade_hooks_lua = class({})
function modifier_item_quelling_blade_hooks_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_START
	}
end

function modifier_item_quelling_blade_hooks_lua:OnAttackStart(event)
    local target = event.target
    local attacker = event.attacker
    local ability = self:GetAbility()
	if attacker == self:GetParent() then
    	if target:IsCreep() and target:GetTeamNumber() ~= attacker:GetTeamNumber() and target:GetModelName() ~= "models/creeps/roshan/roshan.vmdl" then
    	    if attacker:IsRangedAttacker() then
    	        attacker:AddNewModifier(attacker, ability, "modifier_item_quelling_blade_active_ranged_lua", { duration = 1 })
    	    else
    	        attacker:AddNewModifier(attacker, ability, "modifier_item_quelling_blade_active_melee_lua", { duration = 1 })
    	    end
    	else
    	    attacker:RemoveModifierByName("modifier_item_quelling_blade_active_ranged_lua")
    	    attacker:RemoveModifierByName("modifier_item_quelling_blade_active_melee_lua")
    	end
	end
end

function modifier_item_quelling_blade_hooks_lua:IsHidden()
	return true
end
