item_diffusal_blade_datadriven = class({
	OnSpellStart = function(self)
		local target = self:GetCursorTarget()
		if target:TriggerSpellAbsorb(self) then return end
		target:EmitSound("DOTA_Item.DiffusalBlade.Activate")
		self:SpendCharge(0)

		local caster = self:GetParent()
		local RemovePositiveBuffs = not (target:GetTeam() == caster:GetTeam())
		local RemoveDebuffs = target:GetTeam() == caster:GetTeam()
		local BuffsCreatedThisFrameOnly = false
		local RemoveStuns = false
		local RemoveExceptions = false
		target:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)

		if target:GetTeam() ~= caster:GetTeam() then
			local duration = self:GetSpecialValueFor("purge_slow_duration")
			target:AddNewModifier(caster, self, "modifier_diffusal_purge_slow_datadriven", { duration = duration })
		end
	end,
	GetIntrinsicModifierName = function(self)
		return "modifier_item_diffusal_lua"
	end,
	CastFilterResultTarget = function(self, target)
		if target:HasModifier("modifier_repel_datadriven") then
			return UF_SUCCESS
		end
		if target:IsMagicImmune() and target:GetTeam() ~= self:GetParent():GetTeam() then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY 
		end
		if target:HasModifier("modifier_eul_cyclone_datadriven") then
			return UF_SUCCESS
		end
		if target:IsInvulnerable() then
			return UF_FAIL_INVULNERABLE
		end
		return UF_SUCCESS
	end
})

item_diffusal_blade_2_datadriven = item_diffusal_blade_datadriven
function item_diffusal_blade_2_datadriven:GetIntrinsicModifierName()
	return "modifier_item_diffusal_2_lua"
end
