if modifier_tidebringer_cleave == nil then
	modifier_tidebringer_cleave = class({})
end

function modifier_tidebringer_cleave:OnCreated()
	local parent = self:GetParent()
	if parent == nil then return end
	self.particle = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_kunkka/kunkka_weapon_tidebringer.vpcf", 
		PATTACH_POINT_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt(
		self.particle, 2, parent, PATTACH_POINT_FOLLOW, 
		"attach_sword", Vector(0, 0, 0), false)
end

function modifier_tidebringer_cleave:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_tidebringer_cleave:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_PROCESS_CLEAVE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}
	return funcs
end

function modifier_tidebringer_cleave:IsHidden()
	return true
end

function modifier_tidebringer_cleave:OnProcessCleave(event)
	local attacker = event.attacker
	local target = event.target
	local ability = self:GetAbility()
	if attacker ~= self:GetParent() then
		return
	end
	if target:IsBuilding() or attacker:IsIllusion() then
		ability:StartCooldown(-1)
		self:Destroy()
		return
	end
	if attacker:GetTeam() ~= target:GetTeam() then
		local pct = ability:GetSpecialValueFor("cleave_damage")
		local radius = ability:GetSpecialValueFor("cleave_radius")
		local damage = event.damage * pct /100
		local pos = attacker:GetOrigin()+(target:GetOrigin()-attacker:GetOrigin()):Normalized()*radius
		-- DebugDrawCircle(pos,Vector(200,200,200),15,radius,true,1)
		local units = FindUnitsInRadius(attacker:GetTeam(),pos,nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)
		local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf",PATTACH_CENTER_FOLLOW,attacker)
	--	ParticleManager:SetParticleControlOrientationFLU(effect,0,attacker:GetForwardVector()*CalcDistanceBetweenEntityOBB(attacker,target),attacker:GetRightVector(),attacker:GetUpVector())
		ParticleManager:SetParticleControlEnt(effect,1,target,PATTACH_POINT_FOLLOW,"attach_hitloc",target:GetAbsOrigin(),false)

		local n = 2
		for k,v in ipairs(units) do
			if v ~= target
                -- cleave won't work for dragon ancient camp
                and string.find(v:GetModelName(), "black_dragon") == nil
                and string.find(v:GetModelName(), "black_drake") == nil then
				ParticleManager:SetParticleControl(effect, n, v:GetOrigin() + Vector(0, 0, 140))
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
		for i = n,19 do
			ParticleManager:SetParticleControl(effect,i,Vector(0,0,-2000))
		end
		ParticleManager:ReleaseParticleIndex(effect)
		ability:StartCooldown(-1)
		attacker:EmitSound("Hero_Kunkka.Tidebringer.Attack")
		self:Destroy()
	end
end

function modifier_tidebringer_cleave:IsDebuff()
	return false
end

function modifier_tidebringer_cleave:GetActivityTranslationModifiers()
	return "tidebringer"
end

function modifier_tidebringer_cleave:OnDestroy()
	if self.particle then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end
end

function modifier_tidebringer_cleave:GetModifierPreAttack_BonusDamagePostCrit()
	return self:GetAbility():GetSpecialValueFor("damage_bonus")
end
