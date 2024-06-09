DM_HERO_POOL = {
	"npc_dota_hero_abaddon"				,
	"npc_dota_hero_ancient_apparition"	 ,
	"npc_dota_hero_antimage"			,
	"npc_dota_hero_arc_warden"			,
	"npc_dota_hero_axe"					,
	"npc_dota_hero_bane"				,
	"npc_dota_hero_beastmaster"			,
	"npc_dota_hero_brewmaster"			,
	"npc_dota_hero_centaur"				,
	"npc_dota_hero_chaos_knight"		,
	"npc_dota_hero_crystal_maiden"		,
	"npc_dota_hero_dazzle"				,
	"npc_dota_hero_dragon_knight"		,
	"npc_dota_hero_drow_ranger"			,
	"npc_dota_hero_earthshaker"			,
	"npc_dota_hero_faceless_void"		,
	"npc_dota_hero_juggernaut"			,
	"npc_dota_hero_leshrac"				,
	"npc_dota_hero_lich"				,
	"npc_dota_hero_life_stealer"		,
	"npc_dota_hero_lina"				,
	"npc_dota_hero_lion"				,
	"npc_dota_hero_luna"				,
	"npc_dota_hero_lycan"				,
	"npc_dota_hero_magnataur"			,
	"npc_dota_hero_medusa"				,
	"npc_dota_hero_morphling"			,
	"npc_dota_hero_naga_siren"			,
	"npc_dota_hero_nevermore"			,
	"npc_dota_hero_night_stalker"		,
	"npc_dota_hero_nyx_assassin"		,
	"npc_dota_hero_obsidian_destroyer"	,
	"npc_dota_hero_ogre_magi"			,
	"npc_dota_hero_omniknight"			,
	"npc_dota_hero_oracle"				,
	"npc_dota_hero_pugna"				,
	"npc_dota_hero_rattletrap"			,
	"npc_dota_hero_razor"				,
	"npc_dota_hero_shadow_demon"		,
	"npc_dota_hero_shadow_shaman"		,
	"npc_dota_hero_skeleton_king"		,
	"npc_dota_hero_skywrath_mage"		,
	"npc_dota_hero_slardar"				,
	"npc_dota_hero_slark"				,
	"npc_dota_hero_sniper"				,
	"npc_dota_hero_spirit_breaker"		,
	"npc_dota_hero_sven"				,
	"npc_dota_hero_terrorblade"			,
	"npc_dota_hero_tidehunter"			,
	"npc_dota_hero_troll_warlord"		,
	"npc_dota_hero_tusk"				,
	"npc_dota_hero_vengefulspirit"		,
	"npc_dota_hero_viper"				,
	"npc_dota_hero_visage"				,
	"npc_dota_hero_warlock"				,
	"npc_dota_hero_weaver"				,
	"npc_dota_hero_windrunner"			,
	"npc_dota_hero_witch_doctor"		,
	"npc_dota_hero_abyssal_underlord"	,
	"npc_dota_hero_alchemist"			,
	"npc_dota_hero_bounty_hunter"		,
	"npc_dota_hero_clinkz"				,
	"npc_dota_hero_death_prophet"		,
	"npc_dota_hero_disruptor"			,
	"npc_dota_hero_earth_spirit"		,
	"npc_dota_hero_elder_titan"			,
	"npc_dota_hero_ember_spirit"		,
	"npc_dota_hero_enigma"				,
	"npc_dota_hero_gyrocopter"			,
	"npc_dota_hero_huskar"				,
	"npc_dota_hero_jakiro"				,
	"npc_dota_hero_keeper_of_the_light"	,
	"npc_dota_hero_phantom_assassin"	,
	"npc_dota_hero_phoenix"				,
	"npc_dota_hero_sand_king"			,
	"npc_dota_hero_shredder"			,
	"npc_dota_hero_silencer"			,
	"npc_dota_hero_tinker"				,
	"npc_dota_hero_tiny"				,
	"npc_dota_hero_treant"				,
	"npc_dota_hero_venomancer"			,
	"npc_dota_hero_winter_wyvern"		,
	"npc_dota_hero_bristleback"			,
	"npc_dota_hero_storm_spirit"		,
	"npc_dota_hero_wisp"				,
	"npc_dota_hero_dark_seer"			,
	"npc_dota_hero_mirana"				,
	"npc_dota_hero_necrolyte"			,
	"npc_dota_hero_puck"				,
	"npc_dota_hero_pudge"				,
	"npc_dota_hero_queenofpain"			,
	"npc_dota_hero_riki"				,
	"npc_dota_hero_rubick"				,
	"npc_dota_hero_techies"				,
	"npc_dota_hero_templar_assassin"	,
	"npc_dota_hero_zuus"				,
	"npc_dota_hero_batrider"			,
	"npc_dota_hero_bloodseeker"			,
	"npc_dota_hero_broodmother"			,
	"npc_dota_hero_chen"				,
	"npc_dota_hero_doom_bringer"		,
	"npc_dota_hero_enchantress"			,
	"npc_dota_hero_furion"				,
	"npc_dota_hero_kunkka"				,
	"npc_dota_hero_legion_commander"	,
	"npc_dota_hero_spectre"				,
	"npc_dota_hero_undying"				,
	"npc_dota_hero_ursa"				
}

function deathMatchGameRulesUpdate()
	GameRules:AddHeroToBlacklist("npc_dota_hero_hoodwink")			
	GameRules:AddHeroToBlacklist("npc_dota_hero_dawnbreaker")		
	GameRules:AddHeroToBlacklist("npc_dota_hero_marci")		
	GameRules:AddHeroToBlacklist("npc_dota_hero_primal_beast")		
	GameRules:AddHeroToBlacklist("npc_dota_hero_muerta")		
	GameRules:AddHeroToBlacklist("npc_dota_hero_lone_druid")			
	GameRules:AddHeroToBlacklist("npc_dota_hero_void_spirit")		
	GameRules:AddHeroToBlacklist("npc_dota_hero_snapfire")		
	GameRules:AddHeroToBlacklist("npc_dota_hero_pangolier")			
	GameRules:AddHeroToBlacklist("npc_dota_hero_grimstroke")
	GameRules:AddHeroToBlacklist("npc_dota_hero_dark_willow")
	GameRules:AddHeroToBlacklist("npc_dota_hero_monkey_king")
	GameRules:AddHeroToBlacklist("npc_dota_hero_lone_druid")			
	GameRules:AddHeroToBlacklist("npc_dota_hero_meepo")		
	GameRules:AddHeroToBlacklist("npc_dota_hero_invoker")			
	GameRules:SetHeroRespawnEnabled(false)
	GameRules:SetUseUniversalShopMode(true)
end

RESPAWN_MAX = 44
respawnCount = { 0, 0 }
ITEM_SLOTS = {0, 1, 2, 3, 4, 5, 9, 10, 11, 12, 13, 14}
function deathMatchSpawnHero(entity)
	--Tell if team has used up all 44 random heroes, then no respawn
	if entity:GetTeam() == DOTA_TEAM_GOODGUYS then
		respawnCount[1] = respawnCount[1] + 1
		if respawnCount[1] > RESPAWN_MAX then
			GameRules:SendCustomMessage("天辉没命了，玩家".. entity:GetPlayerOwnerID() .."永久死亡。", -1, -1)
			return
		else
			GameRules:SendCustomMessage("天辉剩".. (44 - respawnCount[1]).."条命。", -1, -1)
		end
	else
		respawnCount[2] = respawnCount[2] + 1
		if respawnCount[2] > RESPAWN_MAX then
			GameRules:SendCustomMessage("夜魇没命了，玩家".. entity:GetPlayerOwnerID() .."永久死亡。", -1, -1)
			return
		else
			GameRules:SendCustomMessage("夜魇剩".. (44 - respawnCount[2]).."条命。", -1, -1)
		end
	end
	
	-- remember all hero items
	-- schedule spawning of a random hero
	local nextRandomHeroIdx = RandomInt(1, #DM_HERO_POOL)
	local nextRandomHero = DM_HERO_POOL[nextRandomHeroIdx]
	table.remove(DM_HERO_POOL, nextRandomHeroIdx)
	local spawnLocation
	if entity:GetTeam() == DOTA_TEAM_GOODGUYS then
		spawnLocation = Vector(-7111, -6618, 520)
	else
		spawnLocation = Vector(7022, 6346, 512)
	end
	local player = entity:GetPlayerOwner()
	local playerid = entity:GetPlayerOwnerID()
	local xp = entity:GetCurrentXP()
	local items = {}
	for i=1,#ITEM_SLOTS do
		local item = entity:GetItemInSlot(ITEM_SLOTS[i])
		if item ~= nil then
			table.insert(items, item)
		end
	end
	print("Respawning player " .. playerid .. " with hero " .. nextRandomHero .. " xp " .. xp .. " items:" )
	for i=1,#items do
		print(items[i]:GetName())
	end
	CreateUnitByNameAsync(nextRandomHero, spawnLocation, true, nil, nil, entity:GetTeam(), function(unit)
		unit:SetIdleAcquire(true)
		unit:SetControllableByPlayer(playerid, false)
		unit:SetOwner(player)
		unit:SetPlayerID(playerid)
		player:SetAssignedHeroEntity(unit)
		unit:AddExperience(xp, DOTA_ModifyXP_Unspecified, false, false)
		for i=1,#items do 
			unit:AddItem(items[i])
			-- reset cd for tp scroll or travel boots
			if items[i]:GetName() == "item_tpscroll" or items[i]:GetName() == "item_travel_boots_datadriven" then
				items[i]:EndCooldown()
			end
		end
		entity:Destroy()
	end)
end

function removeHeroFromDMPool(hero_name)
	for i=1,#DM_HERO_POOL do
		if DM_HERO_POOL[i] == hero_name then
			table.remove(DM_HERO_POOL, i)
			return
		end
	end
end
