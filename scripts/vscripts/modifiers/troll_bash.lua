if modifier_troll_warlord_bash == nil then
    modifier_troll_warlord_bash = class({})
end

function modifier_troll_warlord_bash:OnCreated(kv)
    self.kv = kv
    DeepPrintTable(kv)
end

function modifier_troll_warlord_bash:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_troll_warlord_bash:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function modifier_troll_warlord_bash:GetModifierPreAttack_BonusDamage()
    return self.kv.bonus_damage
end

function modifier_troll_warlord_bash:IsHidden()
    return true
end

function modifier_troll_warlord_bash:OnAttackLanded(event)
    if not event.ranged_attack then
        if RandomInt(1, 100) <= self.kv.bash_chance then
            local target = event.target
            local attacker = event.attacker
            local ability = attacker:FindAbilityByName("troll_warlord_berserkers_rage")
            local bashDuration = ability:GetLevelSpecialValueFor("bash_duration", ability:GetLevel() - 1)
            local bashDamage = ability:GetLevelSpecialValueFor("bash_damage", ability:GetLevel() - 1)
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