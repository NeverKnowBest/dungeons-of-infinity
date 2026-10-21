
if(CameraExists){
	if(oCamera.RoomTransition != NONE || oLink.State == LinkState.AutoMove) exit;

	x = oCamera.X + ((CAM_W - DialogueBoxW) / 2);
	y = oCamera.Y + Y;
	
}else{

	x = camera_get_view_x(view_camera[0]) + ((camera_get_view_width(view_camera[0]) - DialogueBoxW) / 2);
	y = camera_get_view_y(view_camera[0]) + Y;	
}


TextX = x + 7;
TextY = y + 7;

if(ShowBox) draw_sprite_stretched(sprite_index, image_index, x, y, DialogueBoxW, DialogueBoxH);
	
if(SurfaceH > 0){

	if(!surface_exists(Surface)) Surface = surface_create(SurfaceW, floor(SurfaceH));
	
	surface_set_target(Surface);
	draw_clear_alpha(c_black, 0.0);
	draw_set_color(TextColor);
	draw_set_font(global.Font_Blue);
	var DialogueLen = array_length(DialogueArray);
	
	var _X = 0;
	if(CenterText){
		draw_set_halign(fa_center);
		_X = BoxCenter - 2;
	}else{
		draw_set_halign(fa_left);
	}
	
	for(var i = 0; i < DialogueLen; i++){
		var _Y = SurfaceY + (i * 16);
		draw_text(_X, _Y, DialogueArray[i]);		
	}

	switch(ScriptCode){
		case DBScriptCode.Dialogue_YesNo:
			draw_set_halign(fa_center);
			var Str = "Yes   No";
			YPos = (DialogueLen mod 3 == 2 ? _Y + 16: _Y + 24)
			draw_text(BoxCenter, YPos, Str);
			draw_text(BoxCenter + (InputChoice == 0 ? -25 : 6), YPos, chr(136));
			break;
			
		case DBScriptCode.Dialogue_Buy:
			draw_set_halign(fa_center);
			var Str = "Buy   Cancel   Info";
			draw_text(BoxCenter, _Y + 24, Str);
			switch(InputChoice){
				case 0:	draw_text(BoxCenter + -52, _Y + 24, chr(136)); break;
				case 1:	draw_text(BoxCenter + -21, _Y + 24, chr(136)); break;
				case 2:	draw_text(BoxCenter + 24, _Y + 24, chr(136)); break;
			}
			break;
			
		case DBScriptCode.Dialogue_ChessEnd:
			draw_set_halign(fa_center);
			var Str = "Cancel    Quit    New Game";
			draw_text(BoxCenter, _Y + 24, Str);
			switch(InputChoice){
				case 0:	draw_text(BoxCenter + -72, _Y + 24, chr(136)); break;
				case 1:	draw_text(BoxCenter + -23, _Y + 24, chr(136)); break;
				case 2:	draw_text(BoxCenter + 14, _Y + 24, chr(136)); break;
			}
			break;
	}

	surface_reset_target();
	
	draw_surface(Surface, TextX, TextY);
	
}
	