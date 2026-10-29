if(instance_exists(oTest) && oTest.Sheet != undefined) exit;	//test mode: the contact sheet pictures the rooms without the night and the flashes

var _DrawLightning = !global.GlobalLighting && oLink.State != LinkState.Dead;

if(global.ChallengeOptions[ChallengeOption.Darkness] >= ChallengeOption_Darkness.AllDark && GLighting){

	if(_DrawLightning){
		draw_set_color(#FFFFFF);
		draw_set_alpha(0.5);
		draw_rectangle(oCamera.X, oCamera.Y, oCamera.X2, oCamera.Y2, false);
		draw_set_alpha(1);
	}
}else if(Cfg.Tint || _DrawLightning){

	draw_set_color(_DrawLightning ? #FFFFFF : #000030);
	draw_set_alpha(0.65);
	if(DrawNight) draw_rectangle(oCamera.X, oCamera.Y, oCamera.X2, oCamera.Y2, false);
	draw_set_alpha(1);

}
draw_set_color(#FFFFFF);
