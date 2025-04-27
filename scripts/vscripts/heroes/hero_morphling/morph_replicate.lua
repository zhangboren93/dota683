require("../../items/item_magic_stick")
morphling_morph_replicate_datadriven = class({
    GetAssociatedPrimaryAbilities = function() return "morphling_replicate_datadriven" end,
	OnSpellStart = function(self)
	    print("OnSpellStart")
		local caster = self:GetCaster()
		local replica = caster.replica
		if replica ~= nil and replica:IsAlive() then
			local pid = ParticleManager:CreateParticle("particles/units/heroes/hero_morphling/morphling_replicate_finish.vpcf",
				PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControlEnt(pid, 0, caster, PATTACH_ABSORIGIN, "attach_hitloc", Vector(0, 0, 0), false)

			ProcsMagicStick({ caster = caster })
			caster:SetAbsOrigin(replica:GetAbsOrigin())
			replica:ForceKill(false)
			caster.replica = nil
		else
			caster:GiveMana(150)
		end
		self:SetActivated(false)
	end
})
