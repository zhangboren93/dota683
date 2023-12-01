function SetWardDamage( event )
	local target = event.target
	local ability = event.ability
	local attack_damage_min = ability:GetLevelSpecialValueFor("damage_min", ability:GetLevel() - 1 )
	local attack_damage_max = ability:GetLevelSpecialValueFor("damage_max", ability:GetLevel() - 1 )

	target:SetBaseDamageMax(attack_damage_max)
	target:SetBaseDamageMin(attack_damage_min)

end

-- Deal splash damage to units in full/medium/small radius, ignore the main target of the attack which was already damaged
function DealSplashDamage( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local targets = event.target_entities

	-- 3 different Radius
	local full_splash_radius = ability:GetLevelSpecialValueFor("full_splash_radius", ability:GetLevel() - 1 )
	local mid_splash_radius = ability:GetLevelSpecialValueFor("mid_splash_radius", ability:GetLevel() - 1 )
	local min_splash_radius = ability:GetLevelSpecialValueFor("min_splash_radius", ability:GetLevel() - 1 )

	-- Damage percentages
	local splash_full = ability:GetLevelSpecialValueFor("splash_full", ability:GetLevel() - 1 ) * 0.01
	local splash_medium = ability:GetLevelSpecialValueFor("splash_medium", ability:GetLevel() - 1 ) * 0.01
	local splash_small = ability:GetLevelSpecialValueFor("splash_small", ability:GetLevel() - 1 ) * 0.01

	-- Substract the percents to account for hitting a unit twice/thrice
	splash_medium = splash_medium - splash_small
	splash_full = splash_full - splash_medium - splash_small

	local attack_damage = caster:GetAverageTrueAttackDamage(nil)

	local team = caster:GetTeamNumber()
	local origin = target:GetAbsOrigin()
	local iTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local iType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local iFlag = DOTA_UNIT_TARGET_FLAG_NONE
	local iOrder = FIND_ANY_ORDER
	
	local full_enemies = FindUnitsInRadius(team, origin, nil, full_splash_radius, iTeam, iType, iFlag, iOrder, false)
	local medium_enemies = FindUnitsInRadius(team, origin, nil, mid_splash_radius, iTeam, iType, iFlag, iOrder, false)
	local small_enemies = FindUnitsInRadius(team, origin, nil, min_splash_radius, iTeam, iType, iFlag, iOrder, false)

	for _,enemy in pairs(full_enemies) do
		if enemy ~= target then
			ApplyDamage({ victim = enemy, attacker = caster, damage = attack_damage * splash_full, damage_type = DAMAGE_TYPE_MAGICAL})
		end
	end

	for _,enemy in pairs(medium_enemies) do
		if enemy ~= target then
			ApplyDamage({ victim = enemy, attacker = caster, damage = attack_damage * splash_medium, damage_type = DAMAGE_TYPE_MAGICAL})
		end
	end

	for _,enemy in pairs(small_enemies) do
		if enemy ~= target then
			ApplyDamage({ victim = enemy, attacker = caster, damage = attack_damage * splash_small, damage_type = DAMAGE_TYPE_MAGICAL})
		end
	end
end

function handleSpellStart(event)
	local ability = event.ability
	local unit_name = "npc_dota_shadow_shaman_ward_" .. ability:GetLevel()
	local point = event.target:GetAbsOrigin()
	local caster = event.caster
	local forward = (caster:GetAbsOrigin() - point):Normalized() * 32 * 2
	local right = Vector(forward.y, -forward.x, 0)
	placeWard(unit_name, ability, caster, point + forward + 2 * right)
	placeWard(unit_name, ability, caster, point + forward + right)
	placeWard(unit_name, ability, caster, point + forward)
	placeWard(unit_name, ability, caster, point + forward - right)
	placeWard(unit_name, ability, caster, point + forward - 2 * right)
	placeWard(unit_name, ability, caster, point + right)
	placeWard(unit_name, ability, caster, point - right)
	placeWard(unit_name, ability, caster, point - forward - right)
	placeWard(unit_name, ability, caster, point - forward)
	placeWard(unit_name, ability, caster, point - forward + right)
end

function placeWard(unit_name, ability, caster, point)
	local duration = ability:GetSpecialValueFor("duration")
	--print(point)
	CreateUnitByNameAsync(unit_name, point, false, caster, caster, caster:GetTeam(), function(unit)
		--unit:AddNewModifier(caster, ability, "modifier_phased", { duration = 0.3 })
		unit:AddNewModifier(caster, ability, "modifier_kill", { duration = duration })
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_serpent_ward", {})
		unit:SetControllableByPlayer(caster:GetPlayerID(), false)
	end)
end
