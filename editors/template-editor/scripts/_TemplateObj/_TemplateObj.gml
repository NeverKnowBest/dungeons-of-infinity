enum TemplateObjID{
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
	Wall_Lower_Side_R,
	DoorT,
	DoorB,
	DoorL,
	DoorR
}

#macro CornerWallW 24

function TemplateObj_Create(_ObjID, _x, _y){
	
	var ObjInst = instance_create_layer(_x, _y, "TemplateObjs", oTemplateObj);
	ObjInst.ID = _ObjID;
	ObjInst.sprite_index = global.TemplateObj_Sprites[_ObjID]
	ObjInst.W = ObjInst.sprite_width;
	ObjInst.H = ObjInst.sprite_height;
	ObjInst.MinX = global.Template_MinX;
	ObjInst.MaxX = global.Template_MaxX - ObjInst.W;
	ObjInst.MinY = global.Template_MinY;
	ObjInst.MaxY = global.Template_MaxY - ObjInst.H;

	return ObjInst;
	
}

function TemplateObj_CornerWall_Create(_ObjID, _x, _y, _Loop_Level, _Loop_ID, _Loop_ArrayPos, _Replace = false){
	
	//creates a corner wall instance and adds it to the wall loop
	var ObjInst = TemplateObj_Create(_ObjID, _x, _y)

	ObjInst.IsCornerWall = true;
	ObjInst.WallLoopLevel = _Loop_Level;
	ObjInst.WallLoopID = _Loop_ID;
	ObjInst.WallLoopIndex = _Loop_ArrayPos;

	
	var WallLoopArray = global.WallLoop[_Loop_Level][_Loop_ID];
	
	if(_Replace){//don't think I need this now
		WallLoopArray[_Loop_ArrayPos].ID = _ObjID;
		WallLoopArray[_Loop_ArrayPos].Inst = ObjInst;
		WallLoopArray[_Loop_ArrayPos].x = _x;
		WallLoopArray[_Loop_ArrayPos].y = _y;
		
	}else{
		
		array_insert(WallLoopArray, _Loop_ArrayPos, new struct_TemplateObj(_ObjID, ObjInst, _x, _y, CornerWallW, CornerWallW));
		
		//increment WallLoopIndex for all corners after this one
		for(var i = _Loop_ArrayPos + 1; i < array_length(WallLoopArray); i++){
			WallLoopArray[i].Inst.WallLoopIndex++;
		}
	}
	
	
}

function TemplateObj_Item_Create(_ObjID, _x, _y){
	
	var ObjInst = TemplateObj_Create(_ObjID, _x, _y);
	//array_insert(TemplateObjs, array_length(TemplateObjs), ObjInst);
	
}



