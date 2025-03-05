function handleIntervalThink(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_troll_warlord_melee") then
		if not caster:HasModifier("modifier_berserkers_rage_active_datadriven") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_berserkers_rage_active_datadriven", {})
		end
		caster:GetAbilityByIndex(1):SetActivated(false) -- ranged
		caster:GetAbilityByIndex(2):SetActivated(true) -- melee
	else
		caster:RemoveModifierByName("modifier_berserkers_rage_active_datadriven")
		caster:GetAbilityByIndex(1):SetActivated(true) -- ranged
		caster:GetAbilityByIndex(2):SetActivated(false) -- melee
	end
end

function handleAttackLanded(event)
    local attacker = event.attacker
	local target = event.target
	if target:IsBuilding() or attacker:IsIllusion() or attacker:PassivesDisabled() then
		return 
	end
    if not attacker:IsRangedAttacker() then
        local ability = attacker:FindAbilityByName("troll_warlord_berserkers_rage")
        if RandomInt(1, 100) <= ability:GetSpecialValueFor("bash_chance") then
            local bashDuration = ability:GetSpecialValueFor("bash_duration")
            local bashDamage = ability:GetSpecialValueFor("bash_damage")
	    	local damage_table = {}
	    	damage_table.attacker = attacker
	    	damage_table.victim = target
	    	damage_table.ability = ability
	    	damage_table.damage_type = DAMAGE_TYPE_PHYSICAL 
	    	damage_table.damage = bashDamage
	    	target:AddNewModifier(attacker, ability, "modifier_stunned", {Duration = bashDuration})
	    	ApplyDamage(damage_table)
			target:EmitSound("Hero_TrollWarlord.BerserkersRage.Stun")
        end
    end
end

--[[Author: Pizzalol
	Date: 14.03.2015.
	Checks the latest attack state and target to determine if a bash should be applied]]
function BerserkersRageBash( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local bash_duration = ability:GetLevelSpecialValueFor("bash_duration", ability_level) 
	local bash_damage = ability:GetLevelSpecialValueFor("bash_damage", ability_level)
	local sound = keys.sound

	-- Check the latest attack state and target to prevent ranged bashes
	if caster.berserkers_rage_attack == DOTA_UNIT_CAP_MELEE_ATTACK and caster.berserkers_rage_target == target then
		local damage_table = {}
		damage_table.attacker = caster
		damage_table.victim = target
		damage_table.ability = ability
		damage_table.damage_type = ability:GetAbilityDamageType() 
		damage_table.damage = bash_damage

		target:AddNewModifier(caster, ability, "modifier_stunned", {Duration = bash_duration})
		EmitSoundOn(sound, target)
		ApplyDamage(damage_table)
	end
end

function handleToggleOn(keys)
	local caster = keys.caster
	local ability = keys.ability
	caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
	if not caster:HasModifier("modifier_troll_warlord_berserkers_rage_lua") then
		caster:AddNewModifier(caster, ability, "modifier_troll_warlord_berserkers_rage_lua", {})
	end
end

function handleToggleOff(keys)
	local caster = keys.caster
	local ability = keys.ability
	caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	caster:RemoveModifierByName("modifier_troll_warlord_berserkers_rage_lua")
end

--[[Author: Pizzalol
	Date: 14.03.2015.
	Swaps the attack capability of the caster]]
function BerserkersRageAttackCapability( keys )
	local caster = keys.caster

	if caster:GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then
		caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	else
		caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK) 
	end
end

--[[Author: Pizzalol
	Date: 14.03.2015.
	Keep track of the attacked target and the current attack state]]
function BerserkersRageTrack( keys )
	local caster = keys.caster
	local target = keys.target
	caster.berserkers_rage_attack = caster:GetAttackCapability()
	caster.berserkers_rage_target = target
end

--[[Author: Noya
	Used by: Pizzalol
	Date: 14.03.2015.
	Swaps the abilities]]
function SwapAbilities( keys )
	local caster = keys.caster

	-- Swap sub_ability
	local sub_ability_name = keys.sub_ability_name
	local main_ability_name = keys.main_ability_name

	caster:SwapAbilities(main_ability_name, sub_ability_name, false, true)
end
