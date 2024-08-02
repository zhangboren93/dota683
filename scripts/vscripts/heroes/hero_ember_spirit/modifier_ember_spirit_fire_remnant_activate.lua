modifier_ember_spirit_fire_remnant_activate_lua = class({
	OnCreated = function(self, data) 
		if not IsServer() then return end
		self.destination = EntIndexToHScript(data.destination)
		local ability = self:GetAbility()
		self.speed = ability:GetSpecialValueFor("speed")
		self.radius = ability:GetSpecialValueFor("radius")
		self.damage = ability:GetSpecialValueFor("damage")
		self.target_point = Vector(data.target_x, data.target_y, 0)
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end
	end,
	UpdateHorizontalMotion = function(self, me, dt)
		if not IsServer() then return end
		local dest_loc = self.destination:GetAbsOrigin()
		local me_loc = me:GetAbsOrigin()
		if (me_loc - dest_loc):Length2D() > 50 then
			me:SetAbsOrigin(me_loc + (dest_loc - me_loc):Normalized() * self.speed * dt)
		else 
			-- Destroy Remnant
			me:RemoveModifierByName( "modifier_fire_remnant_counter_cooldown_datadriven" )
			
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
			self.destination:ForceKill(false)
			self.destination = nil
			-- Find the most far remnant from the target point
			local furthestRemnantIndex = -1
			local furthest_distance = 0
			for k, v in pairs(me.fire_remnant_entities) do
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
			if furthestRemnantIndex == -1 then
				-- put the unit at destination
				FindClearSpaceForUnit(me, dest_loc, true)
				me:RemoveModifierByName("modifier_activate_fire_remnant_buff_datadriven")
				GridNav:DestroyTreesAroundPoint(me:GetAbsOrigin(), 200, false)
				me:EmitSound("Hero_EmberSpirit.FireRemnant.Stop")
		    	me:RemoveHorizontalMotionController(self)
				self:Destroy()
				return true
			else
				-- move to another remnant
				me.fire_remnant_entities[furthestRemnantIndex] = nil
				self.destination = EntIndexToHScript(furthestRemnantIndex)
				print("Move to another remnent located at (" .. self.destination:GetAbsOrigin().x .. ", " .. self.destination:GetAbsOrigin().y .. ")") 
				me:EmitSound("Hero_EmberSpirit.FireRemnant.Explode")
			end
		end
	end
})
