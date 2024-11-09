function handleIntervalThink(event)
	local target = event.target
	if target:HasModifier("modifier_treant_overgrowth_datadriven") then
		ApplyDamage({
			victim = target,
			attacker = event.caster,
			damage = 175,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = event.ability
		})
	end
end

function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local duration = ability:GetSpecialValueFor("duration")
	local radius = ability:GetSpecialValueFor("radius")
	local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(),
			nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for i=1,#units do
		ability:ApplyDataDrivenModifier(caster, units[i], "modifier_treant_overgrowth_datadriven", { duration = duration })
		units[i]:EmitSound("Hero_Treant.Overgrowth.Target")
	end
	caster:EmitSound("Hero_Treant.Overgrowth.Cast")
	ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_overgrowth_cast.vpcf",
			PATTACH_ABSORIGIN, caster)

	if caster:HasScepter() then
		local eyes_in_the_forest = caster:FindAbilityByName("treant_eyes_in_the_forest")
		local overgrowth_aoe = eyes_in_the_forest:GetSpecialValueFor("overgrowth_aoe")
		local trees = Entities:FindAllByName("npc_dota_treant_eyes")
		for i=1,#trees do
			local units = FindUnitsInRadius(caster:GetTeam(), trees[i]:GetAbsOrigin(),
				nil, overgrowth_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			for j=1,#units do
				if not units[j]:HasModifier("modifier_treant_overgrowth_datadriven") then
					ability:ApplyDataDrivenModifier(caster, units[j], "modifier_treant_overgrowth_datadriven", { duration = duration })
					units[j]:EmitSound("Hero_Treant.Overgrowth.Target")
				end
				ability:ApplyDataDrivenModifier(caster, units[j], "modifier_treant_overgrowth_damage_datadriven", { duration = duration });
			end
		end
	end
end
