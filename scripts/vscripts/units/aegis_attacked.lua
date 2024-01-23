function handleAttack(event)
	local target = event.target
	local attacker = event.attacker
	if target:GetClassname() == "dota_item_drop" and target:GetModelName() == "models/props_gameplay/aegis.vmdl" then
		CustomGameEventManager:Send_ServerToAllClients("aegis_destroyed", {kpid = attacker:GetPlayerOwnerID()})
	end
end