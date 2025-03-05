modifier_bane_nightmare_cancel_self_lua = class({
	DeclareFunctions = function() return {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	} end,
	OnTakeDamage = function(self, event) 
		print("OnTakeDamage")
		local caster = self:GetCaster()
		local nightmare_end = caster:FindAbilityByName("bane_nightmare_end")
		print(nightmare_end)
		inflictor = event.inflictor
		if inflictor ~= nil then
			print(inflictor:GetName())
		end
		local parent = self:GetParent()
		if parent == nil then return end
		if not parent:HasModifier("modifier_bane_nightmare") then
			self:Destroy()
			return
		end
		if nightmare_end == nil then return end
		if event.inflictor ~= nil and event.inflictor:GetName() == "bane_nightmare" then return end
		if event.attacker == caster then
			print("nightmare_end cast")
			nightmare_end:ToggleAbility()
		end
	end,
	IsHidden = function() return true end
})
