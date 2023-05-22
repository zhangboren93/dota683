function OnCustomeGameSelectCourier()
{
  $("#courier_shared_label").text="sd12eqwsdfasf"
}

function OnCustomGameCourierSend()
{
  $("#courier_shared_label").text="4322523354"
}

Game.AddCommand( "CustomGameSelectCourier", OnCustomeGameSelectCourier, "", 0 );
Game.AddCommand( "CustomGameCourierSend", OnCustomGameCourierSend, "", 0 );