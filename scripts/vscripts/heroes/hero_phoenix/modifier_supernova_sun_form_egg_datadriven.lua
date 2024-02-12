modifier_supernova_sun_form_egg_datadriven = class({})

function modifier_supernova_sun_form_egg_datadriven:CheckState()
	return {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end

function modifier_supernova_sun_form_egg_datadriven:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end

function modifier_supernova_sun_form_egg_datadriven:GetDisableHealing()
	return 1
end

function modifier_supernova_sun_form_egg_datadriven:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_supernova_sun_form_egg_datadriven:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_supernova_sun_form_egg_datadriven:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_supernova_sun_form_egg_datadriven:GetModifierIncomingDamage_Percentage()
	return 0
end

function modifier_supernova_sun_form_egg_datadriven:IsAura()
	return true
end

function modifier_supernova_sun_form_egg_datadriven:GetModifierAura()
	return "modifier_supernova_burn_datadriven"
end

function modifier_supernova_sun_form_egg_datadriven:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

function modifier_supernova_sun_form_egg_datadriven:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_supernova_sun_form_egg_datadriven:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_supernova_sun_form_egg_datadriven:OnAttacked(event)
	local egg			= self:GetParent()
	local attacker		= event.attacker
	local caster 		= self:GetCaster()
	local maxAttacks	= self:GetAbility():GetSpecialValueFor("max_hero_attacks")

	if egg ~= event.target then return end

	-- Only real heroes can deal damage to the egg.
	if not attacker:IsRealHero() then
		return
	end

	local numAttacked = egg.supernova_numAttacked or 0
	numAttacked = numAttacked + 1
	egg.supernova_numAttacked = numAttacked

	local health = 100 * ( maxAttacks - numAttacked ) / maxAttacks
	egg:SetHealth( health )

	if numAttacked >= maxAttacks then
		-- Now the egg has been killed.
		egg.supernova_lastAttacker = attacker
		caster:RemoveModifierByName( "modifier_supernova_sun_form_caster_datadriven" )
		egg:RemoveModifierByName( "modifier_supernova_sun_form_egg_datadriven" )
	end
end

local function resetHero(hero)
	hero:SetHealth( hero:GetMaxHealth() )
	hero:SetMana( hero:GetMaxMana() )

	-- Strong despel
	local RemovePositiveBuffs = true
	local RemoveDebuffs = true
	local BuffsCreatedThisFrameOnly = false
	local RemoveStuns = true
	local RemoveExceptions = true
	hero:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions )

	-- resets player's basic ability 
	for i=0,2 do
		local ability = hero:GetAbilityByIndex(i)
		if not ability:IsCooldownReady() then
			ability:EndCooldown()
		end
	end
end

function modifier_supernova_sun_form_egg_datadriven:OnDestroy()
	if not IsServer() then return end

	local egg		= self:GetParent()
	local hero		= self:GetCaster()
	local ability	= self:GetAbility()

	local isDead = egg:GetHealth() == 0

	if isDead then

		if hero:HasScepter() and hero.supernova_scepter_target ~= nil then
			hero.supernova_scepter_target:Kill( ability, egg.supernova_lastAttacker)
		end
		hero:Kill( ability, egg.supernova_lastAttacker )

	else

		-- Stun nearby enemies
		local aura_radius = ability:GetSpecialValueFor("aura_radius")
		local stun_duration = ability:GetSpecialValueFor("stun_duration")
		local units = FindUnitsInRadius(hero:GetTeam(),
										hero:GetAbsOrigin(),
										nil,
										aura_radius,
										DOTA_UNIT_TARGET_TEAM_ENEMY,
										DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
										DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
										FIND_ANY_ORDER,
										false)
		for i=1,#units do
			units[i]:AddNewModifier(hero, ability, "modifier_stunned", { duration = stun_duration })
		end

		resetHero(hero)

		if hero:HasScepter() and hero.supernova_scepter_target ~= nil then
			resetHero(hero.supernova_scepter_target)
		end
	end

	-- Play sound effect
	local soundName = "Hero_Phoenix.SuperNova." .. ( isDead and "Death" or "Explode" )
	StartSoundEvent( soundName, hero )

	-- Create particle effect
	local pfxName = "particles/units/heroes/hero_phoenix/phoenix_supernova_" .. ( isDead and "death" or "reborn" ) .. ".vpcf"
	local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_ABSORIGIN, hero )
	ParticleManager:SetParticleControlEnt( pfx, 0, hero, PATTACH_POINT_FOLLOW, "follow_origin", egg:GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( pfx, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", egg:GetAbsOrigin(), true )

	-- Remove the egg
	egg:ForceKill( false )
	egg:AddNoDraw()
end

function modifier_supernova_sun_form_egg_datadriven:GetOverrideAnimation()
	return ACT_DOTA_IDLE 
end
