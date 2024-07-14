modifier_elder_titan_echo_stomp_lua = class({})

function modifier_elder_titan_echo_stomp_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_elder_titan_echo_stomp_lua:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true
	}
end

function modifier_elder_titan_echo_stomp_lua:OnTakeDamage(event)
	-- do nothing in the initial stun duration
	if event.unit ~= self:GetParent() then return end
	local initial_stun_duration = self:GetAbility():GetSpecialValueFor("initial_stun_duration")
	local sleep_duration = self:GetAbility():GetSpecialValueFor("sleep_duration")
	if self:GetRemainingTime() > sleep_duration - initial_stun_duration then
		return
	end
	if event.attacker:IsHero() or event.attacker:IsControllableByAnyPlayer() then
		self:Destroy()
	end
end
