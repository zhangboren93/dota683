modifier_sentry_ward_reveal_invis_aura_lua = class({})
function modifier_sentry_ward_reveal_invis_aura_lua:IsAura()
	return true
end

function modifier_sentry_ward_reveal_invis_aura_lua:GetModifierAura()
	return "modifier_truesight"
end

function modifier_sentry_ward_reveal_invis_aura_lua:GetAuraRadius()
	return 850
end

function modifier_sentry_ward_reveal_invis_aura_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_sentry_ward_reveal_invis_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_sentry_ward_reveal_invis_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_OTHER + DOTA_UNIT_TARGET_CUSTOM
end

function modifier_sentry_ward_reveal_invis_aura_lua:IsHidden()
	return true
end

function modifier_sentry_ward_reveal_invis_aura_lua:OnCreated()
	self:StartIntervalThink(FrameTime())
end

function modifier_sentry_ward_reveal_invis_aura_lua:OnIntervalThink()
	if self:GetParent().SetSkin ~= nil then
		self:GetParent():SetSkin(1)
	end
end

