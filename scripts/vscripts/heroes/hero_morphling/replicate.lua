function replicate(event)
    local target = event.target
    local ability = event.ability
    local caster = event.caster

	local illusion = CreateUnitByName(target:GetUnitName(), target:GetAbsOrigin(), true, caster, nil, caster:GetTeamNumber())
	illusion:SetPlayerID(caster:GetPlayerID())
	illusion:SetControllableByPlayer(caster:GetPlayerID(), true)

	local target_level = target:GetLevel()
	for i = 1, target_level - 1 do
		illusion:HeroLevelUp(false)
	end

	illusion:SetAbilityPoints(0) 
	for ability_slot = 0, 15 do
		local target_ability = target:GetAbilityByIndex(ability_slot) 
		if target_ability then
			local target_ability_level = target_ability:GetLevel() 
			local target_ability_name = target_ability:GetAbilityName() 
			local illusion_ability = illusion:FindAbilityByName(target_ability_name) 
			illusion_ability:SetLevel(target_ability_level) 
		end
	end

	for item_slot = 0, 5 do
		local item = target:GetItemInSlot(item_slot) 
		if item then
			local item_name = item:GetName() 
			local new_item = CreateItem(item_name, illusion, illusion) 
			illusion:AddItem(new_item) 
		end
	end

	illusion:AddNewModifier(caster, ability, "modifier_illusion", {
        duration = ability:GetSpecialValueFor("duration"),
        outgoing_damage = ability:GetSpecialValueFor("illusion_damage_out_pct"),
        incoming_damage = ability:GetSpecialValueFor("illusion_damage_in_pct")})

	illusion:MakeIllusion() 
	illusion:SetHealth(target:GetHealth()) -- Set the health of the illusion to be the same as the target HP
    caster.replica = illusion

	caster:FindAbilityByName("morphling_morph_replicate_datadriven"):SetLevel(1)
end

function morph_replicate(event)
	local caster = event.caster
	local replica = caster.replica
	if replica ~= nill and replica:IsAlive() then
		caster:SetAbsOrigin(replica:GetAbsOrigin())
		replica:ForceKill(false)
		caster.replica = nil
	else
		caster:GiveMana(150)
	end
end