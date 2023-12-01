modifier_toss_flying_lua = class({})

function modifier_toss_flying_lua:IsHidden()
	return false
end

function modifier_toss_flying_lua:OnCreated()
	if IsServer() then
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end
	end
end

function modifier_toss_flying_lua:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		parent:RemoveHorizontalMotionController(self)
		parent:RemoveVerticalMotionController(self)
		if (parent:GetAbsOrigin() - parent.toss_to_target:GetAbsOrigin()):Length() < 120 then
			local caster = self:GetAbility():GetCaster()
			local ability = self:GetAbility()
			local damage_radius = ability:GetSpecialValueFor("radius")
			local toss_damage = ability:GetSpecialValueFor("toss_damage")
			local units = FindUnitsInRadius(
				caster:GetTeamNumber(),
				parent:GetAbsOrigin(),
				nil,
				damage_radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING,
				0, FIND_ANY_ORDER, false) 
			for i=1,#units do
				local damage_building = toss_damage
				if units[i]:IsBuilding() then
					damage_building = toss_damage / 3
				end
				ApplyDamage({
					victim = units[i],
					attacker = caster,
					damage = damage_building,
					damage_type = DAMAGE_TYPE_MAGICAL
				})
			end
			if parent:GetTeam() ~= caster:GetTeam() and not parent:IsMagicImmune() then
				local bonus_damage_pct = ability:GetSpecialValueFor("bonus_damage_pct")
				local grow = caster:FindAbilityByName("tiny_grow")
				bonus_damage_pct = bonus_damage_pct + grow:GetLevel() * 15
				if caster:HasScepter() then
					bonus_damage_pct = bonus_damage_pct + 15
				end
				ApplyDamage({
					victim = parent,
					attacker = caster,
					damage = toss_damage * bonus_damage_pct / 100,
					damage_type = DAMAGE_TYPE_MAGICAL
				})
			end
			ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_toss_impact.vpcf", PATTACH_ABSORIGIN, parent))
			parent:EmitSound("Hero_Tiny.CraggyExterior")
			FindClearSpaceForUnit(parent, parent:GetAbsOrigin(), true)
			parent:AddNewModifier(caster, ability, "modifier_reset_visual_z", { duration = 0.1 })
		end
	end
end

function modifier_toss_flying_lua:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local dist = (me.toss_to_target:GetAbsOrigin() - me:GetAbsOrigin()):Length()
		if dist < 80 then
			return true
		end
		me:SetAbsOrigin(me:GetAbsOrigin() + (me.toss_to_target:GetAbsOrigin() - me:GetAbsOrigin()) * dt / self:GetRemainingTime() )
	end
end

function modifier_toss_flying_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}
	return funcs
end
 

function modifier_toss_flying_lua:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_toss_flying_lua:GetVisualZDelta()
	local height = self:GetRemainingTime() / 0.6
	if height > 2 then return 0 end
	if height > 1 then
		height = 2 - height
	end
	return (2 - height) * height * 1000
end
