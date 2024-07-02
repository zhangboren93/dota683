require("../../items/item_magic_stick")
function handleAbilityStart(event)
	local caster = event.caster
	local ability = event.ability
	ProcsMagicStick(event)
	local necromastery = caster:FindModifierByName("modifier_necromastery")
	if necromastery == nil then return end
	local stacks = necromastery:GetStackCount()
	local souls = math.ceil(stacks / 2)
	releaseNumberOfSouls(souls, ability, caster)
end

function handleIntervalThink(event)
	if not IsServer() then return end
	local unit = event.target
	if unit.requiem_velocity == nil then return end
	unit:SetAbsOrigin(unit:GetAbsOrigin() + unit.requiem_velocity * 0.03)
end

function handleDeath(event)
	if not IsServer() then return end
	local caster = event.caster
	if caster:IsReincarnating() then return end
	local necromastery = caster:FindModifierByName("modifier_necromastery")
	if necromastery == nil then return end
	local stacks = necromastery:GetStackCount()
	-- release half the amount of souls
	local souls = math.ceil(stacks / 2)
	caster:EmitSound("Hero_Nevermore.RequiemOfSouls")
	releaseNumberOfSouls(souls, event.ability, caster)
end

function releaseNumberOfSouls(souls, ability, caster)
	print("releaseNumberOfSouls " .. souls)
	if souls <= 0 then return end
	local anglePerSoul = math.pi / souls * 2
	local requiem_radius = ability:GetSpecialValueFor("requiem_radius")
	local requiem_line_width_start = ability:GetSpecialValueFor("requiem_line_width_start")
	local requiem_line_width_end = ability:GetSpecialValueFor("requiem_line_width_end")
	local requiem_line_speed = ability:GetSpecialValueFor("requiem_line_speed")
	
	for i = 1, souls do
		local angle = (i - 1) * anglePerSoul
		local angleVector = Vector(math.cos(angle), math.sin(angle), 0)
		local velocity = requiem_line_speed * angleVector
		ProjectileManager:CreateLinearProjectile({
			Ability = ability,
			vSpawnOrigin = caster:GetAbsOrigin(),
			vVelocity = velocity,
			fDistance = requiem_radius,
			fStartRadius = requiem_line_width_start,
			fEndRadius = requiem_line_width_end,
			Source = caster,
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = 0,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			bProvidesVision = false,
			bDeleteOnHit = false,
		})
		local dummy = CreateUnitByName("npc_dummy_unit", 
			caster:GetAbsOrigin(), false, caster, caster, caster:GetTeam())
		dummy.requiem_velocity = velocity
		ability:ApplyDataDrivenModifier(dummy, dummy, "modifier_requiem_head_datadriven", {})
		dummy:AddNewModifier(caster, ability, "modifier_kill", { duration = requiem_radius / requiem_line_speed })
	end
end

function handleProjectileHitUnit(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local damage = ability:GetAbilityDamage()
	local duration = ability:GetSpecialValueFor("requiem_slow_duration")
	ApplyDamage({
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability })
    target:AddNewModifier(caster, ability, "modifier_requiem_slow_lua", { duration = duration })
end
