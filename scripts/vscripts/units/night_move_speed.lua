function handleIntervalThink(event)
	local caster = event.caster
	local ability = event.ability
	local isDaytime = GameRules:IsDaytime()
	--print(ability:IsCooldownReady())
	if isDaytime and caster:HasModifier("modifier_move_speed_cancel_active_datadriven") then
		caster:RemoveModifierByName("modifier_move_speed_cancel_active_datadriven")
	elseif not ability:IsCooldownReady() then
		caster:RemoveModifierByName("modifier_move_speed_cancel_active_datadriven")
	elseif not isDaytime and not caster:HasModifier("modifier_move_speed_cancel_active_datadriven") and ability:IsCooldownReady() then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_move_speed_cancel_active_datadriven", {})
	end
end

function handleAttack(event)
	local caster = event.caster
	local ability = event.ability
	caster:RemoveModifierByName("modifier_move_speed_cancel_active_datadriven")
	ability:StartCooldown(ability:GetCooldown(1))
end

function handleTakeDamage(event)
	local attacker = event.attacker
	local ability = event.ability
	local unit = event.unit
	--print(attacker:GetPlayerOwnerID())
	--print(event.Damage)
	if attacker:GetPlayerOwnerID() >= 0 and event.Damage > 0 then
		unit:RemoveModifierByName("modifier_move_speed_cancel_active_datadriven")
		ability:StartCooldown(ability:GetCooldown(1))
	end
end

function analyse_modifier(unit, name)
	local modifier = unit:FindModifierByName(name)
	if modifier ~= nil then
		for i = 0,331 do
			if modifier:HasFunction(i) then
				print(i)
			end
		end
		print("found modifier")
	end
end