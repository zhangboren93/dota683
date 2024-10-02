function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local mana_void_damage_per_mana = ability:GetSpecialValueFor("mana_void_damage_per_mana")
	local mana_void_ministun = ability:GetSpecialValueFor("mana_void_ministun")
	caster:EmitSound("Hero_Antimage.ManaVoidCast")
	if target:TriggerSpellAbsorb(ability) then return end
	target:EmitSound("Hero_Antimage.ManaVoid")
	local particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particleId, 1, Vector(500, 0, 0))
	target:AddNewModifier(caster, ability, "modifier_stunned", { duration = mana_void_ministun })
	local damage = (target:GetMaxMana() - target:GetMana()) * mana_void_damage_per_mana
	local units = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0, 0, false)  
	for i=1,#units do
		ApplyDamage({
			victim = units[i],
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability
		})
	end
end
