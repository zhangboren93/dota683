phoenix_launch_fire_spirit_lua = class({
	IsStealable = function() return false end,
	OnSpellStart = function(self)
		local caster = self:GetCaster()
		caster:EmitSound("Hero_Phoenix.FireSpirits.Launch")
		local ability		= self
		local modifierName	= "modifier_phoenix_fire_spirit_stack_lua"

		-- Update spirits count
		local mainAbility	= caster:FindAbilityByName( "phoenix_fire_spirits_lua" )
		local currentStack	= caster:GetModifierStackCount( modifierName, mainAbility )
		currentStack = currentStack - 1
		caster:SetModifierStackCount( modifierName, mainAbility, currentStack )

		-- Update the particle FX
		local pfx = caster.fire_spirits_pfx
		ParticleManager:SetParticleControl( pfx, 1, Vector( currentStack, 0, 0 ) )
		ParticleManager:SetParticleControl( pfx, 6, Vector( currentStack, 0, 0 ) )
		for i=1, caster.fire_spirits_numSpirits do
			local radius = 0
			if i <= currentStack then
				radius = 1
			end

			ParticleManager:SetParticleControl( pfx, 8+i, Vector( radius, 0, 0 ) )
		end

		-- Remove the stack modifier if all the spirits has been launched.
		if currentStack == 0 then
			caster:RemoveModifierByName( modifierName )
		end

		local cursor_position = self:GetCursorPosition()
		local spirit_speed = self:GetSpecialValueFor("spirit_speed")
		local distance = (cursor_position - caster:GetAbsOrigin()):Length2D()
		spirit_speed = (cursor_position - caster:GetAbsOrigin()):Normalized() * spirit_speed
		spirit_speed = Vector(spirit_speed.x, spirit_speed.y, 0)
		ProjectileManager:CreateLinearProjectile({
			vSpawnOrigin = caster:GetAbsOrigin(),
			vVelocity = spirit_speed,
			fDistance = distance,
			bVisibleToEnemies = true,
			EffectName = "particles/units/heroes/hero_phoenix/phoenix_fire_spirit_launch.vpcf",
			Ability = self,
			Source = caster
		})
	end,
	OnProjectileHit = function(self, target, location)
		local caster = self:GetCaster()
		local radius = self:GetSpecialValueFor("radius")
    	local pid = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf",
			PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(pid, 0, location)
		ParticleManager:SetParticleControl(pid, 1, Vector(radius, 0, 0))
		local units = FindUnitsInRadius(
			caster:GetTeam(),
			location, nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0, 0, false)
		local duration = self:GetSpecialValueFor("duration")
		for i=1,#units do
			if units[i]:GetUnitName() == "npc_dota_roshan_datadriven" or
				units[i]:IsAncient() then
			else
				units[i]:AddNewModifier(caster, self, "modifier_phoenix_fire_spirit_damage_lua", { duration = duration })
			end
		end
		return true
	end,
	OnUpgrade = function(self)
		local caster = self:GetCaster()
		local ability_handle = caster:FindAbilityByName("phoenix_fire_spirits_lua")	
		local ability_level = ability_handle:GetLevel()
		if ability_level ~= self:GetLevel() then
			ability_handle:SetLevel(self:GetLevel())
		end
	end
})
