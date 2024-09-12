modifier_batrider_flamebreak_projectile_lua = class({
	OnCreated = function(self, data)
		if not IsServer() then return end
		self.speedx = data.speedx
		self.speedy = data.speedy
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end
	end,
	UpdateHorizontalMotion = function(self, me, dt)
		me:SetAbsOrigin(me:GetAbsOrigin() + Vector(self.speedx * dt, self.speedy * dt, 0))
	end,
	OnDestroy = function(self)
		if not IsServer() then return end
		local parent = self:GetParent()
		if parent.particleId ~= nil then
			ParticleManager:DestroyParticle(parent.particleId, false)
			parent.particleId = nil
		end
		EmitSoundOnLocationWithCaster(parent:GetAbsOrigin(), "Hero_Batrider.Flamebreak.Impact", parent:GetOwner())
		local ability = self:GetAbility()
		local radius = ability:GetSpecialValueFor("explosion_radius")
		local damage = ability:GetSpecialValueFor("damage")
		local caster = self:GetCaster()
		local units = FindUnitsInRadius(parent:GetTeamNumber(), 
			parent:GetAbsOrigin(), nil,
			radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			0, FIND_ANY_ORDER, false)
		for i=1,#units do
			ApplyDamage({
				attacker = caster,
				victim = units[i],
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = ability
			})
			units[i]:AddNewModifier(caster, ability, "modifier_flamebreak_knockback_lua",
				{ flamebreakx = parent:GetAbsOrigin().x, flamebreaky = parent:GetAbsOrigin().y, duration = 0.5 })
		end
	end,
	CheckState = function()
		return {
			[ MODIFIER_STATE_DISARMED ] = true,
			[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true,
			[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true,
			[ MODIFIER_STATE_UNSELECTABLE ] = true,
			[ MODIFIER_STATE_OUT_OF_GAME ] = true,
			[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
			[ MODIFIER_STATE_INVULNERABLE ] = true
		}
	end
})
