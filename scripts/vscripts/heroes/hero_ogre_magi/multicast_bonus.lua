function handleAbilityExecuted(keys)
    local unit = keys.unit
    local ability = keys.ability
    local event_ability = keys.event_ability
    local target = keys.target
    if event_ability:GetName() == "ogre_magi_fireblast" then
        unit:SetThink(function()
            local multicast = ability
            local newCooldown = event_ability:GetCooldown(event_ability:GetLevel()) + multicast:GetSpecialValueFor("blast_cooldown")
            event_ability:EndCooldown()
            event_ability:StartCooldown(newCooldown)
            unit:SpendMana(multicast:GetSpecialValueFor("blast_mana_cost"), event_ability)
        end, "reset blast cooldown", 0.1)
		
		-- multicast blast
		local two_times = ability:GetSpecialValueFor( "multicast_2_times")
		local three_times = ability:GetSpecialValueFor( "multicast_3_times")
		local four_times = ability:GetSpecialValueFor( "multicast_4_times")
		local rand = math.random(1,100)
		local multicast = 1
		if rand < four_times then
			multicast = 4
		elseif rand < three_times then
			multicast = 3
		elseif rand < two_times then	
			multicast = 2
		else
			return
		end
		local multicast_delay = event_ability:GetSpecialValueFor("multicast_delay")
		local damage = event_ability:GetSpecialValueFor("fireblast_damage")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf", PATTACH_OVERHEAD_FOLLOW, unit) 
		ParticleManager:SetParticleControl(particle, 1, Vector(multicast, 0, 0))
		ParticleManager:ReleaseParticleIndex(particle)
		target:SetThink(function()
			fireblast(unit, target, ability, damage, 1)
		end, "fireblast multicast 1", multicast_delay)

		if multicast > 2 then
			target:SetThink(function()
				fireblast(unit, target, ability, damage, 2)
			end, "fireblast multicast 2", multicast_delay * 2)
		end

		if multicast > 3 then
				target:SetThink(function()
				fireblast(unit, target, ability, damage, 3)
			end, "fireblast multicast 3", multicast_delay * 3)
		end
    elseif event_ability:GetName() == "ogre_magi_bloodlust" then
        unit:SetThink(function()
            local multicast = ability
            local newCooldown = event_ability:GetCooldown(event_ability:GetLevel()) + multicast:GetSpecialValueFor("blood_cooldown")
            event_ability:EndCooldown()
            event_ability:StartCooldown(newCooldown)
        end, "reset blood cooldown", 0.1)
    end
end

function fireblast(caster, target, ability, damage, mt)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_ogre_magi_fire_blast_multicast_datadriven", { })
	ApplyDamage({
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL})
	target:EmitSound("Hero_OgreMagi.Fireblast.Target");
	caster:EmitSound("Hero_OgreMagi.Fireblast.x" .. mt);
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", 1, target) 
	ParticleManager:ReleaseParticleIndex(particle)
end
