--[[Author: YOLOSPAGHETTI
	Date: February 13, 2016
	Heals the hero with bloodrage if they kill a unit, and heals their attacker if they are killed]]
function HealKiller(keys)
	local target = keys.unit
	local attacker = keys.attacker
	local ability = keys.ability
	local health_bonus_pct = ability:GetLevelSpecialValueFor("health_bonus_pct", (ability:GetLevel() -1))/100
	
	if attacker:IsAlive() and not attacker:IsBuilding()
		and not target:IsBuilding() 
		and not target:IsIllusion() 
		and target:GetName() ~= "npc_dota_roshan_datadriven"
		and not target:IsWard() then
		local caster_health = target:GetMaxHealth()
		local heal = caster_health * health_bonus_pct
	
		attacker:Heal(heal, ability)
	end
end

function ApplyModifier(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	target:AddNewModifier(caster, ability, "modifier_blood_rage_lua", {duration = ability:GetSpecialValueFor("duration")})
end

if modifier_blood_rage_lua == nil then
	modifier_blood_rage_lua = class({ 
		RemoveOnDeath           = function(self) return true end,
		DeclareFunctions        = function(self) return 
			{
				MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
				MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
				MODIFIER_EVENT_ON_DEATH
			}
		end,
		GetEffectName           = function(self) return "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf" end,
		GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN end,
	})
end

function modifier_blood_rage_lua:OnCreated(kv)
	self.kv = kv
	self.damage_amplify = self:GetAbility():GetSpecialValueFor("damage_increase_pct")
end

function modifier_blood_rage_lua:GetModifierTotalDamageOutgoing_Percentage(keys)
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= 0 then
		return 0
	end
	if (keys.target:GetAbsOrigin() - keys.attacker:GetAbsOrigin()):Length2D() > 2200 then
		return(self.damage_amplify / 2.0)
	else
		return(self.damage_amplify)
	end
end

function modifier_blood_rage_lua:GetModifierIncomingDamage_Percentage(keys)
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= 0 then
		return 0
	end
	if (keys.target:GetAbsOrigin() - keys.attacker:GetAbsOrigin()):Length2D() > 2200 then
		return(self.damage_amplify / 2.0)
	else
		return(self.damage_amplify)
	end
end

function modifier_blood_rage_lua:OnDeath(keys)
	local parent = self:GetParent()
	if keys.unit == parent or keys.attacker == parent then
		local tmp = keys
		tmp.ability = self:GetAbility()
		HealKiller(tmp)
	end
end
