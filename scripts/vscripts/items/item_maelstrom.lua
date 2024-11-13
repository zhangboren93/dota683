function modifier_item_maelstrom_datadriven_on_orb_impact(event)
    local ability = event.ability
    local caster = event.caster
    local target = event.caster
    local new_target = event.target
    local damage = ability:GetSpecialValueFor("chain_damage")
    local chain_delay = ability:GetSpecialValueFor("chain_delay")
    local count = ability:GetSpecialValueFor("chain_strikes")
    local victims = {}
    victims[new_target:GetEntityIndex()] = true

    if new_target:IsBuilding() or target:IsIllusion() then
        return
    end
	if not caster:HasModifier("modifier_maelstrom_trigger_no_miss") then
		return
	end
	caster:RemoveModifierByName("modifier_maelstrom_trigger_no_miss")
	
	local particle = ParticleManager:CreateParticle( "particles/items_fx/chain_lightning.vpcf", PATTACH_POINT_FOLLOW, target )
	ParticleManager:SetParticleControl(particle,0,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
	ParticleManager:SetParticleControl(particle,1,Vector(new_target:GetAbsOrigin().x,new_target:GetAbsOrigin().y,new_target:GetAbsOrigin().z + new_target:GetBoundingMaxs().z ))
    new_target:EmitSound("Item.Maelstrom.Chain_Lightning")
	ApplyDamage({ victim = new_target, attacker = caster, damage = damage,	damage_type = DAMAGE_TYPE_MAGICAL })
    count = count - 1

	CreateModifierThinker(caster, ability, "modifier_item_maelstrom_thinker_lua", {
		["duration"] = 3,
		target = new_target:entindex(),
		count = count,
	}, caster:GetAbsOrigin(), caster:GetTeam(), false)
end

function handleOrbFire(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local chain_chance = ability:GetSpecialValueFor("chain_chance")
	if target:IsBuilding() or caster:IsIllusion() or target:GetTeam() == caster:GetTeam() then
		return
	end
	if RandomInt(1, 100) <= chain_chance then
		if not caster:HasModifier("modifier_maelstrom_trigger_no_miss") then
			caster:AddNewModifier(caster, ability, "modifier_maelstrom_trigger_no_miss", { duration = 1 })
		end

		-- flaming fist triggers immediately
		if caster:HasModifier("modifier_ember_spirit_sleight_of_fist_caster_invulnerability") then
			modifier_item_maelstrom_datadriven_on_orb_impact(event)
		end

	end
end

item_maelstrom_datadriven = class({})
function item_maelstrom_datadriven:GetIntrinsicModifierName()
	return "modifier_item_maelstrom_datadriven"
end
