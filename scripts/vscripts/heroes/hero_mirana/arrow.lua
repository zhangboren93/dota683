if modifier_mirana_leap_lua == nil then
	modifier_mirana_leap_lua = class({ 
		IsBuff				= function(self) return true end,
		IsPurgable			= function(self) return false end,
		DeclareFunctions    = function(self) return 
			{
				MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
				MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
			}
		end,
	})
end

function modifier_mirana_leap_lua:OnCreated()
	self.ability = self:GetCaster():FindAbilityByName("mirana_leap")

	self.move_speed_pct = self.ability:GetSpecialValueFor("leap_speedbonus")
	self.attack_speed = self.ability:GetSpecialValueFor("leap_speedbonus_as")
end

function modifier_mirana_leap_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed_pct
end

function modifier_mirana_leap_lua:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

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
				units[i]:AddNewModifier(caster, ability, "modifier_mirana_leap_lua", {duration = ability:GetSpecialValueFor("leap_bonus_duration")})
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
