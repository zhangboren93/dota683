function shield_triggered(event)
    local attacker = event.attacker
    local target = event.target
    local ability = event.ability
    local damage = ability:GetSpecialValueFor("static_damage")
    local static_radius = ability:GetSpecialValueFor("static_range")
    local count = ability:GetSpecialValueFor("static_count") - 1

    local time = GameRules:GetDOTATime(true, false)
    if attacker:IsBuilding() or attacker:IsMagicImmune() then
        return
    end
    if ability.staticTime == nil or time - ability.staticTime > 1 then
        ability.staticTime = time

        local new_target = attacker
        -- TODO Add sound
        local particle = ParticleManager:CreateParticle( "particles/item_fx/chain_lightning.xpcf", PATTACH_POINT_FOLLOW, target )
	    ParticleManager:SetParticleControl(particle,0,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
        ParticleManager:SetParticleControl(particle,1,Vector(new_target:GetAbsOrigin().x,new_target:GetAbsOrigin().y,new_target:GetAbsOrigin().z + new_target:GetBoundingMaxs().z ))
        ApplyDamage({ victim = new_target, attacker = ability:GetCaster(), damage = damage,	damage_type = DAMAGE_TYPE_MAGICAL })

		local units = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, static_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
        for i=1,#units do
            if units[i] ~= attacker and not units[i]:IsBuilding() and not units[i]:IsMagicImmune() then
                local new_target = attacker
                local particle = ParticleManager:CreateParticle( "particles/item_fx/chain_lightning.xpcf", PATTACH_POINT_FOLLOW, target )
                ParticleManager:SetParticleControl(particle,0,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
                ParticleManager:SetParticleControl(particle,1,Vector(new_target:GetAbsOrigin().x,new_target:GetAbsOrigin().y,new_target:GetAbsOrigin().z + new_target:GetBoundingMaxs().z ))
                ApplyDamage({ victim = units[i], attacker = ability:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
                count = count - 1
                if count == 0 then
                    break
                end
            end
        end
        target:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
    end
end

item_mjollnir_datadriven = class({})

function item_mjollnir_datadriven:GetIntrinsicModifierName()
	return "modifier_item_maelstrom_datadriven"
end

function item_mjollnir_datadriven:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	caster:EmitSound("DOTA_Item.Mjollnir.Activate")
	target:AddNewModifier(caster, self, "modifier_item_mjollnir_shield_datadriven", { duration = self:GetSpecialValueFor("static_duration") })
end
