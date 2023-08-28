
LinkLuaModifier("modifier_jugg_omni_slash_rebuild","heroes/hero_juggernaut/jugg",LUA_MODIFIER_MOTION_NONE)

modifier_jugg_omni_slash_rebuild = class({
    IsHidden        = function(self) return true end,
    DeclareFunctions = function(self)
        return {
            MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
            MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
        }
    end,
    CheckState      = function(self)
        return {
            [MODIFIER_STATE_INVULNERABLE] = true,
            [MODIFIER_STATE_NO_HEALTH_BAR] = true,
            [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
            [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
            [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
            [MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true
        }
    end,
    GetStatusEffectName     = function(self)
        return "particles/status_fx/status_effect_omnislash.vpcf"
    end,
    StatusEffectPriority    = function(self)
        return MODIFIER_PRIORITY_ULTRA
    end,
    GetOverrideAnimation    = function(self)
        return ACT_DOTA_OVERRIDE_ABILITY_4
    end,
    GetModifierIgnoreCastAngle = function(self)
        return true
    end,
    OnCreated               = function(self,param)
        if IsServer() then
            self:SetStackCount(param.slash_count)
            self.slash_count = param.slash_count
            self.interval = param.interval
            self.damage_max = param.damage_max
            self.damage_min = param.damage_min
            self.radius = param.radius
            self.target = EntIndexToHScript(param.enttarget)
            self.buffer = 0.15
            self.buffer_time = param.buffer_time
            self.think_time = 0
            self.think_interval = 0.03
            self:PerformSlash()
            self:StartIntervalThink(self.think_interval)
        end
    end,
    OnIntervalThink         = function(self)
        self.think_time = self.think_time + self.think_interval
        if not self:FindTarget() then
            self.buffer = self.buffer - self.think_interval
            goto ThinkEnd
        end
        if self.think_time >= self.interval and self.target ~= nil then self:PerformSlash() end
        ::ThinkEnd::
        if ( self.target == nil and self.buffer <= 0 ) or self:GetStackCount() <= 0 then
            local caster = self:GetParent()
            self:Destroy()
            FindClearSpaceForUnit(caster,caster:GetOrigin(),true)
        end
    end,
    FindTarget              = function(self)
        local caster = self:GetParent()
        local units = FindUnitsInRadius(caster:GetTeam(),caster:GetOrigin(),nil,self.radius,DOTA_UNIT_TARGET_TEAM_ENEMY,19,336,0,false)
        if #units > 0 then
            self.target = units[RandomInt(0,#units)]
            self.buffer = self.buffer_time
            return true
        else
            self.target = nil
            return false
        end
    end,
    PerformSlash            = function(self)
        if self:GetStackCount() == self.slash_count then
            if self.target:TriggerSpellAbsorb(self:GetAbility()) then
                goto Move
            else
                self.target:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_stunned",{
                    duration = 0.03
                })
            end
        end
        if self.target:IsCreep() and not self.target:IsCreepHero() and not self.target:IsAncient() then
            self.target:Kill(self:GetAbility(),self:GetParent())
        else
            ApplyDamage({
                attacker = self:GetParent(),
                victim = self.target,
                damage = RandomInt(self.damage_min,self.damage_max),
                damage_type = DAMAGE_TYPE_PHYSICAL,
                ability = self:GetAbility()
            })
            self:GetParent():MoveToTargetToAttack(self.target)
        end
        ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf",PATTACH_CENTER_FOLLOW,self.target))
        EmitSoundOn("Hero_Juggernaut.OmniSlash.Damage",self.target)
        ::Move::
        local tgt_pos = self.target:GetOrigin()
        local old_pos = self:GetParent():GetOrigin()
        local new_pos = tgt_pos + QAngle(0,RandomInt(0,360),0):Forward()*50
        self:GetParent():SetOrigin(new_pos)
        self:GetParent():FaceTowards(tgt_pos)
        AddFOWViewer(self:GetParent():GetTeam(),new_pos,200,self.interval+self.think_interval+self.buffer,false)
        self:PerformEffect(old_pos,new_pos)
        self.think_time = 0
        self:DecrementStackCount()
    end,
    PerformEffect           = function(self,old_pos,new_pos)
        local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf",PATTACH_WORLDORIGIN,nil)
        ParticleManager:SetParticleControl(effect,0,new_pos)
        ParticleManager:SetParticleControl(effect,1,old_pos)
        ParticleManager:ReleaseParticleIndex(effect)
        EmitSoundOn("Hero_Juggernaut.OmniSlash",self:GetParent())
    end
})

juggernaut_omni_slash_rebuild = class({
    OnSpellStart            = function(self)
        local caster = self:GetCaster()
        local target = self:GetCursorTarget()
        local interval = self:GetSpecialValueFor("slash_interval")
        local damage_max = self:GetSpecialValueFor("slash_damage_max")
        local damage_min = self:GetSpecialValueFor("slash_damage_min")
        local slash_count = self:GetSpecialValueFor("slash_count")
        local radius = self:GetSpecialValueFor("omni_slash_radius")
        local buffer_time = self:GetSpecialValueFor("buffer_time")
        if caster:HasScepter() then slash_count = slash_count + self:GetSpecialValueFor("slash_count_bonus_scepter") end
        caster:AddNewModifier(caster,self,"modifier_jugg_omni_slash_rebuild",{
            enttarget = target:entindex(),
            interval = interval,
            damage_max = damage_max,
            damage_min = damage_min,
            slash_count = slash_count,
            radius = radius,
            buffer_time = buffer_time
        })
    end,
    GetCooldown             = function(self,level)
        if self:GetCaster():HasScepter() then
            return self:GetSpecialValueFor("cooldown_scepter")
        else
            return self:GetLevelSpecialValueFor("cooldown",level)
        end
    end
})

LinkLuaModifier("modifier_juggernaut_blade_fury_datadriven", "heroes/hero_juggernaut/jugg", LUA_MODIFIER_MOTION_NONE)
juggernaut_blade_fury_datadriven = class({})
function juggernaut_blade_fury_datadriven:GetCastRange() return self:GetSpecialValueFor("blade_fury_radius") end
function juggernaut_blade_fury_datadriven:OnSpellStart()
    self:GetCaster():Purge(false, true, false, false, false)
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_juggernaut_blade_fury_datadriven", {duration = self:GetDuration()})
end
modifier_juggernaut_blade_fury_datadriven = class({})
function modifier_juggernaut_blade_fury_datadriven:IsPurgable() return false end
function modifier_juggernaut_blade_fury_datadriven:DeclareFunctions() return {MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE, MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_juggernaut_blade_fury_datadriven:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true, [MODIFIER_STATE_SILENCED] = true} end
function modifier_juggernaut_blade_fury_datadriven:GetModifierDamageOutgoing_Percentage(keys) if keys.target and not keys.target:IsMagicImmune() and not keys.target:IsBuilding() then return -100 end end
function modifier_juggernaut_blade_fury_datadriven:OnCreated()
    self.original_caster = self:GetCaster()
    self.radius = self:GetAbility():GetSpecialValueFor("blade_fury_radius")
    self.tick = self:GetAbility():GetSpecialValueFor("blade_fury_damage_tick")
    if not IsServer() then return end
    self.dps = self:GetAbility():GetSpecialValueFor("blade_fury_damage") 
    if not self:GetCaster():IsAlive() then return end
    self.blade_fury_spin_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControl(self.blade_fury_spin_pfx, 5, Vector(self.radius * 1.2, 0, 0))
    self.blade_fury_spin_pfx_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_null.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControl(self.blade_fury_spin_pfx_2, 1, Vector(self.radius * 1.2, 0, 0))
    self:StartIntervalThink(self.tick)
    self:GetCaster():EmitSound("Hero_Juggernaut.BladeFuryStart")
end
function modifier_juggernaut_blade_fury_datadriven:OnIntervalThink()
    local damage = self.dps * self.tick
    local caster_loc = self:GetCaster():GetAbsOrigin()
    local furyEnemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), caster_loc, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _,enemy in pairs(furyEnemies) do
        enemy:EmitSound("Hero_Juggernaut.BladeFury.Impact")
        local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
        ParticleManager:SetParticleControl(fx, 0, enemy:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(fx)
        ApplyDamage({attacker = self:GetCaster(), victim = enemy, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
    end
end
function modifier_juggernaut_blade_fury_datadriven:OnRemoved()
    if not IsServer() then return end
    self:GetCaster():StopSound("Hero_Juggernaut.BladeFuryStart")
    self:GetCaster():EmitSound("Hero_Juggernaut.BladeFuryStop")
    if self.blade_fury_spin_pfx then
        ParticleManager:DestroyParticle(self.blade_fury_spin_pfx, false)
        ParticleManager:ReleaseParticleIndex(self.blade_fury_spin_pfx)
        self.blade_fury_spin_pfx = nil
    end
    if self.blade_fury_spin_pfx_2 then
        ParticleManager:DestroyParticle(self.blade_fury_spin_pfx_2, false)
        ParticleManager:ReleaseParticleIndex(self.blade_fury_spin_pfx_2)
        self.blade_fury_spin_pfx_2 = nil
    end
end
function modifier_juggernaut_blade_fury_datadriven:GetOverrideAnimation() return ACT_DOTA_OVERRIDE_ABILITY_1 end
