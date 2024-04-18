modifier_windrunner_windrun_aura_lua = class({ 
	IsAura			    = function(self) return true end,
	IsHidden		    = function(self) return true end,
	IsPurgable			= function(self) return false end,
	GetAuraRadius		= function(self) return 300 end,
	GetAuraSearchTeam	= function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchType	= function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end,
	GetAuraSearchFlags	= function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
})

function modifier_windrunner_windrun_aura_lua:OnCreated()
	self:StartIntervalThink(0.5)
end

function modifier_windrunner_windrun_aura_lua:OnIntervalThink()
	if not self:GetParent():HasModifier("modifier_windrunner_windrun") then
		self:Destroy()
	end
end

function modifier_windrunner_windrun_aura_lua:GetModifierAura()
	return "modifier_windrunner_windrun_slow_lua"
end

modifier_windrunner_windrun_slow_lua = class({ 
	IsDebuff                = function(self) return true end,
	DeclareFunctions        = function(self) return 
		{
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
			MODIFIER_PROPERTY_TOOLTIP,
		}
	end,
})

function modifier_windrunner_windrun_slow_lua:OnCreated()
    self.enemy_movespeed_bonus_pct = self:GetAbility():GetSpecialValueFor("enemy_movespeed_bonus_pct")
end

function modifier_windrunner_windrun_slow_lua:OnTooltip()
    return self.enemy_movespeed_bonus_pct
end

function modifier_windrunner_windrun_slow_lua:GetModifierMoveSpeedBonus_Percentage()
	if self:GetParent():IsMagicImmune() then
		return self.enemy_movespeed_bonus_pct
    else
		return 0
	end
end