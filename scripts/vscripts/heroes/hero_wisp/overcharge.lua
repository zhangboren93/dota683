--[[
	Author: Ractidous
	Date: 11.02.2015.
	Drain HP and Mana.
]]
function TickDrain( event )
	local caster = event.caster
	local deltaDrainPct	= event.drain_interval * event.drain_pct
	caster:ModifyHealth(caster:GetHealth() * (1 - deltaDrainPct), nil, false, 0)
	caster:SpendMana( caster:GetMana() * deltaDrainPct, event.ability )
end

--[[
	Author: Ractidous
	Date: 11.02.2015.
	Check to see if the overcharged ally should be changed.
]]
function CheckTetheredAlly( event )

	local caster		= event.caster
	local overcharge	= event.ability
	local buffModifier	= event.buff_modifier

	local allies = FindUnitsInRadius(
		caster:GetTeam(), 
		caster:GetAbsOrigin(), nil, 
		1600, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, false)
	for i=1,#allies do
		if allies[i]:HasModifier("modifier_wisp_tether_haste") and allies[i] ~= caster then
			overcharge:ApplyDataDrivenModifier(caster, allies[i], "modifier_overcharge_buff_allie_datadriven", {})
			return
		end
	end
end
--[[
	Author: Ractidous
	Date: 29.01.2015.
	Stop a sound.
]]
function StopSound( event )
	StopSoundEvent( event.sound_name, event.caster )
end

function checkAllieActive(event)
	if not event.target:HasModifier("modifier_wisp_tether_haste") or not event.caster:HasModifier("modifier_overcharge_buff_datadriven") then
		event.target:RemoveModifierByName("modifier_overcharge_buff_allie_datadriven")
	end
end

function handleAbilityExecuted(keys)
    local unit = keys.unit
    local ability = keys.ability
    local event_ability = keys.event_ability
    local target = keys.target
	if event_ability:GetName() == "wisp_tether" and unit:HasModifier("modifier_overcharge_buff_datadriven") then
		unit:FindAbilityByName("wisp_overcharge_datadriven"):ApplyDataDrivenModifier(
			unit, target, "modifier_overcharge_buff_allie_datadriven", {})
	end
end
