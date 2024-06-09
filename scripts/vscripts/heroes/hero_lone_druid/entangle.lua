function StartCooldown( event )
	local caster = event.caster
	local ability = event.ability
	local cooldown = ability:GetCooldown( ability:GetLevel() - 1 )

	-- Start cooldown
	ability:EndCooldown()
	ability:StartCooldown( cooldown )

	-- Disable orb modifier
	caster:RemoveModifierByName( "modifier_lone_druid_spirit_bear_entangle_datadriven" )

	-- Re-enable orb modifier after for the duration
	ability:SetContextThink( DoUniqueString("activateEntangle"), function ()
		-- Here's a magic
		-- Reset the ability level in order to restore a passive modifier
		ability:SetLevel( ability:GetLevel() )	
	end, cooldown + 0.05 )
end