modifier_elder_titan_earth_splitter_disarm = class({})

function modifier_elder_titan_earth_splitter_disarm:OnCreated(kv)
    self.kv = kv
end

function modifier_elder_titan_earth_splitter_disarm:CheckState()
	local state = 
    {
	    [MODIFIER_STATE_DISARMED] = true,
	}
	return state
end

function modifier_elder_titan_earth_splitter_disarm:IsDebuff()
    return true
end

function modifier_elder_titan_earth_splitter_disarm:IsPurgable()
    return true
end

function modifier_elder_titan_earth_splitter_disarm:GetEffectName()
	return "particles/units/heroes/hero_elder_titan/elder_titan_scepter_disarm.vpcf"
end

function modifier_elder_titan_earth_splitter_disarm:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end