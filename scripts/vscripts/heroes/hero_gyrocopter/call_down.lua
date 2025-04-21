--[[Author: YOLOSPAGHETTI
	Date: March 28, 2016
	Gives the caster's team vision in the radius]]
require("../../items/item_magic_stick")
function GiveVision(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = keys.target_points[1]
	local sight_radius = ability:GetLevelSpecialValueFor("vision_radius", (ability:GetLevel() -1))
	local sight_duration = ability:GetLevelSpecialValueFor("vision_duration", (ability:GetLevel() -1))

	ProcsMagicStick(keys)
	
	AddFOWViewer(caster:GetTeam(), point, sight_radius, sight_duration, false)
end

function handleDestroyed(event)
	local target = event.target
	local modifier = event.Modifier
	local caster = event.caster
	local ability = event.ability
	local damage = event.Damage
	local radius = ability:GetSpecialValueFor("radius")
	local units = FindUnitsInRadius(
		caster:GetTeam(),
		target:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)
	for i=1,#units do
		if not units[i]:IsMagicImmune() then
			ApplyDamage({
				victim = units[i],
				attacker = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = ability})
		end
		ability:ApplyDataDrivenModifier(caster, units[i], modifier, {})
	end
end

function handleMarkerCreated(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local radius = ability:GetSpecialValueFor("radius")
	local pid = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_gyrocopter/gyro_calldown_marker.vpcf",
			PATTACH_ABSORIGIN, target, caster:GetTeam())
	--ParticleManager:SetParticleControl(pid, 0, Vector(0, 0, 0))
	ParticleManager:SetParticleControl(pid, 1, Vector(radius, radius, radius))
end
