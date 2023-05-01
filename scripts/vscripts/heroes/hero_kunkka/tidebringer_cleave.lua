if modifier_tidebringer_cleave == nil then
	modifier_tidebringer_cleave = class({})
end

function modifier_tidebringer_cleave:OnCreated(kv)
	self.kv = kv
end

function modifier_tidebringer_cleave:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_tidebringer_cleave:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_PROCESS_CLEAVE,
	}
	return funcs
end

function modifier_tidebringer_cleave:IsHidden()
	return true
end

function modifier_tidebringer_cleave:OnProcessCleave(event)
	local attacker = event.attacker
	local target = event.target
	if attacker == self:GetParent() and not target:IsBuilding() and attacker:GetTeam() ~= target:GetTeam() then
		local ability = attacker:FindAbilityByName("kunkka_tidebringer")
		if not ability:IsCooldownReady() and ability:GetCooldown(ability:GetLevel() - 1) ~= ability:GetCooldownTimeRemaining() then
			return
		end
		local pct = ability:GetSpecialValueFor("cleave_damage")
		local radius = ability:GetSpecialValueFor("cleave_radius")
		local damage = event.damage * pct /100
		local pos = attacker:GetOrigin()+(target:GetOrigin()-attacker:GetOrigin()):Normalized()*radius
		-- DebugDrawCircle(pos,Vector(200,200,200),15,radius,true,1)
		local units = FindUnitsInRadius(attacker:GetTeam(),pos,nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY,19,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)
		-- TODO fix effect
	--	local effect = ParticleManager:CreateParticle("particles/heroes/kunkka/kunkka_spell_tidebringer.vpcf",PATTACH_CENTER_FOLLOW,attacker)
	--	ParticleManager:SetParticleControlOrientationFLU(effect,0,attacker:GetForwardVector()*CalcDistanceBetweenEntityOBB(attacker,target),attacker:GetRightVector(),attacker:GetUpVector())
	--	ParticleManager:SetParticleControlEnt(effect,1,target,PATTACH_CENTER_FOLLOW,"",Vector(0,0,0),false)

		local n = 2
		for k,v in ipairs(units) do
			if v ~= target then
		--		ParticleManager:SetParticleControl(effect, n, v:GetOrigin() )
				ApplyDamage({
					attacker = attacker,
					victim = v,
					damage = damage,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR,
					ability = ability
				})
				n = n + 1
			end
		end
		--for i = n,19 do
		--	ParticleManager:SetParticleControl(effect,i,Vector(0,0,-2000))
		--end
		--ParticleManager:ReleaseParticleIndex(effect)
	end
end

function modifier_tidebringer_cleave:IsDebuff()
	return false
end