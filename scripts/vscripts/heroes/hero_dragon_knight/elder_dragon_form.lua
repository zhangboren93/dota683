function handleAttackLanded(event)
	if event.caster:HasModifier("modifier_dragon_knight_corrosive_breath") then
		event.ability:ApplyDataDrivenModifier(event.caster, event.target, 
			"modifier_dragon_knight_corrosive_breath_dot_datadriven", 
			{ duration = 5 })
	end
end

function handleIntervalThink(event)
	ApplyDamage({
		victim = event.target, 
		attacker = event.caster, 
		damage = 20, 
		damage_type = DAMAGE_TYPE_MAGICAL, 
		damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL})
end
