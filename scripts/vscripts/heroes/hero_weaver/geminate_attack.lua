function handleAttackLanded(event)
	local caster = event.caster
	local ability = event.ability 
	local target = event.target
	if ability:IsCooldownReady() then
		if (target:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() > 1300 then
			return
		end
		caster:PerformAttack(target, true, true, true, false, true, false, false)
		ability:StartCooldown(ability:GetCooldown(ability:GetLevel() - 1))
	end
end
