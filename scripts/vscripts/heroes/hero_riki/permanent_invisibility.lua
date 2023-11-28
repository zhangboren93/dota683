function handleIntervalThink(event)
	if not IsServer() then return end

	local caster = event.caster
	local ability = event.ability
	local invis = caster:FindModifierByName("modifier_invisible")
	if ability:IsCooldownReady() and invis == nil and not caster:IsSilenced() then
		caster:AddNewModifier(caster, ability, "modifier_invisible", {})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_riki_permanent_invisibility_regen_datadriven", {})
		return
	end
	if caster:IsSilenced() then
		caster:RemoveModifierByName("modifier_invisible")
		caster:RemoveModifierByName("modifier_riki_permanent_invisibility_regen_datadriven")
		return
	end
	if not ability:IsCooldownReady() then
		caster:RemoveModifierByName("modifier_riki_permanent_invisibility_regen_datadriven")
	end
end

function handleAttackLanded(event)
	local attacker = event.attacker
	local ability = event.ability
	ability:StartCooldown(ability:GetCooldown(ability:GetLevel() - 1))
	attacker:RemoveModifierByName("modifier_riki_permanent_invisibility_regen_datadriven")
end
