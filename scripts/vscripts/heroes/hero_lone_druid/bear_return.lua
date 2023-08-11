function handleTakeDamage(event)
	local attacker = event.attacker
	local unit = event.unit
	if attacker:GetPlayerOwnerID() >= 0 then
		local ability_return = unit:FindAbilityByName("lone_druid_spirit_bear_return")
		if ability_return:IsCooldownReady() or ability_return:GetCooldownTimeRemaining() < 3 then
			ability_return:StartCooldown(3)
		end
	end
end

function handleIntervalThink(event)
	local caster = event.caster
	local ld = caster:GetPlayerOwner():GetAssignedHero()
	if (caster:GetAbsOrigin() - ld:GetAbsOrigin()):Length() < 1100 then
		caster:RemoveModifierByName("modifier_lone_druid_bear_disarm_datadriven")
		return
	end
	if not caster:HasModifier("modifier_lone_druid_bear_disarm_datadriven") then
		event.ability:ApplyDataDrivenModifier(ld, caster, "modifier_lone_druid_bear_disarm_datadriven", {})
	end
end
