--[[Author: Pizzalol
	Date: 25.02.2015.
	Determines if it should deal the extra damage depending on the targets level]]
require("../../items/item_sphere")
require("items/item_magic_stick")
function LvlDeath( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	ProcsMagicStick(keys)
	if is_spell_blocked_by_linkens_sphere(target) then return end
	target:AddNewModifier(caster, ability, "modifier_stunned", { duration = 0.01 })
	local base_damage = ability:GetSpecialValueFor("damage")
	ApplyDamage({victim = target, attacker = caster, damage = base_damage, damage_type = DAMAGE_TYPE_MAGICAL})
	
	-- Particle
	local bonus_particle = keys.bonus_particle

	-- Ability variables
	local lvl_bonus_multiple = ability:GetLevelSpecialValueFor("lvl_bonus_multiple", ability_level)
	local lvl_bonus_damage = ability:GetLevelSpecialValueFor("lvl_bonus_damage", ability_level) / 100
	local target_max_hp = target:GetMaxHealth()
	local target_level = target:GetLevel()

	-- Checking if it passes the level requirement
	if target_level % lvl_bonus_multiple == 0 or target_level == 25 then
		local damage_table = {}

		-- Initialize the damage table
		damage_table.attacker = caster
		damage_table.victim = target
		damage_table.damage_type = ability:GetAbilityDamageType()
		damage_table.ability = ability
		damage_table.damage = target_max_hp * lvl_bonus_damage

		-- Create the bonus damage particle and apply the damage
		local particle = ParticleManager:CreateParticle(bonus_particle, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:ReleaseParticleIndex(particle)

		ApplyDamage(damage_table)
	end
end
