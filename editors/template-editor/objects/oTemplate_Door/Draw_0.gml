if(Position > 12 && !oDungeonRoom.chkLowerFloor.ChkStatus) exit;

var alpha = 0;
var Col = 0;

var DoorIsEntrance = false;
if(global.ActiveRoom == global.Data_Dungeons[global.DungeonMap].EntranceRoomIndex){
	if(Position == 5 || Position == 7) exit;
	if(Position == 6){
		DoorIsEntrance = true;
		alpha = 1;
		Col = 255;		
	}
}



if(!DoorIsEntrance){
	
	if(Enabled){
		alpha = 1;
		Col = 255;
		if(oDungeonRoom.SelectedDoor == id) SetBrightness(0.2);
	}else{
	
		if(MouseOver){
			alpha = 0.5;
			Col = 160;
		}
	}

}

draw_sprite_ext(sprite_index, Status, x, y, 1, 1, 0, make_color_rgb(Col, Col, Col), alpha);

shader_reset();

