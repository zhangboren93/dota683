-- Deprecated

if modifier_drop_backpack_items == nil then
    modifier_drop_backpack_items = class({})
end

function modifier_drop_backpack_items:OnCreated()
    self:StartIntervalThink(1)
end

function modifier_drop_backpack_items:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function isBackpackFull(parent)
    for i=6,8 do
        local item = parent:GetItemInSlot(i)
        if item == nil then
            return false
        end
    end
    return true
end

function modifier_drop_backpack_items:OnIntervalThink()
    local parent = self:GetParent()
    if parent.GetItemInSlot == nil or parent:IsClone() then
        return
    end
    local item = nil
    for i=6,8 do
        item = parent:GetItemInSlot(i)
        if item ~= nil and item:GetName() ~= "item_dummy_backpackblock_datadriven" then
            parent:DropItemAtPosition(parent:GetAbsOrigin(), item)
        end
    end

    if true then
        return -- only drop items in backpack now
    end

    while not isBackpackFull(parent) do
        parent:AddItemByName("item_dummy_backpackblock_datadriven")
    end

    -- remove block item from inventory
    for i=0,5 do
        item = parent:GetItemInSlot(i)
        if item ~= nil and item:GetName() == "item_dummy_backpackblock_datadriven" then
            parent:RemoveItem(item)
        end
    end
    -- remove block item from stash
    for i=9,14 do
        item = parent:GetItemInSlot(i)
        if item ~= nil and item:GetName() == "item_dummy_backpackblock_datadriven" then
            parent:RemoveItem(item)
        end
    end
end

function modifier_drop_backpack_items:IsHidden()
    return true
end