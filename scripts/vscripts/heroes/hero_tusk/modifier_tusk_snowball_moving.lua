modifier_tusk_snowball_moving_lua = class({})
function modifier_tusk_snowball_moving_lua:OnCreated(event)
	if IsServer() then
		if event.target then
			self.snowballTarget = EntIndexToHScript(event.target)
		end
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end
		self.snowballHitUnits = {}
	end
end

function modifier_tusk_snowball_moving_lua:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		if caster:HasModifier("modifier_tusk_snowball_start_datadriven") then return end

		local dist = (self.snowballTarget:GetAbsOrigin() - me:GetAbsOrigin()):Length2D()
		if dist < 128 then
			self:GetParent():ForceKill(false)
			self:GetParent():AddNoDraw()
			return true
		end
		me:SetAbsOrigin(me:GetAbsOrigin() + 
			(self.snowballTarget:GetAbsOrigin() - me:GetAbsOrigin()):Normalized()
				* dt * (me:GetMoveSpeedModifier(me:GetBaseMoveSpeed(), false) * 1.5
						+ #caster.snowballAllies * ability:GetSpecialValueFor("snowball_speed_bonus")))
		local parent = self:GetParent()
		local units = FindUnitsInRadius(
			caster:GetTeam(),
			parent:GetAbsOrigin(),
			nil,
			200,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)
		local damage = ability:GetSpecialValueFor("snowball_damage") +
			#caster.snowballAllies * ability:GetSpecialValueFor("snowball_damage_bonus")
		local stun_duration = ability:GetSpecialValueFor("stun_duration")
		local caster = self:GetCaster()
		for i=1,#units do
			if self.snowballHitUnits[units[i]:GetEntityIndex()] then
			else
				self.snowballHitUnits[units[i]:GetEntityIndex()] = true
				units[i]:AddNewModifier(caster, ability, "modifier_stunned", {
					duration = stun_duration })
				ApplyDamage({
					victim = units[i],
					attacker = caster, 
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = ability })
				if units[i] == self.snowballTarget then
					units[i]:EmitSound("Hero_Tusk.Snowball.ProjectileHit")
				else
					units[i]:EmitSound("Hero_Tusk.Snowball.Stun")
				end
			end
		end
	end
end

function modifier_tusk_snowball_moving_lua:OnDestroy()
	if not IsServer() then return end
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_tusk_snowball_follow_datadriven")
	for i=1,#caster.snowballAllies do
		caster.snowballAllies[i]:RemoveModifierByName("modifier_tusk_snowball_follow_datadriven")
		caster.snowballAllies[i]:RemoveModifierByName("modifier_tusk_snowball_ally_datadriven")
		FindClearSpaceForUnit(caster.snowballAllies[i], caster:GetAbsOrigin(), false)
	end
	caster:StopSound("Hero_Tusk.Snowball.Loop")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_snowball_destroy.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 4, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
	ParticleManager:DestroyParticle(caster.targetParticle, false)
	caster.targetParticle = nil
end

function modifier_tusk_snowball_moving_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}
end

function modifier_tusk_snowball_moving_lua:GetVisualZDelta()
	return 80
end

function modifier_tusk_snowball_moving_lua:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end
