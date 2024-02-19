drow_ranger_frost_arrows_datadriven = class({})

function drow_ranger_frost_arrows_datadriven:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end

function drow_ranger_frost_arrows_datadriven:ProcsMagicStick()
	return false
end

function drow_ranger_frost_arrows_datadriven:IsStealable() return false end

function drow_ranger_frost_arrows_datadriven:GetProjectileName()
	return "particles/units/heroes/hero_drow/drow_frost_arrow.vpcf"
end

-- Orb Effects
function drow_ranger_frost_arrows_datadriven:OnOrbFire( params )
	self:GetCaster():EmitSound("Hero_DrowRanger.FrostArrows")
end

function drow_ranger_frost_arrows_datadriven:OnOrbImpact( params )
	local caster = self:GetCaster()
	local target = params.target
	if target:IsHero() then
		target:AddNewModifier(caster, self, "modifier_frost_arrows_slow_datadriven", {duration = 1.5})
	else
		target:AddNewModifier(caster, self, "modifier_frost_arrows_slow_datadriven", {duration = 7})	
	end
end


modifier_frost_arrows_slow_datadriven = class({ 
	IsDebuff			    = function(self) return true end,
	IsPurgable			    = function(self) return true end,
	DeclareFunctions        = function(self) return 
		{
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
		}
	end,
	GetEffectName           = function(self) return "particles/generic_gameplay/generic_slowed_cold.vpcf" end,
})

function modifier_frost_arrows_slow_datadriven:OnCreated()
	self.ms_slow = self:GetAbility():GetSpecialValueFor("frost_arrows_movement_speed")
end

function modifier_frost_arrows_slow_datadriven:OnRefresh( kv )
	self.ms_slow = self:GetAbility():GetSpecialValueFor("frost_arrows_movement_speed")
end

function modifier_frost_arrows_slow_datadriven:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end