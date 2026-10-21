
if(State == ArcadeState.UnUsed) exit;


surface_set_target(GameSurface);
draw_set_color(#1C31CC);
draw_rectangle(0, 0, CamW, CamH, false);
for(var _CardIndex = 0; _CardIndex < 5; _CardIndex++){
	draw_sprite(sPoker_CardBack, 0, 10 + (_CardIndex * 37), 80);
}

draw_set_color(#FFFFFF);
surface_reset_target();
