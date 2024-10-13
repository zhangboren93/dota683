function handleIntervalThink(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local percent_damage_pure = ability:GetSpecialValueFor("percent_damage_pure")
	ApplyDamage({
		victim = target, 
		attacker = caster, 
		damage = target:GetHealth() * percent_damage_pure / 100,
		damage_type = DAMAGE_TYPE_PURE,
		ability = ability
	})
end

function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	caster:AddNewModifier(caster, ability, 
		"modifier_winter_wyvern_arctic_burn_flight_datadriven",
		{ duration = ability:GetSpecialValueFor("duration") })
	caster:EmitSound("Hero_Winter_Wyvern.ArcticBurn.Cast")
	ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_start.vpcf",
		PATTACH_ABSORIGIN, caster)
end
