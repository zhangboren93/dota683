modifier_abyssal_underlord_pit_of_malice_thinker_lua = class({})

function modifier_abyssal_underlord_pit_of_malice_thinker_lua:OnCreated()
	if IsServer() then
		self.hit_units = {}
		self:StartIntervalThink(0.1)
	end
end

function modifier_abyssal_underlord_pit_of_malice_thinker_lua:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("ensnare_duration_tooltip")
	local units = FindUnitsInRadius(
		caster:GetTeam(),
		parent:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)
	for i=1,#units do
		local unit = units[i]
		if self.hit_units[unit:entindex()] == nil then
			ApplyDamage({
				victim = units[i],
				attacker = caster,
				damage = ability:GetAbilityDamage(),
				damage_type = DAMAGE_TYPE_MAGICAL
			})
			units[i]:AddNewModifier(caster, ability, 
				"modifier_abyssal_underlord_pit_of_malice_ensare_lua",
				{ duration = duration })
			if units[i]:IsHero() then
				units[i]:EmitSound("Hero_AbyssalUnderlord.Pit.TargetHero")
			else
				units[i]:EmitSound("Hero_AbyssalUnderlord.Pit.Target")
			end
			self.hit_units[unit:entindex()] = true
		end
	end
end
