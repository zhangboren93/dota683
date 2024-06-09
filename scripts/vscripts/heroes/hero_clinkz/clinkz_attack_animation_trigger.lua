HERO_2_ASP = {
	npc_dota_hero_clinkz = -58,
	npc_dota_hero_axe = -20,
	npc_dota_hero_crystal_maiden = -19,
	npc_dota_hero_drow_ranger = -29
}
hero_attack_point_adjust_lua = class({})
function hero_attack_point_adjust_lua:GetIntrinsicModifierName()
	return "modifier_clinkz_attack_animation"
end

if modifier_clinkz_attack_animation == nil then
	modifier_clinkz_attack_animation = class({})
end

function modifier_clinkz_attack_animation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE
	}
	return funcs
end

function modifier_clinkz_attack_animation:GetModifierAttackSpeedPercentage()
	return HERO_2_ASP[self:GetParent():GetName()]
end

function modifier_clinkz_attack_animation:IsHidden()
	return true
end
