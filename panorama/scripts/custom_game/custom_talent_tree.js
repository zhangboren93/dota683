function IntervalCheck(panel)
{
	let hero = Players.GetLocalPlayerPortraitUnit(); // Which unit am I watching?
	if(!Entities.IsHero(hero))
	{
		$.Schedule(0.033, () => IntervalCheck(panel));
		return;
	}
	let ability = Entities.GetAbilityByName(hero, "special_bonus_attributes")
	if(ability != null && ability != undefined)
	{
		let lvl = Abilities.GetLevel(ability);
		if(Players.GetTeam(Game.GetLocalPlayerID()) != DOTA_GC_TEAM.DOTA_GC_TEAM_SPECTATOR
			&& Players.GetTeam(Game.GetLocalPlayerID()) != Entities.GetTeamNumber(hero))
				lvl = 0;
		for(var i = 0; i < lvl; i++)
		{
			let StatBox = panel.FindChildTraverse("StatUp" + i);
			StatBox.AddClass("active_level");
			StatBox.RemoveClass("next_level");
		}
		if(lvl >= 0) // When will level be smaller than 0? IDK.
		{
			for(var i = lvl; i < 10; i++)
			{
				let StatBox = panel.FindChildTraverse("StatUp" + i);
				StatBox.RemoveClass("active_level");
				StatBox.RemoveClass("next_level");
			}
			if(lvl < 10)
			{
				panel.FindChildTraverse("StatUp" + lvl).AddClass("next_level");
				panel.RemoveClass("StatBranchComplete");
				panel.AddClass("StatBranchActive");
				if(lvl * 2 + 1 <= Entities.GetLevel(hero) && Entities.GetAbilityPoints(hero) > 0)
					panel.AddClass("could_level_up");
				else
					panel.RemoveClass("could_level_up");
			}	
			else
			{
				panel.RemoveClass("StatBranchActive");
				panel.RemoveClass("could_level_up");
				panel.AddClass("StatBranchComplete");
			}
		}
	}
	$.Schedule(0.033, () => IntervalCheck(panel));
}

(function ()
{
	IntervalCheck($("#UpgradeStat"));
})();
