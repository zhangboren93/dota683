require("items/item_sphere")
function handleAbilityExecuted(keys)
	local unit = keys.unit
	local ability2 = keys.ability
	local event_ability = keys.event_ability
	local target = keys.target
	if event_ability:GetName() == "item_cyclone" then

		if is_spell_blocked_by_linkens_sphere_a(target, unit) then return end

		local RemovePositiveBuffs = not (target:GetTeam() == unit:GetTeam())
		local RemoveDebuffs = target:GetTeam() == unit:GetTeam()
		local BuffsCreatedThisFrameOnly = false
		local RemoveStuns = false
		local RemoveExceptions = false
		target:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
		ability2:ApplyDataDrivenModifier(unit, target, "modifier_eul_cyclone_datadriven", {}):SetDuration(2.5, true)
	end
end

function handleDestroy(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if target:GetTeam() ~= caster:GetTeam() then
		ApplyDamage({
			victim = target,
			attacker = caster,
			damage = 50,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability })
	end
end
