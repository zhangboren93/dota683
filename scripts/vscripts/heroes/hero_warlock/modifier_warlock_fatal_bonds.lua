modifier_warlock_fatal_bonds_lua = class({})
function modifier_warlock_fatal_bonds_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_warlock_fatal_bonds_lua:OnTakeDamage(event)
	local unit = event.unit
	if IsServer() and unit == self:GetParent() then
		print("Fatal bonds damage taken " .. event.damage)
		local damage_flags = event.damage_flags
		if bit.band(damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == 0 then
			local all_units = FindUnitsInRadius(self:GetCaster():GetTeam(), unit:GetAbsOrigin(),
				nil, 30000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				0, FIND_ANY_ORDER, false)
			local bond_units = {}
			for i=1,#all_units do
				if all_units[i]:HasModifier("modifier_warlock_fatal_bonds_lua") and all_units[i] ~= unit then
					table.insert(bond_units, all_units[i])
				end
			end
			print("bonded units " .. #bond_units)
			local ability = self:GetAbility()
			local damage_share_percentage = ability:GetSpecialValueFor("damage_share_percentage")
			local damage = event.original_damage * damage_share_percentage / 100
			for i=1,#bond_units do
				local bond_unit = bond_units[i]
				ApplyDamage({
					victim = bond_unit,
					attacker = self:GetCaster(),
					damage = damage,
					damage_type = event.damage_type,
					damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
					ability = ability})
			end
		end
	end
end

function modifier_warlock_fatal_bonds_lua:OnTooltip()
	if self.damage_share_percentage == nil then
		self.damage_share_percentage = self:GetAbility():GetSpecialValueFor("damage_share_percentage")
	end
	return self.damage_share_percentage
end

function modifier_warlock_fatal_bonds_lua:GetEffectName()
	return "particles/units/heroes/hero_warlock/warlock_fatal_bonds_icon.vpcf"
end

function modifier_warlock_fatal_bonds_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_warlock_fatal_bonds_lua:IsPurgable()
	return true
end

function modifier_warlock_fatal_bonds_lua:IsDebuff()
	return true
end
