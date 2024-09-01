require("items/item_magic_stick")
function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetSpecialValueFor("stomp_damage")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	ProcsMagicStick(event)
	local units = FindUnitsInRadius(
		caster:GetTeam(),
		caster:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
	for i=1,#units do
		ApplyDamage({
			victim = units[i],
			attacker = caster, 
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability
		})
		units[i]:AddNewModifier(caster, ability, "modifier_stunned", { duration = stun_duration })
	end
end
