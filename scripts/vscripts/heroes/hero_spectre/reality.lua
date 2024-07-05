function handleIntervalThink(event)
	local caster = event.caster
	local haunt = caster:FindAbilityByName("spectre_haunt")
	local reality = caster:FindAbilityByName("spectre_reality_datadriven")
	if haunt:GetLevel() > 0 and reality:GetLevel() == 0 then
		reality:SetLevel(1)
	end
end

function handleSpellStart(event)
	local target_point = event.target_points[1]
	local caster = event.caster
	-- find the closest haunt spectre
	local spectres = Entities:FindAllByName("npc_dota_hero_spectre")
	local closest = nil
	for i=1,#spectres do
		if spectres[i]:HasModifier("modifier_spectre_haunt") then
			if closest == nil then
				closest = spectres[i]
			else
				if (spectres[i]:GetAbsOrigin() - target_point):Length2D()
					< (closest:GetAbsOrigin() - target_point):Length2D() then
					closest = spectres[i]
				end
			end
		end
	end
	if closest == nil then return end
	local closest_location = closest:GetAbsOrigin()
	closest:ForceKill(false)
	FindClearSpaceForUnit(caster, closest_location, true)
	caster:EmitSound("Hero_Spectre.Reality")
end
