--[[Author: Pizzalol
	Date: 04.03.2015.
	Kills the target and applies a modifier with a duration according to the remaining hp of the target
	Checks if the target is in the allowed table for taking abilities
	If it is then get the abilities of the target and give them to the caster]]

local devour_table = {
	"npc_dota_neutral_kobold_taskmaster",
	"npc_dota_neutral_centaur_khan",
	"npc_dota_neutral_polar_furbolg_ursa_warrior",
	"npc_dota_neutral_ogre_magi",
	"npc_dota_neutral_alpha_wolf",
	"npc_dota_neutral_enraged_wildkin",
	"npc_dota_neutral_satyr_soulstealer",
	"npc_dota_neutral_satyr_hellcaller",
	"npc_dota_neutral_satyr_trickster",	
	"npc_dota_neutral_ghost",
	"npc_dota_neutral_dark_troll_warlord",	
	"npc_dota_neutral_harpy_storm",
	"npc_dota_neutral_forest_troll_high_priest"	
}

function CheckDevourable(ability_name)
{
	return ability_name ~= "neutral_upgrade"
		and ability_name ~= "creep_siege_extra"
		and ability_name ~= "creep_piercing"
		and ability_name ~= "creep_piercing_extra"
		and ability_name ~= "creep_irresolute"
		and ability_name ~= "creep_irresolute_extra"
		and ability_name ~= "creep_weak"
		and ability_name ~= "creep_basic"
		and ability_name ~= "creep_strong"
		and ability_name ~= "generic_hidden"
}

function Devour( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local target_hp = target:GetHealth()
	local health_per_second = ability:GetLevelSpecialValueFor("health_per_second", ability_level)
	local modifier = keys.modifier
	local modifier_duration = target_hp/health_per_second

	-- Apply the modifier and kill the target
	ability:ApplyDataDrivenModifier(caster, caster, modifier, {duration = modifier_duration})
	target:Kill(ability, caster)

	-- Setting up the table for allowed devour targets
	local doom_empty1 = keys.doom_empty1
	local doom_empty2 = keys.doom_empty2

	-- Checks if the killed unit is in the table for allowed targets
	for _,v in ipairs(devour_table) do
		if target:GetUnitName() == v then
			-- Get the first two abilities
			local ability1 = target:GetAbilityByIndex(0)
			local ability2 = target:GetAbilityByIndex(1)

			-- If we already devoured a target and stole an ability from before then clear it
			if caster.devour_ability1 then
				caster:SwapAbilities(doom_empty1, caster.devour_ability1, true, false)
				caster:RemoveAbility(caster.devour_ability1)
			end

			if caster.devour_ability2 then
				caster:SwapAbilities(doom_empty2, caster.devour_ability2, true, false) 
				caster:RemoveAbility(caster.devour_ability2)
			end

			-- Checks if the ability actually exist on the target
			if ability1 and CheckDevourable(ability1:GetAbilityName()) then
				-- Get the name and add it to the caster
				local ability1_name = ability1:GetAbilityName()
				caster:AddAbility(ability1_name)

				-- Make the stolen ability active, level it up and save it in the caster handle for later checks
				caster:SwapAbilities(doom_empty1, ability1_name, false, true)
				caster.devour_ability1 = ability1_name
				caster:FindAbilityByName(ability1_name):SetLevel(1)
			end

			-- Checks if the ability actually exist on the target
			if ability2 and CheckDevourable(ability2:GetAbilityName()) then
				-- Get the name and add it to the caster
				local ability2_name = ability2:GetAbilityName()
				caster:AddAbility(ability2_name)

				-- Make the stolen ability active, level it up and save it in the caster handle for later checks
				caster:SwapAbilities(doom_empty2, ability2_name, false, true)
				caster.devour_ability2 = ability2_name
				caster:FindAbilityByName(ability2_name):SetLevel(1)
			end
		end
	end
end

--[[Author: Pizzalol
	Date: 04.03.2015.
	Awards the bonus gold to the modifier owner only if the modifier owner is alive]]
function DevourGold( keys )
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local bonus_gold = ability:GetLevelSpecialValueFor("bonus_gold", ability_level)

	-- Give the gold only if the target is alive
	if target:IsAlive() then
		target:ModifyGold(bonus_gold, false, DOTA_ModifyGold_AbilityGold)
		SendOverheadEventMessage(target:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, target, bonus_gold, target:GetPlayerOwner())
	end
end

--[[Author: igo95862, Noya
	Used by: Pizzalol
	Date: 27.01.2016.
	Disallows eating another unit while Devour is in progress]]
function DevourCheck( keys )
	local caster = keys.caster
	local modifier = keys.modifier
	local player = caster:GetPlayerOwner()
	local pID = caster:GetPlayerOwnerID()
	local target = keys.target

	if caster:HasModifier(modifier) then
		caster:Interrupt()

		-- Play Error Sound
		EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", player)
	end
end
