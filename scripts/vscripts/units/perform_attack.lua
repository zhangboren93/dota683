function handleProjectileHitUnit(event)
	event.ability:ApplyDataDrivenModifier(event.caster, event.caster, "modifier_dont_reset_orb_cd", {})
	event.caster:PerformAttack(event.target, false, true, true, false, false, false, true)
end

function setCDAndDisarm(event)
	local ability = event.ability
	local caster = event.caster
	local duration = caster:GetSecondsPerAttack() - caster:GetAttackAnimationPoint()
	if duration > 0 then
		ability:StartCooldown(duration)
		caster:AddNewModifier(caster, ability, "modifier_disarmed", {duration = duration})
	end
end