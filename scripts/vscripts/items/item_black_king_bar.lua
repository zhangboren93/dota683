--[[ ============================================================================================================
	Author: Rook, with some of Noya's code for model scaling
	Date: January 29, 2015
	Called when Black King Bar is cast.  Applies the modifier and then updates the cooldown and duration for future casts.
	Additional parameters: keys.MaxLevel, keys.PercentageOverModelScale, and keys.Duration
================================================================================================================= ]]
function item_black_king_bar_datadriven_on_spell_start(keys)
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_item_black_king_bar_datadriven_active", nil)
	keys.caster:EmitSound("DOTA_Item.BlackKingBar.Activate")
	
	--Level up BKB so future casts will use an updated cooldown and duration.
	local current_level = keys.ability:GetLevel()
	if current_level + 1 <= keys.MaxLevel then
		keys.ability:SetLevel(current_level + 1)
		keys.caster.BKBLevel = current_level + 1  --BKB's level is tied to the player, not the item, so store it here.
		
		for i=0, 11, 1 do  --Level up any other BKBs in the player's inventory or stash to match the new level.
			local current_item = keys.caster:GetItemInSlot(i)
			if current_item ~= nil then
				if current_item:GetName() == "item_black_king_bar_datadriven" and current_item:GetLevel() ~= keys.caster.BKBLevel then
					current_item:SetLevel(keys.caster.BKBLevel)
				end
			end
		end
	end

	local final_model_scale = (keys.PercentageOverModelScale / 100) + 1  --This will be something like 1.3.
	local model_scale_increase_per_interval = 100 / (final_model_scale - 1)

	--Scale the model up over time.
	keys.caster:SetModelScale(keys.caster:GetModelScale() * (1 + keys.PercentageOverModelScale / 100))

	--Scale the model back down around the time the duration ends.
	keys.caster:SetThink(function()
		keys.caster:SetModelScale(keys.caster:GetModelScale() / (1 + keys.PercentageOverModelScale / 100))
	end, "reset model scale", keys.Duration)
end



--[[ ============================================================================================================
	Author: Rook
	Date: January 29, 2015
	Called when Black King Bar is created.  Since BKB's level is tied to the player, not the item, set it to the
	appropriate level.
================================================================================================================= ]]
function modifier_item_black_king_bar_datadriven_on_created(keys)
	if keys.caster.BKBLevel ~= nil and keys.caster.BKBLevel ~= keys.ability:GetLevel() then
		keys.ability:SetLevel(keys.caster.BKBLevel)
	end
end