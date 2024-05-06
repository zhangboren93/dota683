require("../../items/item_magic_stick")
function handleAbilityExecuted(event)
    local event_ability = event.event_ability
    local caster = event.caster
    local target = event.target
    if event_ability:GetName() == "brewmaster_drunken_haze" then
        caster:EmitSound("Hero_Brewmaster.CinderBrew.Cast")
        target:EmitSound("Hero_Brewmaster.CinderBrew.Target")
    end
end

function handleSpellStart(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability 
	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("duration")
	ProcsMagicStick(event)
	local heroes = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for i=1,#heroes do
		if heroes[i] ~= target or not target:TriggerSpellAbsorb(ability) then
			ability:ApplyDataDrivenModifier(caster, heroes[i], "modifier_drunken_haze", { duration = duration })
		end
	end
end
