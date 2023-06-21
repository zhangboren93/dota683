-- Destroy trees in line
function handleAbilityExecuted(event)
	local event_ability = event.event_ability
	if event_ability:GetName() == "jakiro_macropyre" then
		local caster = event.caster
		local startPos = caster:GetAbsOrigin()
		local max_range = event_ability:GetCastRange(nil, nil)
		local width = event_ability:GetSpecialValueFor("path_radius")
		local tree_destroy_dist = 200
		while tree_destroy_dist <= max_range do
			GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin() + caster:GetForwardVector() * tree_destroy_dist, width, false)
			tree_destroy_dist = tree_destroy_dist + 200
		end
	end
end