function handleAttackLanded(event)
    local attacker = event.attacker
    local target = event.target
	local ability = event.ability
	local mana_cost = ability:GetManaCost(-1)
	local duration = ability:GetSpecialValueFor("duration")
	local max_stack_count = ability:GetSpecialValueFor("max_armor_removed")

	if attacker:GetMana() < mana_cost 
		or target:IsMagicImmune() 
		or target:IsBuilding() 
		or target:HasModifier("roshan_inherent_buffs_checker_datadriven") then
		return
	end

	attacker:SpendMana(mana_cost, ability)
	local modifier = target:FindModifierByName("modifier_melting_strike_debuff_lua")
	if modifier == nil then
		local tmp_modifier = target:AddNewModifier(attacker, abilizty, "modifier_melting_strike_debuff_lua",
			{ duration = duration })
		if tmp_modifier ~= nil then
			tmp_modifier:SetStackCount(1)
		end
	else
		modifier:SetDuration(duration, true)
		if modifier:GetStackCount() < max_stack_count then
			modifier:SetStackCount(modifier:GetStackCount() + 1)
		end
	end
end

function handleCreated(event)
	print("handleCreated")
	local target = event.target
	local hero_caster = target:GetOwner()
	local forge_spirit = hero_caster:FindAbilityByName("invoker_forge_spirit")
	if forge_spirit == nil then
		return
	end
	local spirit_mana = forge_spirit:GetSpecialValueFor("spirit_mana")
	target:SetThink(function()
		target:SetMaxMana(spirit_mana)
		target:SetMana(spirit_mana)
	end, "set mana", 0.1) 
end
