HERO_2_ASP = {
	npc_dota_hero_clinkz = -57,
	npc_dota_hero_axe = -20,
	npc_dota_hero_crystal_maiden = -18,
	npc_dota_hero_drow_ranger = -28.6,
	npc_dota_hero_lina = -13.3,
	npc_dota_hero_luna = -24,
	npc_dota_hero_visage = -13,
	npc_dota_hero_weaver = -14,
	npc_dota_hero_death_prophet = -10.7,
	npc_dota_hero_huskar = -25,
	npc_dota_hero_tiny = -18.4,
	npc_dota_hero_necrolyte = -43.4,
	npc_dota_hero_zuus = -44.7,
	npc_dota_hero_monkey_king = -10,
	npc_dota_hero_muerta = -30,
	npc_dota_hero_mars = -20,
	npc_dota_hero_snapfire = 16.7,
	npc_dota_hero_grimstroke = 31.4
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
