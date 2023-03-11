--[[Author: YOLOSPAGHETTI
	Date: February 4, 2016
	Applies a strong dispel to Ursa]]
function Purge(keys)
	local caster = keys.caster
	local ability = keys.ability
	local model_scale = ability:GetLevelSpecialValueFor( "model_scale", ability:GetLevel() - 1 )
	
--	-- Strong Dispel
--	local RemovePositiveBuffs = false
--	local RemoveDebuffs = true
--	local BuffsCreatedThisFrameOnly = false
--	local RemoveStuns = true
--	local RemoveExceptions = false
--	caster:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
	
	-- Gives Ursa a red tint
	caster:SetRenderColor(255, 0, 0)
	
	-- Scales Ursa's model by 120%
	caster:SetModelScale(model_scale)
end

--[[Author: YOLOSPAGHETTI
	Date: February 4, 2016
	Applies the bonus fury swipe damage]]
function BonusDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local caster_health = caster:GetHealth()
	local damage_health_pct = ability:GetSpecialValueFor("damage_health_pct")
	local ability_damage = caster_health * damage_health_pct / 100
	
	-- Deal damage
	local damage_table = {
		victim = target,
		attacker = caster,
		damage = ability_damage,
		damage_type = DAMAGE_TYPE_PHYSICAL
	}
	ApplyDamage( damage_table )
end

--[[Author: YOLOSPAGHETTI
	Date: February 4, 2016
	Changes Ursa back to his original color and size]]
function ChangeAppearance(keys)
	local caster = keys.caster
	
	caster:SetRenderColor(255, 255, 255)
	caster:SetModelScale(1)
end
