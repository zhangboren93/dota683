modifier_torrent_slow_lua = class({})
function modifier_torrent_slow_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_torrent_slow_lua:GetModifierMoveSpeedBonus_Percentage()
	return -35
end

function modifier_torrent_slow_lua:IsPurgable()
	return true
end
