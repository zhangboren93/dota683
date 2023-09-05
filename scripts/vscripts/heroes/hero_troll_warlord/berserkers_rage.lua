function handleIntervalThink(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_troll_warlord_berserkers_rage") then
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
	    	EmitSoundOn("soundevents/game_sounds_heroes/game_sounds_troll_warlord.vsndevts", target)
	    	ApplyDamage(damage_table)
        end
    end
end
