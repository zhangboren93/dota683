require("items/lifesteal_common")
function VladmirAuraApply(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	if not target:IsIllusion() and not target:IsBuilding() and target:GetTeam() ~= attacker:GetTeam() then
		if not IsUnitLifeStealable(target) then return end
		local damage = event.Damage
		local lifesteal_percent = ability:GetSpecialValueFor("lifesteal_aura_percent")
		attacker:Heal(damage * lifesteal_percent / 100, ability)
		local particleId = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker)
		ParticleManager:ReleaseParticleIndex(particleId)
	end
end
