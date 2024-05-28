function handleSpellStart(event)
	local ability = event.ability
	local location = ability:GetCursorPosition()
	local caster = event.caster
	local radius = ability:GetSpecialValueFor('radius')
	caster:EmitSound("Hero_Batrider.StickyNapalm.Cast")
	local particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_stickynapalm_impact.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particleId, 0, location)
	ParticleManager:SetParticleControl(particleId, 1, Vector(radius, 0, 0))
	ParticleManager:SetParticleControlEnt(particleId, 2, caster, PATTACH_POINT, "attach_attack1", Vector(0, 0, 0), false)
	ParticleManager:ReleaseParticleIndex(particleId)
	CreateUnitByNameAsync("npc_dummy_unit_sticy_napalm_vision",
		location,
		false,
		caster,
		caster,
		caster:GetTeam(),
		function(unit)
			ability:ApplyDataDrivenModifier(caster, unit, "modifier_batrider_sticky_napalm_vision_datadriven", { })
			unit:AddNewModifier(caster, ability, "modifier_kill", { duration = 2 })
			unit:EmitSound("Hero_Batrider.StickyNapalm.Impact")
		end)
	local units = FindUnitsInRadius(caster:GetTeam(),
		location,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
	local duration = ability:GetSpecialValueFor("duration")
	local max_stacks = ability:GetSpecialValueFor("max_stacks")
	for i=1,#units do
		local modifier = units[i]:FindModifierByName("modifier_batrider_sticky_napalm_debuff_lua")
		if modifier == nil then
			units[i]:AddNewModifier(caster, ability, "modifier_batrider_sticky_napalm_debuff_lua", { duration = duration })
		else
			local stackCount = modifier:GetStackCount()
			if stackCount <= 1 then
				stackCount = 2
			elseif stackCount >= max_stacks then
				stackCount = max_stacks
			else
				stackCount = stackCount + 1
			end
			modifier:SetStackCount(stackCount)
			modifier:SetDuration(duration, true)
		end
	end
end

modifier_batrider_sticky_napalm_debuff_lua = class({})
function modifier_batrider_sticky_napalm_debuff_lua:IsPurgable()
	return true
end
function modifier_batrider_sticky_napalm_debuff_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end
function modifier_batrider_sticky_napalm_debuff_lua:GetModifierTurnRate_Percentage()
	return self:GetAbility():GetSpecialValueFor("turn_rate_pct")
end
function modifier_batrider_sticky_napalm_debuff_lua:GetModifierMoveSpeedBonus_Percentage()
	local unit = self:GetAbility():GetSpecialValueFor("movement_speed_pct")
	if self:GetStackCount() <= 1 then
		return unit
	else
		return unit * self:GetStackCount()
	end
end
function modifier_batrider_sticky_napalm_debuff_lua:OnTakeDamage(event)
	if not IsServer() then return end
	local parent = self:GetParent()
	if event.unit ~= parent then return end
	if event.damage == 0 then return end
	local caster = self:GetCaster()
	if event.attacker ~= caster then return end
	local inflictor = event.inflictor
	if inflictor == nil or inflictor:GetName() == "batrider_flamebreak" or inflictor:GetName() == "batrider_firefly" or inflictor:GetName() == "batrider_flaming_lasso" then
		local stackCount = self:GetStackCount()
		if stackCount < 1 then stackCount = 1 end
		local ability = self:GetAbility()
		local damage = ability:GetSpecialValueFor("damage") * stackCount
		if parent:IsCreep() then damage = damage / 2 end
		ApplyDamage({victim = parent, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	end
end
