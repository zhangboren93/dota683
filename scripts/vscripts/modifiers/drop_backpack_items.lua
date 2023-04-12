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
    for i=6,8 do
        local item = parent:GetItemInSlot(i)
        if item ~= nil then
            local couriers = Entities:FindAllByNameWithin("npc_dota_courier", parent:GetAbsOrigin(), 1000)
            local courier = nil
            for j=1,#couriers do
                if couriers[j]:GetTeam() == parent:GetTeam() then
                    courier = couriers[j]
                    break
                end
            end
            if courier ~= nil then
                parent:TakeItem(item)
                courier:AddItem(item)
            else
                parent:DropItemAtPositionImmediate(item, parent:GetAbsOrigin())
            end
        end
    end
end

function modifier_drop_backpack_items:IsHidden()
    return true
end