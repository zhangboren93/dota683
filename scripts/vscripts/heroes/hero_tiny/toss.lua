tiny_toss_datadriven = class({})

-- Can toss if there is any units within 250 radius
function tiny_toss_datadriven:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local ability = self
	local grab_radius = self:GetSpecialValueFor("grab_radius")

	if ability:GetCursorTarget() == caster or ability:GetCursorTarget():IsMagicImmune() then
		return false
	end
	if ability:GetCursorTarget():IsBuilding() then
		return false
	end
	
	local units = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		caster:GetAbsOrigin(), nil, 
		grab_radius, 
		DOTA_UNIT_TARGET_TEAM_BOTH, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
		FIND_ANY_ORDER, false)
	local filtered_units = {}
	for i=1,#units do
		if units[i]:GetUnitName() ~= "npc_dota_roshan_datadriven" then
			table.insert(filtered_units, units[i])
		end
	end
	if #filtered_units <= 1 then
		return false
	else
		return true
	end
end

function tiny_toss_datadriven:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")
	local grab_radius = self:GetSpecialValueFor("grab_radius")
	local units = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		caster:GetAbsOrigin(), nil, 
		grab_radius, 
		DOTA_UNIT_TARGET_TEAM_BOTH, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
		FIND_ANY_ORDER, false)
	filtered_units = {}
	for i=1,#units do
		if units[i] ~= caster and units[i]:GetUnitName() ~= "npc_dota_roshan_datadriven" then
			table.insert(filtered_units, units[i])
		end
	end
	local toss_unit = filtered_units[RandomInt(1, #filtered_units)]
	print("Tossing unit " .. toss_unit:GetName())
	
	toss_unit.toss_to_target = target
	toss_unit:AddNewModifier(caster, self, "modifier_toss_flying_lua", { duration = duration })	
	caster:EmitSound("Hero_Tiny.Toss.Target")
end

function tiny_toss_datadriven:CastFilterResultTarget(target)
	local caster = self:GetCaster()
	local ability = self
	local grab_radius = self:GetSpecialValueFor("grab_radius")

	if target == caster then
		return UF_FAIL_CUSTOM
	end
	if target:IsMagicImmune() then
		return UF_FAIL_MAGIC_IMMUNE_ENEMY
	end
	if target:IsBuilding() then
		return UF_FAIL_BUILDING
	end
	
	if IsServer() then
		local units = FindUnitsInRadius(
			caster:GetTeamNumber(), 
			caster:GetAbsOrigin(), nil, 
			grab_radius, 
			DOTA_UNIT_TARGET_TEAM_BOTH, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
			FIND_ANY_ORDER, false)
		local filtered_units = {}
		for i=1,#units do
			if units[i]:GetUnitName() ~= "npc_dota_roshan_datadriven" then
				table.insert(filtered_units, units[i])
			end
		end
		if #filtered_units <= 1 then
			return UF_FAIL_CUSTOM
		end
	end
	return UF_SUCCESS
end

function tiny_toss_datadriven:GetCustomCastErrorTarget( target )
	local caster = self:GetCaster()
	local ability = self
	local grab_radius = self:GetSpecialValueFor("grab_radius")

	if target == caster then
		return "#dota_hud_error_cant_cast_on_self"
	end
	
	local units = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		caster:GetAbsOrigin(), nil, 
		grab_radius, 
		DOTA_UNIT_TARGET_TEAM_BOTH, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
		FIND_ANY_ORDER, false)
	local filtered_units = {}
	for i=1,#units do
		if units[i]:GetUnitName() ~= "npc_dota_roshan_datadriven" then
			table.insert(filtered_units, units[i])
		end
	end
	if #filtered_units <= 1 then
		return "#dota_hud_error_no_units_to_grab"
	end

	return ""
end
