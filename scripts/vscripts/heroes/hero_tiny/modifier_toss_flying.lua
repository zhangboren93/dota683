modifier_toss_flying_lua = class({})

function modifier_toss_flying_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_toss_flying_lua:IsHidden()
	return false
end

function modifier_toss_flying_lua:OnCreated()
	if IsServer() then
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end
		if not self:ApplyVerticalMotionController() then
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
		if (parent:GetAbsOrigin() - parent.toss_to_target:GetAbsOrigin()):Length2D() < 1000 then
			-- move parent to target
			local direction = parent.toss_to_target:GetAbsOrigin() - parent:GetAbsOrigin()
			direction = direction:Normalized()
			local new_position = parent.toss_to_target:GetAbsOrigin() - direction * 128
			FindClearSpaceForUnit(parent, new_position, false)
			local caster = self:GetAbility():GetCaster()
			local ability = self:GetAbility()
			local damage_radius = ability:GetSpecialValueFor("radius")
			local toss_damage = ability:GetSpecialValueFor("toss_damage")
			local units = FindUnitsInRadius(
				caster:GetTeamNumber(),
				new_position,
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
				if units[i] ~= parent then
					ApplyDamage({
						victim = units[i],
						attacker = caster,
						damage = damage_building,
						damage_type = DAMAGE_TYPE_MAGICAL
					})
				end
			end
			if parent:GetTeam() ~= caster:GetTeam() and not parent:IsMagicImmune() and not parent:TriggerSpellAbsorb(ability) then
				local bonus_damage_pct = 100 + ability:GetSpecialValueFor("bonus_damage_pct")
				local grow = caster:FindAbilityByName("tiny_grow")
				if grow ~= nil then
					bonus_damage_pct = bonus_damage_pct + grow:GetLevel() * 15
				end
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
		end
	end
end

function modifier_toss_flying_lua:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local dist = (me.toss_to_target:GetAbsOrigin() - me:GetAbsOrigin()):Length()
		if dist < 80 or dist > 3000 or self:GetRemainingTime() < 0.1 then
			return true
		end
		local speed = (me.toss_to_target:GetAbsOrigin() - me:GetAbsOrigin()):Length2D() / self:GetRemainingTime()
		if speed > 2308 then
			speed = 2308
		end
		me:SetAbsOrigin(me:GetAbsOrigin() + (me.toss_to_target:GetAbsOrigin() - me:GetAbsOrigin()):Normalized() * speed * dt)
	end
end

function modifier_toss_flying_lua:UpdateVerticalMotion(me, dt)
	if IsServer() then
		local height = self:GetRemainingTime() / 0.6
		if height > 2 then return 0 end
		if height > 1 then
			height = 2 - height
		end
		height = (2 - height) * height * 1000
		local groundLocation = GetGroundPosition(me:GetAbsOrigin(), me)
		me:SetAbsOrigin(Vector(groundLocation.x, groundLocation.y, groundLocation.z + height))
	end
end

function modifier_toss_flying_lua:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end
