modifier_damage_absorb_lua = class({ 
	RemoveOnDeath           = function(self) return true end,
	IsPurgable				= function(self) return false end,
	DeclareFunctions        = function(self) return { MODIFIER_PROPERTY_AVOID_DAMAGE_AFTER_REDUCTIONS } end,
	GetTexture				= function(self) return "templar_assassin_refraction" end
})

function modifier_damage_absorb_lua:OnCreated()
	if not IsServer() then return end

	if self.refraction_particle then
		ParticleManager:DestroyParticle(self.refraction_particle, false)
		ParticleManager:ReleaseParticleIndex(self.refraction_particle)
	end

	self.refraction_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.refraction_particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(self.refraction_particle, false, false, -1, true, false)

	local ability = self:GetAbility()
	
	self.instances			= ability:GetSpecialValueFor("instances")
	self.damage_threshold	= ability:GetSpecialValueFor("damage_threshold")
end

function modifier_damage_absorb_lua:OnRefresh()
	self:OnCreated()
end

function modifier_damage_absorb_lua:OnStackCountChanged(PreviousCount)
	if self:GetStackCount() <= 0 then
		self:Destroy()
	end
end

function modifier_damage_absorb_lua:OnDestroy()
	if not IsServer() then return end
	
	if self.refraction_particle then
		ParticleManager:DestroyParticle(self.refraction_particle, false)
		ParticleManager:ReleaseParticleIndex(self.refraction_particle)
	end
end

function modifier_damage_absorb_lua:GetModifierAvoidDamageAfterReductions(event)
	local damage = event.damage
	if bit.band(event.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) > 0
		or damage <= self.damage_threshold 
		or event.attacker == nil then
			return 0
	end

	local parent = self:GetParent()

	parent:EmitSound("Hero_TemplarAssassin.Refraction.Absorb")
		
	local warp_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refract_plasma_contact_warp.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:ReleaseParticleIndex(warp_particle)
	local hit_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refract_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt(hit_particle, 2, parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(hit_particle)

	self:DecrementStackCount()
	return damage
end