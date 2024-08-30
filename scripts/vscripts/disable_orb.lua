function CheckOrb(event)
	local caster = event.caster
	local ability = caster:FindAbilityByName(event.CheckAbility)
	if ability:GetLevel() > 0 then
		caster:AddNewModifier(caster, ability, "modifier_disable_item_orb", {})
	end
end

function CheckOrbPrime(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:PassivesDisabled() then
		caster:AddNewModifier(caster, ability, "modifier_disable_item_orb", {})
	else
		caster:RemoveModifierByName("modifier_disable_item_orb")
	end
end