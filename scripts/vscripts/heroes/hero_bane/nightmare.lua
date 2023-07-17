function handleIntervalThink(event)
	local caster = event.caster
	local target = event.target
	if target:HasModifier("modifier_bane_nightmare") and target:GetTeam() ~= caster:GetTeam() then
		ApplyDamage({victim = target, attacker = caster, damage = 20, damage_type = DAMAGE_TYPE_PURE})
	end
end

function handleAttackStart(event)
	local target = event.target
	local attacker = event.attacker
	local caster = event.caster
	local nightmare = caster:FindAbilityByName("bane_nightmare")
	if target:HasModifier("modifier_bane_nightmare") and target:GetTeam() ~= attacker:GetTeam() then
		attacker:AddNewModifier(caster, nightmare, "modifier_bane_nightmare",
			{duration = nightmare:GetSpecialValueFor("duration")})
		target:RemoveModifierByName("modifier_bane_nightmare")
	end
end
