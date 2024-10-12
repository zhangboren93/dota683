modifier_oracle_fates_edict_lua = class({
	CheckState = function() return {
		[ MODIFIER_STATE_DISARMED ] = true
	} end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	} end,
	GetModifierMagicalResistanceBonus = function() return 100 end,
	GetModifierIncomingDamage_Percentage = function() return 50 end,
	IsPurgable = function() return false end,
	IsPurgeException = function() return true end,
	IsDebuff = function() return true end,
	GetEffectName = function() return "particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf" end
})
