require("items/item_magic_stick")

--[[
	Author: kritth
	Date: 9.1.2015.
	Bubbles seen only to ally as pre-effect
]]
function torrent_bubble_allies( keys )
	local caster = keys.caster
	
	ProcsMagicStick(keys)
	local delay = keys.ability:GetLevelSpecialValueFor( "delay", keys.ability:GetLevel() - 1 )
	local particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_bubbles.vpcf"
	local target = keys.target_points[1]
	
	local fxIndex = ParticleManager:CreateParticleForTeam( particleName, PATTACH_ABSORIGIN, caster, caster:GetTeam() )
	ParticleManager:SetParticleControl( fxIndex, 0, target )
	
	EmitSoundOnLocationForAllies(target, "Ability.pre.Torrent", caster)
	
	-- Destroy particle after delay
	caster:SetThink(function()
		ParticleManager:DestroyParticle( fxIndex, false )
	end, "torrent invis fade", delay)

	
end

--[[
	Author: kritth
	Date: 9.1.2015.
	Emit sound at location
]]
function torrent_emit_sound( keys )
	EmitSoundOnLocationWithCaster(keys.target_points[1], "Ability.Torrent", keys.caster )
end

--[[
	Author: kritth, Pizzalol
	Date: February 24, 2016
	Provides obstructed vision of the area
]]
function torrent_vision( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target_points[1]
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor( "vision_duration", ability:GetLevel() - 1 )
	
	AddFOWViewer(caster:GetTeamNumber(),target,radius,duration,true)
end
