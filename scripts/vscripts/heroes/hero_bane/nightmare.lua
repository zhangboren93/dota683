function handleIntervalThink(event)
	local caster = event.caster
	local target = event.target
	if target:HasModifier("modifier_bane_nightmare") and target:GetTeam() ~= caster:GetTeam() then
		ApplyDamage({victim = target, attacker = caster, damage = 20, damage_type = DAMAGE_TYPE_PURE})
	end
end