require("../../items/item_magic_stick")
function handleSpellStart(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local search_aoe = ability:GetSpecialValueFor("search_aoe")
	local count = ability:GetSpecialValueFor("count")
	local duration = ability:GetSpecialValueFor("duration")
	ProcsMagicStick(event)
	local units = FindUnitsInRadius(caster:GetTeam(),
		target:GetAbsOrigin(),
		nil,
		search_aoe,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
		FIND_CLOSEST,
		false)
	for i=1,math.min(#units, count) do
		if units[i] ~= target or not target:TriggerSpellAbsorb(ability) then
			units[i]:AddNewModifier(caster, ability, "modifier_warlock_fatal_bonds_lua", {
				duration = duration
			})
		end
	end
	caster:EmitSound("Hero_Warlock.FatalBonds")
end
