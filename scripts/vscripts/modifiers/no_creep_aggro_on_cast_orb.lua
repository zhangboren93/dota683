if modifier_no_creep_aggro_on_cast_orb_lua == nil then
	modifier_no_creep_aggro_on_cast_orb_lua = class({})
end

function modifier_no_creep_aggro_on_cast_orb_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_no_creep_aggro_on_cast_orb_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ORDER
    }
    return funcs
end

function modifier_no_creep_aggro_on_cast_orb_lua:OnOrder(event)
	if event.order_type == DOTA_UNIT_ORDER_CAST_TARGET 
		and type(event.ability:GetBehavior()) ~= "userdata" then
		local ability = event.ability
		if bit.band(ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_ATTACK) ~= 0 then
			self:GetParent():FindAbilityByName("hero_intrinstic_mechanism_datadriven"):ApplyDataDrivenModifier(
				self:GetParent(), self:GetParent(), "modifier_no_creep_aggro_on_attack", {})
		end
	else
		self:GetParent():RemoveModifierByName("modifier_no_creep_aggro_on_attack")
	end
end

function modifier_no_creep_aggro_on_cast_orb_lua:IsHidden(event)
	return true
end
