--[[Astral Imprisonment stop loop sound and show the model again
	Author: chrislotix
	Date: 6.1.2015.]]
function AstralImprisonmentEnd( keys )

	local sound_name = "Hero_ObsidianDestroyer.AstralImprisonment"
	local target = keys.target

	--Stops the loop sound when the modifier ends

	StopSoundEvent(sound_name, target)

	target:RemoveNoDraw()	
	local ability = keys.ability
	if ability.pid ~= nil then
		ParticleManager:DestroyParticle(ability.pid, false)
		ability.pid = nil
	end
end

--[[Author: Pizzalol
	Date: 27.04.2015.
	Hides the model for the duration of Astral Imprisonment]]
function AstralImprisonmentStart( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability

	target:AddNoDraw()
	-- creates dummy unit with AstrialImprison effect
	if ability.pid ~= nil then
		ParticleManager:DestroyParticle(ability.pid, false)
	end
	ability.pid = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(ability.pid, 0, target:GetAbsOrigin())
end

function handleSpellStart(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local sound_name = "Hero_ObsidianDestroyer.AstralImprisonment"
	if target:GetTeam() == caster:GetTeam() then
		target:EmitSound(sound_name)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_astral_imprisonment_datadriven", {})
	else
		if target:TriggerSpellAbsorb(ability) then return end
		target:EmitSound(sound_name)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_astral_imprisonment_int_steal_target_datadriven", {})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_astral_imprisonment_datadriven", {})
	end
end
