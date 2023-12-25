if modifier_primal_beast_attack_animation_lua == nil then
	modifier_primal_beast_attack_animation_lua = class({})
end

function modifier_primal_beast_attack_animation_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
	return funcs
end

function modifier_primal_beast_attack_animation_lua:IsHidden()
	return true
end

function modifier_primal_beast_attack_animation_lua:GetOverrideAnimation()
	return ACT_DOTA_ATTACK
end

function modifier_primal_beast_attack_animation_lua:GetOverrideAnimationWeight()
	return 10
end

function modifier_primal_beast_attack_animation_lua:GetOverrideAnimationRate()
	return 1.66 * self:GetParent():GetAttackSpeed(false)
end

function HandleAttackStart(event)
	local caster = event.attacker
	local ability = event.ability
	caster:AddNewModifier(caster, ability, "modifier_primal_beast_attack_animation_lua", { duration = 1 })
end
