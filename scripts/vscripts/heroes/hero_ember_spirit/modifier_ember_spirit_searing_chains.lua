modifier_ember_spirit_searing_chains_lua = class({
	CheckState = function() return { [ MODIFIER_STATE_ROOTED ] = true } end,
	IsPurgable = function() return true end,
	GetStatusEffectName = function(self) return "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf" end,
	OnCreated = function(self) 
		if IsServer() then
			self:StartIntervalThink(0.5)
		end
	end,
	OnIntervalThink = function(self)
		local parent = self:GetParent()
		if parent ~= nil then
			local ability = self:GetAbility()
			local caster = self:GetCaster()
			local damage = ability:GetSpecialValueFor("damage_per_second") / 2
			ApplyDamage({
				victim = parent,
				attacker = caster, 
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = ability
			})
		end
	end,
})
