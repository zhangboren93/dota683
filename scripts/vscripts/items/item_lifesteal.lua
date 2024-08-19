function attack_landed(event)
    if not event.target:IsIllusion() 
		and not event.target:IsBuilding() 
		and event.target:GetTeam() ~= event.caster:GetTeam() then
		event.caster:AddNewModifier(event.caster, event.ability, "modifier_item_lifesteal_lua", { duration = 0.03 })
    end
end

item_lifesteal_datadriven = class({})

function item_lifesteal_datadriven:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_item_lua"
end

function item_lifesteal_datadriven:OnOrbImpact(event)
	event.caster = self:GetCaster()
	attack_landed(event)
end
