function modifier_item_maelstrom_datadriven_on_orb_impact(event)
    local ability = event.ability
    local caster = event.caster
    local target = event.caster
    local new_target = event.target
    local damage = ability:GetSpecialValueFor("chain_damage")
    local chain_delay = ability:GetSpecialValueFor("chain_delay")
    local count = ability:GetSpecialValueFor("chain_strikes")
    local chain_radius = ability:GetSpecialValueFor("chain_radius")
    local victims = {}
    victims[new_target:GetEntityIndex()] = true

    if new_target:IsBuilding() or new_target:IsMagicImmune() then
        return
    end

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_POINT_FOLLOW, target )
	ParticleManager:SetParticleControl(particle,0,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
	ParticleManager:SetParticleControl(particle,1,Vector(new_target:GetAbsOrigin().x,new_target:GetAbsOrigin().y,new_target:GetAbsOrigin().z + new_target:GetBoundingMaxs().z ))
    new_target:EmitSound("Item.Maelstrom.Chain_Lightning")
	ApplyDamage({ victim = new_target, attacker = caster, damage = damage,	damage_type = DAMAGE_TYPE_MAGICAL })
    count = count - 1

    caster:SetThink(function()
        target = new_target
        new_target = nil
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, chain_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
        for i=1,#units do
            if not units[i]:IsMagicImmune() and victims[units[i]:GetEntityIndex()] == nil then
                new_target = units[i]
                break
            end
        end
        if new_target == nil then
            return
        end
        victims[new_target:GetEntityIndex()] = true
    	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_POINT_FOLLOW, target )
    	ParticleManager:SetParticleControl(particle,0,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
    	ParticleManager:SetParticleControl(particle,1,Vector(new_target:GetAbsOrigin().x,new_target:GetAbsOrigin().y,new_target:GetAbsOrigin().z + new_target:GetBoundingMaxs().z ))
        new_target:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
    	ApplyDamage({ victim = new_target, attacker = caster, damage = damage,	damage_type = DAMAGE_TYPE_MAGICAL })
        count = count - 1
        if count > 0 then
            return chain_delay
        end
    end, "finds another target", chain_delay)
end
