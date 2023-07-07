
if modifier_magnataur_empower_cleave_lua == nil then
	modifier_magnataur_empower_cleave_lua = class({})
end

function modifier_magnataur_empower_cleave_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_magnataur_empower_cleave_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_PROCESS_CLEAVE,
	}
	return funcs
end

function modifier_magnataur_empower_cleave_lua:IsHidden()
	return true
end

function modifier_magnataur_empower_cleave_lua:IsDebuff()
	return false
end

function modifier_magnataur_empower_cleave_lua:IsPurgable()
	return true
end

function modifier_magnataur_empower_cleave_lua:OnProcessCleave(event)
	local attacker = event.attacker
	local target = event.target
	local ability = self:GetAbility()
	if attacker == self:GetParent() and not target:IsBuilding() and attacker:GetTeam() ~= target:GetTeam() then
		local pct = ability:GetSpecialValueFor("cleave_radius_damage")
		local radius = ability:GetSpecialValueFor("cleave_radius")
		local damage = event.damage * pct /100
		local pos = attacker:GetOrigin()+(target:GetOrigin()-attacker:GetOrigin()):Normalized()*radius
		local units = FindUnitsInRadius(attacker:GetTeam(),pos,nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY,19,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)
		local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf",PATTACH_CENTER_FOLLOW,attacker)
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

function handleAbilityExecuted(event)
	local event_ability = event.event_ability
	if event_ability:GetName() == "magnataur_empower" then
		event.target:AddNewModifier(
			event.caster, event_ability, 
			"modifier_magnataur_empower_cleave_lua", 
			{ duration = event_ability:GetSpecialValueFor("empower_duration") })
	end
end
