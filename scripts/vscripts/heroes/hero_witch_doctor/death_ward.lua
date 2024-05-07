--[[Author: YOLOSPAGHETTI
	Date: March 15, 2016
	Creates the death ward]]
require("../../items/item_magic_stick")

WARD_ATTACK_RANGE = 700

function CreateWard(keys)
	local caster = keys.caster
	local ability = keys.ability
	local position = ability:GetCursorPosition()
	
	ProcsMagicStick(keys)

	-- Creates the death ward (There is no way to control the default ward, so this is a custom one)
	caster.death_ward = CreateUnitByName("witch_doctor_death_ward_datadriven", position, true, caster, nil, caster:GetTeam())
	caster.death_ward:SetControllableByPlayer(caster:GetPlayerID(), true)
	caster.death_ward:SetOwner(caster)
	local bounces = ability:GetSpecialValueFor("bounces")
	if bounces > 0 then
		caster.death_ward:AddAbility("death_ward_attack_scepter_lua"):SetLevel(1)
	end
	
	-- Applies the modifier (gives it damage, removes health bar, and makes it invulnerable)
	ability:ApplyDataDrivenModifier( caster, caster.death_ward, "modifier_death_ward_datadriven", {} )
end

--[[Author: YOLOSPAGHETTI
	Date: March 15, 2016
	Removes the death ward entity from the game and stops its sound]]
function DestroyWard(keys)
	local caster = keys.caster
	StopSoundEvent(keys.sound, caster)
	caster.death_ward:AddNewModifier(caster, keys.ability, "modifier_disarmed", {})
	caster.death_ward:AddNewModifier(caster, keys.ability, "modifier_kill", { duration = 2 })
end

function handleAttackStart(event)
	local target = event.target
	local attacker = event.attacker
	if not target:IsHero() then
		attacker:AddNewModifier(attacker, event.ability, "modifier_disarmed", {duration = 0.1})
		local units = FindUnitsInRadius(attacker:GetTeam(),
			attacker:GetAbsOrigin(),
			nil, 
			WARD_ATTACK_RANGE,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
			FIND_CLOSEST, 
			false)
		if #units > 0 and IsValidEntity(units[1]) and units[1]:IsAlive() then
			attacker:MoveToTargetToAttack(units[1])
			return
		end
	end
end

function handleAttackLanded(event)
	local ability = event.ability
	local target = event.target
	local attacker = event.attacker
	local damage = ability:GetSpecialValueFor("damage")
	ApplyDamage({
		attacker = attacker,
		victim = target,
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK,
		ability = ability })
end
