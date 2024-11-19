--[[Last Word stop loop sound
	Author: chrislotix
	Date: 11.1.2015.]]

function LastWordStopSound( keys )

	local sound_name = "Hero_Silencer.LastWord.Target"
	local unit = keys.unit
	local event_ability = keys.event_ability
	local ability = keys.ability
	local caster = keys.caster
	if event_ability:IsItem() then
		print("Won't trigger last word on item use " .. event_ability:GetName())
		return
	end

	StopSoundEvent(sound_name, unit)
	unit:EmitSound("Hero_Silencer.LastWord.Damage")
	unit:RemoveModifierByName("modifier_last_word_datadriven")
	ability:ApplyDataDrivenModifier(caster, unit, "modifier_last_word_silence_datadriven", {})
	local damage = ability:GetSpecialValueFor("damage")
	ApplyDamage({
		victim = unit,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability
	})
end
