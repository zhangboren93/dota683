-- Generic Orb Effect Library created by Elfansoer (with modifications by AltiV)
-- See the reference at https://github.com/Elfansoer/dota-2-lua-abilities/blob/c3bfb93a32e8257f861a5e32e4d25231185a6ba4/scripts/vscripts/lua_abilities/generic/modifier_generic_orb_effect_item_lua.lua

-- There's some weird bug that lets you bypass target flags if you level up the ability mid-attack -_-

modifier_generic_orb_effect_item_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_orb_effect_item_lua:IsHidden()
	return true
end

function modifier_generic_orb_effect_item_lua:IsDebuff()
	return false
end

function modifier_generic_orb_effect_item_lua:IsPurgable()
	return false
end

function modifier_generic_orb_effect_item_lua:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_orb_effect_item_lua:OnCreated( kv )
	-- generate data
	self.ability = self:GetAbility()
	self.cast = false
	self.records = {}
	
	-- Test variable for proper projectile effect display
	self.target = nil
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_generic_orb_effect_item_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

function modifier_generic_orb_effect_item_lua:OnAttack( params )
	if params.attacker~=self:GetParent() then return end

	-- record the attack
	self.records[params.record] = true

	self.cast = false
end

function modifier_generic_orb_effect_item_lua:GetModifierProcAttack_Feedback( params )
	if params.attacker ~= self:GetParent() then return end

	-- don't proc if attacker has hero orb
	local hero_orb_modifier = params.attacker:FindModifierByName("modifier_generic_orb_effect_lua")
	if hero_orb_modifier ~= nil and hero_orb_modifier.records[params.record] then return end

	if self.records[params.record] then
		-- apply the effect
		if self.ability.OnOrbImpact then self.ability:OnOrbImpact( params ) end
	end
end

function modifier_generic_orb_effect_item_lua:GetModifierProjectileName( params )
	local hero_orb_modifier = self:GetParent():FindModifierByName("modifier_generic_orb_effect_lua")
	if self.ability.GetProjectileName then
		local projectileName = self.ability:GetProjectileName()
		return projectileName
	end
end

function modifier_generic_orb_effect_item_lua:GetPriority()
	return MODIFIER_PRIORITY_LOW 
end
