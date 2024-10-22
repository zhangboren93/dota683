function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local duration = ability:GetSpecialValueFor("windwalk_duration")
	local fade = ability:GetSpecialValueFor("windwalk_fade_time")
	caster:SetThink(function()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_silver_edge_windwalk_datadriven", { duration = duration })
		caster:AddNewModifier(caster, ability, "modifier_invisible", { duration = duration })
	end, "silver edge fade.", fade)
end

function handleAttackLanded(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local duration = ability:GetSpecialValueFor("backstab_duration")
	ability:ApplyDataDrivenModifier(caster, target, "modifier_silver_edge_debuff_datadriven", { duration = duration })
	caster:RemoveModifierByName("modifier_item_silver_edge_windwalk_datadriven")
	target:EmitSound("DOTA_Item.SilverEdge.Target")
end

function handleAttackMissed(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	caster:RemoveModifierByName("modifier_item_silver_edge_windwalk_datadriven")
end

function handleAbilityExecuted(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	caster:RemoveModifierByName("modifier_item_silver_edge_windwalk_datadriven")
	caster:EmitSound("DOTA_Item.InvisibilitySword.Activate")
end
