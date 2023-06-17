GameEvents.Subscribe("ladder_ban_start", OnLadderBanStart);
GameEvents.Subscribe("ladder_pick_start", OnLadderPickStart);
GameEvents.Subscribe("ladder_hero_ban_s2c", OnLadderBanS2C);

function OnLadderBanStart(data) {
    $.GetContextPanel().RemoveClass("hero-selection-ban-panel-hide")
    $.GetContextPanel().AddClass("hero-selection-ban-panel-show")
    $("#hero-image-str-1" ).heroname = data.str_1;
    $("#hero-image-str-2" ).heroname = data.str_2;
    $("#hero-image-str-3" ).heroname = data.str_3;
    $("#hero-image-str-4" ).heroname = data.str_4;
    $("#hero-image-str-5" ).heroname = data.str_5;
    $("#hero-image-str-6" ).heroname = data.str_6;
    $("#hero-image-str-7" ).heroname = data.str_7;
    $("#hero-image-str-8" ).heroname = data.str_8;
    $("#hero-image-str-9" ).heroname = data.str_9;
    $("#hero-image-str-10").heroname = data.str_10;
    $("#hero-image-str-11").heroname = data.str_11;
    $("#hero-image-str-12").heroname = data.str_12;
    $("#hero-image-str-13").heroname = data.str_13;
    $("#hero-image-agi-1" ).heroname = data.agi_1;
    $("#hero-image-agi-2" ).heroname = data.agi_2;
    $("#hero-image-agi-3" ).heroname = data.agi_3;
    $("#hero-image-agi-4" ).heroname = data.agi_4;
    $("#hero-image-agi-5" ).heroname = data.agi_5;
    $("#hero-image-agi-6" ).heroname = data.agi_6;
    $("#hero-image-agi-7" ).heroname = data.agi_7;
    $("#hero-image-agi-8" ).heroname = data.agi_8;
    $("#hero-image-agi-9" ).heroname = data.agi_9;
    $("#hero-image-agi-10").heroname = data.agi_10;
    $("#hero-image-agi-11").heroname = data.agi_11;
    $("#hero-image-agi-12").heroname = data.agi_12;
    $("#hero-image-agi-13").heroname = data.agi_13;
    $("#hero-image-int-1" ).heroname = data.int_1;
    $("#hero-image-int-2" ).heroname = data.int_2;
    $("#hero-image-int-3" ).heroname = data.int_3;
    $("#hero-image-int-4" ).heroname = data.int_4;
    $("#hero-image-int-5" ).heroname = data.int_5;
    $("#hero-image-int-6" ).heroname = data.int_6;
    $("#hero-image-int-7" ).heroname = data.int_7;
    $("#hero-image-int-8" ).heroname = data.int_8;
    $("#hero-image-int-9" ).heroname = data.int_9;
    $("#hero-image-int-10").heroname = data.int_10;
    $("#hero-image-int-11").heroname = data.int_11;
    $("#hero-image-int-12").heroname = data.int_12;
    $("#hero-image-int-13").heroname = data.int_13;
}

function OnBanPressed(id_suffix) {
    GameEvents.SendCustomGameEventToServer("ladder_hero_banned", { "hero_id_suffix": id_suffix } );
    $("#ban-but-str-1").AddClass("button-invisible");
    $("#ban-but-str-2").AddClass("button-invisible");
    $("#ban-but-str-3").AddClass("button-invisible");
    $("#ban-but-str-4").AddClass("button-invisible");
    $("#ban-but-str-5").AddClass("button-invisible");
    $("#ban-but-str-6").AddClass("button-invisible");
    $("#ban-but-str-7").AddClass("button-invisible");
    $("#ban-but-str-8").AddClass("button-invisible");
    $("#ban-but-str-9").AddClass("button-invisible");
    $("#ban-but-str-10").AddClass("button-invisible");
    $("#ban-but-str-11").AddClass("button-invisible");
    $("#ban-but-str-12").AddClass("button-invisible");
    $("#ban-but-str-13").AddClass("button-invisible");
    $("#ban-but-agi-1").AddClass("button-invisible");
    $("#ban-but-agi-2").AddClass("button-invisible");
    $("#ban-but-agi-3").AddClass("button-invisible");
    $("#ban-but-agi-4").AddClass("button-invisible");
    $("#ban-but-agi-5").AddClass("button-invisible");
    $("#ban-but-agi-6").AddClass("button-invisible");
    $("#ban-but-agi-7").AddClass("button-invisible");
    $("#ban-but-agi-8").AddClass("button-invisible");
    $("#ban-but-agi-9").AddClass("button-invisible");
    $("#ban-but-agi-10").AddClass("button-invisible");
    $("#ban-but-agi-11").AddClass("button-invisible");
    $("#ban-but-agi-12").AddClass("button-invisible");
    $("#ban-but-agi-13").AddClass("button-invisible");
    $("#ban-but-int-1").AddClass("button-invisible");
    $("#ban-but-int-2").AddClass("button-invisible");
    $("#ban-but-int-3").AddClass("button-invisible");
    $("#ban-but-int-4").AddClass("button-invisible");
    $("#ban-but-int-5").AddClass("button-invisible");
    $("#ban-but-int-6").AddClass("button-invisible");
    $("#ban-but-int-7").AddClass("button-invisible");
    $("#ban-but-int-8").AddClass("button-invisible");
    $("#ban-but-int-9").AddClass("button-invisible");
    $("#ban-but-int-10").AddClass("button-invisible");
    $("#ban-but-int-11").AddClass("button-invisible");
    $("#ban-but-int-12").AddClass("button-invisible");
    $("#ban-but-int-13").AddClass("button-invisible");
}

function OnLadderPickStart() {
    $.GetContextPanel().AddClass("hero-selection-ban-panel-hide")
    $.GetContextPanel().RemoveClass("hero-selection-ban-panel-show")
}

function OnLadderBanS2C(event) {
    $.Msg(event.id_suffix)
    $("#ban-label-" + event.id_suffix).text =  $("#ban-label-" + event.id_suffix).text + "x";
}
