function handleAttack(event)
	local target = event.target
	local attacker = event.attacker
	if target:GetClassname() == "dota_item_rune" then
		local rune = DOTA_RUNE_INVALID
		if target:GetModelName() == "models/props_gameplay/rune_doubledamage01.vmdl" then
			rune = DOTA_RUNE_DOUBLEDAMAGE
		elseif target:GetModelName() == "models/props_gameplay/rune_haste01.vmdl" then
			rune = DOTA_RUNE_HASTE
		elseif target:GetModelName() == "models/props_gameplay/rune_illusion01.vmdl" then
			rune = DOTA_RUNE_ILLUSION
		elseif target:GetModelName() == "models/props_gameplay/rune_invisibility01.vmdl" then
			rune = DOTA_RUNE_INVISIBILITY
		elseif target:GetModelName() == "models/props_gameplay/rune_regeneration01.vmdl" then
			rune = DOTA_RUNE_REGENERATION
		elseif target:GetModelName() == "models/props_gameplay/rune_goldxp.vmdl" then
			rune = DOTA_RUNE_BOUNTY
		end
		CustomGameEventManager:Send_ServerToTeam(attacker:GetTeam(), "player_rune_denied", {
			pid = attacker:GetPlayerOwnerID(), rune_type = rune })
	end
end