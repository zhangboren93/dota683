function handleAbilityExecuted(event)
	if event.event_ability:GetName() == "lich_frost_armor" or
		event.event_ability:GetName() == "lich_frost_armor_2" then
		event.target:EmitSound("n_creep_OgreMagi.FrostArmor")
	elseif event.event_ability:GetName() == "lich_dark_ritual_datadriven" or
		event.event_ability:GetName() == "lich_dark_ritual_datadriven_2" then
		event.caster:EmitSound("Hero_Lich.SinisterGaze.Cast")
		event.caster:SetThink(function()
			event.caster:StopSound("Hero_Lich.SinisterGaze.Cast")
		end, "stop sound", 1)
	end
end
