function handleAttackStart(event)
	local target = event.target
	local attacker = event.attacker
	if target:GetTeam() ~= attacker:GetTeam() and not target:IsBuilding() and not attacker:PassivesDisabled() then
		event.ability:ApplyDataDrivenModifier(attacker, attacker, event.ModifierName, {})
	end
end

function handleAttackLanded(event)
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	local chance = ability:GetSpecialValueFor("chance_pct")
	local bonus_damage = ability:GetSpecialValueFor("bonus_damage")
	local i = RandomInt(1, 100)
	if i <= chance then
		target:EmitSound("Hero_FacelessVoid.TimeLockImpact")
		ability:ApplyDataDrivenModifier(attacker, target, "modifier_time_lock_stun_datadriven", { duration = 1 })
		--double damage if in chronosphere
		if target:HasModifier("modifier_faceless_void_chronosphere_freeze") then
			bonus_damage = bonus_damage * 2
		end
		ApplyDamage({
			attacker = attacker,
			victim = target,
			damage = bonus_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability
		})
	end
end
