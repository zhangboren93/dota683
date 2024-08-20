modifier_ember_spirit_flame_guard_lua = class({
	DeclareFunctions = function() return { MODIFIER_EVENT_ON_TAKEDAMAGE } end,
	IsPurgable = function() return true end,
	OnDestroy = function(self) if IsServer() then self:GetParent():StopSound("Hero_EmberSpirit.FlameGuard.Loop") end end,
	OnCreated = function(self)
		local ability = self:GetAbility()
		local tick_interval = ability:GetSpecialValueFor("tick_interval")
		self.damage = ability:GetSpecialValueFor("damage_per_second") * tick_interval
		self.radius = ability:GetSpecialValueFor("radius")
		self:StartIntervalThink(tick_interval)
		self.particleId = ParticleManager:CreateParticle(
			"particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.particleId, 2, Vector(400, 0, 0))
	end,
	OnIntervalThink = function(self)
		if not IsServer() then return end
		local ability = self:GetAbility()
		local parent = self:GetParent()
		local units = FindUnitsInRadius(
			parent:GetTeam(),
			parent:GetAbsOrigin(),
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)
		for i=1,#units do
			ApplyDamage({
				victim = units[i],
				attacker = parent,
				damage = self.damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = ability
			})
		end
	end,
	OnTakeDamage = function(self, event)
		local damage_type = event.damage_type
		local unit = event.unit
		local parent = self:GetParent()
		if unit ~= parent or damage_type ~= DAMAGE_TYPE_MAGICAL or not IsServer() then
			return
		end
		local damage = event.damage
		local ability = self:GetAbility()
		if damage < self.flame_guard_absorb_amount then
			-- absorb damage
			parent:Heal(damage, ability)
			self.flame_guard_absorb_amount = self.flame_guard_absorb_amount - damage
		else
			parent:Heal(self.flame_guard_absorb_amount, ability)
			self:Destroy()
		end
	end,
	OnDestroy = function(self)
		if self.particleId ~= nil then
			ParticleManager:DestroyParticle(self.particleId, false)
			self.particleId = nil
		end
	end
})

