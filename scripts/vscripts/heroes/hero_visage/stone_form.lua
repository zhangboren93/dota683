function handleSpellStart(event)
	print("familiar stone form start.")
	local caster = event.caster
	local ability = event.ability
	caster:Stop()
	caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 0.55)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_summon_familiar_stone_form_diving", { duration = 1 })
end

function handleDivingDestroy(event)
	local caster = event.caster
	local ability = event.ability
	caster:EmitSound("Visage_Familar.StoneForm.Cast")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_summon_familiar_stone_form_recovering", { duration = 1 })
	local radius = ability:GetSpecialValueFor("stun_radius")
	local units = FindUnitsInRadius(caster:GetTeam(),
		caster:GetAbsOrigin(),
		nil, radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		0, FIND_ANY_ORDER, false)
	local damage = ability:GetSpecialValueFor("stun_damage")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	for i=1,#units do
		units[i]:AddNewModifier(caster, ability, "modifier_stunned", { duration = stun_duration })
		ApplyDamage({
			victim = units[i],
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability
		})
	end
end

function handleRecoveringDestroy(event)
	local caster = event.caster
	caster:FindModifierByName("modifier_familiar_attack_damage_lua"):refreshStackCount()
	caster:FadeGesture(ACT_DOTA_CAST_ABILITY_1)
end
