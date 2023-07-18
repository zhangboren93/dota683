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
		local multicast = getMulticastCount(ability)
		if multicast <= 1 then
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
		
		local multicast = getMulticastCount(ability)
	--	print(multicast)
		if multicast <= 1 then
			return
		end
		local multicast_range = event_ability:GetSpecialValueFor("multicast_bloodlust_aoe")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf", PATTACH_OVERHEAD_FOLLOW, unit) 
		ParticleManager:SetParticleControl(particle, 1, Vector(multicast, 0, 0))
		ParticleManager:ReleaseParticleIndex(particle)
		local units = FindUnitsInRadius(unit:GetTeam(), 
										unit:GetAbsOrigin(), 
										nil, multicast_range,
										DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										0, 0, false)
		local not_self_units = {}
		for i=1,#units do
			if units[i] ~= target then
				table.insert(not_self_units, units[i])
			end
		end
		for i=2,multicast do
			if #not_self_units == 0 then
				break
			end
			local random_index = math.random(1, #not_self_units)
			not_self_units[random_index]:AddNewModifier(unit, event_ability, "modifier_ogre_magi_bloodlust", {duration = 30})
			table.remove(not_self_units, random_index)
		end
	elseif event_ability:GetName() == "ogre_magi_unrefined_fireblast" then
		local multicast = getMulticastCount(ability)
		if multicast <= 1 then
			return
		end
		local multicast_delay = event_ability:GetSpecialValueFor("multicast_delay")
		local damage = event_ability:GetSpecialValueFor("fireblast_damage")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf", PATTACH_OVERHEAD_FOLLOW, unit) 
		ParticleManager:SetParticleControl(particle, 1, Vector(multicast, 0, 0))
		ParticleManager:ReleaseParticleIndex(particle)
		target:SetThink(function()
			ufireblast(unit, target, ability, damage, 1)
		end, "unrefined fireblast multicast 1", multicast_delay)

		if multicast > 2 then
			target:SetThink(function()
				ufireblast(unit, target, ability, damage, 2)
			end, "unrefined fireblast multicast 2", multicast_delay * 2)
		end

		if multicast > 3 then
			target:SetThink(function()
				ufireblast(unit, target, ability, damage, 3)
			end, "unrefined fireblast multicast 3", multicast_delay * 3)
		end
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

function ufireblast(caster, target, ability, damage, mt)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_ogre_magi_fire_blast_multicast_datadriven", { })
	ApplyDamage({
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL})
	target:EmitSound("Hero_OgreMagi.Fireblast.Target");
	caster:EmitSound("Hero_OgreMagi.Fireblast.x" .. mt);
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_unr_fireblast.vpcf", 1, target) 
	ParticleManager:ReleaseParticleIndex(particle)
end

function getMulticastCount(ability)
	local two_times = ability:GetSpecialValueFor( "multicast_2_times")
	local three_times = ability:GetSpecialValueFor( "multicast_3_times")
	local four_times = ability:GetSpecialValueFor( "multicast_4_times")
	local rand = math.random(1,100)
	if rand < four_times then
		return 4
	elseif rand < three_times then
		return 3
	elseif rand < two_times then	
		return 2
	else
		return 1
	end
end
