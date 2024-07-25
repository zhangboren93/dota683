function handleSpellStart(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	caster:EmitSound("Hero_Winter_Wyvern.WintersCurse.Cast")
	if target:TriggerSpellAbsorb(ability) then return end
	local caster = event.caster
	local duration = ability:GetSpecialValueFor("duration")
	caster:EmitSound("Hero_Winter_Wyvern.WintersCurse.Target")
	target:AddNewModifier(caster, target, "modifier_winter_wyvern_winters_curse_aura", { duration = duration })
	ability:ApplyDataDrivenModifier(caster, target, "modifier_winter_wyvern_winters_curse_aura_datadriven", {})
end

function handleCreated(event)
	local target = event.target
	local ability = event.ability
	local modifier = target:FindModifierByName("modifier_winter_wyvern_winters_curse_datadriven")
	local aura_owner = modifier:GetAuraOwner()
	target:MoveToTargetToAttack(aura_owner)
end
