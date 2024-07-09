modifier_techies_stasis_trap_explode_sound_lua = class({
	OnDestroy = function(self) 
		if not IsServer() then return end
		--TODO use real stasis trap detonate sound
		EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Techies.StickyBomb.Detonate", self:GetCaster())
	end
})
