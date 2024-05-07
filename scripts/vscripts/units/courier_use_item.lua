function handleUseClarityStart(event)
	local caster = event.caster
	local target = event.target
	local item = caster:FindItemInInventory("item_clarity")
	if item ~= nil then
		caster:CastAbilityOnTarget(target, item, caster:GetPlayerOwnerID())
	end
end
