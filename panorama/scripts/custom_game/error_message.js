
GameEvents.Subscribe( "courier_shared", OnCourierShared);
GameEvents.Subscribe( "error_message_clear", ClearErrorMsg);

function OnCourierShared() {
    $("#courier_shared_label").text = "信使已分享";
}

function ClearErrorMsg() {
    $("#courier_shared_label").text = "";
}