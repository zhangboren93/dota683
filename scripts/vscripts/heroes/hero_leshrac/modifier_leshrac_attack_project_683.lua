modifier_leshrac_attack_project_683_lua = class({
	OnCreated = function(self, data)
		local parent = self:GetParent()
		if data.style ~= nil and parent ~= nil then
			print("modifier_sf_weapon_effect_683_lua creates with " .. data.style)
			if data.style == "deft" then
				return
			elseif data.style == "green" then
				self.mpn = "particles/units/heroes/hero_leshrac/leshrac_base_attack_green.vpcf"
			end
		end
	end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	IsHidden = function() return true end,
	DeclareFunctions = function() return { MODIFIER_PROPERTY_PROJECTILE_NAME } end,
	GetModifierProjectileName = function(self)
		return self.mpn
	end
})
