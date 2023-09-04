modifier_beastmaster_wild_axes_damage_lua = class({})

function modifier_beastmaster_wild_axes_damage_lua:OnCreated()
	if IsServer() then
		self.damaged_units = {}
		self:StartIntervalThink(0.05)
	end
end

function modifier_beastmaster_wild_axes_damage_lua:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local damage = ability:GetSpecialValueFor("axe_damage_physical")
	--TODO apply physical damage
	local units = FindUnitsInRadius(caster:GetTeam(),
		parent:GetAbsOrigin(),
		nil,
		175,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)
	for i=1,#units do
		local unit = units[i]
		if self.damaged_units[unit:GetEntityIndex()] == nil then
			ApplyDamage({victim = unit, attacker = caster, damage_type = DAMAGE_TYPE_PHYSICAL, damage = damage})
			self.damaged_units[unit:GetEntityIndex()] = true
		end
	end
end
