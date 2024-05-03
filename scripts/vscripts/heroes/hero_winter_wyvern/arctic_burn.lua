function handleIntervalThink(event)
	local caster = event.caster
	local target = event.target
	if target:GetModelName() ~= "models/creeps/roshan/roshan.vmdl" then
		ApplyDamage({
			victim = target, 
			attacker = caster, 
			damage = target:GetHealth() * 6 / 100,
			damage_type = DAMAGE_TYPE_PURE })
	end
end

function handleAttackLanded(event)
	local attacker = event.attacker
	local ability = event.ability
	local target = event.target
	if attacker:GetName() == "npc_dota_hero_winter_wyvern"
		and attacker:HasModifier("modifier_winter_wyvern_frost_attack")
		and not target:IsBuilding() then
		ability:ApplyDataDrivenModifier(attacker, target, "modifier_winter_wyvern_arctic_burn_pure_datadriven", { duration = 5 })
	end
end
