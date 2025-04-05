require("../../items/item_magic_stick")
function providesVision(event)
	local ability = event.ability
	local vision_duration = ability:GetSpecialValueFor("vision_duration")
	local vision_radius = ability:GetSpecialValueFor("vision_radius")
	local target = event.target
	ability:CreateVisibilityNode(target:GetAbsOrigin(), vision_radius, vision_duration)
end

function handleSpellStart(event)
	local target = event.target
	local ability = event.ability
	ProcsMagicStick(event)
	if target:TriggerSpellAbsorb(ability) then
		return
	end
	local caster = event.caster
	ability:ApplyDataDrivenModifier(caster, target, "modifier_thunder_strike_datadriven", {})
	target:EmitSound("Hero_Disruptor.ThunderStrike.Cast")
end

function handleDeath(event)
	local target = event.unit
	local pos = target:GetAbsOrigin()
	local modifier = target:FindModifierByName("modifier_thunder_strike_datadriven")
	local remainingTime = modifier:GetRemainingTime()
	local caster = event.caster
	local ability = event.ability
	if remainingTime > 0.1 then
		print("Dead with more strikes to come.")
		local dummy = CreateUnitByName("npc_dummy_unit", pos, false, caster, caster, caster:GetTeam())
		dummy:AddNewModifier(caster, ability, "modifier_thunder_strike_after_death_lua", { duration = remainingTime })
	end
end


function AttachStrikeEffect(event)
	local particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf",
													  PATTACH_POINT_FOLLOW,
													  event.caster)
	local target = event.target
	ParticleManager:SetParticleControlEnt(particleId,
										  1,
										  target,
										  PATTACH_POINT_FOLLOW,
										  "attach_hitloc",
										  Vector(0, 0, 0),
										  false)
	ParticleManager:SetParticleControlEnt(particleId,
										  0,
										  target,
										  PATTACH_OVERHEAD_FOLLOW,
										  "",
										  Vector(0, 0, 0),
										  false)
	ParticleManager:SetParticleControlEnt(particleId,
										  2,
										  target,
										  PATTACH_POINT_FOLLOW,
										  "attach_hitloc",
										  Vector(0, 0, 0),
										  false)
end
