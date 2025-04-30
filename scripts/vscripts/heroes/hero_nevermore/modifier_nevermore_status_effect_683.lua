modifier_nevermore_status_effect_683_lua = class({
	OnCreated = function(self, data)
		local parent = self:GetParent()
		if data.style ~= nil and parent ~= nil then
			print("modifier_sf_weapon_effect_683_lua creates with " .. data.style)
			if data.style == "deft" then
				return
			elseif data.style == "orange" then
				self.mpn = "particles/units/heroes/hero_nevermore/sf_necromastery_attack.vpcf"
			elseif data.style == "red" then
				self.mpn = "particles/units/heroes/hero_nevermore/sf_necromastery_attack_pink.vpcf"
			end
		end
	end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	IsHidden = function() return true end,
	DeclareFunctions = function() return { MODIFIER_PROPERTY_PROJECTILE_NAME } end,
	GetModifierProjectileName = function(self)
		local item = self:GetParent():FindItemInInventory("item_desolator_datadriven")
		if item ~= nil then
			return item:GetProjectileName()
		end
		return self.mpn
	--	return "particles/units/heroes/hero_nevermore/sf_necromastery_attack.vpcf"
	end
})
