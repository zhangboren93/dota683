modifier_queenofpain_attack_project_683_lua = class({
	OnCreated = function(self, data)
		local parent = self:GetParent()
		if data.style ~= nil and parent ~= nil then
			print("modifier_sf_weapon_effect_683_lua creates with " .. data.style)
			if data.style == "deft" then
				return
			elseif data.style == "blue" then
				self.mpn = "particles/units/heroes/hero_queenofpain/queen_base_attack_blue.vpcf"
			elseif data.style == "gold" then
				self.mpn = "particles/units/heroes/hero_queenofpain/queen_base_attack_gold.vpcf"
			end
		end
	end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	IsHidden = function() return true end,
	DeclareFunctions = function() return { MODIFIER_PROPERTY_PROJECTILE_NAME } end,
	GetModifierProjectileName = function(self)
		return self.mpn
	--	return "particles/units/heroes/hero_nevermore/sf_necromastery_attack.vpcf"
	end
})
