function dominateCreep(event)
    local item = event.ability
    local caster = event.caster
    local target = event.target
    if item.dominatedCreep ~= nil and IsValidEntity(item.dominatedCreep) then
        item.dominatedCreep:ForceKill(false)
    end
    local name = target:GetUnitName()
    local spawn_location = target:GetAbsOrigin()
    target:Destroy()

	local double = CreateUnitByName( name, spawn_location, true, caster, caster:GetOwner(), caster:GetTeamNumber())
	double:SetControllableByPlayer(caster:GetPlayerID(), true)
    double:SetMaxHealth(double:GetMaxHealth() + item:GetSpecialValueFor("health_bonus"))
    double:SetHealth(double:GetMaxHealth())
    item.dominatedCreep = double
end
