LinkLuaModifier( "arc_warden_tempest_double_modifier", "heroes/hero_arc_warden/arc_warden_tempest_double_lua.lua", LUA_MODIFIER_MOTION_NONE )

arc_warden_tempest_double_lua = class({})

function arc_warden_tempest_double_lua:OnSpellStart()
	local caster = self:GetCaster()
	local spawn_location = caster:GetOrigin()
	local health_cost = 1 - (self:GetSpecialValueFor("health_cost") / 100)
	local mana_cost = 1 - (self:GetSpecialValueFor("mana_cost") / 100)
	local duration = self:GetSpecialValueFor("duration")
	local health_after_cast = caster:GetHealth() * mana_cost
	local mana_after_cast = caster:GetMana() * health_cost

	caster:SetHealth(health_after_cast)
	caster:SetMana(mana_after_cast)

	if caster.double ~= nil and caster.double:IsAlive() then
		caster.double:ForceKill(false)
	end
	local double = CreateUnitByName( caster:GetUnitName(), spawn_location, true, caster, caster:GetOwner(), caster:GetTeamNumber())
	double:SetControllableByPlayer(caster:GetPlayerID(), false)
	caster.double = double

	local caster_level = caster:GetLevel()
	for i = 2, caster_level do
		double:HeroLevelUp(false)
	end

	for ability_id = 0, 15 do
		local ability = double:GetAbilityByIndex(ability_id)
		if ability then
			
			ability:SetLevel(caster:GetAbilityByIndex(ability_id):GetLevel())
			if ability:GetName() == "arc_warden_tempest_double_lua" then
				ability:SetActivated(false)
			end
		end
	end


	double:SetMaximumGoldBounty(0)
	double:SetMinimumGoldBounty(0)
	double:SetDeathXP(0)
	double:SetAbilityPoints(0) 

	double:SetHasInventory(false)
	double:SetCanSellItems(false)

	double:AddNewModifier(caster, self, "arc_warden_tempest_double_modifier", nil)
	double:AddNewModifier(caster, self, "modifier_kill", {["duration"] = duration})
	
	caster:EmitSound("Hero_ArcWarden.TempestDouble")

	caster:SetThink(function()
		double:SetHealth(health_after_cast)
		double:SetMana(mana_after_cast)
		double:FindItemInInventory("item_tpscroll"):Destroy()
		for item_id = 0, 5 do
			local item_in_caster = caster:GetItemInSlot(item_id)
			if item_in_caster ~= nil then
				local item_name = item_in_caster:GetName()
				if not (item_name == "item_aegis_lua" 
					 or item_name == "item_smoke_of_deceit" 
					 or item_name == "item_recipe_refresher_datadriven"
					 or item_name == "item_refresher_datadriven"
					 or item_name == "item_ward_observer"
					 or item_name == "item_ward_sentry") then
					local item_created = CreateItem( item_in_caster:GetName(), double, double)
					double:AddItem(item_created)
				end
			end
		end
	end, "tempest copy items", 0.03)
	caster:SetThink(function()
		for item_id = 0, 5 do
			local item_in_caster = double:GetItemInSlot(item_id)
			if item_in_caster ~= nil then
				local item_name = item_in_caster:GetName()
				if item_name == "item_tpscroll" or item_name == "item_travel_boots_datadriven" then
					item_in_caster:EndCooldown()
				end
			end
		end
	end, "tempest reset tp & travel cooldown", 0.06)

end

arc_warden_tempest_double_modifier = class({})

function arc_warden_tempest_double_modifier:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SUPER_ILLUSION, 
		MODIFIER_PROPERTY_ILLUSION_LABEL, 
		MODIFIER_PROPERTY_IS_ILLUSION, 
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TEMPEST_DOUBLE
	}
end

function arc_warden_tempest_double_modifier:GetIsIllusion()
	return true
end

function arc_warden_tempest_double_modifier:GetModifierSuperIllusion()
	return true
end

function arc_warden_tempest_double_modifier:GetModifierIllusionLabel()
	return true
end

function arc_warden_tempest_double_modifier:OnTakeDamage( event )
	if event.unit == self:GetParent() and event.unit:IsAlive() == false then
		event.unit:MakeIllusion()
	end
end

function arc_warden_tempest_double_modifier:GetStatusEffectName()
	return "particles/status_fx/status_effect_arc_warden_tempest.vpcf"
end

function arc_warden_tempest_double_modifier:IsHidden()
	return true
end

function arc_warden_tempest_double_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function arc_warden_tempest_double_modifier:GetModifierTempestDouble()
	return 1
end
