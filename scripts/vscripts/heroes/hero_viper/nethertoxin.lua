viper_nethertoxin_lua = class({})
function viper_nethertoxin_lua:GetIntrinsicModifierName()
	return "modifier_viper_nethertoxin_lua"
end

modifier_viper_nethertoxin_lua = class({})

function modifier_viper_nethertoxin_lua:IsHidden()
	return true
end

function modifier_viper_nethertoxin_lua:DeclareFunctions()
	return { MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL }
end

function modifier_viper_nethertoxin_lua:GetModifierProcAttack_BonusDamage_Physical(event)
	local attacker = event.attacker
	if not IsServer() or attacker ~= self:GetParent() then return 0 end
	local victim = event.target
	local ability = self:GetAbility()
	local health_pct = victim:GetHealthPercent()
	local bonus_damage = ability:GetSpecialValueFor("bonus_damage")
	local damage = 0
	if health_pct > 80 then
		damage = bonus_damage
	elseif health_pct > 60 then
		damage = bonus_damage * 2
	elseif health_pct > 40 then
		damage = bonus_damage * 4  
	elseif health_pct > 20 then
		damage = bonus_damage * 8
	else
		damage = bonus_damage * 16 
	end
	if victim:IsHero() then
		return damage
	end
	return damage / 2
end
