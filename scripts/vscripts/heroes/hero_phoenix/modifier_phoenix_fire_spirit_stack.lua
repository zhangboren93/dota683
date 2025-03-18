modifier_phoenix_fire_spirit_stack_lua = class({
	IsBuff = function() return true end,
	OnDestroy = function(self)
		local caster	= self:GetCaster()
		local ability	= self:GetAbility()

		local pfx = caster.fire_spirits_pfx
		if pfx then
			ParticleManager:DestroyParticle( pfx, false )
		end

		if ability == nil then return end
		-- Swap main ability
		local main_ability_name	= ability:GetAbilityName()
		local sub_ability_name	= "phoenix_launch_fire_spirit_lua"
		caster:SwapAbilities( main_ability_name, sub_ability_name, true, false )
	end
})
