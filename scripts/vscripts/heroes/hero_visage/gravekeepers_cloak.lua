function handleIntervalThink(event)
	local caster = event.caster
	local ability = event.ability
	local time = GameRules:GetGameTime()
	if ability.gravekeepers_time == nil then
		ability.gravekeepers_time = time
		local modifier = ability:ApplyDataDrivenModifier(caster, caster, "modifier_visage_gravekeepers_cloak_datadriven", {})
		modifier:SetStackCount(4)
		return
	end
	local modifier = caster:FindModifierByName("modifier_visage_gravekeepers_cloak_datadriven")
	if modifier == nil then
		if time - ability.gravekeepers_time >= 6 then
			modifier = ability:ApplyDataDrivenModifier(caster, caster, "modifier_visage_gravekeepers_cloak_datadriven", {})
			modifier:SetStackCount(1)
			ability.gravekeepers_time = time
		end
		return
	end
	if modifier:GetStackCount() < 4 and time - ability.gravekeepers_time >= 6 then
		modifier:SetStackCount(modifier:GetStackCount() + 1)
		ability.gravekeepers_time = time
		return
	end
end

function handleTakeDamage(event)
	local caster = event.caster
	local ability = event.ability
	if event.damage <= 2 or not event.attacker:IsOwnedByAnyPlayer() then return end
	ability.gravekeepers_time = GameRules:GetGameTime()
	local modifier = caster:FindModifierByName("modifier_visage_gravekeepers_cloak_datadriven")
	if modifier == nil then return end
	local stack_count = modifier:GetStackCount()
	if stack_count == 1 then
		caster:RemoveModifierByName("modifier_visage_gravekeepers_cloak_datadriven")
	else
		modifier:SetStackCount(modifier:GetStackCount() - 1)
	end
end

function handleRespawn(event)
	local ability = event.ability
	ability.gravekeepers_time = nil
end

function handleUpgrade(event)
	local caster = event.caster
	local ability = event.ability
	local modifier = caster:FindModifierByName("modifier_visage_gravekeepers_cloak_datadriven")
	if modifier == nil then return end
	local stack_count = modifier:GetStackCount()
	caster:RemoveModifierByName("modifier_visage_gravekeepers_cloak_datadriven")
	modifier = ability:ApplyDataDrivenModifier(caster, caster, "modifier_visage_gravekeepers_cloak_datadriven", {})
	modifier:SetStackCount(stack_count)
end
