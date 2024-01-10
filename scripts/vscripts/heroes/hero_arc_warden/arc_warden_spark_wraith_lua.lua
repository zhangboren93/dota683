LinkLuaModifier( "arc_warden_spark_wraith_thinker_lua", "heroes/hero_arc_warden/arc_warden_spark_wraith_lua.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

arc_warden_spark_wraith_lua = class({})

function arc_warden_spark_wraith_lua:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local team_id = caster:GetTeamNumber()
	local thinker = CreateModifierThinker(caster, self, "arc_warden_spark_wraith_thinker_lua", {}, point, team_id, false)
	caster:EmitSound("Hero_ArcWarden.SparkWraith.Cast")
end

function arc_warden_spark_wraith_lua:OnProjectileHit( target, location )
	local caster = self:GetCaster()
	ApplyDamage({ victim = target, attacker = caster, damage = self:GetAbilityDamage(), damage_type = self:GetAbilityDamageType(), ["ability"] = self})
	AddFOWViewer(caster:GetTeamNumber(), target:GetAbsOrigin(), self:GetSpecialValueFor("vision_radius"), 3.34, true)
	target:EmitSound("Hero_ArcWarden.SparkWraith.Damage")
end

arc_warden_spark_wraith_thinker_lua = class({})

function arc_warden_spark_wraith_thinker_lua:OnCreated(event)
	if IsServer() then
		local thinker = self:GetParent()
		local ability = self:GetAbility()
		self.startup_time = ability:GetSpecialValueFor("startup_time")
		self.duration = ability:GetSpecialValueFor("duration")
		self.speed = ability:GetSpecialValueFor("speed")
		self.search_radius = ability:GetSpecialValueFor("search_radius")
		self.vision_radius = ability:GetSpecialValueFor("vision_radius")
		thinker:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
		local startup_particle = ParticleManager:CreateParticle(
			"particles/units/heroes/hero_arc_warden/arc_warden_wraith.vpcf", PATTACH_WORLDORIGIN, thinker)
		local thinker_pos = thinker:GetAbsOrigin()
		ParticleManager:SetParticleControl(startup_particle, 0, thinker_pos)
		self:StartIntervalThink(self.startup_time)
		self.startup_particle = startup_particle
		thinker:SetDayTimeVisionRange(self.vision_radius)
		thinker:SetNightTimeVisionRange(self.vision_radius)
	end
end

function arc_warden_spark_wraith_thinker_lua:OnIntervalThink()
	local thinker = self:GetParent()
	local thinker_pos = thinker:GetAbsOrigin()
	if self.startup_time ~= nil then
		self.startup_time = nil
		self.particle = self.startup_particle
		self.expire = GameRules:GetGameTime() + self.duration
		self:StartIntervalThink(0)
	elseif self.duration ~= nil then
		if GameRules:GetGameTime() > self.expire then
			self:Destroy()
		else
			local enemies = FindUnitsInRadius(thinker:GetTeam(), thinker_pos, nil, self.search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES, FIND_CLOSEST, false)
			if enemies[1] then
				self.target = enemies[1]
				self.duration = nil
				self.expire = nil
				self:StartIntervalThink(-1)
				local info = 
				{
					Target = enemies[1],
					--Source = thinker,
					Ability = self:GetAbility(),	
					EffectName = "particles/units/heroes/hero_arc_warden/arc_warden_wraith_prj.vpcf",
					vSourceLoc = (thinker_pos + Vector(0, 0, 150)),
					bDrawsOnMinimap = false,
					iSourceAttachment = 1,
					iMoveSpeed = self.speed,
					bDodgeable = false,
					bProvidesVision = true,
					iVisionRadius = self.vision_radius,
					iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
					bVisibleToEnemies = true,
					flExpireTime = nil,
					bReplaceExisting = false
				}
				ProjectileManager:CreateTrackingProjectile(info)
				ParticleManager:DestroyParticle(self.particle, false)
				EmitSoundOnLocationWithCaster(thinker_pos, "Hero_ArcWarden.SparkWraith.Activate", self:GetCaster()) 
				self:Destroy()
			end
		end
	else

	end
end

function arc_warden_spark_wraith_thinker_lua:OnDestroy()
	if self.particle then
		ParticleManager:DestroyParticle(self.particle, false)
	end
end

function arc_warden_spark_wraith_thinker_lua:CheckState()
	if self.duration then
		return {[MODIFIER_STATE_PROVIDES_VISION] = true}
	end
	return nil
end
