-- main buff

if modifier_doom_bringer_scorched_earth_buff_lua == nil then
    modifier_doom_bringer_scorched_earth_buff_lua = class({})
end

function modifier_doom_bringer_scorched_earth_buff_lua:OnCreated(kv)
    self.kv = kv
end

function modifier_doom_bringer_scorched_earth_buff_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_doom_bringer_scorched_earth_buff_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return funcs
end

function modifier_doom_bringer_scorched_earth_buff_lua:IsHidden()
	return false
end

function modifier_doom_bringer_scorched_earth_buff_lua:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor("damage_per_second")
end

function modifier_doom_bringer_scorched_earth_buff_lua:GetModifierMoveSpeedBonus_Percentage()
	if self:GetCaster() == self:GetParent() then
		return 0
	else
		return self:GetAbility():GetSpecialValueFor("bonus_movement_speed_pct")
	end
end

function modifier_doom_bringer_scorched_earth_buff_lua:GetTexture()
    return "doom_bringer_scorched_earth"
end

-- buff aura

if modifier_doom_bringer_scorched_earth_buff_aura_lua == nil then
    modifier_doom_bringer_scorched_earth_buff_aura_lua = class({})
end

function modifier_doom_bringer_scorched_earth_buff_aura_lua:OnCreated(kv)
    self.kv = kv
	self:StartIntervalThink(1)
end

function modifier_doom_bringer_scorched_earth_buff_aura_lua:OnIntervalThink()
	if not self:GetParent():HasModifier("modifier_doom_bringer_scorched_earth_effect") then
		self:Destroy()
	end
end

function modifier_doom_bringer_scorched_earth_buff_aura_lua:GetAuraRadius()
	return 600
end

function modifier_doom_bringer_scorched_earth_buff_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_doom_bringer_scorched_earth_buff_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

function modifier_doom_bringer_scorched_earth_buff_aura_lua:GetAuraEntityReject(entity)
	return entity:GetPlayerOwner() ~= self:GetCaster():GetPlayerOwner()
end

function modifier_doom_bringer_scorched_earth_buff_aura_lua:GetModifierAura()
	return "modifier_doom_bringer_scorched_earth_buff_lua"
end

function modifier_doom_bringer_scorched_earth_buff_aura_lua:IsAura()
	return true
end

function modifier_doom_bringer_scorched_earth_buff_aura_lua:IsHidden()
	return true
end

function modifier_doom_bringer_scorched_earth_buff_aura_lua:IsPurgable()
	return true
end
