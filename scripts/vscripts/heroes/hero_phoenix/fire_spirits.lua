--[[
	Author: Noya
	Date: 16.01.2015.
	Levels up the ability_name to the same level of the ability that runs this
]]
function LevelUpAbility( event )
	local caster = event.caster
	local this_ability = event.ability		
	local this_abilityName = this_ability:GetAbilityName()
	local this_abilityLevel = this_ability:GetLevel()

	-- The ability to level up
	local ability_name = event.ability_name
	local ability_handle = caster:FindAbilityByName(ability_name)	
	if ability_handle == nil then return end
	local ability_level = ability_handle:GetLevel()

	-- Check to not enter a level up loop
	if ability_level ~= this_abilityLevel then
		ability_handle:SetLevel(this_abilityLevel)
	end
end

phoenix_fire_spirits_lua = class({
	GetAssociatedSecondaryAbilities = function() return "phoenix_launch_fire_spirit_lua" end,
	ProcsMagicStick = function() return true end,
	OnSpellStart = function(self)
		local caster = self:GetCaster()
		local ability = self
		local duration = self:GetSpecialValueFor("spirit_duration")
		local modifierStackName	= "modifier_phoenix_fire_spirit_stack_lua"
		local hpCost = self:GetSpecialValueFor("hp_cost_perc")
		local numSpirits = self:GetSpecialValueFor("spirit_count")
		local particleName = "particles/units/heroes/hero_phoenix/phoenix_fire_spirits.vpcf"
		local sub_ability_name	= "phoenix_launch_fire_spirit_lua"
		local main_ability_name	= self:GetAbilityName()
		caster:EmitSound("Hero_Phoenix.FireSpirits.Cast")
		caster:AddNewModifier(caster, self, modifierStackName, { duration = duration })

		-- Create particle FX
		if caster.fire_spirits_pfx then
			ParticleManager:DestroyParticle(caster.fire_spirits_pfx, false)
		end
		pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl( pfx, 1, Vector( numSpirits, 0, 0 ) )
		ParticleManager:SetParticleControl( pfx, 6, Vector( numSpirits, 0, 0 ) )
		for i=1, numSpirits do
			ParticleManager:SetParticleControl( pfx, 8+i, Vector( 1, 0, 0 ) )
		end

		caster.fire_spirits_numSpirits	= numSpirits
		caster.fire_spirits_pfx			= pfx

		-- Set the stack count
		caster:SetModifierStackCount( modifierStackName, ability, numSpirits )

		caster:SetHealth( caster:GetHealth() * ( 100 - hpCost ) / 100 )

		-- Swap sub ability
		caster:SwapAbilities( main_ability_name, sub_ability_name, false, true )
	end,
	OnUpgrade = function(self)
		local caster = self:GetCaster()
		local this_ability = self		
		local ability_name = "phoenix_launch_fire_spirit_lua"

		local this_abilityName = this_ability:GetAbilityName()
		local this_abilityLevel = this_ability:GetLevel()
	
		-- The ability to level up
		local ability_handle = caster:FindAbilityByName(ability_name)	
		if ability_handle == nil then return end
		local ability_level = ability_handle:GetLevel()
	
		-- Check to not enter a level up loop
		if ability_level ~= this_abilityLevel then
			ability_handle:SetLevel(this_abilityLevel)
		end
	end
})
