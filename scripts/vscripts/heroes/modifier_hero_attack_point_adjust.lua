require("hero_types")

modifier_hero_attack_point_adjust_lua = class({})

function modifier_hero_attack_point_adjust_lua:OnCreated(keys)
	if keys.stackCount ~= nil then
		self:SetStackCount(keys.stackCount)
	end
end

function modifier_hero_attack_point_adjust_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
	return funcs
end

function modifier_hero_attack_point_adjust_lua:IsHidden()
	return false
end

function modifier_hero_attack_point_adjust_lua:GetOverrideAnimation()
	return ACT_DOTA_ATTACK  
end

function modifier_hero_attack_point_adjust_lua:GetOverrideAnimationWeight()
	return 10
end

function modifier_hero_attack_point_adjust_lua:GetOverrideAnimationRate()
	return self:GetParent():GetAttackSpeed(false) * self:GetStackCount() / 100
end

function HandleHeroAttackStart(event)
	local caster = event.attacker
	local ability = event.ability
	local current_point = caster:GetAttackAnimationPoint()
	local new_point = HERO_ATTACKPOINT_NEW[caster:GetName()]
	if new_point == nil then
		print("Error hero no new point")
		return
	end
	if math.abs(current_point - new_point) < 0.03 then
		print("New and old point almost the same")
		return
	end
	local stackCount = math.floor(new_point / current_point * 100)
	local modifier = caster:AddNewModifier(caster, ability, "modifier_hero_attack_point_adjust_lua", { duration = 1, stackCount = stackCount })
end
