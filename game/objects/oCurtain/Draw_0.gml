with(DoorInst) Lighting_UpdateLight_Visible(RoomIndex, FloorLight, false);
		
PixelRender(true, true, false, noone, 0, false, []);

draw_sprite(sprite_index, image_index, x, y);

with(DoorInst){ if(Status == DoorStatus.Open || Status == DoorStatus.ClosedHalf ||Status == DoorStatus.Secret_Open) Lighting_UpdateLight_Visible(RoomIndex, FloorLight, true); }

shader_reset();

switch(Location){
	case "Top":
		DrawTileBlock(global.TMID_Tiles_Highest, x, y, BeamTileX, 0, 2, 1);
		DrawTileBlock(global.TMID_Tiles_Highest, x + 16, y, BeamTileX, 0, 2, 1);
		break;
	case "Bottom":
		DrawTileBlock(global.TMID_Tiles_Highest, x, y + 24, BeamTileX, 1, 2, 1);
		DrawTileBlock(global.TMID_Tiles_Highest, x + 16, y + 24, BeamTileX, 1, 2, 1);
		break;
	case "Left":
		DrawTileBlock(global.TMID_Tiles_Highest, x, y, BeamTileX + 2, 0, 1, 2);
		DrawTileBlock(global.TMID_Tiles_Highest, x, y + 16, BeamTileX + 2, 0, 1, 2);
		break;
	case "Right":
		DrawTileBlock(global.TMID_Tiles_Highest, x + 24, y, BeamTileX + 3, 0, 1, 2);
		DrawTileBlock(global.TMID_Tiles_Highest, x + 24, y + 16, BeamTileX + 3, 0, 1, 2);
		break;
}

	//draw_set_alpha(0.5);
	//draw_set_color(c_red);
	//draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
	//draw_set_alpha(1);