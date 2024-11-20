function handleIntervalThink(event)
	local caster = event.caster
	local ability = event.ability
	if ability:IsCooldownReady() then
		if not caster:HasModifier("modifier_tidebringer_cleave") and not caster:IsAttacking() then
			caster:AddNewModifier(caster, ability, "modifier_tidebringer_cleave", {})
		end
	end
end

function handleAttack(event)
	local caster = event.caster
	caster:SetThink(function()
		local ability = event.ability
		if ability:IsCooldownReady() then
			if not caster:HasModifier("modifier_tidebringer_cleave") then
				caster:AddNewModifier(caster, ability, "modifier_tidebringer_cleave", {})
			end
		end
	end, "Adds tidebringer effect.", 0.1)
end

function handleAttackStart(event)
	local caster = event.caster
	local ability = event.ability
	if ability:IsCooldownReady() then
		if not caster:HasModifier("modifier_tidebringer_cleave") and not caster:IsAttacking() then
			caster:AddNewModifier(caster, ability, "modifier_tidebringer_cleave", {})
		end
		return
	end
	local remaining = ability:GetCooldownTimeRemaining()
	local attack_speed = caster:GetAttackSpeed(false)
	local attack_point = caster:GetAttackAnimationPoint()  / attack_speed
	--print("as:" .. attack_speed ..",ap:" .. attack_point .. ",rm:"..remaining)
	if remaining <= attack_point then
		if not caster:HasModifier("modifier_tidebringer_cleave") then
			caster:AddNewModifier(caster, ability, "modifier_tidebringer_cleave", {})
		end
	end
end
