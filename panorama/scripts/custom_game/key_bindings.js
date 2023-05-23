function OnCustomeGameSelectCourier()
{
    var entities = Entities.GetAllEntitiesByName("npc_dota_courier");
    entities.forEach(element => {
        if (Entities.GetTeamNumber(element) == Players.GetTeam(Players.GetLocalPlayer())) {
            GameUI.SelectUnit(element, false);
        }
    });
    //$("#courier_shared_label").text = entities.length + " " + Players.GetLocalPlayer() + " " + Players.GetTeam(Players.GetLocalPlayer());
}

function OnCustomGameCourierSend()
{
    //$("#courier_shared_label").text="4322523354";
}

Game.AddCommand( "CustomGameSelectCourier", OnCustomeGameSelectCourier, "", 0 );
Game.AddCommand( "CustomGameCourierSend", OnCustomGameCourierSend, "", 0 );