shredder_return_chakram_datadriven = class({
	OnSpellStart = function(self)
		local caster = self:GetCaster()
		local chakram_dummy_unit = caster.chakram_dummy_unit
		local ability = self
		local is_scepter_chakram = false
		if not IsValidEntity(chakram_dummy_unit) then return end
		chakram_dummy_unit:AddNewModifier(caster, ability, "modifier_shredder_chakram_return_lua", { })
		caster:EmitSound("Hero_Shredder.Chakram.Return")
		local chakram_ability = caster:FindAbilityByName("shredder_chakram_datadriven")
		if is_scepter_chakram then
			chakram_ability = caster:FindAbilityByName("shredder_chakram_2_datadriven")
		end
		chakram_dummy_unit:RemoveModifierByName("modifier_shredder_chakram_move_lua")
	end,
	IsStealable = function() return false end
})

shredder_return_chakram_2_datadriven = class({
	OnSpellStart = function(self)
		local caster = self:GetCaster()
		local ability = self
		local is_scepter_chakram = false
		local chakram_dummy_unit = caster.chakram_2_dummy_unit
		if not IsValidEntity(chakram_dummy_unit) then return end
		chakram_dummy_unit:AddNewModifier(caster, ability, "modifier_shredder_chakram_return_lua", { })
		caster:EmitSound("Hero_Shredder.Chakram.Return")
		local chakram_ability = caster:FindAbilityByName("shredder_chakram_datadriven")
		if is_scepter_chakram then
			chakram_ability = caster:FindAbilityByName("shredder_chakram_2_datadriven")
		end
		chakram_dummy_unit:RemoveModifierByName("modifier_shredder_chakram_move_lua")
	end,
	IsStealable = function() return false end
})
