modifier_eidelon_check_attacks_lua = class({})

function modifier_eidelon_check_attacks_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_eidelon_check_attacks_lua:IsHidden()
	return true
end

function modifier_eidelon_check_attacks_lua:OnAttackLanded(event)
	if event.attacker ~= self:GetParent() then return end
	local caster = self:GetParent() -- The eidelon
	local target = event.target -- The target it is attacking
	local ability = self:GetAbility()
	local attack_count = ability:GetSpecialValueFor("split_attack_count")
	local duration = ability:GetSpecialValueFor("duration_tooltip")
	local life_extension = ability:GetSpecialValueFor("life_extension")
	local time_left = duration - (GameRules:GetGameTime() - caster.time) + life_extension
	
	-- Counts the number of attacks for each eidelon
	if target:GetTeam() ~= caster:GetTeam() and not target:IsBuilding() then
		if caster.attacks == nil then
			caster.attacks = 1
		else
			caster.attacks = caster.attacks + 1
		end
	end
	
	if caster.attacks == nil then
		return
	end
	-- If the number of attacks is greater than the necessary count, we split the eidelon (create a new one)
	if caster.attacks >= attack_count then
		local eidelon = CreateUnitByName(caster:GetUnitName(), caster:GetAbsOrigin(), true, ability:GetCaster(), ability:GetCaster(), ability:GetCaster():GetTeam())
		eidelon:SetForwardVector(caster:GetForwardVector())
		eidelon:SetControllableByPlayer(ability:GetCaster():GetPlayerID(), true)
		eidelon:SetOwner(ability:GetCaster())
		
		--Adds the green duration circle, and kill the eidelon after the duration ends
		eidelon:AddNewModifier(eidelon, nil, "modifier_kill", {duration = time_left})
		-- Phases the eidelon for a short period so there is no unit collision
		eidelon:AddNewModifier(eidelon, nil, "modifier_phased", {duration = 0.03})
		-- Remove the modifier to check attacks
		caster:RemoveModifierByName("modifier_eidelon_check_attacks_lua")
		-- Heal the original eidelon to full
		caster:Heal(caster:GetMaxHealth(), caster)
		caster:FindModifierByName("modifier_kill"):SetDuration(time_left, true)
	end
end
