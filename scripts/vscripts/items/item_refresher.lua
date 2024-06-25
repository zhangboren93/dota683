function handleSpellStart(event)
	local caster = event.caster
	caster:EmitSound("DOTA_Item.Refresher.Activate")
	local particleId = ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(particleId)
	for i=0,15 do 
		local ability = caster:GetAbilityByIndex(i)
		if ability ~= nil and not ability:IsCooldownReady() then
			print("Refreshing ability " .. ability:GetName())
			ability:EndCooldown()
		end
	end
	for i=DOTA_ITEM_SLOT_1,DOTA_ITEM_SLOT_6 do
		local item = caster:GetItemInSlot(i)
		if item ~= nil and item:GetName() ~= "item_refresher_datadriven" and not item:IsCooldownReady() then
			print("Refreshing item " .. item:GetName())
			item:EndCooldown()
		end
	end
end
