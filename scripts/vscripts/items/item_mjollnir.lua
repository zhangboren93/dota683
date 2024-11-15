function shield_triggered(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local damage = ability:GetSpecialValueFor("static_damage")
	local static_radius = ability:GetSpecialValueFor("static_range")
	local count = ability:GetSpecialValueFor("static_count") - 1

	local time = GameRules:GetGameTime()
	if attacker:IsBuilding() then
		return
	end
	if ability.staticTime == nil or time - ability.staticTime > 1 then
		ability.staticTime = time

		if not attacker:IsMagicImmune() and (attacker:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= 900 then
			local particle = ParticleManager:CreateParticle( "particles/items_fx/chain_lightning.vpcf", PATTACH_POINT_FOLLOW, target )
			ParticleManager:SetParticleControl(particle,0,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
			ParticleManager:SetParticleControl(particle,1,Vector(attacker:GetAbsOrigin().x,attacker:GetAbsOrigin().y,attacker:GetAbsOrigin().z + attacker:GetBoundingMaxs().z ))   
			ApplyDamage({ victim = attacker, attacker = ability:GetCaster(), damage = damage,	damage_type = DAMAGE_TYPE_MAGICAL })
		end

		local units = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, 
				static_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0,
				FIND_ANY_ORDER, false)
		-- randomly pick units
		local filtered_units = {}
		for i=1,#units do
			if units[i] ~= attacker and not units[i]:IsBuilding() and not units[i]:IsMagicImmune() then
				table.insert(filtered_units, units[i])
			end
		end
		if #filtered_units > count then
			local randomed_units = {}
			for i=1,count do
				idx = RandomInt(1, #filtered_units)
				table.insert(randomed_units, filtered_units[idx])
				table.remove(filtered_units, idx)
			end
			units = randomed_units
		else
			units = filtered_units
		end

		for i=1,#units do
			local particle = ParticleManager:CreateParticle( "particles/items_fx/chain_lightning.vpcf", PATTACH_POINT_FOLLOW, target )
			ParticleManager:SetParticleControl(particle,0,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
			ParticleManager:SetParticleControl(particle,1,Vector(units[i]:GetAbsOrigin().x,units[i]:GetAbsOrigin().y,units[i]:GetAbsOrigin().z + units[i]:GetBoundingMaxs().z ))   
			ApplyDamage({ victim = units[i], attacker = ability:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
		end
		target:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
	end
end

item_mjollnir_datadriven = class({})

function item_mjollnir_datadriven:GetIntrinsicModifierName()
	return "modifier_item_maelstrom_datadriven"
end

function item_mjollnir_datadriven:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	caster:EmitSound("DOTA_Item.Mjollnir.Activate")
	target:AddNewModifier(caster, self, "modifier_item_mjollnir_shield_datadriven", { duration = self:GetSpecialValueFor("static_duration") })
end
