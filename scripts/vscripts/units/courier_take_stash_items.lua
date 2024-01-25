local function getFountain(team)
    if team == DOTA_TEAM_GOODGUYS then
        return Vector(-7093, -6542)
    else
        return Vector(7015, 6534)
    end
end

local function needGoBackToBase(courier, hero)
	-- if courier not in base, and hero has item in stash
	local courier_in_base = courier:IsInRangeOfShop(DOTA_SHOP_HOME, true)
	local hero_stash_has_item = false
	for i = DOTA_STASH_SLOT_1, DOTA_STASH_SLOT_6 do
		local item = hero:GetItemInSlot(i)
		if item ~= nil then hero_stash_has_item = true end
	end
	return not courier_in_base and hero_stash_has_item
end

modifier_courier_take_stash_return_to_base = class({})
function modifier_courier_take_stash_return_to_base:OnCreated(data)
	if not IsServer() then return end
	self.issuer_hero = data.issuer_hero
	self:StartIntervalThink(0.5)
end

function modifier_courier_take_stash_return_to_base:OnIntervalThink()
	local parent = self:GetParent()
	if parent:IsInRangeOfShop(DOTA_SHOP_HOME, true) then
		parent:RemoveModifierByName("modifier_courier_take_stash_return_to_base")
		parent.target_hero = parent.issuer_hero:GetEntityIndex()
		parent:CastAbilityNoTarget(
			parent:FindAbilityByName("courier_transfer_items_lua"), 
			parent.issuer_hero:GetPlayerID())
	end
end

courier_take_stash_items_lua = class({})

function courier_take_stash_items_lua:GetIntrinsicModifierName()
	return "modifier_courier_take_stash_items_lua"
end

local function hasStashItem(hero)
	local hero_stash_has_item = false
	for i = DOTA_STASH_SLOT_1, DOTA_STASH_SLOT_6 do
		local item = hero:GetItemInSlot(i)
		if item ~= nil then 
			return true 
		end
	end
	return false
end

function courier_take_stash_items_lua:OnSpellStart()
	if not IsServer() then return end
	local courier = self:GetCaster()
	local hero = courier.issuer_hero
	if needGoBackToBase(courier, hero) then
		courier:AddNewModifier(courier, self, "modifier_courier_take_stash_return_to_base", 
			{ issuer_hero = hero:GetEntityIndex() })
		courier:MoveToPosition(getFountain(courier:GetTeam()))
		CustomGameEventManager:Send_ServerToTeam(courier:GetTeam(),
												 "courier_start_transfer",
												 {
													id = tostring(courier:GetEntityIndex()), 
                                                    player_id = hero:GetPlayerID()
												 })
	elseif courier:IsInRangeOfShop(DOTA_SHOP_HOME, true) and hasStashItem(hero) then
		courier.target_hero = courier.issuer_hero:GetEntityIndex()
		courier:CastAbilityNoTarget(
			courier:FindAbilityByName("courier_transfer_items_lua"), 
			courier.issuer_hero:GetPlayerID())
	end
end

modifier_courier_take_stash_items_lua = class({})
function modifier_courier_take_stash_items_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER
	}
end
function modifier_courier_take_stash_items_lua:IsHidden()
	return true
end

function modifier_courier_take_stash_items_lua:OnOrder(event)
	if not IsServer() then return end
    local courier = event.unit
    if courier ~= self:GetParent() then
        return
    end
    local ability = event.ability
    if ability == nil or ability:GetName() ~= "courier_take_stash_items_lua" then
		courier:RemoveModifierByName("modifier_courier_take_stash_return_to_base")
		CustomGameEventManager:Send_ServerToTeam(
	        courier:GetTeam(), "courier_end_transfer", { id = tostring(courier:GetEntityIndex()) })
        return
    end
    local issuer_player_id = event.issuer_player_index
    local hero = PlayerResource:GetPlayer(issuer_player_id):GetAssignedHero()
	-- if hero has item in stash, retrieve item from stash & transfer
	courier.issuer_hero = hero
end


