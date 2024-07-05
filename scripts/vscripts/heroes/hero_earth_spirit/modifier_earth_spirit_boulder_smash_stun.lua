modifier_earth_spirit_boulder_smash_stun_lua = class({})

function modifier_earth_spirit_boulder_smash_stun_lua:OnCreated()
	if IsServer() then
		self.stunned_units = {}
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_earth_spirit_boulder_smash_stun_lua:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local duration = ability:GetSpecialValueFor("duration")
	local radius = ability:GetSpecialValueFor("radius")
	local units = FindUnitsInRadius(caster:GetTeam(),
		parent:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
	for i=1,#units do
		local unit = units[i]
		if self.stunned_units[unit:GetEntityIndex()] == nil then
			unit:AddNewModifier(caster, ability, "modifier_stunned", { duration = duration })
			self.stunned_units[unit:GetEntityIndex()] = true
		end
	end
end
