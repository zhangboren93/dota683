function handleSiegeExtra(event)
	local attacker = event.attacker
	local ability = event.ability
	attacker:AddNewModifier(attacker, ability, "modifier_creep_siege_alter", {})
	attacker:RemoveModifierByName("modifier_creep_siege_extra")
end

modifier_creep_siege_alter = class({ 
	IsPurgable			= function(self) return false end,
	IsHidden			= function(self) return true end,
	DeclareFunctions	= function(self) return 
		{
			MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
			MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE
		}
	end
})

function modifier_creep_siege_alter:OnCreated()
	local ability = self:GetAbility()
	self.hero_damage = ability:GetSpecialValueFor("hero_damage_penalty")
	self.building_damage = ability:GetSpecialValueFor("bonus_building_damage")
	self.basic_armor_damage = ability:GetSpecialValueFor("basic_armor_damage_penalty")
	self.strong_armor_damage = ability:GetSpecialValueFor("strong_armor_damage_bonus")

	self.incoming_hero_damage = ability:GetSpecialValueFor("incoming_hero_damage_penalty")
	self.incoming_basic_damage = ability:GetSpecialValueFor("incoming_basic_damage_penalty")
end

function modifier_creep_siege_alter:GetModifierDamageOutgoing_Percentage(event)
	local target = event.target
	local ability = self:GetAbility()
	if event.attacker ~= self:GetParent() or target == nil then return 0 end
	if target:IsHero() or target:HasAbility("creep_hero_armor") then
		return self.hero_damage
	elseif target:HasAbility("creep_siege_alter") then
		return self.building_damage
	elseif target:HasAbility("creep_basic") then
		return self.basic_armor_damage
	elseif target:HasAbility("creep_strong") then
		return self.strong_armor_damage
	end
	return 0
end

function modifier_creep_siege_alter:GetModifierIncomingPhysicalDamage_Percentage(event)
	local attacker = event.attacker
	local ability = self:GetAbility()
	if (attacker:IsHero() or attacker:HasAbility("creep_hero_attack"))
		and (inflictor == nil or inflictor ~= 'centaur_return') then
		return self.incoming_hero_damage
	elseif attacker:HasAbility('creep_light') or attacker:HasAbility("creep_siege_alter") then
		return 0
	else
		return self.incoming_basic_damage
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
	if target:HasAbility("creep_siege_alter") then
		return ability:GetSpecialValueFor("building_damage_penalty")
	else
		return 0
	end
end

creep_irresolute_alter = class({})

function creep_irresolute_alter:GetIntrinsicModifierName()
	return "modifier_creep_irresolute_alter"
end

modifier_creep_irresolute_alter = class({ 
	IsPurgable			= function(self) return false end,
	IsHidden			= function(self) return true end,
	DeclareFunctions	= function(self) return 
		{
			MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		}
	end,
})

function modifier_creep_irresolute_alter:OnCreated()
	local ability = self:GetAbility()
	self.hero_penalty = ability:GetSpecialValueFor("hero_damage_penalty")
	self.basic_bonus = ability:GetSpecialValueFor("basic_armor_damage_bonus")
	self.strong_bonus = ability:GetSpecialValueFor("strong_armor_damage_bonus")
end

function modifier_creep_irresolute_alter:GetModifierDamageOutgoing_Percentage(event)
	local target = event.target
	if target == nil then return 0 end
	if target:IsHero() then
		return self.hero_penalty
	elseif target:HasAbility("creep_basic") then
		return self.basic_bonus
	elseif target:HasAbility("creep_strong") then
		return self.strong_bonus
	else
		return 0
	end
end