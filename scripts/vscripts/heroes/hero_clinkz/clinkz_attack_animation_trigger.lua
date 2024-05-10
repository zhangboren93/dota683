if modifier_clinkz_attack_animation == nil then
	modifier_clinkz_attack_animation = class({})
end

function modifier_clinkz_attack_animation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_EVENT_ON_ORDER
	}
	return funcs
end

function modifier_clinkz_attack_animation:IsHidden()
	return true
end

function modifier_clinkz_attack_animation:GetOverrideAnimation()
	return ACT_DOTA_ATTACK_STATUE  
end

function modifier_clinkz_attack_animation:GetOverrideAnimationWeight()
	return 10
end

function modifier_clinkz_attack_animation:GetOverrideAnimationRate()
	return self:GetParent():GetAttackSpeed(false)
end

function modifier_clinkz_attack_animation:OnOrder(event)
	if event.unit == self:GetParent() and event.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		self:Destroy()
	end
end

function HandleClinkzAttackStart(event)
	local caster = event.attacker
	local ability = event.ability
	caster:AddNewModifier(caster, ability, "modifier_clinkz_attack_animation", { duration = 1})
end
