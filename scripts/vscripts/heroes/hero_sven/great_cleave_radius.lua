if modifier_sven_great_cleave_radius == nil then
	modifier_sven_great_cleave_radius = class({})
end

function modifier_sven_great_cleave_radius:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_sven_great_cleave_radius:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_PROCESS_CLEAVE,
	}
	return funcs
end

function modifier_sven_great_cleave_radius:IsHidden()
	return true
end

function modifier_sven_great_cleave_radius:OnProcessCleave(event)
	local attacker = event.attacker
	local target = event.target
	local ability = self:GetAbility()
	if attacker == self:GetParent() and not target:IsBuilding() and attacker:GetTeam() ~= target:GetTeam() and not attacker:PassivesDisabled() then
		local pct = ability:GetSpecialValueFor("cleave_radius_damage")
		local radius = ability:GetSpecialValueFor("cleave_radius")
		local damage = event.damage * pct /100
		local pos = attacker:GetOrigin()+(target:GetOrigin()-attacker:GetOrigin()):Normalized()*radius
		local units = FindUnitsInRadius(attacker:GetTeam(),pos,nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)
		for k,v in ipairs(units) do
			if v ~= target then
				ApplyDamage({
					attacker = attacker,
					victim = v,
					damage = damage,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR,
					ability = ability
				})
			end
		end
	end
end

function handleIntervalThink(event)
	local caster = event.caster
	if IsServer() and caster:HasAbility("sven_great_cleave") then
		if not caster:HasModifier("modifier_sven_great_cleave_radius") then
			local great_cleave = caster:FindAbilityByName("sven_great_cleave")
			if great_cleave:GetLevel() > 0 then
				caster:AddNewModifier(caster, great_cleave, "modifier_sven_great_cleave_radius", {})
			end
		end
	end
end
