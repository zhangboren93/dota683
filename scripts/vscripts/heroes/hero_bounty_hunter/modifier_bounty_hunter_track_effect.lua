if modifier_bounty_hunter_track_effect_lua == nil then
    modifier_bounty_hunter_track_effect_lua = class({})
end

function modifier_bounty_hunter_track_effect_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_bounty_hunter_track_effect_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return funcs
end

function modifier_bounty_hunter_track_effect_lua:IsHidden()
    return false
end

function modifier_bounty_hunter_track_effect_lua:GetModifierMoveSpeedBonus_Percentage()
    return 20
end

function modifier_bounty_hunter_track_effect_lua:GetTexture()
    return "bounty_hunter_track"
end

function modifier_bounty_hunter_track_effect_lua:IsDebuff()
    return false
end

function modifier_bounty_hunter_track_effect_lua:OnCreated()
	local parent = self:GetParent()
	self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_haste.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt(self.particleId, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), false)
	ParticleManager:SetParticleControl(self.particleId, 1, Vector(1, 0, 0))
end

function modifier_bounty_hunter_track_effect_lua:OnDestroy()
	ParticleManager:DestroyParticle(self.particleId, false)
end
