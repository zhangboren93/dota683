function dominateCreep(event)
	local item = event.ability
	local caster = event.caster
	local target = event.target
	if item.dominatedCreep ~= nil and IsValidEntity(item.dominatedCreep) then
		item.dominatedCreep:ForceKill(false)
	end
	local name = target:GetUnitName()
	local spawn_location = target:GetAbsOrigin()
	target:ForceKill(false)

	local double = CreateUnitByName( name, spawn_location, true, caster, caster, caster:GetTeamNumber())
	double:SetControllableByPlayer(caster:GetPlayerID(), true)
	double:SetMaxHealth(double:GetMaxHealth() + 500)
	double:SetBaseMaxHealth(double:GetBaseMaxHealth() + 500)
	double:Heal(500, caster)
	item.dominatedCreep = double
end
