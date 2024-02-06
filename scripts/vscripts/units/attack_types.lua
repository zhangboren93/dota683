function handleSiegeExtra(event)
	local attacker = event.attacker
	local ability = event.ability
	attacker:AddNewModifier(attacker, ability, "modifier_creep_siege_extra_effect", {})
	attacker:RemoveModifierByName("modifier_creep_siege_extra")
end

if modifier_creep_siege_extra_effect == nil then
	modifier_creep_siege_extra_effect = class({})
end

function modifier_creep_siege_extra_effect:IsPurgable() return false end
function modifier_creep_siege_extra_effect:IsHidden() return true end

function modifier_creep_siege_extra_effect:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE }
	return funcs
end

function modifier_creep_siege_extra_effect:GetModifierPreAttack_BonusDamage(event)
	if not IsServer() then return end
	local target = event.target
	local attacker = event.attacker
	local ability = self:GetAbility()
	local damage_pct = 0
	if target == nil then return end
	if target:HasAbility("creep_basic") then
		damage_pct = ability:GetSpecialValueFor("basic_armor_damage_penalty")
	elseif target:HasAbility("creep_strong") then
		damage_pct = ability:GetSpecialValueFor("strong_armor_damage_bonus")
	elseif target:IsHero() then
		damage_pct = ability:GetSpecialValueFor("hero_damage_penalty")
	end
	return attacker:GetAverageTrueAttackDamage(nil) * damage_pct / 100.0
end

if creep_piercing_extra == nil then
	creep_piercing_extra = class({})
end

function creep_piercing_extra:GetIntrinsicModifierName()
	return "modifier_creep_piercing_extra"
end

if modifier_creep_piercing_extra == nil then
	modifier_creep_piercing_extra = class({})
end

function modifier_creep_piercing_extra:IsPurgable() return false end
function modifier_creep_piercing_extra:IsHidden() return true end

function modifier_creep_piercing_extra:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE }
	return funcs
end

function modifier_creep_piercing_extra:GetModifierPreAttack_BonusDamage(event)
	if not IsServer() then return end
	local target = event.target
	local attacker = event.attacker
	local ability = self:GetAbility()
	local damage_pct = 0
	if target == nil then return end
	if target:HasAbility("creep_weak") then
		damage_pct = ability:GetSpecialValueFor("weak_armor_damage_bonus")
	elseif target:HasAbility("creep_basic") then
		damage_pct = ability:GetSpecialValueFor("basic_armor_damage_penalty")
	elseif target:HasAbility("creep_strong") then
		damage_pct = ability:GetSpecialValueFor("strong_armor_damage_penalty")
		if target:IsHero() then
			damage_pct = 50
		end
	end
	return attacker:GetAverageTrueAttackDamage(nil) * damage_pct / 100.0
end

if creep_irresolute_extra == nil then
	creep_irresolute_extra = class({})
end

function creep_irresolute_extra:GetIntrinsicModifierName()
	return "modifier_creep_irresolute_extra"
end

if modifier_creep_irresolute_extra == nil then
	modifier_creep_irresolute_extra = class({})
end

function modifier_creep_irresolute_extra:IsPurgable() return false end
function modifier_creep_irresolute_extra:IsHidden() return true end

function modifier_creep_irresolute_extra:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE }
	return funcs
end

function modifier_creep_irresolute_extra:GetModifierPreAttack_BonusDamage(event)
	if not IsServer() then return end
	local target = event.target
	local attacker = event.attacker
	local ability = self:GetAbility()
	local damage_pct = 0
	if target == nil then return end
	if target:HasAbility("creep_basic") then
		damage_pct = ability:GetSpecialValueFor("basic_armor_damage_bonus")
	elseif target:HasAbility("creep_strong") then
		damage_pct = ability:GetSpecialValueFor("strong_armor_damage_bonus")
		if target:IsHero() then
			damage_pct = 150
		end
	end
	return attacker:GetAverageTrueAttackDamage(nil) * damage_pct / 100.0
end

if creep_light == nil then
	creep_light = class({})
end

function creep_light:GetIntrinsicModifierName()
	return "modifier_creep_light"
end

modifier_creep_light = class({})

function modifier_creep_light:IsPurgable() return false end
function modifier_creep_light:IsHidden() return true end

function modifier_creep_light:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE }
	return funcs
end

function modifier_creep_light:GetModifierDamageOutgoing_Percentage(event)
	if not IsServer() then return end
	local target = event.target
	local attacker = event.attacker
	local ability = self:GetAbility()
	if target == nil then return end
	if target:HasAbility("creep_siege") then
		return ability:GetSpecialValueFor("building_damage_penalty")
	else
		return 0
	end
end