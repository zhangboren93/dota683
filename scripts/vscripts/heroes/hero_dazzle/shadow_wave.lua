require("../../items/item_magic_stick")
--------------------------------------------------------------------------------
-- Ability Start
--
local function targetNotHealed(target, healedUnits)
	for i = 1,#healedUnits do
		if target:GetEntityIndex() == healedUnits[i]:GetEntityIndex() then
			return false
		end
	end
	return true
end

function ShadowWave(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	-- references
	local radius = ability:GetSpecialValueFor( "damage_radius" )
	local bounce_radius = ability:GetSpecialValueFor( "bounce_radius" )
	local jumps = ability:GetSpecialValueFor( "max_targets" )
	local damage = ability:GetSpecialValueFor( "damage" )

	ProcsMagicStick(keys)
	-- precache damage

	-- unit groups
	local healedUnits = {}
	table.insert( healedUnits, caster )

	local source = caster

	-- Jump
	while(true) do
		source:Heal( damage, ability )

		-- Find enemy nearby
		local enemies = FindUnitsInRadius(
			source:GetTeamNumber(),	-- int, your team number
			source:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		-- Damage
		local damageTable =
		{
			-- victim = target,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = ability, --Optional.
		}
		for _,enemy in pairs(enemies) do
			damageTable.victim = enemy
			ApplyDamage( damageTable )

			-- Play effects
			ShadowWavePlayEffects2( enemy )
		end

		-- counter
		local jump = jumps - 1
		if jump < 0 then
			break
		end

		-- next target
		local nextTarget = nil
		if target and target ~= source and targetNotHealed(target, healedUnits) then
			nextTarget = target
		else
			-- Find ally nearby
			local allies = FindUnitsInRadius(
				source:GetTeamNumber(),	-- int, your team number
				source:GetOrigin(),	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				bounce_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
				FIND_CLOSEST,	-- int, order filter
				false	-- bool, can grow cache
			)
		
			for _,ally in pairs(allies) do
				local pass = false
				for _,unit in pairs(healedUnits) do
					if ally == unit then
						pass = true
					end
				end

				if not pass then
					nextTarget = ally
					break
				end
			end
		end

		if nextTarget then
			table.insert( healedUnits, nextTarget )
			jumps = jump
			source = nextTarget
		else
			break
		end

		ShadowWavePlayEffects1( source, nextTarget )
	end

	EmitSoundOn( "Hero_Dazzle.Shadow_Wave", caster )
end

--------------------------------------------------------------------------------
function ShadowWavePlayEffects1( source, target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf"

	if not target then
		target = source
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, source )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		source,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		source:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function ShadowWavePlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dazzle/dazzle_shadow_wave_impact_damage.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
