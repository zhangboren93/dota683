modifier_shredder_chakram_return_lua = class({
	OnCreated = function(self, data)
		if not IsServer() then return end
		self.damage_check_count = 0
		self.damaged_units = {}
		self:StartIntervalThink(0.1)
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end
	end,
	UpdateHorizontalMotion = function(self, me, dt) 
		if not IsServer() then return end
		local caster = self:GetCaster()
		local destination = caster:GetAbsOrigin()
		local ability = self:GetAbility()
		if (me:GetAbsOrigin() - destination):Length2D() < 50 then
			if ability:GetName() == "shredder_return_chakram_2_datadriven" then
				caster:SwapAbilities("shredder_chakram_2_datadriven", "shredder_return_chakram_2_datadriven", true, false)
			else
				caster:SwapAbilities("shredder_chakram_datadriven", "shredder_return_chakram_datadriven", true, false)
			end
			if me.particle_id ~= nil then
				ParticleManager:DestroyParticle(me.particle_id, false)
				me.particle_id = nil
			end
			me:StopSound("Hero_Shredder.Chakram")
			caster:RemoveModifierByName("modifier_shredder_chakram_disarm_datadriven")
			me:RemoveModifierByName("modifier_shredder_chakram_lua")
			me:ForceKill(false)
		else
			velocity = destination - me:GetAbsOrigin()
			velocity = Vector(velocity.x, velocity.y, 0):Normalized() * 900 * dt
			local new_destination = me:GetAbsOrigin() + velocity
			me:SetAbsOrigin(GetGroundPosition(new_destination, nil))
		end
	end,
	OnIntervalThink = function(self)
		if not IsServer() then return end
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local destination = caster:GetAbsOrigin()
		local chakram_ability = caster:FindAbilityByName("shredder_chakram_datadriven")
		local units = FindUnitsInRadius(caster:GetTeam(),
			parent:GetAbsOrigin(),
			nil,
			200,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)
		for i=1,#units do
			if self.damaged_units[units[i]:GetEntityIndex()] == nil then
				handleProjectileHitUnit({
					target = units[i],
					ability = chakram_ability,
					caster = caster
				})
				self.damaged_units[units[i]:GetEntityIndex()] = true
			end
		end
	end
})
