function CheckOrb(event)
	local caster = event.caster
	local ability = caster:FindAbilityByName("broodmother_incapacitating_bite")
	if ability:GetLevel() > 0 then
		caster:AddNewModifier(caster, ability, "modifier_disable_item_orb", {})
	end
end