require("cleave_units_check")

if modifier_magnataur_empower_cleave_lua == nil then
	modifier_magnataur_empower_cleave_lua = class({})
end

function modifier_magnataur_empower_cleave_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_magnataur_empower_cleave_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_PROCESS_CLEAVE,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function modifier_magnataur_empower_cleave_lua:GetModifierBaseDamageOutgoing_Percentage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage_pct")
end


function modifier_magnataur_empower_cleave_lua:IsHidden()
	return false
end

function modifier_magnataur_empower_cleave_lua:IsDebuff()
	return false
end

function modifier_magnataur_empower_cleave_lua:IsPurgable()
	return true
end

function modifier_magnataur_empower_cleave_lua:GetEffectName()
	return "particles/units/heroes/hero_magnataur/magnataur_empower.vpcf"
end

function modifier_magnataur_empower_cleave_lua:OnProcessCleave(event)
	local attacker = event.attacker
	local target = event.target
	local ability = self:GetAbility()
	if attacker == self:GetParent() and passCleaveUnitCheck(attacker, target) then
		local pct = ability:GetSpecialValueFor("cleave_damage_pct")
		local radius = ability:GetSpecialValueFor("cleave_radius")
		local damage = event.damage * pct /100
		local pos = attacker:GetOrigin()+(target:GetOrigin()-attacker:GetOrigin()):Normalized()*radius
		local units = FindUnitsInRadius(attacker:GetTeam(),pos,nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)
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
