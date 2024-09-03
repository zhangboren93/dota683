modifier_ember_spirit_fire_remnant_activate_lua = class({
	OnCreated = function(self, data) 
		if not IsServer() then return end
		self.destination_entity = EntIndexToHScript(data.destination)
		self.destination = self.destination_entity:GetAbsOrigin()
		local ability = self:GetAbility()
		self.speed = ability:GetSpecialValueFor("speed")
		self.radius = ability:GetSpecialValueFor("radius")
		self.damage = ability:GetSpecialValueFor("damage")
		self.time_upper_bound = GameRules:GetGameTime() + 0.4
		self.target_point = Vector(data.target_x, data.target_y, 0)
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end
	end,
	UpdateHorizontalMotion = function(self, me, dt)
		if not IsServer() then return end
		local dest_loc = self.destination
		if self.destination_entity:IsAlive() then
			dest_loc = self.destination_entity:GetAbsOrigin()
		end
		local me_loc = me:GetAbsOrigin()
		if (me_loc - dest_loc):Length2D() > 50 and GameRules:GetGameTime() < self.time_upper_bound then
			me:SetAbsOrigin(me_loc + (dest_loc - me_loc):Normalized() * self.speed * dt)
		else 
			-- Destroy Remnant
			me:RemoveModifierByName( "modifier_fire_remnant_counter_cooldown_lua" )
			
			-- Do damage in area
			local units = FindUnitsInRadius( me:GetTeam(), dest_loc, me, self.radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )
			for k, v in pairs( units ) do
				local damageTable =
				{
					victim = v,
					attacker = me,
					damage = self.damage,
					damage_type = DAMAGE_TYPE_MAGICAL
				}
				ApplyDamage( damageTable )
			end
			local particle_id = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf", PATTACH_ABSORIGIN, me)
			if self.destination_entity.fire_remnant_particle ~= nil then
				ParticleManager:DestroyParticle(self.destination_entity.fire_remnant_particle, false)
				self.destination_entity.fire_remnant_particle = nil
			end
			self.destination_entity:ForceKill(false)
			self.destination_entity = nil
			self.destination = nil
			-- Find the most far remnant from the target point
			local furthestRemnantIndex = -1
			local furthest_distance = 0
			for k, v in pairs(me.fire_remnant_entities) do
				if IsValidEntity(EntIndexToHScript(k)) then
					if furthestRemnantIndex == -1 then
						furthestRemnantIndex = k
						furthest_distance = (EntIndexToHScript(k):GetAbsOrigin() - self.target_point):Length2D()
					else
						local my_distance = (EntIndexToHScript(k):GetAbsOrigin() - self.target_point):Length2D()
						if my_distance > furthest_distance then
							furthestRemnantIndex = k
							furthest_distance = my_distance
						end
					end
				end
			end
			if furthestRemnantIndex == -1 then
				-- put the unit at destination
				FindClearSpaceForUnit(me, dest_loc, true)
				me:RemoveModifierByName("modifier_activate_fire_remnant_buff_lua")
				GridNav:DestroyTreesAroundPoint(me:GetAbsOrigin(), 200, false)
				me:EmitSound("Hero_EmberSpirit.FireRemnant.Stop")
		    	me:RemoveHorizontalMotionController(self)
				self:Destroy()
				return true
			else
				-- move to another remnant
				if GameRules:GetGameTime() >= self.time_upper_bound then
					me:SetAbsOrigin(dest_loc)
				end
				me.fire_remnant_entities[furthestRemnantIndex] = nil
				self.destination_entity = EntIndexToHScript(furthestRemnantIndex)
				self.destination = self.destination_entity:GetAbsOrigin()
				self.time_upper_bound = GameRules:GetGameTime() + 0.4
				print("Move to another remnent located at (" .. self.destination.x .. ", " .. self.destination.y .. ")") 
				me:EmitSound("Hero_EmberSpirit.FireRemnant.Explode")
			end
		end
	end
})
