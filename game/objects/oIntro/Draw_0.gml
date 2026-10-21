//draw_set_color(Lightning ? #FFFFFF : #000030);
//draw_set_alpha(0.65);
//draw_rectangle(oCamera.X, oCamera.Y, oCamera.X + 256, oCamera.Y + 224, false);
//draw_set_alpha(1);

var _DrawLightning = !global.GlobalLighting && oLink.State != LinkState.Dead;

if(global.ChallengeOptions[ChallengeOption.Darkness] >= ChallengeOption_Darkness.AllDark && GLighting){
	
	if(_DrawLightning){
		draw_set_color(#FFFFFF);
		draw_set_alpha(0.5); 
		draw_rectangle(oCamera.X, oCamera.Y, oCamera.X2, oCamera.Y2, false);
		draw_set_alpha(1);
	}	
}else{
	
	draw_set_color(_DrawLightning ? #FFFFFF : #000030);
	draw_set_alpha(0.65);
	if(DrawDarkScreen) draw_rectangle(oCamera.X, oCamera.Y, oCamera.X2, oCamera.Y2, false);
	draw_set_alpha(1);
	
}


draw_set_color(#000000);
draw_set_alpha(DarkScreenAlpha);
if(DrawDarkScreen) draw_rectangle(oCamera.X, oCamera.Y, oCamera.X2, oCamera.Y2, false);
draw_set_alpha(1);
draw_set_color(#FFFFFF);

