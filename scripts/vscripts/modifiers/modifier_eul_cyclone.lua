require("items/item_cyclone")
modifier_eul_cyclone_datadriven = class({
	IsPurgable = function() return true end,
	GetEffectName = function() return "particles/items_fx/cyclone.vpcf" end,
	GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
	CheckState = function() return {
		[ MODIFIER_STATE_FLYING ] = true,
		[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true,
		[ MODIFIER_STATE_STUNNED ] = true,
		[ MODIFIER_STATE_ROOTED ] = true,
		[ MODIFIER_STATE_DISARMED ] = true,
		[ MODIFIER_STATE_INVULNERABLE ] = true,
		[ MODIFIER_STATE_NO_HEALTH_BAR ] = true
	} end,
	IsBuff = function(self)
		return self:GetParent():GetTeam() == self:GetCaster():GetTeam()
	end,
	OnCreated = function(self)
		self:StartIntervalThink(0.03)
	end,
	OnIntervalThink = function(self)
		if not IsServer() then return end
		modifier_invoker_tornado_datadriven_cyclone_on_interval_think({
			target = self:GetParent()
		})
	end,
	OnDestroy = function(self)
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		if not IsServer() then return end
		handleDestroy({
			target = parent,
			caster = caster,
			ability = ability,
			modifier = self
		})
		parent:AddNewModifier(caster, ability, "modifier_eul_cyclone_fall_datadriven", { duration = 0.1 })
	end,
	GetOverrideAnimation = function() return ACT_DOTA_FLAIL end
})

modifier_eul_cyclone_fall_datadriven = class({
	IsHidden = function() return true end,
	DeclareFunctions = function() return MODIFIER_PROPERTY_VISUAL_Z_DELTA end,
	GetVisualZDelta = function() return 0 end
})
