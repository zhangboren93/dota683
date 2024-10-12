function handleSpellStart(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	caster:EmitSound("Hero_Oracle.FatesEdict.Cast")
	if target:GetTeam() ~= caster:GetTeam() and target:TriggerSpellAbsorb(ability) then
		return
	end
	local duration = ability:GetSpecialValueFor("duration")
	target:AddNewModifier(caster, ability, "modifier_oracle_fates_edict_lua", { duration = duration })
end
