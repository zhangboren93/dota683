faceless_void_chronosphere_lua = class({})

function faceless_void_chronosphere_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor("duration")
	local vision = self:GetSpecialValueFor("vision_radius")

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_faceless_void_chronosphere_lua_thinker",
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_faceless_void_chronosphere_selfbuff", -- Original Dota2 modifier thinker
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)

	-- create fov
	AddFOWViewer( self:GetCaster():GetTeamNumber(), point, vision, duration, false)
end

LinkLuaModifier( "modifier_faceless_void_chronosphere_lua_thinker", "heroes/hero_faceless_void/chronosphere.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_faceless_void_chronosphere_freeze_lua", 	"heroes/hero_faceless_void/chronosphere.lua", LUA_MODIFIER_MOTION_NONE)

modifier_faceless_void_chronosphere_lua_thinker = class({ 
	IsAura				= function(self) return true end,
	GetModifierAura		= function(self) return "modifier_faceless_void_chronosphere_freeze_lua" end,
	GetAuraRadius		= function(self) return self.radius end,
	GetAuraDuration		= function(self) return 0.01 end,
	GetAuraSearchTeam	= function(self) return DOTA_UNIT_TARGET_TEAM_BOTH end,
	GetAuraSearchType	= function(self) return DOTA_UNIT_TARGET_ALL end,
	GetAuraSearchFlags	= function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
})

function modifier_faceless_void_chronosphere_lua_thinker:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	if IsServer() then
		local parent = self:GetParent()

		local particle_name = "particles/units/heroes/hero_faceless_void/faceless_void_chronosphere.vpcf"
		local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, parent)
		ParticleManager:SetParticleControl(particle, 0, parent:GetOrigin())
		ParticleManager:SetParticleControl(particle, 1, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(
			particle,
			false, -- bDestroyImmediately
			false, -- bStatusEffect
			-1, -- iPriority
			false, -- bHeroEffect
			false -- bOverheadEffect
		)

		EmitSoundOn("Hero_FacelessVoid.Chronosphere", parent)
	end	
end

function modifier_faceless_void_chronosphere_lua_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end

function modifier_faceless_void_chronosphere_lua_thinker:GetAuraEntityReject( hEntity )
	if IsServer() then
		if hEntity == self:GetCaster()
			or hEntity:GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID()
			or hEntity:GetUnitName() == "npc_dota_faceless_void"
			then
				return true
			end
	end
	return false
end

modifier_faceless_void_chronosphere_freeze_lua = class({ 
	IsDebuff		= function(self) return true end,
	IsStunDebuff	= function(self) return true end,
	IsPurgable		= function(self) return true end,
	GetPriority		= function(self) return MODIFIER_PRIORITY_ULTRA end
})

function modifier_faceless_void_chronosphere_freeze_lua:OnCreated( kv )
	if IsServer() then
		self:GetParent():InterruptMotionControllers( false )
	end
end

function modifier_faceless_void_chronosphere_freeze_lua:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}
	return state
end