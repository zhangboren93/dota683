function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if target:TriggerSpellAbsorb(ability) then return end
	target:EmitSound("Hero_Disruptor.Glimpse.Target")
	ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_glimpse_targetstart.vpcf", PATTACH_ABSORIGIN, target)
	-- TODO projectile to hero 4s position
end

function handleIntervalThink(event)
	-- TODO record all hero's position
end
