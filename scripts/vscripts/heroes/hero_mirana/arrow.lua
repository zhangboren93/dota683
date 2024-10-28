function handleAbilityExecuted(event)
	-- mirana's jump dodges projectile
	if event.event_ability:GetName() == "mirana_leap" then
		local ability = event.event_ability
		ProjectileManager:ProjectileDodge(event.caster)
		local caster = event.caster
		local units = FindUnitsInRadius(
			caster:GetTeam(),
			caster:GetAbsOrigin(),
			nil,
			775, 
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)
		if #units > 0 then
			for i = 1,#units do
				units[i]:AddNewModifier(caster, ability, "modifier_mirana_leap_buff", {duration = ability:GetSpecialValueFor("leap_bonus_duration")})
			end
		end
	end
	-- startfall will hit randomly unit within 175 radius
	if event.event_ability:GetName() == "mirana_starfall" then
		local caster = event.caster
		local units = FindUnitsInRadius(
			caster:GetTeam(),
			caster:GetAbsOrigin(),
			nil,
			175, 
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)
		if #units > 0 then
			local unit = units[RandomInt(1, #units)]
			caster:SetThink(function()
				event.ability:ApplyDataDrivenModifier(caster, unit, "modifier_mirana_secondary_datadriven", {})
			end, "secondary star fall", 0.8)
		end
	end
end

function handleSecondaryDestroyed(event)
	if not IsServer() then return end
	local caster = event.caster
	local target = event.target
	local starfall = caster:FindAbilityByName("mirana_starfall")
	local damage = starfall:GetSpecialValueFor("damage") * 75 / 100
	ApplyDamage({
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = starfall})
	target:EmitSound("Hero_Mirana.Starstorm.Impact")
end

--[[Author: Pizzalol
	Date: 26.09.2015.
	Initializes the required data for the arrow stun,damage and vision calculation]]
function LaunchArrow( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local target_point = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	ability.arrow_vision_radius = ability:GetLevelSpecialValueFor("arrow_vision", ability_level)
	ability.arrow_vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)
	ability.arrow_speed = ability:GetLevelSpecialValueFor("arrow_speed", ability_level)
	ability.arrow_start = caster_location
	ability.arrow_start_time = GameRules:GetGameTime()
	ability.arrow_direction = (target_point - caster_location):Normalized()
end

--[[Calculates the distance traveled by the arrow, then applies damage and stun according to calculations]]
function ArrowHit( keys )
	local caster = keys.caster
	local target = keys.target
	local target_location = target:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_damage = ability:GetAbilityDamage()

	-- Initializing the damage table
	local damage_table = {}
	damage_table.attacker = caster
	damage_table.victim = target
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.ability = ability	

	-- Arrow
	local arrow_max_stunrange = ability:GetLevelSpecialValueFor("arrow_max_stunrange", ability_level)
	local arrow_max_damagerange = ability:GetLevelSpecialValueFor("arrow_max_damagerange", ability_level)
	local arrow_min_stun = ability:GetLevelSpecialValueFor("arrow_min_stun", ability_level)
	local arrow_max_stun = ability:GetLevelSpecialValueFor("arrow_max_stun", ability_level)
	local arrow_bonus_damage = ability:GetLevelSpecialValueFor("arrow_bonus_damage", ability_level)

	-- Stun and damage per distance
	local stun_per_30 = arrow_max_stun/(arrow_max_stunrange*1/30)
	local damage_per_30 = arrow_bonus_damage/(arrow_max_damagerange*1/30)

	local arrow_stun_duration = 0
	local arrow_damage = 0
	local distance = (target_location - ability.arrow_start):Length2D()

	-- Stun
	if distance < arrow_max_stunrange then
		arrow_stun_duration = distance*1/30*stun_per_30 + arrow_min_stun
	else
		arrow_stun_duration = arrow_max_stun
	end

	-- Damage
	if distance < arrow_max_damagerange then
		arrow_damage = distance*1/30*damage_per_30 + ability_damage
	else
		arrow_damage = ability_damage + arrow_bonus_damage
	end

	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = arrow_stun_duration})
	damage_table.damage = arrow_damage
	ApplyDamage(damage_table)
end

--[[Calculates arrow location using available data and then creates a vision point]]
function ArrowVision( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- Calculate the arrow location using the data we saved at launch
	local vision_location = ability.arrow_start + ability.arrow_direction * ability.arrow_speed * (GameRules:GetGameTime() - ability.arrow_start_time)

	-- Create the vision point
	AddFOWViewer(caster:GetTeamNumber(), vision_location, ability.arrow_vision_radius, ability.arrow_vision_duration, false)
end
