modifier_abyssal_underlord_pit_of_malice_ensare_lua = class({})

function modifier_abyssal_underlord_pit_of_malice_ensare_lua:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true
	}
end

function modifier_abyssal_underlord_pit_of_malice_ensare_lua:GetEffectName()
	return "particles/units/heroes/heroes_underlord/abyssal_underlord_pitofmalice_stun.vpcf"
end

function modifier_abyssal_underlord_pit_of_malice_ensare_lua:IsPurgeException()
	return true
end
