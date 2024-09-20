function handleSpellStart(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local fade_time = ability:GetSpecialValueFor("fade_time")
	if target == caster then
		caster:SetThink(function()
			ability:EndCooldown()
		end, 'end amulet cooldown', 0.1)
	end
	if target.shadow_amulet_particle == nil then
		target.shadow_amulet_particle = ParticleManager:CreateParticle("particles/items2_fx/shadow_amulet.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_item_shadow_amulet_fade_datadriven", {})
	target:EmitSound("DOTA_Item.ShadowAmulet.Activate")
end

function handleFade(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local modifier = target:FindModifierByName("modifier_item_shadow_amulet_fade_datadriven")
	if modifier:GetElapsedTime() >= 1.5 and not target:HasModifier("modifier_invisible") then
		target:AddNewModifier(caster, ability, "modifier_invisible", {})
		modifier.shadow_position = target:GetAbsOrigin()
		return
	end
	if target:HasModifier("modifier_invisible") and modifier.shadow_position ~= nil then
		local pos = target:GetAbsOrigin()
		if (modifier.shadow_position - pos):Length2D() > 10 then
			target:RemoveModifierByName("modifier_invisible")
			target:RemoveModifierByName("modifier_item_shadow_amulet_fade_datadriven")
			return
		end
	end
end

function handleDestroy(event)
	local target = event.target
	if target.shadow_amulet_particle ~= nil then
		ParticleManager:DestroyParticle(target.shadow_amulet_particle, false)
		target.shadow_amulet_particle = nil
	end
end
