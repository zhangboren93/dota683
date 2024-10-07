function handleDoubleDamage(event)
	local caster = event.caster
	local modifier = caster:FindModifierByName("modifier_rune_doubledamage_datadriven")
	modifier:SetStackCount(math.floor((caster:GetBaseDamageMin() + caster:GetBaseDamageMax())/2))
end

function handleRuneRegenThink(event)
	local target = event.target
	if target:GetMaxHealth() - target:GetHealth() < 1 and target:GetMaxMana() - target:GetMana() < 1 then
		target:RemoveModifierByName("modifier_rune_regen_datadriven")
	end
end

function handleRuneRegenTakeDamage(event)
	local damage = event.Damage
	local attacker = event.attacker
	local target = event.unit
	if damage < 20 and event.inflictor ~= nil then return end
	if attacker == target then return end
	target:RemoveModifierByName("modifier_rune_regen_datadriven")
end
