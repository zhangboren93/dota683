require("../../items/item_magic_stick")
function applyAttributeDebuff(event)
    local target = event.target
    local ability = event.ability
    local primary_attr = target:GetPrimaryAttribute()
    local primary_attr_value = 0
    local debuff_modifier_name = ""
    if primary_attr == DOTA_ATTRIBUTE_STRENGTH then
        primary_attr_value = target:GetBaseStrength()
        debuff_modifier_name = "modifier_timber_whiling_death_debuff_str"
    elseif primary_attr == DOTA_ATTRIBUTE_AGILITY then
        primary_attr_value = target:GetBaseAgility()
        debuff_modifier_name = "modifier_timber_whiling_death_debuff_agi"
    else
        primary_attr_value = target:GetBaseIntellect()
        debuff_modifier_name = "modifier_timber_whiling_death_debuff_int"
    end

    local num_debuff = math.floor(primary_attr_value * ability:GetSpecialValueFor("stat_loss_pct") / 100)
    for i=1,num_debuff do
        ability:ApplyDataDrivenModifier(event.caster, target, debuff_modifier_name, {})
    end
end

function applyDamage(event)
    local caster = event.caster
    local ability = event.ability
    local whirling_radius = ability:GetSpecialValueFor("whirling_radius") 
    local whirling_damage = ability:GetSpecialValueFor("whirling_damage") 
    local has_tree = GridNav:IsNearbyTree(caster:GetAbsOrigin(), whirling_radius, false)
    local damage_type = DAMAGE_TYPE_MAGICAL if has_tree then damage_type = DAMAGE_TYPE_PURE end
	ProcsMagicStick(event)
    GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), whirling_radius, false)
    local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, whirling_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
    for i=1,#units do
        ApplyDamage({victim = units[i], attacker = caster, damage = whirling_damage, damage_type = damage_type})
    end
end
