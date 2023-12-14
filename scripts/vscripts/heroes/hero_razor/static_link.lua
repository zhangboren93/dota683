function handleSpellStart(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target:TriggerSpellAbsorb(ability) then
		return
	end
	caster:EmitSound("Ability.static.start")
	caster:EmitSound("Ability.static.loop")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_razor_static_link_datadriven", {})
	if caster.static_link_particle ~= nil then
		ParticleManager:DestroyParticle(caster.static_link_particle, false)
		ParticleManager:ReleaseParticleIndex(caster.static_link_particle)
		caster.static_link_particle = nil
	end
	caster.static_link_particle = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_razor/razor_static_link.vpcf",
		PATTACH_ABSORIGIN_FOLLOW,
		caster)
	ParticleManager:SetParticleControlEnt(caster.static_link_particle,
		0,
		caster, 
		PATTACH_POINT_FOLLOW,
		"attach_static",
		Vector(0, 0, 200),
		false)
	ParticleManager:SetParticleControlEnt(caster.static_link_particle,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0, 0, 0),
		false)
	caster.static_link_target = target
end

function handleDestory(event)
	local caster = event.caster
	caster:EmitSound("Ability.static.end")
	caster:StopSound("Ability.static.loop")
	if caster.static_link_particle ~= nil then
		ParticleManager:DestroyParticle(caster.static_link_particle, false)
		ParticleManager:ReleaseParticleIndex(caster.static_link_particle)
		caster.static_link_particle = nil
	end
end

function handleIntervalThink(event)
	local caster = event.caster
	local target = caster.static_link_target
	local ability = event.ability
	local break_distance = ability:GetSpecialValueFor("drain_range_buffer") + ability:GetCastRange(nil, nil)
	local drain_rate = ability:GetSpecialValueFor("drain_rate")
	local drain_duration = ability:GetSpecialValueFor("drain_duration")
	if target ~= nil then
		if not caster:IsAlive() or not target:IsAlive() or (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > break_distance then
			caster:RemoveModifierByName("modifier_razor_static_link_datadriven")
			return
		end
		local buff = caster:FindModifierByName("modifier_razor_static_link_buff_datadriven")
		if buff == nil then
			buff = ability:ApplyDataDrivenModifier(caster, caster, "modifier_razor_static_link_buff_datadriven", {})
		end
		buff:SetStackCount(buff:GetStackCount() + drain_rate) 
		buff:SetDuration(drain_duration, true)
		local debuff = target:FindModifierByName("modifier_razor_static_link_debuff_datadriven")
		if debuff == nil then
			debuff = ability:ApplyDataDrivenModifier(caster, target, "modifier_razor_static_link_debuff_datadriven", {})
		end
		debuff:SetStackCount(debuff:GetStackCount() + drain_rate) 
		debuff:SetDuration(drain_duration, true)
		ability:CreateVisibilityNode(target:GetAbsOrigin(), 800, 1.1)
	end
end
