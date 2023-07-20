require("../../items/item_sphere")
function handleProjectileHit(event)
	local target = event.target
	if is_spell_blocked_by_linkens_sphere(target) then return end
	local ability = event.ability
	local caster = event.caster
	local bolt_aoe = ability:GetSpecialValueFor("bolt_aoe")
	local units = FindUnitsInRadius(caster:GetTeam(),
									target:GetAbsOrigin(), nil,
									bolt_aoe,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									0,0,false)
	for i=1,#units do
		ApplyDamage({ victim = units[i], attacker = caster, damage = ability:GetAbilityDamage(), damage_type = DAMAGE_TYPE_MAGICAL })
		ability:ApplyDataDrivenModifier(caster, units[i], "modifier_storm_bolt_datadriven", {})
	end
end
