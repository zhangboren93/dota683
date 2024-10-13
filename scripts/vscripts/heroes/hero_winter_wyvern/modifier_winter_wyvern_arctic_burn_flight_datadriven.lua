modifier_winter_wyvern_arctic_burn_flight_datadriven = class({
	GetEffectName = function() return "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_buff.vpcf" end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	} end,
	GetModifierAttackRangeBonus = function(self) return self:GetAbility():GetSpecialValueFor("attack_range_bonus") end,
	GetBonusNightVision = function() return 400 end,
	GetModifierProjectileSpeedBonus = function() return 500 end,
	GetModifierAttackPointConstant = function() return 0.1 end,
	CheckState = function() return { [ MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY ] = true } end,
	OnAttackStart = function(self, event)
		local attacker = event.attacker
		local parent = self:GetParent()
		if attacker == parent then
			parent:EmitSound("Hero_Winter_Wyvern.ArcticBurn.attack")
		end
	end,
	OnAttackLanded = function(self, event)
		local attacker = event.attacker
		local parent = self:GetParent()
		if attacker ~= parent then return end
		local target = event.target
		local ability = self:GetAbility()
		if target:IsBuilding() or target:GetModelName() == "models/creeps/roshan/roshan.vmdl" then
			return
		end
		ability:ApplyDataDrivenModifier(attacker, target, 
			"modifier_winter_wyvern_arctic_burn_pure_datadriven", 
			{ duration = ability:GetSpecialValueFor("damage_duration") })
		target:EmitSound("Hero_Winter_Wyvern.ArcticBurn.projectileImpact")
	end,
	OnDestroy = function(self)
		local caster = self:GetParent()
		local ability = self:GetAbility()
		if IsServer() then
			GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), 
				ability:GetSpecialValueFor("tree_destruction_radius"),
				false)
		end
	end

})
