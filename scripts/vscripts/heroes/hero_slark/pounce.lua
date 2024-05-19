modifier_slark_pounce_leash_lua = class({})

function modifier_slark_pounce_leash_lua:OnCreated(keys)
	if not IsServer() then return end
	local caster = self:GetCaster()
	local target = self:GetParent()
	self.leash_loc = caster:GetAbsOrigin()
 	self.leash_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_pounce_leash.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(self.leash_particle, 1, caster:GetAbsOrigin())
    ParticleManager:SetParticleControlEnt(self.leash_particle, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
end

function modifier_slark_pounce_leash_lua:CheckState() 
	local leash_loc = self.leash_loc
	local target = self:GetParent()
	if not IsServer() then return {} end
	
	if (target:GetAbsOrigin() - leash_loc):Length2D() > 425 then
		self:Destroy()
		return {}
	end

	if not target:IsCurrentlyHorizontalMotionControlled() 
		and (target:GetAbsOrigin() - leash_loc):Length2D() > 325 
		and target:GetForwardVector():Dot(target:GetAbsOrigin() - leash_loc) > 0 then
		return {
			[MODIFIER_STATE_ROOTED] = true
		}
	end

	return { }
end

function modifier_slark_pounce_leash_lua:IsPurgable()
	return true
end

function modifier_slark_pounce_leash_lua:OnDestroy()
	if not IsServer() then return end
    ParticleManager:DestroyParticle(self.leash_particle, false)
    ParticleManager:ReleaseParticleIndex(self.leash_particle)
end
