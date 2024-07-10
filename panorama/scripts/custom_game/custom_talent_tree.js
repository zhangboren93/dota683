function IntervalCheck(panel, isConst)
{
	let hero = Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID());
	let ability = Entities.GetAbilityByName(hero, "special_bonus_attributes")
	if(ability != null && ability != undefined)
	{
		let lvl = Abilities.GetLevel(ability);
		for(var i = 0; i < lvl; i++)
		{
			let StatBox = panel.FindChildTraverse("StatUp" + i);
			StatBox.AddClass("active_level");
			StatBox.RemoveClass("next_level");
		}
		if(lvl > 0) // When will level be smaller than 0? IDK.
		{
			if(lvl < 10)
			{
				panel.FindChildTraverse("StatUp" + lvl).AddClass("next_level");
				panel.RemoveClass("StatBranchComplete");
				panel.AddClass("StatBranchActive");
				if(lvl * 2 + 1 <= Entities.GetLevel(hero))
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
	IntervalCheck($("#UpgradeStat"), 1);
})();
