function handleSpellStart(event)
	local target_point = event.target_points[1]
	local original_ability = event.ability
	local caster = event.caster
	local is_scepter_chakram = false
	local ability = event.ability
	local speed = ability:GetSpecialValueFor("speed")
	local radius = ability:GetSpecialValueFor("radius")
	if ability:GetName() == "shredder_chakram_2_datadriven" then
		print(caster:GetName())
		if caster:GetName() == "npc_dota_hero_shredder" then
			ability = caster:FindAbilityByName("shredder_chakram_datadriven")
			speed = ability:GetSpecialValueFor("speed")
			radius = ability:GetSpecialValueFor("radius")
		elseif caster:GetName() == "npc_dota_hero_rubick" then
			local shredder = Entities:FindAllByName("npc_dota_hero_shredder")
			if #shredder > 0 then
				shredder = shredder[1]
			end
			local origin_ability = shredder:FindAbilityByName("shredder_chakram_datadriven")
			speed = origin_ability:GetSpecialValueFor("speed")
			radius = origin_ability:GetSpecialValueFor("radius")
		end
		is_scepter_chakram = true
	end
	
	local velocity = target_point - caster:GetAbsOrigin()
	velocity = Vector(velocity.x, velocity.y, 0):Normalized() * speed
	local duration = (target_point - caster:GetAbsOrigin()):Length2D() / speed
	CreateUnitByNameAsync("npc_dummy_unit", 
		caster:GetAbsOrigin(),
		false,
		caster,
		caster, 
		caster:GetTeam(),
		function(unit)
			if is_scepter_chakram then
				caster.chakram_2_dummy_unit = unit
			else
				caster.chakram_dummy_unit = unit
			end
			unit:AddNewModifier(caster, ability, "modifier_shredder_chakram_lua", { })
			unit:AddNewModifier(caster, ability, "modifier_shredder_chakram_move_lua", { vx = velocity.x, vy = velocity.y, duration = duration })
			unit.particle_id = ParticleManager:CreateParticle(
				"particles/units/heroes/hero_shredder/shredder_chakram_spin.vpcf",
				PATTACH_ABSORIGIN_FOLLOW,
				unit)
			ParticleManager:SetParticleControl(unit.particle_id, 1, Vector(radius, 0, 0))
			ParticleManager:SetParticleControlEnt(unit.particle_id, 3, unit, PATTACH_ABSORIGIN_FOLLOW, "default", Vector(0, 0, 0), false)
			if is_scepter_chakram then
				ParticleManager:SetParticleControl(unit.particle_id, 15, Vector(0, 0, 255))
				ParticleManager:SetParticleControl(unit.particle_id, 16, Vector(1, 0, 0))
			end
			unit:EmitSound("Hero_Shredder.Chakram")
		end)
	local return_ability = nil
	if is_scepter_chakram then
		return_ability = caster:FindAbilityByName("shredder_return_chakram_2_datadriven")
	else
		return_ability = caster:FindAbilityByName("shredder_return_chakram_datadriven")
	end
	if return_ability ~= nil and return_ability:GetLevel() == 0 then
		return_ability:SetLevel(1)
	end
	if is_scepter_chakram then
		caster:SwapAbilities("shredder_chakram_2_datadriven", "shredder_return_chakram_2_datadriven", false, true)
	else
		caster:SwapAbilities("shredder_chakram_datadriven", "shredder_return_chakram_datadriven", false, true)
	end
	caster:EmitSound("Hero_Shredder.Chakram.Cast")
	caster:AddNewModifier(caster, ability, "modifier_disarmed", {})
end

function handleProjectileHitUnit(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local damage = ability:GetSpecialValueFor("pass_damage")
	ApplyDamage({
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = ability
	})
	target:EmitSound("Hero_Shredder.Chakram.Target")
end

function handleDeath(event)
	local caster = event.caster
	local ability = event.ability
	local chakram_dummy_unit = caster.chakram_dummy_unit
	if chakram_dummy_unit ~= nil then
		chakram_dummy_unit:StopSound("Hero_Shredder.Chakram")
		if chakram_dummy_unit.particle_id ~= nil then
			ParticleManager:DestroyParticle(chakram_dummy_unit.particle_id, false)
			chakram_dummy_unit.particle_id = nil
		end
		chakram_dummy_unit:ForceKill(false)
		caster.chakram_dummy_unit = nil
	end
	if ability:IsHidden() then
		caster:SwapAbilities("shredder_chakram_datadriven", "shredder_return_chakram_datadriven", true, false)
	end
	-- clean scepter chakram
	chakram_dummy_unit = caster.chakram_2_dummy_unit
	if chakram_2_dummy_unit ~= nil then
		chakram_dummy_unit:StopSound("Hero_Shredder.Chakram")
		if chakram_dummy_unit.particle_id ~= nil then
			ParticleManager:DestroyParticle(chakram_dummy_unit.particle_id, false)
			chakram_dummy_unit.particle_id = nil
		end
		chakram_dummy_unit:ForceKill(false)
		caster.chakram_2_dummy_unit = nil
	end
	ability = caster:FindAbilityByName("shredder_chakram_2_datadriven")
	if ability:IsHidden() and ability:GetLevel() > 0 then
		caster:SwapAbilities("shredder_chakram_2_datadriven", "shredder_return_chakram_2_datadriven", true, false)
	end
end

function handleIntervalThink(event)
	local caster = event.caster
	if caster:HasScepter() then
		local chakram_2 = caster:FindAbilityByName("shredder_chakram_2_datadriven")
		if chakram_2 ~= nil and chakram_2:GetLevel() == 0 then
			chakram_2:SetLevel(1)
			chakram_2:SetHidden(false)
		end
	end
end

function handleRemoveAbility(parent)
	local chakram_dummy_unit = parent.chakram_dummy_unit
	if chakram_dummy_unit ~= nil then
		chakram_dummy_unit:StopSound("Hero_Shredder.Chakram")
		if chakram_dummy_unit.particle_id ~= nil then
			ParticleManager:DestroyParticle(chakram_dummy_unit.particle_id, false)
			chakram_dummy_unit.particle_id = nil
		end
		chakram_dummy_unit:ForceKill(false)
		parent.chakram_dummy_unit = nil
	end
	-- clean scepter chakram
	chakram_dummy_unit = parent.chakram_2_dummy_unit
	if chakram_dummy_unit ~= nil then
		chakram_dummy_unit:StopSound("Hero_Shredder.Chakram")
		if chakram_dummy_unit.particle_id ~= nil then
			ParticleManager:DestroyParticle(chakram_dummy_unit.particle_id, false)
			chakram_dummy_unit.particle_id = nil
		end
		chakram_dummy_unit:ForceKill(false)
		parent.chakram_2_dummy_unit = nil
	end
	local disarms = parent:FindAllModifiersByName("modifier_disarmed")
	for i=1,#disarms do
		if     disarms[i]:GetAbility():GetName() == "shredder_chakram_datadriven" 
		  	or disarms[i]:GetAbility():GetName() == "shredder_chakram_2_datadriven" then
			disarms[i]:Destroy()
		end
	end
end

shredder_chakram_datadriven = class({
	OnSpellStart = function(self)
		handleSpellStart({
			target_points = {self:GetCursorPosition()},
			ability = self,
			caster = self:GetCaster()
		})
	end,
	GetAssociatedSecondaryAbilities = function() return "shredder_return_chakram_datadriven" end,
	GetIntrinsicModifierName = function() return "modifier_shredder_chakram_death_lua" end,
	GetAOERadius = function() return 200 end
})

shredder_chakram_2_datadriven = class({
	OnSpellStart = function(self)
		handleSpellStart({
			target_points = {self:GetCursorPosition()},
			ability = self,
			caster = self:GetCaster()
		})
	end,
	GetAssociatedSecondaryAbilities = function() return "shredder_return_chakram_2_datadriven" end,
	GetAOERadius = function() return 200 end,
	GetIntrinsicModifierName = function() return "modifier_shredder_chakram_remove_rubick_lua" end
})

modifier_shredder_chakram_death_lua = class({
	IsHidden = function() return true end,
	OnCreated = function(self) 
		self:StartIntervalThink(1)
	end,
	OnIntervalThink = function(self)
		handleIntervalThink({
			caster = self:GetCaster()
		})
	end,
	DeclareFunctions = function(self)
		return { MODIFIER_EVENT_ON_DEATH }
	end,
	OnDeath = function(self, event)
		if event.unit ~= self:GetParent() then return end
		if not IsServer() then return end
		handleDeath({
			caster = self:GetCaster(),
			ability = self
		})
	end,
	OnDestroy = function(self)
		if not IsServer() then return end
		local parent = self:GetParent()
		if parent:GetName() == "npc_dota_hero_rubick" then
			handleRemoveAbility(parent)
		end
	end
})

modifier_shredder_chakram_remove_rubick_lua = class({
	IsHidden = function() return true end,
	OnDestroy = function(self)
		if not IsServer() then return end
		local parent = self:GetParent()
		if parent:GetName() == "npc_dota_hero_rubick" then
			handleRemoveAbility(parent)
		end
	end
})
