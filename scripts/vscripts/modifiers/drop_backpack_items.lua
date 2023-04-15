if modifier_drop_backpack_items == nil then
    modifier_drop_backpack_items = class({})
end

function modifier_drop_backpack_items:OnCreated()
    self:StartIntervalThink(0.5)
end

function modifier_drop_backpack_items:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_drop_backpack_items:OnIntervalThink()
    local parent = self:GetParent()
    if parent.GetItemInSlot == nil then
        return
    end
    local moveToStashItems = {}
    for i=6,8 do
        local item = parent:GetItemInSlot(i)
        if item ~= nil and parent:IsAlive() then
            if parent:IsInRangeOfShop(DOTA_SHOP_HOME, true) then
                table.insert(moveToStashItems, parent:TakeItem(item))
            else
                local couriers = Entities:FindAllByNameWithin("npc_dota_courier", parent:GetAbsOrigin(), 1000)
                local courier = nil
                for j=1,#couriers do
                    if couriers[j]:GetTeam() == parent:GetTeam() then
                        courier = couriers[j]
                        break
                    end
                end
                if courier ~= nil and courier:GetItemInSlot(DOTA_ITEM_SLOT_7) == nil then
                    parent:TakeItem(item)
                    courier:AddItem(item)
                else
                    parent:DropItemAtPosition(parent:GetAbsOrigin(), item)
                end
            end
        end
    end
    if #moveToStashItems > 0 then
    	for i=0, 8 do  --Fill all empty slots in the player's inventory with "dummy" items.
    		local current_item = parent:GetItemInSlot(i)
    		if current_item == nil then
    			parent:AddItem(CreateItem("item_dummy_datadriven", parent, parent))
    		end
    	end
        for i=1,#moveToStashItems do
            parent:AddItem(moveToStashItems[i])
        end
	    for i=0, 8 do  --Remove all dummy items from the player's inventory.
	    	local current_item = parent:GetItemInSlot(i)
	    	if current_item ~= nil then
	    		if current_item:GetName() == "item_dummy_datadriven" then
	    			parent:RemoveItem(current_item)
	    		end
	    	end
	    end
    end
end

function modifier_drop_backpack_items:IsHidden()
    return true
end