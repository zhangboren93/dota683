function handleAbilityExecuted(event)
	if event.event_ability:GetName() == "mirana_arrow" then
		event.caster.arrow_start_loc = event.caster:GetAbsOrigin()
	end
	-- mirana's jump dodges projectile
	if event.event_ability:GetName() == "mirana_leap" then
		local ability = event.event_ability
		ProjectileManager:ProjectileDodge(event.caster)
		local caster = event.caster
		local units = FindUnitsInRadius(
			caster:GetTeam(),
			caster:GetAbsOrigin(),
			nil,
			775, 
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)
		if #units > 0 then
			for i = 1,#units do
				units[i]:AddNewModifier(caster, ability, "modifier_mirana_leap_buff", {duration = ability:GetSpecialValueFor("leap_bonus_duration")})
			end
		end
	end
	-- startfall will hit randomly unit within 175 radius
	if event.event_ability:GetName() == "mirana_starfall" then
		local caster = event.caster
		local units = FindUnitsInRadius(
			caster:GetTeam(),
			caster:GetAbsOrigin(),
			nil,
			175, 
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)
		if #units > 0 then
			local unit = units[RandomInt(1, #units)]
			caster:SetThink(function()
				event.ability:ApplyDataDrivenModifier(caster, unit, "modifier_mirana_secondary_datadriven", {})
			end, "secondary star fall", 0.8)
		end
	end
end

function handleSecondaryDestroyed(event)
	if not IsServer() then return end
	local caster = event.caster
	local target = event.target
	local starfall = caster:FindAbilityByName("mirana_starfall")
	local damage = starfall:GetSpecialValueFor("damage") * 75 / 100
	ApplyDamage({
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = starfall})
	target:EmitSound("Hero_Mirana.Starstorm.Impact")
end
