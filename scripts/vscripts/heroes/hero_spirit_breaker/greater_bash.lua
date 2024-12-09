function handleAttackLanded(event)
	local caster = event.caster
	local target = event.target
	if caster:IsIllusion() then return end
	if target:IsBuilding() then return end
	if target:GetTeam() == caster:GetTeam() then return end
	if caster:HasItemInInventory("item_basher") then return end
	local ability = event.ability
	local chance_pct = ability:GetSpecialValueFor("chance_pct")
	if RandomInt(1, 100) > chance_pct then return end
	caster:EmitSound("Hero_Spirit_Breaker.GreaterBash")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_spirit_breaker_greater_bash_speed_datadriven", {})
	local damage = ability:GetSpecialValueFor("damage") 
	damage = damage * caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), false) / 100
	ApplyDamage({
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability
	})
	local pos = caster:GetAbsOrigin()
	local knockback_distance = ability:GetSpecialValueFor("knockback_distance")
	local knockback_height = ability:GetSpecialValueFor("knockback_height")
	local knockback_duration = ability:GetSpecialValueFor("knockback_duration")
	local duration = ability:GetSpecialValueFor("duration")
	target:AddNewModifier(caster, ability, "modifier_knockback", {
		center_x = pos.x,
		center_y = pos.y,
		center_z = pos.z,
		knockback_duration = knockback_duration,
		knockback_distance = knockback_distance,
		knockback_height = knockback_height,
		duration = duration,
		should_stun = true
	})
	ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
end
