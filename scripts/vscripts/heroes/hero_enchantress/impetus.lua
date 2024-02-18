enchantress_impetus_lua = class({})

function enchantress_impetus_lua:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end

function enchantress_impetus_lua:ProcsMagicStick()
	return false
end

function enchantress_impetus_lua:IsStealable() return false end

function enchantress_impetus_lua:GetProjectileName()
	return "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf"
end

-- Orb Effects
function enchantress_impetus_lua:OnOrbFire( params )
	self:GetCaster():EmitSound("Hero_Enchantress.Impetus")
end

function enchantress_impetus_lua:OnOrbImpact( params )
	-- unit identifier
	local caster = self:GetCaster()
	local target = params.target

	-- load data
	local distance_cap = self:GetSpecialValueFor("distance_damage_cap")
	local distance_dmg = self:GetSpecialValueFor("distance_damage_pct")
	
	-- calculate distance & damage
	local distance = math.min( (caster:GetOrigin()-target:GetOrigin()):Length2D(), distance_cap )
	local damage = distance_dmg/100 * distance

	-- apply damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- play effects
	local sound_cast = "Hero_Enchantress.ImpetusDamage"
	EmitSoundOn( sound_cast, target )
end

function DisToDamage(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
    local disPct = ability:GetSpecialValueFor("distance_damage_pct")
    local damageCap = ability:GetSpecialValueFor("distance_damage_cap")
    local loc1 = caster:GetAbsOrigin()
    local loc2 = target:GetAbsOrigin()
    local dist = math.sqrt((loc1[1] - loc2[1]) * (loc1[1] - loc2[1]) + (loc1[2] - loc2[2]) * (loc1[2] - loc2[2]))
    local damage = dist * disPct / 100
    if damage > damageCap then
        damage = damageCap
    end
    print("Dist " .. dist .. " damage " .. damage)

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.ability = ability
	damage_table.victim = target

	damage_table.damage = damage

	ApplyDamage(damage_table)
end
