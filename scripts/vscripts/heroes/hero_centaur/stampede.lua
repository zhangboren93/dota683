-- Emits the global sound and initializes a table to keep track of the units hit
function StampedeStart( event )

	event.ability.TargetsHit = {}

	local caster = event.caster
	caster:EmitSound("Hero_Centaur.Stampede.Cast")
	local ability = event.ability
	local team = caster:GetTeam()
	local count = PlayerResource:GetPlayerCountForTeam(team)
	local duration = ability:GetSpecialValueFor("duration")
	for i=1,count do
		local playerid = PlayerResource:GetNthPlayerIDOnTeam(team, i)
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		if hero ~= nil and hero:IsAlive() then
			ability:ApplyDataDrivenModifier(caster, hero, 
				"modifier_centaur_stampede_datadriven", { duration = duration })
		end
	end
end

--[[
	Author: Noya
	Date: 9.1.2015.
	Does damage and slow the unit, checks to damage only once per spell usage.
]]
function Stampede( event )
	-- Variables
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local casterSTR = caster:GetStrength()
	local strength_damage = ability:GetLevelSpecialValueFor( "strength_damage" , ability:GetLevel() - 1  )
	local damageType = ability:GetAbilityDamageType()
	local total_damage = ( casterSTR * strength_damage )
	local hit = false

	-- Ignore the target if its already on the table
	local targetsHit = event.ability.TargetsHit
	for k,v in pairs(targetsHit) do
		if v == target then
			hit = true
		end
	end

	if not hit then
		-- Damage
		ApplyDamage({ victim = target, attacker = caster, damage = total_damage, damage_type = damageType })

		-- Modifier
		ability:ApplyDataDrivenModifier( caster, target, "modifier_centaur_stampede_debuff_datadriven", nil)

		-- Add to the targets hit by this cast
		table.insert(event.ability.TargetsHit, target)

		target:EmitSound("Hero_Centaur.Stampede.Stun")
	end
end
