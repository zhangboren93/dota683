modifier_fountain_aura_buff_lua = class({})
function modifier_fountain_aura_buff_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_fountain_aura_buff_lua:GetEffectName()
	return "particles/generic_gameplay/radiant_fountain_regen.vpcf"
end

function modifier_fountain_aura_buff_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW 
end

function modifier_fountain_aura_buff_lua:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_fountain_aura_buff_lua:OnIntervalThink()
	local parent = self:GetParent()
	local bottle = parent:FindItemInInventory("item_bottle")
	if bottle ~= nil then
		if bottle:GetCurrentCharges() < 3 then
			bottle:SetCurrentCharges(3)
		end
	end
end

function modifier_fountain_aura_buff_lua:GetModifierConstantHealthRegen()
	return self:GetParent():GetMaxHealth() / 25
end

function modifier_fountain_aura_buff_lua:GetModifierConstantManaRegen()
	return 14 + self:GetParent():GetMana() / 25
end

function modifier_fountain_aura_buff_lua:OnTakeDamage(event)
	if event.target == self:GetParent() then
		self:Destroy()
	end
end

function modifier_fountain_aura_buff_lua:GetTexture()
	return "fountain_regen"
end
