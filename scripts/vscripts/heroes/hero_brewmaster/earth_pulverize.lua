function handleAttack(event)
	if event.attacker ~= event.caster then return end
	local target = event.target
	if target:IsWard() or target:IsBuilding() then return end
	local ability = event.ability
	local chance = ability:GetSpecialValueFor("chance")
	if RandomInt(1, 100) > chance then return end
	local damage_inner = ability:GetSpecialValueFor("damage_inner")
	local radius_inner = ability:GetSpecialValueFor("radius_inner")
	local damage_outer = ability:GetSpecialValueFor("damage_outer")
	local radius_outer = ability:GetSpecialValueFor("radius_outer")
	local caster = event.caster
	local units = FindUnitsInRadius(
		caster:GetTeam(),
		caster:GetAbsOrigin(),
		nil, 
		radius_outer,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
	for i=1,#units do
		local damage = damage_outer
		if (units[i]:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() <= radius_inner then
			damage = damage_inner
		end
		ApplyDamage({
			victim = units[i],
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability})
	end
end
