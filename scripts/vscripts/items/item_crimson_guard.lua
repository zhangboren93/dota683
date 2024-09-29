item_crimson_guard_lua = class({
	GetIntrinsicModifierName = function()
		return "modifier_item_crimson_guard_lua"
	end,
	OnSpellStart = function(self)
		local caster = self:GetCaster()
		local units = FindUnitsInRadius(caster:GetTeam(),
			caster:GetAbsOrigin(), nil,
			750,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO, 0, 0, false)
		for i=1,#units do
			if not units[i]:HasModifier("modifier_item_crimson_guard_nostack_lua") then
				local modifier = units[i]:AddNewModifier(caster, self, "modifier_item_crimson_guard_extra_lua", { duration = 10 })
				modifier.particleId = ParticleManager:CreateParticle("particles/items2_fx/vanguard_active.vpcf", PATTACH_OVERHEAD_FOLLOW, units[i])
				ParticleManager:SetParticleControlEnt(modifier.particleId, 0, units[i], PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", Vector(0, 0, 0), false)
				ParticleManager:SetParticleControlEnt(modifier.particleId, 1, units[i], PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0, 0, 0), false)
				units[i]:AddNewModifier(caster, self, "modifier_item_crimson_guard_nostack_lua", { duration = 70 })
			end
		end
		caster:EmitSound("Item.CrimsonGuard.Cast")
	end
})
