require("../../items/item_magic_stick")
function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local ability_range = ability:GetCastRange(nil, nil)
	ProcsMagicStick(event)
	local units = FindUnitsInRadius(
		caster:GetTeam(), 
		caster:GetAbsOrigin(), nil, 
		ability_range, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER, false)
	for i=1,#units do
		ApplyDamage({victim = units[i], attacker = caster, damage = ability:GetAbilityDamage(), damage_type = DAMAGE_TYPE_PHYSICAL})
		if not units[i]:HasModifier("roshan_inherent_buffs_checker_datadriven") then
			ability:ApplyDataDrivenModifier(caster, units[i], "modifier_tidehunter_anchor_smash_datadriven", {})
		end
	end
end
