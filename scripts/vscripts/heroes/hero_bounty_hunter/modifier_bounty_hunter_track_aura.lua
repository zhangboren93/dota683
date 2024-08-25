modifier_bounty_hunter_track_aura_lua = class({})

function modifier_bounty_hunter_track_aura_lua:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_bounty_hunter_track_aura_lua:OnIntervalThink()
	if not IsServer() then return end
	if not self:GetParent():HasModifier("modifier_bounty_hunter_track_lua") then self:Destroy() end
end

function modifier_bounty_hunter_track_aura_lua:GetAuraDuration()
	return 0.1
end

function modifier_bounty_hunter_track_aura_lua:GetAuraRadius()
	return 900
end

function modifier_bounty_hunter_track_aura_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES 
end

function modifier_bounty_hunter_track_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY 
end

function modifier_bounty_hunter_track_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO 
end

function modifier_bounty_hunter_track_aura_lua:GetModifierAura()
	return "modifier_bounty_hunter_track_effect_lua"
end

function modifier_bounty_hunter_track_aura_lua:IsAura()
	return true
end

function modifier_bounty_hunter_track_aura_lua:IsHidden()
	return true
end

function modifier_bounty_hunter_track_aura_lua:IsPurgable()
	return true
end

function modifier_bounty_hunter_track_aura_lua:IsDebuff()
	return true
end
