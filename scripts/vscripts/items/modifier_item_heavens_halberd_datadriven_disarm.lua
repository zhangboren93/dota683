modifier_item_heavens_halberd_datadriven_disarm = class({})

function modifier_item_heavens_halberd_datadriven_disarm:IsPurgable()
	return false
end

function modifier_item_heavens_halberd_datadriven_disarm:IsPurgeException()
	return false
end

function modifier_item_heavens_halberd_datadriven_disarm:GetEffectName()
	return "particles/items2_fx/heavens_halberd.vpcf"
end

function modifier_item_heavens_halberd_datadriven_disarm:GetEffectAttachType()
	return PATTACH_ABSORIGIN 
end

function modifier_item_heavens_halberd_datadriven_disarm:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_item_heavens_halberd_datadriven_disarm:OnIntervalThink()
	local parent = self:GetParent()
	if parent:IsMagicImmune() then
		self:Destroy()
	end
end

function modifier_item_heavens_halberd_datadriven_disarm:OnDestroy()
	local parent = self:GetParent()
	local modifiers = parent:FindAllModifiersByName("modifier_disarmed")
	for i=1,#modifiers do
		if modifiers[i]:GetAbility() == self:GetAbility() then
			modifiers[i]:Destroy()
		end
	end
end
