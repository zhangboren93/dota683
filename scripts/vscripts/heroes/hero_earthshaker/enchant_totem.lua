function handleAbilityPhaseStart(event)
	local caster = event.caster
	caster:SetThink(function()
		caster:StartGesture( ACT_DOTA_CAST_ABILITY_2 )
	end, "cast totem later", 0.2)
end

function handleOrder(event)
	local caster = event.caster
	caster:StopThink("cast totem later")
	caster:FadeGesture( ACT_DOTA_CAST_ABILITY_2 )
end
