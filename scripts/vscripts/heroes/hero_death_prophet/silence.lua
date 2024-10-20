-- Creator:
--	EarthSalamander, May 12th, 2019
--	Death Prophet Silence Luafied

death_prophet_silence_lua = class({ 
	GetAOERadius = function(self) return self:GetSpecialValueFor("radius") end
})

function death_prophet_silence_lua:GetCooldown(level)
	local ability = self:GetCaster():FindAbilityByName("death_prophet_witchcraft_datadriven")
	if ability ~= nil then
		return 15 + ability:GetSpecialValueFor("silence_cooldown_adjust")
	else
		return 15
	end
end

function death_prophet_silence_lua:GetManaCost(level)
	local ability = self:GetCaster():FindAbilityByName("death_prophet_witchcraft_datadriven")
	if ability ~= nil then
		return 80 + ability:GetSpecialValueFor("silence_mana_cost_adjust")
	else
		return 80
	end
end

function death_prophet_silence_lua:OnSpellStart()
	if IsClient() then return end

	self:GetCaster():EmitSound("Hero_DeathProphet.Silence")

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCursorPosition(),
		nil,
		self:GetSpecialValueFor("radius"),
		self:GetAbilityTargetTeam(),
		self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(),
		FIND_ANY_ORDER,
		false
	)

	local file = "particles/units/heroes/hero_death_prophet/death_prophet_silence.vpcf"

	local pfx = ParticleManager:CreateParticle(file, PATTACH_CUSTOMORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(pfx, 0, self:GetCursorPosition())
	ParticleManager:SetParticleControl(pfx, 1, Vector(self:GetSpecialValueFor("radius"), 0, 1))
	ParticleManager:ReleaseParticleIndex(pfx)

	for _, enemy in pairs(enemies) do
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_death_prophet/death_prophet_silence_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControl(pfx, 0, enemy:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)

		enemy:AddNewModifier(self:GetCaster(), self, "modifier_death_prophet_silence_lua", {duration = self:GetDuration() * (1 - enemy:GetStatusResistance())})
	end
end

if modifier_death_prophet_silence_lua == nil then
	modifier_death_prophet_silence_lua = class({})
end

function modifier_death_prophet_silence_lua:CheckState()
	return
	{
		[MODIFIER_STATE_SILENCED] = true,
	}
end

function modifier_death_prophet_silence_lua:OnCreated()
	if IsClient() then return end

	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_death_prophet/death_prophet_silence_custom.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
	--ParticleManager:SetParticleControl(self.pfx, 1, self:GetParent():GetAbsOrigin())

	self.pfx2 = ParticleManager:CreateParticle("particles/generic_gameplay/generic_silenced.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.pfx2, 0, self:GetParent():GetAbsOrigin())
end

function modifier_death_prophet_silence_lua:OnDestroy()
	if IsClient() then return end

	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end

	if self.pfx2 then
		ParticleManager:DestroyParticle(self.pfx2, false)
		ParticleManager:ReleaseParticleIndex(self.pfx2)
	end
end
