enum RoomObj{
	Wall_Corner_TL,	
	Wall_Corner_TR,	
	Wall_Corner_BL,	
	Wall_Corner_BR,	
	Wall_InnerCorner_TL,
	Wall_InnerCorner_TR,
	Wall_InnerCorner_BL,
	Wall_InnerCorner_BR,
	Wall_Side_T,
	Wall_Side_B,
	Wall_Side_L,
	Wall_Side_R,
	Wall_Lower_Corner_TL,	
	Wall_Lower_Corner_TR,	
	Wall_Lower_Corner_BL,	
	Wall_Lower_Corner_BR,	
	Wall_Lower_InnerCorner_TL,
	Wall_Lower_InnerCorner_TR,
	Wall_Lower_InnerCorner_BL,
	Wall_Lower_InnerCorner_BR,
	Wall_Lower_Side_T,
	Wall_Lower_Side_B,
	Wall_Lower_Side_L,
	Wall_Lower_Side_R	
}
#macro CornerWallW 24

function RoomObj_Create(_ObjID, _x, _y){
	
	var ObjInst = instance_create_layer(_x, _y, "RoomObjs", oRoomObj);
	ObjInst.Type = _ObjID;
	ObjInst.sprite_index = global.RoomObjSprites[_ObjID]
	ObjInst.W = ObjInst.sprite_width;
	ObjInst.H = ObjInst.sprite_height;
	ObjInst.MinX = oRoom.MinX;
	ObjInst.MaxX = oRoom.MaxX - ObjInst.W;
	ObjInst.MinY = oRoom.MinY;
	ObjInst.MaxY = oRoom.MaxY - ObjInst.H;

	return ObjInst;
	
}

function RoomObj_CornerWall_Create(_ObjID, _x, _y, _Loop_Level, _Loop_ID, _Loop_ListPos){
	
	//creates a corner wall instance and adds it to the wall loop
	var ObjInst = RoomObj_Create(_ObjID, _x, _y)

	ObjInst.IsCornerWall = true;
	ObjInst.WallLoopLevel = _Loop_Level;
	ObjInst.WallLoopID = _Loop_ID;
	
	ds_list_insert(WallLoopList[_Loop_Level][_Loop_ID], _Loop_ListPos, ObjInst);
	
}

function RoomObj_Item_Create(_ObjID, _x, _y){
	
	var ObjInst = RoomObj_Create(_ObjID, _x, _y);
	//array_insert(RoomObjs, array_length(RoomObjs), ObjInst);
	
}



