function shouldApplyGripToUnit(unit)
	if unit:HasModifier("modifier_faceless_void_chronosphere_freeze_lua") then return false end
	if unit:HasModifier("modifier_legion_commander_duel") then return false end
	if unit:HasModifier("modifier_enigma_black_hole_pull_lua") then return false end
	return true
end

local function findBouldersAtPoint(target_point)
	local boulders = Entities:FindAllByNameWithin("npc_dota_earth_spirit_stone", target_point, 180)
	local units = Entities:FindAllInSphere(target_point, 180)
	for i=1,#units do
		if units[i].HasModifier ~= nil and units[i]:HasModifier("modifier_earthspirit_petrify") then
			table.insert(boulders, units[i])
		end
	end
	return boulders
end

function handleAbilityPhaseStart(event)
	print("handleAbilityPhaseStart")
	local caster = event.caster
	if event.target ~= nil then
		print("Targeting allies unit " .. event.target:GetName())
	elseif event.target_points ~= nil and #event.target_points > 0 then
		print("Targeting point :")
		print(event.target_points[1])
		local target_point = event.target_points[1]
		local boulders = findBouldersAtPoint(target_point)
		print("Find boulders count: " .. #boulders)
		if #boulders == 0 then
			local caster = event.caster
			caster:Stop()
		end
	end
end

function handleSpellStart(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if target ~= nil then
		target:EmitSound("Hero_EarthSpirit.GeomagneticGrip.Target")
		caster:EmitSound("Hero_EarthSpirit.GeomagneticGrip.Cast")
		if shouldApplyGripToUnit(target) then
			target:AddNewModifier(caster, ability, "modifier_earth_spirit_geomagnetic_grip_lua", { duration = 2.5 })
			ability:ApplyDataDrivenModifier(caster, target, "modifier_earth_spirit_geomagnetic_grip_aura_datadriven", {})
		end
	elseif event.target_points ~= nil and #event.target_points > 0 then
		local target_point = event.target_points[1]
		local boulders = findBouldersAtPoint(target_point)
		if #boulders == 0 then
			return
		end
		target = boulders[1]
		target:EmitSound("Hero_EarthSpirit.GeomagneticGrip.Target")
		caster:EmitSound("Hero_EarthSpirit.GeomagneticGrip.Cast")
		target:RemoveModifierByName("modifier_earthspirit_petrify")
		target:AddNewModifier(caster, ability, "modifier_earth_spirit_geomagnetic_grip_lua", { duration = 2.5 })
		ability:ApplyDataDrivenModifier(caster, target, "modifier_earth_spirit_geomagnetic_grip_aura_datadriven", {})
	end
end

function handleAuraActiveCreated(event)
	local unit = event.target
	local caster = event.caster
	local ability = event.ability
	local damage = ability:GetSpecialValueFor("rock_damage")
	if not unit:HasModifier("modifier_earth_spirit_geomagnetic_grip_debuff_datadriven") then
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_earth_spirit_geomagnetic_grip_debuff_datadriven", {})
		ApplyDamage({
			victim = unit,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability
		})
		unit:EmitSound("Hero_EarthSpirit.GeomagneticGrip.Damage")
	end
end
