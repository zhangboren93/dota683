modifier_spirit_breaker_charge_of_darkness_lua = class({})
function modifier_spirit_breaker_charge_of_darkness_lua:OnCreated(data)
    if IsServer() then
        self.target = EntIndexToHScript(data.target)
        self.hit_targets = {}
        if self:ApplyHorizontalMotionController() == false then
            self:Destroy()
        end
        local parent = self:GetParent()
        self.particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge_target.vpcf",
            PATTACH_OVERHEAD_FOLLOW, self.target, parent:GetTeam())
    end
end

function modifier_spirit_breaker_charge_of_darkness_lua:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local parent = self:GetParent()
        local ability = self:GetAbility()
		if not IsValidEntity(self.target) or parent:IsStunned() or parent:IsRooted() or parent:IsHexed() then
            if self.particle then
                ParticleManager:DestroyParticle(self.particle, false)
                ParticleManager:ReleaseParticleIndex(self.particle)
                self.particle = nil
            end
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
                DOTA_UNIT_TARGET_FLAG_NONE,
                FIND_CLOSEST,
                false)
            if #units == 0 then
		        parent:RemoveHorizontalMotionController(self)
                self:Destroy()
                return
            end
            self.target = units[1]
            self.particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge_target.vpcf",
                PATTACH_OVERHEAD_FOLLOW, self.target, parent:GetTeam())
            return
        end
        if (self.target:GetAbsOrigin() - me:GetAbsOrigin()):Length2D() <= 150 then
            parent:EmitSound("Hero_Spirit_Breaker.Charge.Impact")
            local bash = parent:FindAbilityByName("spirit_breaker_greater_bash")
            if bash:GetLevel() > 0 then
                local damage = bash:GetSpecialValueFor("damage") * parent:GetMoveSpeedModifier(parent:GetBaseMoveSpeed(), false) / 100 + ability:GetSpecialValueFor("damage")
                local bash_duration = ability:GetSpecialValueFor("stun_duration")
    	        ApplyDamage({
    	            victim = self.target,
    	            attacker = parent,
    	            damage = damage,
    	            damage_type = DAMAGE_TYPE_MAGICAL,
    	            ability = ability
    	        })
		        self.target:AddNewModifier(parent, ability, "modifier_stunned", { duration = bash_duration })
                local direction = (self.target:GetAbsOrigin() - parent:GetAbsOrigin()):Normalized()
		        self.target:AddNewModifier(caster, bash, "modifier_nether_bash_motion_lua", { duration = 0.5, directx = direction.x, directy = direction.y })
            end
            GridNav:DestroyTreesAroundPoint(parent:GetAbsOrigin(), 150, false)
		    parent:RemoveHorizontalMotionController(self)
            ParticleManager:DestroyParticle(self.particle, false)
            ParticleManager:ReleaseParticleIndex(self.particle)
            self.particle = nil
            self:Destroy()
            return true
        end

        local speed = ability:GetSpecialValueFor("movement_speed")
		me:SetAbsOrigin(me:GetAbsOrigin() + (self.target:GetAbsOrigin() - me:GetAbsOrigin()):Normalized() * dt * speed )

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
		        units[i]:AddNewModifier(parent, bash, "modifier_nether_bash_motion_lua", { duration = 0.5, directx = direction.x, directy = direction.y })
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
	self:Destroy()
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
        if self.particle then
            ParticleManager:DestroyParticle(self.particle, false)
            ParticleManager:ReleaseParticleIndex(self.particle)
            self.particle = nil
        end
        self:Destroy()
    end
end

function modifier_spirit_breaker_charge_of_darkness_lua:CheckState(event)
    return {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end

function modifier_spirit_breaker_charge_of_darkness_lua:GetOverrideAnimation()
	return ACT_DOTA_SPIRIT_BREAKER_ULT_RUN
end
