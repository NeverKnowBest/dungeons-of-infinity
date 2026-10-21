
RoomButtons = array_create(0);
RoomSetGridW = 1;
RoomSetGridH = 1;

global.RoomButtonW = 64;

global.DungeonClass = DungeonClass.Castle
global.DungeonIndex = 0;

for(var GridY = 0; GridY < DungeonGridMax; GridY++){
	for(var GridX = 0; GridX < DungeonGridMax; GridX++){
		RoomButton_Create(-1, GridX, GridY, 1, 1);
	}
}

OriginalCamW = camera_get_view_width(view_camera[1]);
OriginalCamH = camera_get_view_height(view_camera[1]);
CamRatio = OriginalCamW / OriginalCamH;

Cam_CurrentW = OriginalCamW;
Cam_CurrentH = OriginalCamH;

UpdateZoom = false;

Panning = false;
WinMove_MX = 0;
WinMove_MY = 0;
WinMove_PosX = 0;
WinMove_PosY = 0;


DoorStatusColors = array_create(5);
DoorStatusColors[DoorStatus.Open] = c_black;
DoorStatusColors[DoorStatus.Closed] = c_maroon;
DoorStatusColors[DoorStatus.Locked] = c_yellow;
DoorStatusColors[DoorStatus.Entrance] = c_white;
DoorStatusColors[DoorStatus.Exit] = c_blue;

//Button positions
BtnPosX[ButtonPos.TopLeft] = 4;
BtnPosY[ButtonPos.TopLeft] = 4;

BtnPosX[ButtonPos.DungeonGrid_Top] = global.DungeonGridX_2;
BtnPosY[ButtonPos.DungeonGrid_Top] = BtnPosY[ButtonPos.TopLeft];

BtnPosX[ButtonPos.DungeonGrid_Below] = global.DungeonGridX_2;
BtnPosY[ButtonPos.DungeonGrid_Below] = (global.DungeonGridY + global.DungeonGridH + 10) / 2;

BtnPosX[ButtonPos.SpecialObjs] = global.DungeonGridX_2;
BtnPosY[ButtonPos.SpecialObjs] = BtnPosY[ButtonPos.DungeonGrid_Below] + 24;

BtnPosX[ButtonPos.Sections] = global.DungeonGridX_2;
BtnPosY[ButtonPos.Sections] = BtnPosY[ButtonPos.SpecialObjs] + 27;

BtnPosX[ButtonPos.SectionType] = global.DungeonGridX_2;
BtnPosY[ButtonPos.SectionType] = BtnPosY[ButtonPos.Sections] + 142;

BtnPosX[ButtonPos.Warps] = 960;//BtnPosX[ButtonPos.TopLeft];
BtnPosY[ButtonPos.Warps] = 10;//BtnPosY[ButtonPos.DungeonGrid_Below];

BtnPosWarpClearX = BtnPosX[ButtonPos.TopLeft];
BtnPosWarpClearY = BtnPosY[ButtonPos.DungeonGrid_Below];

BtnPosX[ButtonPos.Shift] = 120;
BtnPosY[ButtonPos.Shift] = 4;


var BtnX = BtnPosX[ButtonPos.TopLeft]; var BtnY = BtnPosY[ButtonPos.TopLeft];
btnDungeon_New = CreateButton(BtnX, BtnY, false, "New Dungeon", fnt_button); BtnY += 20;
btnDungeon_Del = CreateButton(BtnX, BtnY, false, "Del Dungeon", fnt_button); BtnY += 20;
btnResetGrid = CreateButton(BtnX, BtnY, false, "Reset View", fnt_button); BtnY += 20;
chkShowRoomIndexes = CreateButton(BtnX, BtnY, true, "Indexes", fnt_button); BtnY += 40;

chkDungeonClass[DungeonClass.Castle] = CreateButton(BtnX, BtnY, true, "    Castle", fnt_button); BtnY += 20;
chkDungeonClass[DungeonClass.CastleBasement] = CreateButton(BtnX, BtnY, true, "  Basement", fnt_button); BtnY += 20;
chkDungeonClass[DungeonClass.CastleJails] = CreateButton(BtnX, BtnY, true, "     Jails", fnt_button); BtnY += 20;
chkDungeonClass[DungeonClass.CatacombsSewers] = CreateButton(BtnX, BtnY, true, "   Cat/Sew", fnt_button); BtnY += 20;
chkDungeonClass[DungeonClass.BossesRuins] = CreateButton(BtnX, BtnY, true, "Boss/Ruins", fnt_button); BtnY += 20;
chkDungeonClass[DungeonClass.Aghanim] = CreateButton(BtnX, BtnY, true, "   Aghanim", fnt_button); BtnY += 20;
chkDungeonClass[DungeonClass.Special] = CreateButton(BtnX, BtnY, true, "   Special", fnt_button); BtnY += 20;
chkDungeonClass[DungeonClass.Castle].ChkStatus = true;

BtnX = BtnPosX[ButtonPos.DungeonGrid_Top]; BtnY = BtnPosY[ButtonPos.DungeonGrid_Top];
btnDungeon_Start = CreateButton(BtnX, BtnY, false, "|<", fnt_button); BtnX += 24;
btnDungeon_Prev10 = CreateButton(BtnX, BtnY, false, "<<", fnt_button); BtnX += 24;
btnDungeon_Prev1 = CreateButton(BtnX, BtnY, false, "<", fnt_button); BtnX += 82;
btnDungeon_Next1 = CreateButton(BtnX, BtnY, false, ">", fnt_button); BtnX += 15;
btnDungeon_Next10 = CreateButton(BtnX, BtnY, false, ">>", fnt_button); BtnX += 24;
btnDungeon_End = CreateButton(BtnX, BtnY, false, ">|", fnt_button); BtnX += 36;


BtnX = BtnPosX[ButtonPos.DungeonGrid_Below]; BtnY = BtnPosY[ButtonPos.DungeonGrid_Below];
for(var btnRoomSizeX = 1; btnRoomSizeX <= 2; btnRoomSizeX++){
	for(var btnRoomSizeY = 1; btnRoomSizeY <= 2; btnRoomSizeY++){
		btnRoom[btnRoomSizeX][btnRoomSizeY] = CreateButton(BtnX, BtnY, false, string(btnRoomSizeX) + "x" + string(btnRoomSizeY), fnt_button); 
		BtnX += btnRoom[btnRoomSizeX][btnRoomSizeY].W + 8;
	}
}
btnRoom[1][1].Active = true;
btnRoom_LastActiveX = 1;
btnRoom_LastActiveY = 1;

btnRoomDel =   CreateButton(BtnX, BtnY, false, "Del Room", fnt_button); BtnX += btnRoomDel.W + 8;


//Special Objs
BtnX = BtnPosX[ButtonPos.SpecialObjs]; BtnY = BtnPosY[ButtonPos.SpecialObjs];
btnSection_Key = CreateButton(BtnX, BtnY, false, sButtons_RoomSection_Key); BtnW = btnSection_Key.W; BtnX += BtnW + 5;
btnSection_Crystal = CreateButton(BtnX, BtnY, false, sButtons_RoomSection_Crystal); BtnX += BtnW + 5;
btnSection_DoorSwitch = CreateButton(BtnX, BtnY, false, sButtons_RoomSection_DoorSwitch); BtnX += BtnW + 5;
btnSection_EnemyTrap = CreateButton(BtnX, BtnY, false, sButtons_RoomSection_EnemyTrap); BtnX += BtnW + 5;
btnSection_Warp = CreateButton(BtnX, BtnY, false, sButtons_RoomSection_Warp); BtnX += BtnW + 5;
btnSection_SpecialRoom = CreateButton(BtnX, BtnY, false, sButtons_RoomSection_SpecialRoom); BtnX += BtnW + 5;
btnSection_Boss = CreateButton(BtnX, BtnY, false, sButtons_RoomSection_Boss); BtnX += BtnW + 5;
btnSection_House = CreateButton(BtnX, BtnY, false, sButtons_RoomSection_House); BtnX += BtnW + 5;
btnSection_Jail = CreateButton(BtnX, BtnY, false, sButtons_RoomSection_Jail); BtnX += BtnW + 5;
btnSection_JailKey = CreateButton(BtnX, BtnY, false, sButtons_RoomSection_JailKey); BtnX += BtnW + 5;
DungeonObjRefresh();

//Sections
BtnX = BtnPosX[ButtonPos.Sections]; BtnY = BtnPosY[ButtonPos.Sections];
btnSection = array_create(31);
for(var i = 0; i < 30; i++){
	var _PosX = BtnX + ((i mod 8) * 36);
	var _PosY = BtnY + ((i div 8) * 34);
	var _SectionIndex = i + 1;
	btnSection[_SectionIndex] = CreateButton(_PosX, _PosY, false, sButtons_RoomSections_Off); 
	btnSection[_SectionIndex].SpriteIndex = _SectionIndex;
	btnSection[_SectionIndex].Enabled = true;	
}
btnSection_Delete = CreateButton(_PosX + 40, _PosY + 8, false, "Del Sct", fnt_button); 

global.SectionActive = false;

//Section Types
BtnX = BtnPosX[ButtonPos.SectionType]; BtnY = BtnPosY[ButtonPos.SectionType];
btnSection_Rail = CreateButton(BtnX, BtnY, false, sButtons_RoomSection_Rail); BtnX += BtnW + 5;
btnSection_SwitchBlock = array_create(2);
btnSection_SwitchBlock[0] = CreateButton(BtnX, BtnY, false, sButtons_RoomSection_SwitchBlock_Color0); BtnX += BtnW + 5;
btnSection_SwitchBlock[1] = CreateButton(BtnX, BtnY, false, sButtons_RoomSection_SwitchBlock_Color1); BtnX += BtnW + 5;


ToggleActiveSectionButtons(false, false);

SwitchBlockColors = array_create(3);
SwitchBlockColors[0] = c_orange;
SwitchBlockColors[1] = c_blue;
SwitchBlockColors[2] = c_green;


//Warps
btnWarpClear = CreateButton(BtnPosWarpClearX, BtnPosWarpClearY, false, "Clear Warp", fnt_button);
btnWarpSet = CreateButton(BtnPosWarpClearX, BtnPosWarpClearY + 24, false, "Set Warp", fnt_button);
WarpSet = false;
WarpRoomIndex = 0;

//Dungeon Shift
btnShiftUp = CreateButton(BtnPosX[ButtonPos.Shift] + 16, BtnPosY[ButtonPos.Shift], false, "^", fnt_button);
btnShiftLeft = CreateButton(BtnPosX[ButtonPos.Shift], BtnPosY[ButtonPos.Shift] + 16, false, "<", fnt_button);
btnShiftRight = CreateButton(BtnPosX[ButtonPos.Shift] + 32, BtnPosY[ButtonPos.Shift] + 16, false, ">", fnt_button);
btnShiftDown = CreateButton(BtnPosX[ButtonPos.Shift] + 16, BtnPosY[ButtonPos.Shift] + 32, false, "v", fnt_button);



MsgBox_DungeonDel = noone;
