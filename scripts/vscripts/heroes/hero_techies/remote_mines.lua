--[[Author: Pizzalol
	Date: 25.03.2015.
	Upgrades the focused detonate ability]]
function RemoteMinesUpgrade( keys )
	local caster = keys.caster
	local ability_name = keys.ability_name

	caster:FindAbilityByName(ability_name):SetLevel(1)
end

--[[Author: Pizzalol
	Date: 25.03.2015.
	Creates the remote mine and initializes its functions]]
function RemoteMinesPlant( keys )
	local caster = keys.caster
	local player = caster:GetPlayerID()
	local target_point = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Modifiers
	local modifier_remote_mine = keys.modifier_remote_mine
	local modifier_remote_mine_invisibility = keys.modifier_remote_mine_invisibility

	-- Ability variables
	local activation_time = ability:GetLevelSpecialValueFor("activation_time", ability_level)
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local model_scale = ability:GetLevelSpecialValueFor("model_scale", ability_level) / 100

	-- Create the land mine and initialize it
	local remote_mine = CreateUnitByName("npc_dota_techies_remote_mine_datadriven", target_point, false, nil, nil, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, remote_mine, modifier_remote_mine, {})
	remote_mine:AddNewModifier(caster, ability, "modifier_kill", {Duration = duration})
	remote_mine:SetModelScale(1 + model_scale)
	remote_mine:SetControllableByPlayer(player, true)

	-- Level it up
	remote_mine:FindAbilityByName("techies_remote_mines_self_detonate_datadriven"):SetLevel(1)

	-- Apply the invisibility after the activation time
	caster:SetThink(function()
		remote_mine:AddNewModifier(caster, ability, "modifier_invisible", {})
	end, "Add invis to remote boom", activation_time)
end

--[[Author: Pizzalol
	Date: 25.03.2015.
	Detonates the selected mine]]
function RemoteMinesSelfDetonate( keys )
	local caster = keys.caster

	caster:Kill(keys.ability, caster)
end

--[[Author: Pizzalol
	Date: 25.03.2015.
	Detonates all the mines in the radius]]
function RemoteMinesFocusedDetonate( keys )
	local caster = keys.caster
	local target_point = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)

	local target_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	local target_types = DOTA_UNIT_TARGET_ALL
	local target_flags = DOTA_UNIT_TARGET_FLAG_NONE

	local units = FindUnitsInRadius(caster:GetTeamNumber(), target_point, nil, radius, target_team, target_types, target_flags, FIND_CLOSEST, false)

	for _,unit in ipairs(units) do
		if unit:HasAbility("techies_remote_mines_self_detonate_datadriven") then
			unit:Kill(ability, caster) 
		end
	end
end

function RemoteMinesDeath( keys )
	print("RemoteMinesDeath")
	local target = keys.unit
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetSpecialValueFor("damage")
	target:SetThink(function()
		target:EmitSound("Hero_Techies.RemoteMine.Detonate")
		local units = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for i=1,#units do
			ApplyDamage({
				victim = units[i],
				attacker = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = ability
			})
		end
		local particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf", PATTACH_ABSORIGIN, target)
		ParticleManager:ReleaseParticleIndex(particleId)
	end, "Detonate Sound", 0.03)
end
