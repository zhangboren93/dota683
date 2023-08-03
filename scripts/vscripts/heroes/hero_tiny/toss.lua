tiny_toss_datadriven = class({})

-- Can toss if there is any units within 250 radius
function tiny_toss_datadriven:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local ability = self
	local grab_radius = self:GetSpecialValueFor("grab_radius")

	if ability:GetCursorTarget() == caster then
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
	if #units <= 1 then
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
	for i=1,#units do
		if units[i] == caster then
			table.remove(units, i)
			break
		end
	end
	print(#units)
	local toss_unit = units[RandomInt(1, #units)]
	print("Tossing unit " .. toss_unit:GetName())
	
	toss_unit.toss_to_target = target
	toss_unit:AddNewModifier(caster, self, "modifier_toss_flying_lua", { duration = duration })
end
