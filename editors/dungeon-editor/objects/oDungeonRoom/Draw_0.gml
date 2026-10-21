
var RoomArray = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex][$ "Rooms"];
if(array_length(RoomArray) == 0) exit;

draw_self();

//draw_set_color(make_color_rgb(0,100,200))
//draw_set_font(fnt_button);
//draw_text(x, 8, "Room Index " + string(global.ActiveRoom));

var ActiveRoom = RoomArray[global.ActiveRoom];

var RoomAsset = "sRoom_" + string(ActiveRoom[$ "GridW"]) + "x" + string(ActiveRoom[$ "GridH"]);
if(chkLowerFloor.ChkStatus) draw_sprite(asset_get_index(RoomAsset + "_Lower"), 0, x, y);

//draw sections
if(ActiveRoom[$ "Section_ID"] > 0){
	switch(ActiveRoom[$ "Section_WallType"]){
		case SectionWallType.Rail:
			draw_sprite(asset_get_index(RoomAsset + "_Sections_Rails"), ActiveRoom[$ "Section_ID"], x, y);
			break;
			
		case SectionWallType.SwitchBlock:
			
			pal_swap_set(sPalette_SwitchBlock, ActiveRoom[$ "Section_Color"], false);
			draw_sprite(asset_get_index(RoomAsset + "_Sections_SwitchBlocks_Up"), ActiveRoom[$ "Section_ID"], x, y);
			pal_swap_reset();
			break;
		
	}	
}

//draw entrance frame
//if(global.ActiveRoom == global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].EntranceRoomIndex){
//	var ShiftX = (ActiveRoom.GridW - 1) * 128;
//	var ShiftY = (ActiveRoom.GridH - 1) * 256;
//	draw_sprite(sEntrance, 0, x + 72 + ShiftX, y + 192 + ShiftY);
//	draw_sprite(sEntrance, 1, x + 128 + ShiftX, y + 192 + ShiftY);
//}