function handleAbilityExecuted(keys)
	local unit = keys.unit
	local ability2 = keys.ability
	local event_ability = keys.event_ability
	local target = keys.target
	if target ~= nil and target:GetName() == "npc_dota_hero_razor" and not event_ability:IsItem() then
		unit:Purge(true, false, false, false, false)
		local duration = ability2:GetSpecialValueFor("slow_duration")
		print(duration)
		ability2:ApplyDataDrivenModifier(target, unit, "modifier_unstable_current_purge", {duration = duration})
		local damage = ability2:GetSpecialValueFor("damage")
		unit:EmitSound("Hero_Razor.UnstableCurrent.Target")
		ApplyDamage({
			victim = unit,
			attacker = target,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability2})
	end
end
