modifier_item_pipe_barrier_lua = class({
	OnCreated = function(self)
		local parent = self:GetParent()
		self.magic_block_total = self:GetAbility():GetSpecialValueFor("barrier_block")
		self.pid = ParticleManager:CreateParticle("particles/items2_fx/pipe_of_insight_v2.vpcf",
			PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(self.pid, 1, parent,
			PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", Vector(0, 0, 0), false)
		ParticleManager:SetParticleControl(self.pid, 2, Vector(120, 0, 0))
	end,
	OnDestroy = function(self)
		ParticleManager:DestroyParticle(self.pid, false)
	end,
	DeclareFunctions = function() return { MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK } end,
	GetModifierMagical_ConstantBlock = function(self, event)
		local parent = self:GetParent()
		if event.target ~= parent or event.damage_type ~= DAMAGE_TYPE_MAGICAL then return 0 end
		local damage = event.damage
		if damage < self.magic_block_total then
			self.magic_block_total = self.magic_block_total - damage
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, parent, damage, nil)
			return damage
		end
		local tmp = self.magic_block_total
		self.magic_block_total = 0
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, parent, tmp, nil)
		self:Destroy()
		return tmp
	end
})
