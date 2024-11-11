modifier_broodmother_web_dummy_aura_lua = class({
	OnCreated = function(self)
		local parent = self:GetParent()
		local pid = ParticleManager:CreateParticle("particles/units/heroes/hero_broodmother/broodmother_web.vpcf", PATTACH_ABSORIGIN, parent)
		ParticleManager:SetParticleControl(pid, 1, Vector(900, 0, 150))
	end,
	CheckState = function()
		return {
			[ MODIFIER_STATE_NO_HEALTH_BAR ] 				= true,
			[ MODIFIER_STATE_NO_TEAM_SELECT ]			 	= true,
			[ MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES	] 	= true, 
			[ MODIFIER_STATE_NO_UNIT_COLLISION ]			= true,
			[ MODIFIER_STATE_ROOTED ]						= true,
			[ MODIFIER_STATE_INVULNERABLE ]					= true
		}
	end,
	IsHidden = function() return true end,
	IsAura = function() return true end,
	GetAuraDuration = function() return 0.15 end,
	GetAuraEntityReject = function(self, entity)
		if entity:IsHero() and entity:HasAbility("broodmother_spin_web_datadriven") then
			return false
		end
		if entity:IsCreep() then
			if entity:GetName() == "npc_dota_broodmother_spiderling" then
				return false
			end
			if entity:GetName() == "npc_dota_broodmother_spiderite" then
				return false
			end
		end
		return true
	end,
	GetAuraRadius = function() return 900 end,
	GetAuraSearchTeam = function() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
	GetAuraSearchType = function() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
	GetAuraSearchFlags = function() return 0 end,
	GetModifierAura = function() return "modifier_broodmother_spin_web_lua" end
})
