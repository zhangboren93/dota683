modifier_spirit_breaker_charge_of_darkness_lua = class({})
function modifier_spirit_breaker_charge_of_darkness_lua:OnCreated(data)
	if IsServer() then
		self.target = EntIndexToHScript(data.target)
		self.hit_targets = {}
		local parent = self:GetParent()
		self.particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge_target.vpcf",
			PATTACH_OVERHEAD_FOLLOW, self.target, parent:GetTeam())
		self:StartIntervalThink(0.03)
	end
end

function modifier_spirit_breaker_charge_of_darkness_lua:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local ability = self:GetAbility()
		if not IsValidEntity(self.target) or parent:IsStunned() or parent:IsRooted() or parent:IsHexed() then
			self:Destroy()
			return true
		end
		if not self.target:IsAlive() then
			-- choose another target
			if self.particle then
				ParticleManager:DestroyParticle(self.particle, false)
				ParticleManager:ReleaseParticleIndex(self.particle)
				self.particle = nil
			end
			local units = FindUnitsInRadius(
				parent:GetTeam(),
				self.target:GetAbsOrigin(),
				nil,
				10000,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
				FIND_CLOSEST,
				false)
			if #units == 0 then
				self:Destroy()
				return
			end
			self.target = units[1]
			self.particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge_target.vpcf",
				PATTACH_OVERHEAD_FOLLOW, self.target, parent:GetTeam())
			return
		end
		if (self.target:GetAbsOrigin() - parent:GetAbsOrigin()):Length2D() <= 150 then
			parent:EmitSound("Hero_Spirit_Breaker.Charge.Impact")
			local bash = parent:FindAbilityByName("spirit_breaker_greater_bash")
			if bash ~= nil and bash:GetLevel() > 0 then
				local damage = bash:GetSpecialValueFor("damage") * parent:GetMoveSpeedModifier(parent:GetBaseMoveSpeed(), false) / 100 + ability:GetSpecialValueFor("damage")
				ApplyDamage({
					victim = self.target,
					attacker = parent,
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = ability
				})
				local direction = (self.target:GetAbsOrigin() - parent:GetAbsOrigin()):Normalized()
				if self.target:GetUnitName() ~= "npc_dota_roshan_datadriven" then
					self.target:AddNewModifier(caster, bash, "modifier_nether_bash_motion_lua", { duration = 0.5, directx = direction.x, directy = direction.y })
					ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target)
				end
			end
			local bash_duration = ability:GetSpecialValueFor("stun_duration")
			self.target:AddNewModifier(parent, ability, "modifier_stunned", { duration = bash_duration })

			parent:MoveToTargetToAttack(self.target)
			self:Destroy()
			return true
		end

		local speed = ability:GetSpecialValueFor("movement_speed")
		parent:SetAbsOrigin(GetGroundPosition(parent:GetAbsOrigin(), parent) + (self.target:GetAbsOrigin() - parent:GetAbsOrigin()):Normalized() * 0.03 * speed )

		local modifier_vision = self.target:FindModifierByName("modifier_spirit_breaker_charge_target_vision_datadriven")
		if modifier_vision == nil or modifier_vision:GetRemainingTime() < 0.1 then
			ability:ApplyDataDrivenModifier(parent, self.target, "modifier_spirit_breaker_charge_target_vision_datadriven", {})
		end

		local bash = parent:FindAbilityByName("spirit_breaker_greater_bash")
		if bash == nil or bash:GetLevel() == 0 then return end
		local damage = bash:GetSpecialValueFor("damage") * parent:GetMoveSpeedModifier(parent:GetBaseMoveSpeed(), false) / 100 + ability:GetSpecialValueFor("damage")
		local bash_duration = ability:GetSpecialValueFor("stun_duration")
		local units = FindUnitsInRadius(
			parent:GetTeam(),
			parent:GetAbsOrigin(),
			nil,
			300,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)
		for i=1,#units do
			local unit_idx = units[i]:GetEntityIndex()
			if self.hit_targets[unit_idx] or self.target:GetEntityIndex() == unit_idx then
			else
				self.hit_targets[unit_idx] = true
				ApplyDamage({
					victim = units[i],
					attacker = parent,
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = ability
				})
				units[i]:AddNewModifier(parent, ability, "modifier_stunned", { duration = bash_duration })
				local direction = (units[i]:GetAbsOrigin() - parent:GetAbsOrigin()):Normalized()
				if units[i]:GetUnitName() ~= "npc_dota_roshan_datadriven" then
					units[i]:AddNewModifier(parent, bash, "modifier_nether_bash_motion_lua", { duration = 0.5, directx = direction.x, directy = direction.y })
					ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", PATTACH_ABSORIGIN_FOLLOW, units[i])
				end
				units[i]:EmitSound("Hero_Spirit_Breaker.GreaterBash")
			end
		end
	end
end

function modifier_spirit_breaker_charge_of_darkness_lua:OnDestroy()
	if self.particle then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end
	-- start counting ability's cooldown when charge stops.
	local ability = self:GetAbility()
	if ability and ability.StartCooldown ~= nil then
		ability:StartCooldown(12)
	end
	local parent = self:GetParent()
	if parent ~= nil and IsServer() then
		GridNav:DestroyTreesAroundPoint(parent:GetAbsOrigin(), 150, false)
	end
end

function modifier_spirit_breaker_charge_of_darkness_lua:GetEffectName()
	return "particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge.vpcf"
end

function modifier_spirit_breaker_charge_of_darkness_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION 
	}
end

function modifier_spirit_breaker_charge_of_darkness_lua:OnOrder(event)
	if event.unit == self:GetParent() then
		if event.order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
			return
		end	
		self:Destroy()
	end
end

function modifier_spirit_breaker_charge_of_darkness_lua:CheckState(event)
	return {
		[ MODIFIER_STATE_DISARMED ] = true,
		[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true,
		[ MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY ] = true,
		[ MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS ] = true
	}
end

function modifier_spirit_breaker_charge_of_darkness_lua:GetOverrideAnimation()
	return ACT_DOTA_RUN
end

function modifier_spirit_breaker_charge_of_darkness_lua:IsPurgable()
	return false
end

function modifier_spirit_breaker_charge_of_darkness_lua:IsPurgeException()
	return false
end
