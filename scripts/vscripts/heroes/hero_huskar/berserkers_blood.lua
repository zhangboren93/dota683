LinkLuaModifier("modifier_huskar_berserkers_blood_lua", "heroes/hero_huskar/berserkers_blood.lua", LUA_MODIFIER_MOTION_NONE)

huskar_berserkers_blood_lua = class({})
function huskar_berserkers_blood_lua:GetIntrinsicModifierName()
	return "modifier_huskar_berserkers_blood_lua"
end

modifier_huskar_berserkers_blood_lua = class({ 
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
			MODIFIER_PROPERTY_MODEL_SCALE,
			MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		}
	end,
	IsHidden							 = function(self) return false end,
	GetModifierModelScale				 = function(self) return 3 * self:GetStackCount() + 1 end,
	GetActivityTranslationModifiers		 = function(self)
		if self:GetParent():GetHealthPercent() <= 99.99 then 
			return "berserkers_blood"
		end
	end,
	GetModifierAttackSpeedBonus_Constant = function(self) return self.attack_speed_bonus_per_stack * self:GetStackCount() end,
	GetModifierMagicalResistanceBonus	 = function(self) return self.resistance_per_stack * self:GetStackCount() end
})

function modifier_huskar_berserkers_blood_lua:OnCreated(keys)
	local parent = self:GetParent()
	local ability = self:GetAbility()

	self.attack_speed_bonus_per_stack	= ability:GetSpecialValueFor("attack_speed_bonus_per_stack");
	self.resistance_per_stack			= ability:GetSpecialValueFor("resistance_per_stack");

	if IsServer() then
		if parent:IsIllusion() then
			self:Destroy()
		else
			self:StartIntervalThink(FrameTime())
		end
	end
end

function modifier_huskar_berserkers_blood_lua:OnIntervalThink()
	local parent = self:GetParent()

	local stack_cnt = math.floor((101 - parent:GetHealthPercent()) / 7)	
	if stack_cnt < 1 then stack_cnt = 1 end

	self:SetStackCount(stack_cnt)
end