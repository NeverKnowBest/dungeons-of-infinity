#macro LOWER 0
#macro UPPER 1
#macro RoomBuffer 16

enum RoomSize{
 _1x1,
 _1x2,
 _2x1,
 _2x2
}

function Room_InitData(){
	
	global.RoomObjSprites[RoomObj.Wall_Corner_TL] = sWall_Corner_TL;
	global.RoomObjSprites[RoomObj.Wall_Corner_TR] = sWall_Corner_TR;
	global.RoomObjSprites[RoomObj.Wall_Corner_BL] = sWall_Corner_BL;
	global.RoomObjSprites[RoomObj.Wall_Corner_BR] = sWall_Corner_BR;
	global.RoomObjSprites[RoomObj.Wall_InnerCorner_TL] = sWall_InnerCorner_TL;
	global.RoomObjSprites[RoomObj.Wall_InnerCorner_TR] = sWall_InnerCorner_TR;
	global.RoomObjSprites[RoomObj.Wall_InnerCorner_BL] = sWall_InnerCorner_BL;
	global.RoomObjSprites[RoomObj.Wall_InnerCorner_BR] = sWall_InnerCorner_BR;
	global.RoomObjSprites[RoomObj.Wall_Side_T] = sWall_Side_T;
	global.RoomObjSprites[RoomObj.Wall_Side_B] = sWall_Side_B;
	global.RoomObjSprites[RoomObj.Wall_Side_L] = sWall_Side_L;
	global.RoomObjSprites[RoomObj.Wall_Side_R] = sWall_Side_R;

	global.RoomObjSprites[RoomObj.Wall_Lower_Corner_TL] = sWall_Lower_Corner_TL;
	global.RoomObjSprites[RoomObj.Wall_Lower_Corner_TR] = sWall_Lower_Corner_TR;
	global.RoomObjSprites[RoomObj.Wall_Lower_Corner_BL] = sWall_Lower_Corner_BL;
	global.RoomObjSprites[RoomObj.Wall_Lower_Corner_BR] = sWall_Lower_Corner_BR;
	global.RoomObjSprites[RoomObj.Wall_Lower_InnerCorner_TL] = sWall_Lower_InnerCorner_TL;
	global.RoomObjSprites[RoomObj.Wall_Lower_InnerCorner_TR] = sWall_Lower_InnerCorner_TR;
	global.RoomObjSprites[RoomObj.Wall_Lower_InnerCorner_BL] = sWall_Lower_InnerCorner_BL;
	global.RoomObjSprites[RoomObj.Wall_Lower_InnerCorner_BR] = sWall_Lower_InnerCorner_BR;
	global.RoomObjSprites[RoomObj.Wall_Lower_Side_T] = sWall_Lower_Side_T;
	global.RoomObjSprites[RoomObj.Wall_Lower_Side_B] = sWall_Lower_Side_B;
	global.RoomObjSprites[RoomObj.Wall_Lower_Side_L] = sWall_Lower_Side_L;
	global.RoomObjSprites[RoomObj.Wall_Lower_Side_R] = sWall_Lower_Side_R;
	
	global.RoomSizeID[1][1] = RoomSize._1x1;
	global.RoomSizeID[1][2] = RoomSize._1x2;
	global.RoomSizeID[2][1] = RoomSize._2x1;
	global.RoomSizeID[2][2] = RoomSize._2x2;

}

function Room_SetSize(_W, _H){

	GridW = _W;
	GridH = _H;	
	W = _W * 256;
	H = _H * 256;
	MinX = x + RoomBuffer;
	MinY = y + RoomBuffer;
	MaxX = x + W - RoomBuffer;
	MaxY = y + H - RoomBuffer;
	oRoom.image_index = global.RoomSizeID[_W][_H];
}

function Room_DrawDoor(_Level, _Position, _WallStart, _WallEnd, _WallEdge){
	
	_Position = _Position + (_Level == LOWER ? 12 : 0);
	var _RoomBuffer = RoomBuffer + (_Level == LOWER ? 24 : 0);
	
	switch(_Position){
		case 11: case 12: case 1: 
		case 23: case 24: case 13: 
			var DoorX = global.DoorCoordinates[global.RoomSizeID[oRoom.GridW][oRoom.GridH]][_Position].x;
			if(_WallEdge == oRoom.y + _RoomBuffer && _WallStart <= oRoom.x + DoorX && _WallEnd >= oRoom.x + DoorX + 32){
				draw_sprite(sDoor_Top, 0, oRoom.x + DoorX, oRoom.y + _RoomBuffer);
			}		
			break;

		case 2: case 3: case 4: 
		case 14: case 15: case 16: 
			var DoorY = global.DoorCoordinates[global.RoomSizeID[oRoom.GridW][oRoom.GridH]][_Position].y;
			if(_WallEdge == oRoom.x + oRoom.W - _RoomBuffer - 24 && _WallStart <= oRoom.y + DoorY && _WallEnd >= oRoom.y + DoorY + 32){
				draw_sprite(sDoor_Right, 0, oRoom.x + oRoom.W - _RoomBuffer - 24, oRoom.y + DoorY);
			}	
			break;	

		case 5: case 6: case 7: 
		case 17: case 18: case 19: 
			var DoorX = global.DoorCoordinates[global.RoomSizeID[oRoom.GridW][oRoom.GridH]][_Position].x;
			if(_WallEdge == oRoom.y + oRoom.H - _RoomBuffer - 24 && _WallStart <= oRoom.x + DoorX && _WallEnd >= oRoom.x + DoorX + 32){
				draw_sprite(sDoor_Bottom, 0, oRoom.x + DoorX, oRoom.y + oRoom.H - _RoomBuffer - 24);
			}		
			break;
			
		case 8: case 9: case 10: 
		case 20: case 21: case 22: 
			var DoorY = global.DoorCoordinates[global.RoomSizeID[oRoom.GridW][oRoom.GridH]][_Position].y;
			if(_WallEdge == oRoom.x + _RoomBuffer && _WallStart <= oRoom.y + DoorY && _WallEnd >= oRoom.y + DoorY + 32){
				draw_sprite(sDoor_Left, 0, oRoom.x + _RoomBuffer, oRoom.y + DoorY);
			}	
			break;


			
	}

				
}

function GetWallLoopLinkedInsts(_Inst, _List){
	//returns an array with 2 indexes holding the L(0) and R(1) instances in the wall loop
		var ListSize = ds_list_size(_List);
		var CornerWallInstPos = ds_list_find_index(_List, _Inst);
		Inst[0] = ds_list_find_value(_List, CornerWallInstPos == 0 ? ListSize - 1 : CornerWallInstPos - 1);
		Inst[1] = ds_list_find_value(_List, CornerWallInstPos == ListSize - 1 ? 0 : CornerWallInstPos + 1);	
		
		return Inst;
}
