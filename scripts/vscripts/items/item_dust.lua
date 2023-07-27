function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local radius = ability:GetSpecialValueFor("radius")
	local linger_duration = ability:GetSpecialValueFor("linger_duration")
	local units = FindUnitsInRadius(
		caster:GetTeam(),
		caster:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)
	for i=1,#units do
		units[i]:AddNewModifier(caster, ability, "modifier_item_dustofappearance", { duration = linger_duration })
		ability:ApplyDataDrivenModifier(caster, units[i], "modifier_dust_invis_slow_checker", {})
	end

	local particle = ParticleManager:CreateParticle("particles/items_fx/dust_of_appearance.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, 0))
	caster:SetThink(function()
		ParticleManager:DestroyParticle(particle, true)
		ParticleManager:ReleaseParticleIndex(particle)
	end, "dust effect stop", 2.5)
end

function handleIntervalThink(event)
	local target = event.target
	if target:HasModifier("modifier_invisible") then
		event.ability:ApplyDataDrivenModifier(event.caster, target, "modifier_dust_invis_slow_active", {})
	end
end
