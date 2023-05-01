function HandleClinkzAttackStart(event)
	local caster = event.attacker
	local ability = event.ability
--	print(ability:GetName())
--	print(caster:GetAttackSpeed())
	if caster:GetAttackSpeed() < 1.7 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_clinkz_attack_animation_active", {})
	--	caster:AddNewModifier(caster, ability, "modifier_clinkz_attack_animation", {
	--		rate = 1 }):SetDuration(1, true)
	end
end