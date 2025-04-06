life_stealer_consume_datadriven = class({
	IsStealable = function() return false end,
	OnSpellStart = function(self)
		local caster = self:GetCaster()
		local ability = self
		if caster.host == nil then return end
		caster:SetAbsOrigin(caster.host:GetAbsOrigin())
		caster:RemoveModifierByName("modifier_infest_hide")
		caster:SwapAbilities("life_stealer_infest_datadriven", "life_stealer_consume_datadriven", true, false) 
		if caster:HasAbility("rubick_spell_steal") then
			caster:FindAbilityByName("rubick_spell_steal"):SetHidden(false)
		end
		caster:FindAbilityByName("life_stealer_control_datadriven"):SetHidden(true)
		for i = 0, 2 do
			if caster.removed_spells[i] ~= nil then
				print(caster.removed_spells[i])
				caster.removed_spells[i]:SetHidden(false)
			end
		end
	
		local exceptionlist = {"spirit_bear", "visage_familiars"}
		local isexception = false
		for _,item in pairs(exceptionlist) do
			if item == caster.host:GetUnitLabel()  then
				isexception = true
				break
			end
		end
		-- if the unit is not a hero, the unit dies
		if not caster.host:IsHero() and not isexception then
			-- heal the caster
			caster:Heal(caster.host:GetHealth(), caster)
	
			caster.host:Kill(ability, caster)
		end
	
		-- deal aoe damage
		units = FindUnitsInRadius(caster:GetTeamNumber(),
					caster:GetAbsOrigin(),
					nil,
					caster.ability["range"], 
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
					DOTA_UNIT_TARGET_FLAG_NONE,
					FIND_ANY_ORDER,
					false)
	
		-- if we find units, deal the damage
		if units ~= nil then
			for k, unit in pairs(units) do
				ApplyDamage({victim = unit,
							attacker = caster,
							damage = caster.ability["damage"],
							damage_type = DAMAGE_TYPE_MAGICAL,
							ability = ability}) 
			end
		end
		--remove the particle
		ParticleManager:DestroyParticle(caster.particleid, true)
		caster:RemoveNoDraw()
	end
})
