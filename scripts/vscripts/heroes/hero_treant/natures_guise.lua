function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local fade_time = ability:GetSpecialValueFor("fade_time")
	local duration = ability:GetSpecialValueFor("duration")
	local radius = ability:GetSpecialValueFor("radius")
	target:SetThink(function()
    	local neartrees = GridNav:IsNearbyTree(target:GetAbsOrigin(), radius, false)
		if neartrees then
			target:AddNewModifier(caster, ability, "modifier_treant_natures_guise_lua", { duration = duration })
			target:AddNewModifier(caster, ability, "modifier_invisible", { duration = duration })
			target:EmitSound("Hero_Treant.NaturesGuise.On")
		end
	end, "nature disguise", fade_time)
	caster:EmitSound("Hero_Treant.NaturesGrasp.Cast")
end
