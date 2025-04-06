GameEvents.Subscribe( "courier_shared", OnCourierShared);

let message_hide_time = 5;
function OnCourierShared(data) {
    $("#courier_shared_label").text = data.text;
	message_hide_time = 5;
}

function ClearErrorMsg() {
	if (message_hide_time <= 0) {
    	$("#courier_shared_label").text = "";
	} else {
		message_hide_time = message_hide_time - 1;
	}
	$.Schedule(1, ClearErrorMsg);
}

(function() {
	$.Schedule(1, ClearErrorMsg);
})()
