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

ORB_PRIORITY_ITEMS = {
	"item_satanic_datadriven",
	"item_helm_of_the_dominator_datadriven",
	"item_mask_of_madness_datadriven",
	"item_lifesteal_datadriven",
	"item_desolator_datadriven"
}
function modifier_generic_orb_effect_item_lua:OnAttack( params )
	if params.attacker~=self:GetParent() then return end

	-- if maelstrom triggers, don't trigger other item orbs
	if self:GetParent():HasModifier("modifier_maelstrom_trigger_no_miss") then return end

	-- lifesteal orb has highest priority, then is desolator
	local parent = self:GetParent()
	local activeOrbItem = nil
	for i=1,#ORB_PRIORITY_ITEMS do
		local item = parent:FindItemInInventory(ORB_PRIORITY_ITEMS[i])
		if item ~= nil and item:GetItemState() == 1 then
			activeOrbItem = item
			break
		end
	end
	if activeOrbItem == nil then
		self:Destroy()
		return
	end
	-- record the attack
	self.ability = activeOrbItem
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
