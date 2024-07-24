require("cleave_units_check")
if item_bfury_cleave_lua == nil then
    item_bfury_cleave_lua = class({})
end

function item_bfury_cleave_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function item_bfury_cleave_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_PROCESS_CLEAVE,
	}
	return funcs
end

function item_bfury_cleave_lua:OnProcessCleave(event)
	local attacker = event.attacker
	local target = event.target
    local ability = self:GetAbility()
	if attacker == self:GetParent() and passCleaveUnitCheck(attacker, target) then
		local pct = ability:GetSpecialValueFor("cleave_damage_percent")
		local radius = ability:GetSpecialValueFor("cleave_radius")
		local damage = event.damage * pct /100
		local pos = attacker:GetOrigin()+(target:GetOrigin()-attacker:GetOrigin()):Normalized()*radius
		-- If ember's cleaves a random direction
		if attacker:HasModifier("modifier_ember_spirit_sleight_of_fist_in_progress") then
			pos = target:GetOrigin() + RandomVector(radius - 128)
		end
		local units = FindUnitsInRadius(attacker:GetTeam(),pos,nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)

		local effect = ParticleManager:CreateParticle("particles/items_fx/battlefury_cleave.vpcf",PATTACH_CENTER_FOLLOW,attacker)
		ParticleManager:SetParticleControlOrientationFLU(effect,0,attacker:GetForwardVector()*CalcDistanceBetweenEntityOBB(attacker,target),attacker:GetRightVector(),attacker:GetUpVector())
		ParticleManager:SetParticleControlEnt(effect,1,target,PATTACH_POINT_FOLLOW,"attach_hitloc",target:GetAbsOrigin(),false)

		for k,v in ipairs(units) do
			if v ~= target
				-- cleave won't work for dragon ancient camp
				and string.find(v:GetModelName(), "black_dragon") == nil
				and string.find(v:GetModelName(), "black_drake") == nil then
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
		ParticleManager:ReleaseParticleIndex(effect)
	end
end

function item_bfury_cleave_lua:IsHidden()
    return true
end

function handleIntervalThink(event)
    event.caster:AddNewModifier(event.caster, event.ability, "item_bfury_cleave_lua", {}):SetDuration(1, true)
end
