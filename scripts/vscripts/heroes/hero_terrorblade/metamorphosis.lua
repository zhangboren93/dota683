--[[Author: Pizzalol/Noya
	Date: 10.01.2015.
	Swaps the ranged attack, projectile and caster model
]]
function ModelSwapStart( keys )
	local caster = keys.target
	local model = keys.model
	local projectile_model = keys.projectile_model

	-- Saves the original model and attack capability
	if caster.caster_model == nil then 
		caster.caster_model = caster:GetModelName()
	end
	caster.caster_attack = caster:GetAttackCapability()

	-- Sets the new model and projectile
	caster:SetOriginalModel(model)
	caster:SetRangedProjectileName(projectile_model)

	-- Sets the new attack type
	caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)

	ProjectileManager:ProjectileDodge(caster)
end

--[[Author: Pizzalol/Noya
	Date: 10.01.2015.
	Reverts back to the original model and attack type
]]
function ModelSwapEnd( keys )
	local caster = keys.caster

	caster:SetModel(caster.caster_model)
	caster:SetOriginalModel(caster.caster_model)
	caster:SetAttackCapability(caster.caster_attack)
end


--[[Author: Noya
	Date: 09.08.2015.
	Hides all dem hats
]]
function HideWearables( event )
	local hero = event.caster
	local ability = event.ability

	hero.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" then
            model:AddEffects(EF_NODRAW) -- Set model hidden
            table.insert(hero.hiddenWearables, model)
        end
        model = model:NextMovePeer()
    end
end

function ShowWearables( event )
	local hero = event.caster

	for i,v in pairs(hero.hiddenWearables) do
		v:RemoveEffects(EF_NODRAW)
	end
end

function handleIntervalThink( event )
	-- any illusions which has create time after metamorph, adds metamorph
	local caster = event.target
	if not IsServer() then return end
	if caster:IsIllusion() then return end
	local terrorblades = Entities:FindAllByName("npc_dota_hero_terrorblade")
	local modifier = caster:FindModifierByName("modifier_metamorphosis_datadriven")
	local ability = event.ability
	for i=1,#terrorblades do 
		if terrorblades[i]:IsIllusion() then
			if terrorblades[i]:GetCreationTime() > modifier:GetCreationTime() 
				and not terrorblades[i]:HasModifier("modifier_metamorphosis_datadriven") then
				ability:ApplyDataDrivenModifier(caster, terrorblades[i], "modifier_metamorphosis_datadriven", {})
			end
		end
	end
	-- has a bug where manta will remove demon model
	if caster:GetModelName() ~= "models/heroes/terrorblade/demon.vmdl" then
		caster:SetOriginalModel("models/heroes/terrorblade/demon.vmdl")
		caster:ManageModelChanges()
		caster:SetRangedProjectileName("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf")
		caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	end
end
