function ApplyModifiers( event )
	local caster = event.caster
	local ability = event.ability
	local buff_duration = ability:GetSpecialValueFor("duration")
	caster:AddNewModifier(caster, ability, "modifier_ursa_maul", {duration = buff_duration})
	caster:AddNewModifier(caster, ability, "modifier_ursa_enrage_model", {duration = buff_duration})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_enrage_buff_datadriven", {duration = buff_duration})
end

modifier_ursa_enrage_model = class({
	DeclareFunctions        = function(self) return 
		{MODIFIER_PROPERTY_MODEL_SCALE}
	end,
	GetModifierModelScale	= function(self) return 20 end,
	IsHidden				= function(self) return true end,
	IsPurgable				= function(self) return true end
})