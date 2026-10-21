

//Draw Dungeon No
draw_set_font(fnt_button);
draw_set_color(#0064c8)
draw_set_halign(fa_center);

var Dungeons = array_length(global.Data_Dungeons[global.DungeonClass]);
var Str = string(global.DungeonIndex) + (Dungeons < 10 ? " / " : "/") + string(Dungeons - 1);


draw_text(global.DungeonGridX_2 + 96, 8, Str);
draw_set_halign(fa_left);

//draw_text(700, 0, "MK_Section: " + string(global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].MasterKeySection));
//draw_text(700, 20, "MK_RoomIndex: " + string(global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].MasterKeyRoomIndex));

//Coordinates
draw_set_color(#AAAAAA)
for(var _x = 0; _x < 8; _x++){
	draw_text(global.DungeonGridX - 166 + (_x * 32), global.DungeonGridY - 60, string(_x));
}
for(var _y = 0; _y < 8; _y++){
	draw_text(global.DungeonGridX - 190, global.DungeonGridY - 37 + (_y * 32), string(_y));
}

var Rooms = array_length(global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms);

//Warp Dest Coordinate
if(Rooms > 0){
	var _WarpDest = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[global.ActiveRoom].Warp_DestGridPosition;

	if(_WarpDest == -1){
		var _DestStr = WarpSet ? "Select" : "none";
	}else{
		var _x = _WarpDest mod 8;
		var _y = _WarpDest div 8;
		_DestStr = "(" + string(_x) + "," + string(_y) + ")";
	}
	draw_text(8, 282, "Warp Dest: " + _DestStr);
}


//Draw grid rooms

for(var RoomIndex = 0; RoomIndex < Rooms; RoomIndex++){
	
	var RoomGridX = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[RoomIndex].GridX;
	var RoomGridY = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[RoomIndex].GridY;
	var RoomGridW = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[RoomIndex].GridW;
	var RoomGridH = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[RoomIndex].GridH;
	var RSI = RoomSizeIndex(RoomGridW, RoomGridH)
	
	//draw base room
	var RoomX = RoomGridX * global.RoomButtonW;
	var RoomY = 1200 + (RoomGridY * global.RoomButtonW);
	var Col = (RoomIndex == global.ActiveRoom ? c_lime : c_white);
	draw_sprite_ext(asset_get_index("sGridRoom_" + string(RoomGridW) + "x" + string(RoomGridH) + "_Upper"), 0, RoomX, RoomY, 1, 1, 0, Col, 1);
	
	var RoomButtonIndex = GetRoomButtonIndex_FromRoomIndex(RoomIndex);
	if(RoomButtons[RoomButtonIndex].LowerFloor) draw_sprite_ext(asset_get_index("sGridRoom_" + string(RoomGridW) + "x" + string(RoomGridH) + "_Lower"), 0, RoomX, RoomY, 1, 1, 0, Col, 1);
	
	//draw doors
	var Doors = array_length(global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[RoomIndex].Doors);

	for(var DoorIndex = 0; DoorIndex < Doors; DoorIndex++){
		var DoorStatus = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[RoomIndex].Doors[DoorIndex].Status;
		var DoorPosition = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[RoomIndex].Doors[DoorIndex].Position;
		var DoorLocation = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[RoomIndex].Doors[DoorIndex].Location;
		var DoorPosX = RoomX + (global.DoorCoordinates[RSI][DoorPosition].x / 4);
		var DoorPosY = RoomY + (global.DoorCoordinates[RSI][DoorPosition].y / 4);		
		
		var DoorColor = DoorStatusColors[DoorStatus];
			
		draw_sprite_ext(DoorLocation == "Top" || DoorLocation == "Bottom" ? sDoor_Grid_TB : sDoor_Grid_LR, 0, DoorPosX, DoorPosY, 1, 1, 0, DoorColor, 1);
	}
	


	if(chkShowRoomIndexes.ChkStatus){
		
		draw_set_color(#c8c8c8);
		draw_set_font(fnt_header);
		var RoomIndexStr = string(RoomIndex);
		var StrW = string_width(RoomIndexStr);
		var StrH = string_height(RoomIndexStr);
		var StrX = RoomX + (((global.RoomButtonW * RoomGridW) - StrW) / 2) + 2;
		var StrY = RoomY + (((global.RoomButtonW * RoomGridH) - StrH) / 2) + 2;
		draw_text(StrX, StrY, RoomIndexStr);
		
	}else{


		//draw section
		var SectionID = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex][$ "Rooms"][RoomIndex][$ "Section_ID"];

		//These will be used below when drawing the objects

		if(SectionID > 0){

			var SectionType = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex][$ "Rooms"][RoomIndex][$ "Section_WallType"];
		
			if(SectionType == SectionWallType.Rail)
				var SectionColor = c_grey;
			else
				var SectionColor = SwitchBlockColors[global.Data_Dungeons[global.DungeonClass][global.DungeonIndex][$ "Rooms"][RoomIndex][$ "Section_Color"]];
		
			var GridRoomAsset = "sGridRoom_" + string(RoomGridW) + "x" + string(RoomGridH);
			draw_sprite_ext(asset_get_index(GridRoomAsset + "_Sections"), SectionID, RoomX, RoomY, 1, 1, 0, SectionColor, 1);
		}
	
		//Draw Objects
		var SpecialObj = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[RoomIndex].SpecialObj;
		var SpecialObjSection = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[RoomIndex].SpecialObjSection;
		
		if(SpecialObj != 0){
			
			if(SpecialObjSection == 0){
				switch(SectionID){
					case 21: SpecialObjSection = 8; break;
					case 22: SpecialObjSection = 6; break;
					case 23: SpecialObjSection = 3; break;
					case 24: SpecialObjSection = 1; break;
					case 25: SpecialObjSection = 2; break;
					case 26: SpecialObjSection = 4; break;
					case 27: SpecialObjSection = 8; break;
					case 28: SpecialObjSection = 6; break;
					case 29: SpecialObjSection = 3; break;
					case 30: SpecialObjSection = 1; break;
				}
			}
					
			switch(SpecialObj){
			
				case SpecialObject.Key:
					var SprIndex = sKey;
					break;
				
				case SpecialObject.SpecialRoom:
					var SprIndex = sSpecialRoom;
					break;
					
				case SpecialObject.Crystal:
					var SprIndex = sCrystal;
					break;

				case SpecialObject.DoorSwitch:
					var SprIndex = sDoorSwitch;
					break;
					
				case SpecialObject.Warp:
					var SprIndex = sWarp;
					break;
					
				case SpecialObject.Boss:
					var SprIndex = sBoss;
					break;

				case SpecialObject.House:
					var SprIndex = sHouse;
					break;
					
				case SpecialObject.Jail:
					var SprIndex = sJail;
					break;
					
				case SpecialObject.JailKey:
					var SprIndex = sJailKey;
					break;

				case SpecialObject.EnemyTrap:
					var SprIndex = sEnemyTrap;
					break;
					
			}
			

			if(SectionID == 0){

				var ObjX = RoomX + (32 * RoomGridW);
				var ObjY = RoomY + (32 * RoomGridH);

			}else{
				
				var ObjX = RoomX + global.SectionObjCoordinates[RSI][SpecialObjSection].x;
				var ObjY = RoomY + global.SectionObjCoordinates[RSI][SpecialObjSection].y;
			
			}

			var DrawSize = (SectionID == 0 ? 2 : 1);
			
			draw_sprite_ext(SprIndex, 0, ObjX, ObjY, DrawSize, DrawSize, 0, c_white, 1)	
			
		}

	}

	
}

