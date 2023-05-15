if item_tpscroll_clear_tree_modifier == nil then
    item_tpscroll_clear_tree_modifier = class({})
end

function item_tpscroll_clear_tree_modifier:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function item_tpscroll_clear_tree_modifier:IsHidden()
    return true
end

function item_tpscroll_clear_tree_modifier:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TELEPORTED
    }
    return funcs
end

function item_tpscroll_clear_tree_modifier:OnTeleported(event)
	local unit = event.unit
	if unit == self:GetParent() then
        unit:SetThink(function()
            if not unit:HasModifier("modifier_furion_arboreal_might_armor") then
               print("tp " .. unit:GetName())
               GridNav:DestroyTreesAroundPoint(unit:GetAbsOrigin(), 200, false)
            end
        end, "tp clear tree", 0.1)
	end
end