--[[
	Author: Noya
	Date: 9.1.2015.
	Adds gold based on stacks with a duration
	The stack tracks the gold to be gained on the next kill
]]
function GoblinsGreed( event )
	-- Variables
	local caster = event.caster
	local target = event.unit
	if caster:GetTeam() == target:GetTeam() then
		return
	end
	local player = PlayerResource:GetPlayer( caster:GetPlayerID() )
	if caster:IsIllusion() then
		caster = player:GetAssignedHero()
	end
	local ability = event.ability
	local bonus_gold = ability:GetLevelSpecialValueFor( "bonus_gold", ability:GetLevel() - 1 )
	local bonus_bonus_gold = ability:GetLevelSpecialValueFor( "bonus_bonus_gold", ability:GetLevel() - 1 )
	local bonus_gold_cap = ability:GetLevelSpecialValueFor( "bonus_gold_cap", ability:GetLevel() - 1 )
	local stack_duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local stacks = #caster:FindAllModifiersByName("modifier_goblins_greed_stack_duration") * bonus_bonus_gold + bonus_gold
	if stacks > bonus_gold_cap then
		stacks = bonus_gold_cap
	end

	-- Grant the gold
	print("GG Stack Count: " .. stacks)
	caster:ModifyGold(stacks, false, 0)

	-- Show the particles, player only
	local particleName = "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf"		
	local particle = ParticleManager:CreateParticleForPlayer( particleName, PATTACH_ABSORIGIN, target, player )
	ParticleManager:SetParticleControl( particle, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl( particle, 1, target:GetAbsOrigin() )
	
	-- Message Particle, has a bunch of options
	-- Similar format to the popup library by soldiercrabs: http://www.reddit.com/r/Dota2Modding/comments/2fh49i/floating_damage_numbers_and_damage_block_gold/
	local symbol = 0 -- "+" presymbol
	local color = Vector(255, 200, 33) -- Gold
	local lifetime = 2
	local digits = string.len(stacks) + 1
	local particleName = "particles/units/heroes/hero_alchemist/alchemist_lasthit_msg_gold.vpcf"
	local particle = ParticleManager:CreateParticleForPlayer( particleName, PATTACH_ABSORIGIN, target, player )
	ParticleManager:SetParticleControl(particle, 1, Vector(symbol, stacks, symbol))
    ParticleManager:SetParticleControl(particle, 2, Vector(lifetime, digits, 0))
    ParticleManager:SetParticleControl(particle, 3, color)
	
	-- Increase the stack. Never go beyond the bonus gold cap
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_goblins_greed_stack_duration", {})
	if stacks < bonus_gold_cap then
		-- If the increased stack would surpass the gold cap, restrict it
		local newStack = stacks + bonus_bonus_gold
		if newStack  > bonus_gold_cap then
			caster:SetModifierStackCount("modifier_goblins_greed", ability, bonus_gold_cap )
		else
			caster:SetModifierStackCount("modifier_goblins_greed", ability, stacks + bonus_bonus_gold )
		end
	end
end

-- Sets the base and upgrade bonus
function handleIntervalThink( event )
	local caster = event.caster
	local ability = event.ability
	local bonus_gold = ability:GetLevelSpecialValueFor( "bonus_gold", ability:GetLevel() - 1 )
	local bonus_bonus_gold = ability:GetLevelSpecialValueFor( "bonus_bonus_gold", ability:GetLevel() - 1 )
	local bonus_gold_cap = ability:GetLevelSpecialValueFor( "bonus_gold_cap", ability:GetLevel() - 1 )
	local stacks = #caster:FindAllModifiersByName("modifier_goblins_greed_stack_duration") * bonus_bonus_gold + bonus_gold
	if stacks > bonus_gold_cap then stacks = bonus_gold_cap end
	caster:SetModifierStackCount("modifier_goblins_greed", ability, stacks)
end