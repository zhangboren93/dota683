modifier_spect_ward_lua = class({
    CheckState = function(self) return {
        [ MODIFIER_STATE_INVISIBLE ] = true,
        [ MODIFIER_STATE_INVULNERABLE ] = true,
        [ MODIFIER_STATE_NO_UNIT_COLLISION ] = true,
        [ MODIFIER_STATE_OUT_OF_GAME ] = true,
        [ MODIFIER_STATE_NO_HEALTH_BAR ] = true
    } end,
    OnCreated = function(self, data)
        self.track = data.track
        self.team  = data.team
        self:StartIntervalThink(0.2)
        -- TODO add visual for dire ward
    end,
    OnIntervalThink = function(self)
		if not IsServer() then return end
        local trackUnit = EntIndexToHScript(self.track)
        if trackUnit == nil or not trackUnit:IsAlive() then
            self:StartIntervalThink(-1)
            self:GetParent():ForceKill(false)
        end
    end,
	IsBuff = function() return true end
})


modifier_spect_ward_dire_lua = class({
    CheckState = function(self) return {
        [ MODIFIER_STATE_INVISIBLE ] = true,
        [ MODIFIER_STATE_INVULNERABLE ] = true,
        [ MODIFIER_STATE_NO_UNIT_COLLISION ] = true,
        [ MODIFIER_STATE_OUT_OF_GAME ] = true,
        [ MODIFIER_STATE_NO_HEALTH_BAR ] = true
    } end,
    OnCreated = function(self, data)
        self.track = data.track
        self.team  = data.team
        self:StartIntervalThink(0.2)
        -- TODO add visual for dire ward
    end,
    OnIntervalThink = function(self)
		if not IsServer() then return end
        local trackUnit = EntIndexToHScript(self.track)
        if trackUnit == nil or not trackUnit:IsAlive() then
            self:StartIntervalThink(-1)
            self:GetParent():ForceKill(false)
        end
    end,
	IsDebuff = function() return true end
})
