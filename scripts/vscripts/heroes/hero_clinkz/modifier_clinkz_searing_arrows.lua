modifier_clinkz_searing_arrow_lua = class({})

function modifier_clinkz_searing_arrow_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_clinkz_searing_arrow_lua:OnAttack(event)
	if event.attacker == self:GetParent() then
		local attacker = event.attacker
		local ability = self:GetAbility()
		local mana_cost = ability:GetManaCost(-1)
		local projectile_speed = attacker:GetProjectileSpeed()
		local target = event.target
		if (self.cast_on_building or (target:IsBuilding() and self:GetAbility():GetAutoCastState()))
			and attacker:GetMana() >= mana_cost then
			attacker:SpendMana(mana_cost, ability)
			ProjectileManager:CreateTrackingProjectile({
				Target = target,
				Source = attacker,
				Ability = ability,
				bDodgeable = true,
				iMoveSpeed = projectile_speed,
				EffectName = "particles/units/heroes/hero_clinkz/clinkz_searing_arrow.vpcf"
			})
			ability:ApplyDataDrivenModifier(attacker, target, "modifier_building_immune_to_deso", {
				duration = (attacker:GetAbsOrigin() - target:GetAbsOrigin()):Length() / projectile_speed + 0.1
			})
			attacker:EmitSound("Hero_Clinkz.SearingArrows")
		end
	end
end

function modifier_clinkz_searing_arrow_lua:OnOrder(event)
	if event.order_type == DOTA_UNIT_ORDER_CAST_TARGET and event.ability == self:GetAbility()
		and event.target:IsBuilding() then
		self.cast_on_building = true
	else
		self.cast_on_building = false
	end
end

function modifier_clinkz_searing_arrow_lua:IsHidden()
	return true
end
