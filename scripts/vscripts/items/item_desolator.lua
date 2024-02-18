function handleOrbFire(event)
	if event.target:HasModifier("modifier_building_immune_to_deso") then
		return
	end
    if not event.attacker:IsIllusion() then
		event.target:AddNewModifier(event.attacker, event.ability, "modifier_item_desolator_datadriven_corruption", { duration = 15 })
		event.target:EmitSound("Item_Desolator.Target")
    end
end

item_desolator_datadriven = class({})

function item_desolator_datadriven:GetIntrinsicModifierName()
	return "modifier_item_desolator_datadriven"
end

function item_desolator_datadriven:OnOrbImpact(event)
	event.caster = self:GetCaster()
	event.ability = self
	handleOrbFire(event)
end

function item_desolator_datadriven:GetProjectileName()
	return "particles/items_fx/desolator_projectile.vpcf"
end
