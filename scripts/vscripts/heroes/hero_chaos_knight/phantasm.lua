require("../../items/item_magic_stick")
--[[Author: Pizzalol, Noya, Ractidous
	Date: 08.04.2015.
	Creates illusions while shuffling the positions]]
function Phantasm( keys )
	local caster = keys.caster
	local player = caster:GetPlayerID()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local unit_name = caster:GetUnitName()
	local images_count = ability:GetLevelSpecialValueFor( "images_count", ability_level )
	local duration = ability:GetLevelSpecialValueFor( "illusion_duration", ability_level )
	local outgoingDamage = ability:GetLevelSpecialValueFor( "outgoing_damage", ability_level )
	local incomingDamage = ability:GetLevelSpecialValueFor( "incoming_damage", ability_level )
	local extra_illusion_chance = ability:GetLevelSpecialValueFor("extra_phantasm_chance_pct_tooltip", ability_level)
	local extra_illusion_sound = keys.sound

	local chance = RandomInt(1, 100)

	ProcsMagicStick(keys)

	-- Stop any actions of the caster otherwise its obvious which unit is real
	caster:Stop()
	caster:Purge( false, true, false, false, false )

	-- Initialize the illusion table to keep track of the units created by the spell
	if not caster.phantasm_illusions then
		caster.phantasm_illusions = {}
	end

	-- Kill the old images
	for k,v in pairs(caster.phantasm_illusions) do
		if v and IsValidEntity(v) then 
			v:ForceKill(false)
		end
	end

	if chance <= extra_illusion_chance then
		images_count = images_count + 1
		EmitSoundOn(extra_illusion_sound, caster)
	end

	caster.phantasm_illusions = CreateIllusions(caster, caster,{
		duration = duration,
		outgoing_damage = outgoingDamage,
		incoming_damage = incomingDamage,
		bounty_base = 0,
		bounty_growth = 0
		outgoing_damage_structure = -25
	}, images_count, 72, true, true )
end

--[[Creates unobstructed vision around the caster while shuffling the illusions]]
function PhantasmVision( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level) 
	local vision_duration = ability:GetLevelSpecialValueFor("invuln_duration", ability_level)

	AddFOWViewer(caster:GetTeamNumber(), caster_location, vision_radius, vision_duration, false)
end
