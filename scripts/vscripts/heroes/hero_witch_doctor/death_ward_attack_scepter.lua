death_ward_attack_scepter_lua = class({})

function death_ward_attack_sceptert :GetIntrinsicModifierName()
	return "modifier_death_ward_attack_scepter_lua"
end

function death_ward_attack_scepter:OnProjectileHit_ExtraData(target, location, data)
	DeepPrintTable(data)
	return true
end
