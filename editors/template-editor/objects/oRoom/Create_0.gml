
Mouse_Inst = noone;
Mouse_Inst_OffsetX = 0;
Mouse_Inst_OffsetY = 0;
Mouse_Inst_Move = false;

Mouse_OffClickL = false;
Mouse_OffClickR = false;
Mouse_OffClickM = false;

Room_InitData();

Room_SetSize(1, 1);


//RoomObjs = array_create(0);

WallLoopList[LOWER][0] = ds_list_create();
WallLoopList[LOWER][1] = ds_list_create();
WallLoopList[UPPER][0] = ds_list_create();
WallLoopList[UPPER][1] = ds_list_create();

//Add wall corners to the loop. Loops should always start at TL and go clockwise
var i = 0;
RoomObj_CornerWall_Create(RoomObj.Wall_Corner_TL, MinX, MinY, UPPER, 0, i++);
RoomObj_CornerWall_Create(RoomObj.Wall_Corner_TR, MaxX - CornerWallW, MinY, UPPER, 0, i++);
RoomObj_CornerWall_Create(RoomObj.Wall_Corner_BR, MaxX - CornerWallW, MaxY - CornerWallW, UPPER, 0, i++);
RoomObj_CornerWall_Create(RoomObj.Wall_Corner_BL, MinX, MaxY - CornerWallW, UPPER, 0, i++);

//var i = 0;
//RoomObj_CornerWall_Create(RoomObj.Wall_Lower_Corner_TL, MinX, MinY, LOWER, 0, i++);
//RoomObj_CornerWall_Create(RoomObj.Wall_Lower_Corner_TR, MaxX - 128, MinY, LOWER, 0, i++);
//RoomObj_CornerWall_Create(RoomObj.Wall_Lower_InnerCorner_TR, MaxX - 128, MinY + 64, LOWER, 0, i++);
//RoomObj_CornerWall_Create(RoomObj.Wall_Lower_InnerCorner_TL, MaxX - 96, MinY + 64, LOWER, 0, i++);
//RoomObj_CornerWall_Create(RoomObj.Wall_Lower_Corner_TL, MaxX - 96, MinY, LOWER, 0, i++);
//RoomObj_CornerWall_Create(RoomObj.Wall_Lower_Corner_TR, MaxX - CornerWallW - CornerWallW, MinY, LOWER, 0, i++);
//RoomObj_CornerWall_Create(RoomObj.Wall_Lower_Corner_BR, MaxX - CornerWallW - CornerWallW, MaxY - CornerWallW, LOWER, 0, i++);
//RoomObj_CornerWall_Create(RoomObj.Wall_Lower_Corner_BL, MaxX - 96, MaxY - CornerWallW - CornerWallW, LOWER, 0, i++);
//RoomObj_CornerWall_Create(RoomObj.Wall_Lower_InnerCorner_BL, MaxX - 96, MaxY - 64, LOWER, 0, i++);
//RoomObj_CornerWall_Create(RoomObj.Wall_Lower_InnerCorner_BR, MaxX - 128, MaxY - 64, LOWER, 0, i++);
//RoomObj_CornerWall_Create(RoomObj.Wall_Lower_Corner_BR, MaxX - 128, MaxY - CornerWallW - CornerWallW, LOWER, 0, i++);
//RoomObj_CornerWall_Create(RoomObj.Wall_Lower_Corner_BL, MinX, MaxY - CornerWallW - CornerWallW, LOWER, 0, i++);
