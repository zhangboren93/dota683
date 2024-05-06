require("../../items/item_magic_stick")
function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	ProcsMagicStick(event)
	if caster:HasScepter() then
		buildings = FindUnitsInRadius(
			caster:GetTeam(),
			caster:GetAbsOrigin(), 
			nil,
			20000,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_BUILDING,
			DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
			FIND_ANY_ORDER,
			false)
		for i=1,#buildings do
			ability:ApplyDataDrivenModifier(caster, buildings[i], "modifier_guardian_angel", {})
			buildings[i].guardian_angel_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf",
				PATTACH_ABSORIGIN, buildings[i])
		end
	end
end

function handleDestroy(event)
	local target = event.target
	if target.guardian_angel_particle ~= nil then
		ParticleManager:DestroyParticle(target.guardian_angel_particle, false)
		ParticleManager:ReleaseParticleIndex(target.guardian_angel_particle)
		target.guardian_angel_particle = nil
	end
end
