--[[Jinada
	Author: Pizzalol
	Date: 1.1.2015.]]
function Jinada( keys )
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(level)
	local caster = keys.caster	
	local modifierName = "modifier_jinada_datadriven"

	ability:StartCooldown(cooldown)

--	caster:RemoveModifierByName(modifierName) 
--
--	caster:SetThink(function()
--		ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
--		end, "bounty jinada", cooldown)	
--
	local target = keys.target
	if caster:IsRealHero() and not target:IsBuilding() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_jinada_slow_datadriven", {})
	end
	if caster.jinada_ready_pid ~= nil then
		ParticleManager:DestroyParticle(caster.jinada_ready_pid, false)
		ParticleManager:DestroyParticle(caster.jinada_ready_pid2, false)
		caster.jinada_ready_pid = nil
		caster.jinada_ready_pid2 = nil
	end
end

function handleAttackStart(event)
	local ability = event.ability
	local attacker = event.attacker
	local target = event.target
	if attacker:IsRealHero() 
		and not target:IsBuilding() 
		and ability:IsCooldownReady() 
		and target:GetTeam() ~= attacker:GetTeam()
		and target:GetName() ~= "npc_dota_unit_undying_tombstone" then
		if attacker:PassivesDisabled() then
			ability:ApplyDataDrivenModifier(attacker, attacker, "modifier_jinada_breaked_datadriven", {})
		else
			ability:ApplyDataDrivenModifier(attacker, attacker, "modifier_jinada_datadriven", {})
		end
	else
		attacker:RemoveModifierByName("modifier_jinada_datadriven")
		attacker:RemoveModifierByName("modifier_jinada_breaked_datadriven")
	end
end

function handleIntervalThink(event)
	local caster = event.caster
	local ability = event.ability
	if ability:IsCooldownReady() and caster.jinada_ready_pid == nil then
		caster.jinada_ready_pid = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_hand_r.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(caster.jinada_ready_pid, 0, caster, PATTACH_POINT_FOLLOW, "attach_weapon1", Vector(0, 0, 0), false)
		caster.jinada_ready_pid2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_hand_l.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(caster.jinada_ready_pid2, 0, caster, PATTACH_POINT_FOLLOW, "attach_weapon2", Vector(0, 0, 0), false)
	end
end
