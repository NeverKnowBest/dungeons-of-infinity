//visible = false; //visible set to false so DepthDrawObjs can sort and draw everything manually

FloorLevel = GetFloorLevelID(x, y);
FloorLevelStr = GetFloorLevelString(FloorLevel);

WallInst = WallObj_Create("ObjsHigher_" + FloorLevelStr, x - 12, y - 28, 3, 2.5);
WallInst.FloorLevel = FloorLevel;

//Get game name from object
var ObjName = object_get_name(object_index);
var StrLen = string_length(ObjName);
var GameNamePos = string_pos("_", ObjName) + 1;
GameName = string_copy(ObjName, GameNamePos, StrLen - GameNamePos + 1) ;

MiniScreen_Sprite = asset_get_index(GameName == "Fake" ? "sArcadeScreen" + string(irandom(3)) : "sArcade_Screen_" + GameName);

MiniScreen_LightID = Lighting_CreateLight(RoomIndex, x, y - 23, 0.35, [1.1, 1.1, 1.1]);

MiniScreen_SpriteIndex = choose(0,1,2);
MiniScreenX = x - 6;
MiniScreenY = y - 27;
MiniScreenFrames = sprite_get_number(MiniScreen_Sprite);

alarm[0] = 8;

RoomW = 0;
RoomH = 0;

GameSurface = 0;
Sprite_BG = 0;

State = ArcadeState.UnUsed;

LinkInFront = false;
GameAllowed = true;