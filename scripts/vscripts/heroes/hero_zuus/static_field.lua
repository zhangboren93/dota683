--[[Author: YOLOSPAGHETTI
	Date: March 24, 2016
	Checks if the event was called by an ability and if so deals the health-based damage]]
function StaticField(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() -1))
	local damage_health_pct = ability:GetLevelSpecialValueFor("damage_health_pct", (ability:GetLevel() -1))/100
	local event_ability = keys.event_ability
	local abilityTriggers = {
		"zuus_arc_lightning",
		"zuus_lightning_bolt",
		"zuus_cloud",
		"zuus_thundergods_wrath",		
	}

	print(event_ability:GetName())
	for i=1,#abilityTriggers do
		if event_ability:GetName() == abilityTriggers[i] then
	    	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0, 0, false)
			print(#units)
	    	for i,unit in ipairs(units) do
	    		-- Attaches the particle
	    		local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_ABSORIGIN_FOLLOW, unit)
	    		ParticleManager:SetParticleControl(particle,0,unit:GetAbsOrigin())
	    		-- Plays the sound on the target
	    		--EmitSoundOn(keys.sound, unit)
	    		-- Deals the damage based on the unit's current health
	    		ApplyDamage({victim = unit, attacker = caster, damage = unit:GetHealth() * damage_health_pct, damage_type = ability:GetAbilityDamageType()})
	    	end
			return
		end
	end
end
