modifier_bounty_hunter_track_lua = class({})

function modifier_bounty_hunter_track_lua:CheckStates()
	return {
		[ MODIFIER_STATE_PROVIDES_VISION ] = true,
		[ MODIFIER_STATE_INVISIBLE ] = false
	}
end

function modifier_bounty_hunter_track_lua:IsHidden()
	return false
end

function modifier_bounty_hunter_track_lua:IsPurgable()
	return true
end

function modifier_bounty_hunter_track_lua:GetLevel()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_bounty_hunter_track_lua:OnDestroy()
	if self.particleId ~= nil then
		ParticleManager:DestroyParticle(self.particleId, false)
		ParticleManager:DestroyParticle(self.particleId2, false)
		self.particleId = nil
		self.particleId2 = nil
	end
	if not IsServer() then return end
	local target = self:GetParent()
	if target:IsAlive() then return end
	caster = self:GetCaster()
	targetLocation = target:GetAbsOrigin()
	local ability = self:GetAbility()
	local bonus_gold_self = ability:GetSpecialValueFor("bonus_gold_self")
	local bonus_gold = ability:GetSpecialValueFor("bonus_gold")
	local bonus_gold_radius = ability:GetSpecialValueFor("bonus_gold_radius")
	caster:ModifyGold(bonus_gold_self, true, 0)
	local bonus_gold_targets = FindUnitsInRadius(caster:GetTeam(), targetLocation, nil, bonus_gold_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
	for i=1,#bonus_gold_targets do
		if bonus_gold_targets[i] ~= caster then
			bonus_gold_targets[i]:ModifyGold(bonus_gold, true, 0)
		end
	end
	target:RemoveModifierByName("modifier_bounty_hunter_track_lua")
	target:RemoveModifierByName("modifier_bounty_hunter_track_aura_lua")
end

function modifier_bounty_hunter_track_lua:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_bounty_hunter_track_lua:OnIntervalThink()
	if not IsServer() then return end
	local parent = self:GetParent()
	local vision_radius = parent:GetCurrentVisionRange()
	local ability = self:GetAbility()
	ability:CreateVisibilityNode(parent:GetAbsOrigin(), vision_radius, 0.1)
end
