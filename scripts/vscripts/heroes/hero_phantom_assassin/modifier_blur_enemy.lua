modifier_blur_enemy_lua = class({
	CheckState = function() 
		return {
			[ MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES ] = true
		}
	end,
	GetEffectName = function() return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_blur.vpcf" end,
	GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end
})
