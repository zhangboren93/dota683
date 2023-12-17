if enchantress_enchant_lua == nil then
	enchantress_enchant_lua = class({})
end

function enchantress_enchant_lua:OnSpellStart()
	self.caster	= self:GetCaster()
	self.target	= self:GetCursorTarget()
	
	-- AbilitySpecials
	self.dominate_duration		= self:GetSpecialValueFor("dominate_duration")
	self.duration 				= self:GetDuration()
	
	-- Blocked by Linkens
	if self.target:TriggerSpellAbsorb(self) then return nil	end
	
	self.caster:EmitSound("Hero_Enchantress.EnchantCast")
	
	if not self.target:IsConsideredHero() or self.target:IsIllusion() then
		
		if string.find(self.target:GetUnitName(), "guys_") then
			local lane_creep_name = self.target:GetUnitName()
			
			local new_lane_creep = CreateUnitByName(self.target:GetUnitName(), self.target:GetAbsOrigin(), false, self.caster, self.caster, self.caster:GetTeamNumber())
			-- Copy the relevant stats over to the creep
			new_lane_creep:SetBaseMaxHealth(self.target:GetMaxHealth())
			new_lane_creep:SetHealth(self.target:GetHealth())
			new_lane_creep:SetBaseDamageMin(self.target:GetBaseDamageMin())
			new_lane_creep:SetBaseDamageMax(self.target:GetBaseDamageMax())
			new_lane_creep:SetMinimumGoldBounty(self.target:GetGoldBounty())
			new_lane_creep:SetMaximumGoldBounty(self.target:GetGoldBounty())
			self.target:AddNoDraw()
			self.target:ForceKill(false)
			self.target = new_lane_creep
		end

		self.target:SetOwner(self.caster)
		self.target:SetTeam(self.caster:GetTeam())
		self.target:SetControllableByPlayer(self.caster:GetPlayerID(), false)
		self.target:AddNewModifier(self.caster, self, "modifier_enchantress_enchant_lua", {duration = self.dominate_duration})
		self.target:AddNewModifier(self.caster, self, "modifier_kill", {duration = self.dominate_duration})

		if self.caster:GetName() == "npc_dota_hero_enchantress" then
			self.caster:EmitSound("enchantress_ench_ability_enchant_0"..math.random(1,3))
		end
	else
		self.target:AddNewModifier(self.caster, self, "modifier_enchantress_enchant_slow_lua", {duration = self.duration * (1 - self.target:GetStatusResistance())})

		if self.caster:GetName() == "npc_dota_hero_enchantress" then
			self.caster:EmitSound("enchantress_ench_ability_enchant_0"..math.random(4,6))
		end
	end
end

---------------------------------
-- ENCHANT CONTROLLED MODIFIER --
---------------------------------

if modifier_enchantress_enchant_lua == nil then
	modifier_enchantress_enchant_lua = class({
		IsPurgable	= function(self) return false end,
		-- AllowIllusionDuplicate	= function(self) return true end,
	})
end

function modifier_enchantress_enchant_lua:OnCreated()
	if not IsServer() then return end
	local parent = self:GetParent()
	
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_enchantress/enchantress_enchant.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControl(self.particle, 0, parent:GetAbsOrigin())
	self:AddParticle(self.particle, false, false, -1, false, false)
	
	parent:EmitSound("Hero_Enchantress.EnchantCreep")
end

function modifier_enchantress_enchant_lua:CheckState()
	return
	{
		[MODIFIER_STATE_DOMINATED] = true
	}
end

---------------------------
-- ENCHANT SLOW MODIFIER --
---------------------------

if modifier_enchantress_enchant_slow_lua == nil then
	modifier_enchantress_enchant_slow_lua = class({
		IsDebuff	= function(self) return true end,
		IsPurgable	= function(self) return true end,
	})
end

function modifier_enchantress_enchant_slow_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_enchantress_enchant_slow.vpcf"
end

function modifier_enchantress_enchant_slow_lua:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	
	self.slow_movement_speed = self.ability:GetSpecialValueFor("slow_movement_speed")
	
	if not IsServer() then return end
	
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_enchantress/enchantress_enchant_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle, 0, self.parent:GetAbsOrigin())
	self:AddParticle(self.particle, false, false, -1, false, false)
	
	self.parent:EmitSound("Hero_Enchantress.EnchantHero")
end

function modifier_enchantress_enchant_slow_lua:OnDestroy()
	if not IsServer() then return end
	self.parent:StopSound("Hero_Enchantress.EnchantHero")
end

function modifier_enchantress_enchant_slow_lua:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return decFuncs
end

function modifier_enchantress_enchant_slow_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.slow_movement_speed
end