chen_holy_persuasion_lua = class({})

function chen_holy_persuasion_lua:CastFilterResultTarget(target)
	if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return UF_FAIL_FRIENDLY
	end
	if target:IsBuilding() then
		return UF_FAIL_BUILDING
	elseif target:IsHero() then
		return UF_FAIL_HERO
	elseif target:HasModifier("roshan_inherent_buffs_checker_datadriven") then
		return UF_FAIL_CUSTOM
	elseif target:IsCourier() then
		return UF_FAIL_COURIER
	end
	if self:GetCaster():HasScepter() then
		return UF_SUCCESS
	end
	if target:IsAncient() then
		return UF_FAIL_ANCIENT
	end
	return UF_SUCCESS
end

function chen_holy_persuasion_lua:GetCustomCastErrorTarget(target)
	if target:HasModifier("roshan_inherent_buffs_checker_datadriven") then
		return "#dota_hud_error_cant_cast_on_roshan"
	end
	return ""
end

function chen_holy_persuasion_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local max_units = self:GetSpecialValueFor("max_units")
	local health_bonus = self:GetSpecialValueFor("health_bonus")

	local player_controlled_units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(),
		nil, 20000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)
	local chen_persuaded_units = {}
	for i=1,#player_controlled_units do
		print("player_controlled_units " .. player_controlled_units[i]:GetName())
		local modifier_dominated = player_controlled_units[i]:FindModifierByName("modifier_dominated")
		if modifier_dominated ~= nil and modifier_dominated:GetAbility() == self then
			table.insert(chen_persuaded_units, player_controlled_units[i])
		end
	end
	for i=1,#chen_persuaded_units do
		print("chen_persuaded_units " .. chen_persuaded_units[i]:GetName())
	end

	target:AddNewModifier(caster, self, "modifier_dominated", {})
	target:SetTeam(caster:GetTeam())
	target:SetOwner(caster)
	target:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
	target:GiveMana(target:GetMaxMana())
	target:SetBaseMaxHealth(target:GetMaxHealth() + health_bonus)
	target:Heal(health_bonus, self)
	local ancient_unit_killed = false
	if caster:HasScepter() and target:IsAncient() then
		local max_ancient_units = caster:FindAbilityByName("chen_hand_of_god"):GetLevel()
		if max_ancient_units > 0 then
			local chen_persuaded_ancient_units = {}
			for i=1,#chen_persuaded_units do
				if chen_persuaded_units[i]:IsAncient() then
					table.insert(chen_persuaded_ancient_units, chen_persuaded_units[i])
				end
			end
			if #chen_persuaded_ancient_units >= max_ancient_units then
				killOldestUnit(chen_persuaded_ancient_units)
				ancient_unit_killed = true
			end
		end
	end
	if not ancient_unit_killed then
		if #chen_persuaded_units >= max_units then
			killOldestUnit(chen_persuaded_units)
		end
	end

	caster:EmitSound("Hero_Chen.HolyPersuasionCast")
	target:EmitSound("Hero_Chen.HolyPersuasionEnemy")
	local particle = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf",
		PATTACH_ABSORIGIN_FOLLOW, 
		target)
	ParticleManager:ReleaseParticleIndex(particle)
end

function killOldestUnit(chen_persuaded_units)
	local oldest_unit = chen_persuaded_units[1]
	for i=2,#chen_persuaded_units do
		if chen_persuaded_units[i]:FindModifierByName("modifier_dominated"):GetCreationTime() 
			< oldest_unit:FindModifierByName("modifier_dominated"):GetCreationTime() then
			oldest_unit = chen_persuaded_units[i]
		end
	end
	print("oldest_unit " .. oldest_unit:GetName())
	oldest_unit:ForceKill(true)
end
