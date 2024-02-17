modifier_item_satanic_datadriven_unholy_rage = class({})
function modifier_item_satanic_datadriven_unholy_rage:IsPurgable()
	return true
end

function modifier_item_satanic_datadriven_unholy_rage:GetStatusEffectName()
	return "particles/items2_fx/satanic_buff.vpcf"
end
