life_stealer_control_datadriven = class({
	IsStealable = function() return false end,
	OnSpellStart = function(self)
		print("infest_control")
		local caster = self:GetCaster()
		local host = caster.host
		local ability = self

    	host:AddNewModifier(caster, ability, "modifier_life_stealer_infest_creep", {}) -- Dota2 Original modifier
		host:RemoveAbility("life_stealer_consume")

		host:AddNewModifier(caster, ability, "modifier_dominated", {})
		host:SetTeam(caster:GetTeam())
		host:SetControllableByPlayer(caster:GetPlayerID(), true)
		local movespeed = caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), true)
		print("Set movespeed to " .. movespeed)
		host:SetBaseMoveSpeed(movespeed)
		host:SetOwner(caster)
		caster:FindAbilityByName("life_stealer_control_datadriven"):SetHidden(true)
	end
})
