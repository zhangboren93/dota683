--[[
    author: jacklarnes
    email: christucket@gmail.com
    reddit: /u/jacklarnes
    Date: 05.04.2015.
]]

--[[
    issues: partical doesn't follow the unit
]]


function diabolic_edict_start( keys )
    local caster = keys.caster
    local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_leshrac_diabolic_edict_datadriven", { duration = 10 })
end

function diabolic_edict_repeat( event )
	local ability = event.ability
	local caster = event.caster
	local num_explosions = ability.num_explosions
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetAbilityDamage()
	local tower_bonus = ability:GetSpecialValueFor("tower_bonus")

    -- hit initial target
    --[[local lightning = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, params.initial_target)
    local loc = params.initial_target:GetAbsOrigin()
    ParticleManager:SetParticleControl(lightning, 0, loc + Vector(0, 0, 1000))
    ParticleManager:SetParticleControl(lightning, 1, loc)
    ParticleManager:SetParticleControl(lightning, 2, loc)
    EmitSoundOn("Hero_Leshrac.Lightning_Storm", params.initial_target)]]

    -- find next target (closest one to previous one)
    unitsInRange = FindUnitsInRadius(caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false)

    local target = unitsInRange[RandomInt(1, #unitsInRange)]

    local pulse = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_diabolic_edict.vpcf", PATTACH_WORLDORIGIN, caster)
    
    -- if target is nil then pick a random spot to do explosion, 
    -- otherwise do it on target and cause damage
    if target == nil then
        x, y = GetRandomXYInCircle(radius)
        local loc = Vector(x, y, 0)
        local caster_loc = caster:GetAbsOrigin()
        ParticleManager:SetParticleControl(pulse, 1, caster_loc + loc)
    else
        local target_loc = target:GetAbsOrigin()
        ParticleManager:SetParticleControl(pulse, 1, target_loc)

        --tower_bonus
        if target:IsTower() then
            damage = damage * (1 + tower_bonus/100)
        end

        local damageTable = {
            attacker = caster,
            victim = target,
            damage = damage,
            damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_PHYSICAL_BLOCK,
            ability = ability}
        ApplyDamage(damageTable)
    end
    caster:EmitSound("Hero_Leshrac.Diabolic_Edict")
end

function GetRandomXYInCircle(radius)
    local degree = math.random(360)
    local radi = math.random(100, radius)

    return math.cos(degree) * radi, math.sin(degree) * radi
end

function diabolic_edict_stop(event)
	local caster = event.caster
    StopSoundEvent("Hero_Leshrac.Diabolic_Edict_lp", caster)
end
