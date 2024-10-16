modifier_item_bloodthorn_debuff_lua = class({
	GetEffectName = function() return "particles/items2_fx/orchid.vpcf" end,
	GetEffectAttachType = function() return PATTACH_OVERHEAD_FOLLOW end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	} end,
	GetModifierEvasion_Constant = function() return -100 end,
	OnTakeDamage = function(self, event)
		if event.unit ~= self:GetParent() then return end
		local damage = event.damage
		local stack = self:GetStackCount()
		self:SetStackCount(stack + math.floor(damage))
	end,
	IsPurgable = function() return true end,
	OnCreated = function(self) self:StartIntervalThink(5) end,
	OnIntervalThink = function(self)
		local parent = self:GetParent()
		local damage = self:GetStackCount() * 3 / 10
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		ApplyDamage({
			victim = parent,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability
		})
	end
})
