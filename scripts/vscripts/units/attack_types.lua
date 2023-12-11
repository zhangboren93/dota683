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
	if target and target:IsHero() then
		return (0 - attacker:GetAverageTrueAttackDamage(nil) * 25 / 100.0)
	end
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
	if target and target:HasAbility("creep_weak") then
		print(attacker:GetAverageTrueAttackDamage(nil) / 2.0)
		return attacker:GetAverageTrueAttackDamage(nil) / 2.0
	end
end