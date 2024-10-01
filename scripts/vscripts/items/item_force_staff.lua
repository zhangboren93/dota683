function handleSpellStart(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	-- cannot force staff over chrono, black hole etc. units
	caster:EmitSound("DOTA_Item.ForceStaff.Activate")
	if target:HasModifier("modifier_faceless_void_chronosphere_freeze_lua") then return end
	if target:HasModifier("modifier_enigma_black_hole_pull_lua") then return end
	if target:HasModifier("modifier_legion_commander_duel") then return end
	if target:HasModifier("modifier_disruptor_kinetic_field") then return end
	if caster:GetTeam() ~= target:GetTeam() and target:TriggerSpellAbsorb(ability) then return end
	target:AddNewModifier(caster, ability, "modifier_item_force_staff_active_lua", { duration = 0.4 })
end

modifier_item_force_staff_active_lua = class({
	OnCreated = function(self)
		local parent = self:GetParent()
		if not IsServer() then return end
		self.speed = parent:GetForwardVector():Normalized() * 1500
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()	
		end
	end,
	UpdateHorizontalMotion = function(self, me, dt)
		if IsServer() then
			me:SetAbsOrigin(me:GetAbsOrigin() + self.speed * dt)
		end
	end,
	CheckState = function() return { [MODIFIER_STATE_NO_UNIT_COLLISION] = true } end,
	GetEffectName = function() return "particles/items_fx/force_staff.vpcf" end
})
