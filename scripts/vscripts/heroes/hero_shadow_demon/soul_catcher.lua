require("../../items/item_magic_stick")
function handleSpellStart(event)
	local target_point = event.target_points[1]
	local caster = event.caster
	local ability = event.ability
	local radius = ability:GetSpecialValueFor("radius")

	ProcsMagicStick(event)
	caster:EmitSound("Hero_ShadowDemon.Soul_Catcher.Cast")

	local units = FindUnitsInRadius(
        caster:GetTeam(), 
        target_point, nil,
        radius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
        0, 0, false)
	local invulnerable_units = FindUnitsInRadius(
        caster:GetTeam(), 
        target_point, nil,
        radius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
        DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false)
	for i=1,#invulnerable_units do
		if invulnerable_units[i]:HasModifier("modifier_shadow_demon_disruption") then
			table.insert(units, invulnerable_units[i])
		end
	end
    if #units == 0 then
        return
    end
    local pickedUnit = units[RandomInt(1, #units)]
	if pickedUnit:HasModifier("modifier_shadow_demon_disruption") then
		caster:SetThink(function()
    		ability:ApplyDataDrivenModifier(caster, pickedUnit, "modifier_sd_soul_catcher_debuff_datadriven", {})
		end, "soul catch after disruption", pickedUnit:FindModifierByName("modifier_shadow_demon_disruption"):GetRemainingTime() + 0.1)
	else
    	ability:ApplyDataDrivenModifier(caster, pickedUnit, "modifier_sd_soul_catcher_debuff_datadriven", {})
	end

	pickedUnit:EmitSound("Hero_ShadowDemon.Soul_Catcher")
end
