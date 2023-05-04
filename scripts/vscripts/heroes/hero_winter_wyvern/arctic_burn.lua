function handleIntervalThink(event)
	local caster = event.caster
	local target = event.target
	if target:GetModelName() ~= "models/creeps/roshan/roshan.vmdl" then
		ApplyDamage({
			victim = target, 
			attacker = caster, 
			damage = target:GetHealth() * 6 / 100,
			damage_type = DAMAGE_TYPE_PURE })
	end
end