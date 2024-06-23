-- Deprecated

function handleAttackStart(event)
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	if target:GetTeam() == attacker:GetTeam() then
		local tidebringer = attacker:FindAbilityByName("kunkka_tidebringer")
		if tidebringer:IsCooldownReady() then
			ability:SetLevel(tidebringer:GetLevel())
			ability:ApplyDataDrivenModifier(attacker, attacker, "modifier_tidebringer_deny_damage_active", {})
			return
		end
	end
	attacker:RemoveAllModifiersOfName("modifier_tidebringer_deny_damage_active")
end