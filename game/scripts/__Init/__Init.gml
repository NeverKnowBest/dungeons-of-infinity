
function INIT(){
	
	math_set_epsilon(0.000001); //add more precision. There were rounding issues with rare prob cases at the 5th decimal place
	
	randomize();
	
	Data_InitGlobals();
	
	Dungeon_LoadTemplates();
	
	RoomTemplates_Load();
	
	Items_InitData();
	
	Inventory_InitData();
		
	Enemies_InitData();	

	RupeePatterns_Init();
	
	PixelRender_Init();
	
	Music_InitData();
	
	
}

function Data_InitGlobals(){
	
	Data_InitDoorCoordinates();
	
	global.RoomSizeIndex[1][1] = RoomSize._1x1;
	global.RoomSizeIndex[1][2] = RoomSize._1x2;
	global.RoomSizeIndex[2][1] = RoomSize._2x1;
	global.RoomSizeIndex[2][2] = RoomSize._2x2;

	//Lighting map for village level.	
	global.VillageLightingMap[0] = [1, 1, 1, 1, 0, 0, 0, 0];
	global.VillageLightingMap[1] = [1, 1, 1, 1, 0, 0, 1, 1];
	global.VillageLightingMap[2] = [1, 0, 0, 0, 0, 0, 0, 1];
	global.VillageLightingMap[3] = [1, 0, 0, 0, 0, 0, 0, 1];
	global.VillageLightingMap[4] = [1, 0, 0, 0, 0, 0, 0, 0];
	global.VillageLightingMap[5] = [1, 0, 0, 0, 0, 0, 0, 0];
	global.VillageLightingMap[6] = [0, 1, 0, 0, 0, 0, 1, 0];
	global.VillageLightingMap[7] = [0, 0, 0, 0, 0, 0, 0, 0]; 
	
	global.MainTemplates_Mine[0] = [-1,-1,-1,-1,-1,-1, 0,-1];
	global.MainTemplates_Mine[1] = [-1,-1,-1,-1,-1, 1, 0,-1];
	global.MainTemplates_Mine[2] = [-1,-1,-1, 2, 2, 3, 3, 4];
	global.MainTemplates_Mine[3] = [-1,-1,-1, 2, 2, 3, 3,-1];
	global.MainTemplates_Mine[4] = [ 8, 9,10,11, 5, 6, 6,12];
	global.MainTemplates_Mine[5] = [13,14,15,16,17,18,19,20];
	global.MainTemplates_Mine[6] = [21,22,23,24,25,26,27,28];
	global.MainTemplates_Mine[7] = [29,30,31,32,33,34,35,36];
	
	global.LargeMapItems = ds_list_create();
	
	global.UnusedPrisoners = ds_list_create(); 
	global.UnusedShopKeepers = ds_list_create(); 
	
	InitGemPrizes();
	
	global.Continue = false;
	global.SaveLevel = false;	
	global.ContinueLevel = 0;
	
	global.CrashSoundID = 0;
	
	global.InWaterSprite = sInWater;
	
	var i = 0;
	global.DungeonNames[i++] = "Destroy Agahnim"; 
	global.DungeonNames[i++] = "Hyrule Castle"; 
	global.DungeonNames[i++] = "Castle Basement";
	global.DungeonNames[i++] = "Castle Prison"; 
	global.DungeonNames[i++] = "Catacombs";
	global.DungeonNames[i++] = "Sewers"; 
	global.DungeonNames[i++] = "Rebel Village"; 
	global.DungeonNames[i++] = "Lanmola's Lair"; 
	global.DungeonNames[i++] = "Ancient Ruins"; 
	global.DungeonNames[i++] = "Water Temple"; 
	global.DungeonNames[i++] = "Dwarven Mining Town"; 
	global.DungeonNames[i++] = "Moldorm's Lair"; 
	global.DungeonNames[i++] = "Agahnim's Fortress"; 
	global.DungeonNames[i++] = "Agahnim"; 
	
}

function InitLayers(){

	global.LayerID_System = layer_get_id("System");
	global.LayerID_ObjsHighest = layer_get_id("ObjsHighest");
	global.LayerID_Tiles_Ceiling = layer_get_id("Tiles_Ceiling");
	global.LayerID_Tiles_Highest = layer_get_id("Tiles_Highest");
	global.LayerID_ObjsHigher_Upper = layer_get_id("ObjsHigher_Upper");
	global.LayerID_Tiles_Higher = layer_get_id("Tiles_Higher");
	global.LayerID_Objs_Upper = layer_get_id("Objs_Upper");
	global.LayerID_ObjsFloor_Upper = layer_get_id("ObjsFloor_Upper");
	global.LayerID_ObjsDoors_Upper = layer_get_id("ObjsDoors_Upper");
	global.LayerID_Tiles_Decor_Upper = layer_get_id("Tiles_Decor_Upper");	
	global.LayerID_Tiles_Walls_Upper = layer_get_id("Tiles_Walls_Upper");
	
	//special layers only used to placing monuments and monument decor on upper floor stair templates because there's no other layer that could work to illuminate them correctly when room is dark and Link is on lower floor
	//We can't put them on floor or water layers in case water is below the monument, and walls and decor layers are always illuminated, causing the monuments to be seen
	global.LayerID_Tiles_StairMonumentsDecor = layer_get_id("Tiles_StairMonumentsDecor"); 
	global.LayerID_Tiles_StairMonuments = layer_get_id("Tiles_StairMonuments");
	
	global.LayerID_Tiles_Water_Upper = layer_get_id("Tiles_Water_Upper");
	global.LayerID_Tiles_Floor_Upper = layer_get_id("Tiles_Floor_Upper");
	global.LayerID_ObjsHigher_Lower = layer_get_id("ObjsHigher_Lower");
	global.LayerID_Objs_Lower = layer_get_id("Objs_Lower");
	global.LayerID_ObjsFloor_Lower = layer_get_id("ObjsFloor_Lower");
	global.LayerID_ObjsDoors_Lower = layer_get_id("ObjsDoors_Lower");
	global.LayerID_Tiles_Decor_Lower = layer_get_id("Tiles_Decor_Lower");
	global.LayerID_Tiles_Walls_Lower = layer_get_id("Tiles_Walls_Lower");
	global.LayerID_Tiles_Water_Lower = layer_get_id("Tiles_Water_Lower");
	global.LayerID_Tiles_Floor_Lower = layer_get_id("Tiles_Floor_Lower");
	global.LayerID_Tiles_Pit = layer_get_id("Tiles_Pit");
	global.LayerID_Tiles_Lava = layer_get_id("Tiles_Lava");
	global.LayerID_Starfield = layer_get_id("Starfield");
	

	global.TMID_Tiles_Ceiling = layer_tilemap_get_id(global.LayerID_Tiles_Ceiling);
	global.TMID_Tiles_Highest = layer_tilemap_get_id(global.LayerID_Tiles_Highest);
	global.TMID_Tiles_Higher = layer_tilemap_get_id(global.LayerID_Tiles_Higher);
	global.TMID_Decor_Upper = layer_tilemap_get_id(global.LayerID_Tiles_Decor_Upper);
	global.TMID_Walls_Upper = layer_tilemap_get_id(global.LayerID_Tiles_Walls_Upper);
	global.TMID_StairMonumentsDecor = layer_tilemap_get_id(global.LayerID_Tiles_StairMonumentsDecor);
	global.TMID_StairMonuments = layer_tilemap_get_id(global.LayerID_Tiles_StairMonuments);
	global.TMID_Water_Upper = layer_tilemap_get_id(global.LayerID_Tiles_Water_Upper);
	global.TMID_Floor_Upper = layer_tilemap_get_id(global.LayerID_Tiles_Floor_Upper);
	
	global.TMID_Decor_Lower = layer_tilemap_get_id(global.LayerID_Tiles_Decor_Lower);
	global.TMID_Walls_Lower = layer_tilemap_get_id(global.LayerID_Tiles_Walls_Lower);
	global.TMID_Water_Lower = layer_tilemap_get_id(global.LayerID_Tiles_Water_Lower);
	global.TMID_Floor_Lower = layer_tilemap_get_id(global.LayerID_Tiles_Floor_Lower);
	
	global.TMID_Pit = layer_tilemap_get_id(global.LayerID_Tiles_Pit);
	global.TMID_Lava = layer_tilemap_get_id(global.LayerID_Tiles_Lava);
	
	global.TMID[TileLayer.Lava] = global.TMID_Lava;
	global.TMID[TileLayer.Pit] = global.TMID_Pit;
	global.TMID[TileLayer.Floor_Lower] = global.TMID_Floor_Lower;
	global.TMID[TileLayer.Water_Lower] = global.TMID_Water_Lower;
	global.TMID[TileLayer.Walls_Lower] = global.TMID_Walls_Lower;
	global.TMID[TileLayer.Decor_Lower] = global.TMID_Decor_Lower;
	global.TMID[TileLayer.Floor_Upper] = global.TMID_Floor_Upper;
	global.TMID[TileLayer.Water_Upper] = global.TMID_Water_Upper;
	global.TMID[TileLayer.StairMonuments] = global.TMID_StairMonuments;
	global.TMID[TileLayer.StairMonumentsDecor] = global.TMID_StairMonumentsDecor;
	global.TMID[TileLayer.Walls_Upper] = global.TMID_Walls_Upper;
	global.TMID[TileLayer.Decor_Upper] = global.TMID_Decor_Upper;
	global.TMID[TileLayer.Higher] = global.TMID_Tiles_Higher;
	global.TMID[TileLayer.Highest] = global.TMID_Tiles_Highest;
	global.TMID[TileLayer.Ceiling] = global.TMID_Tiles_Ceiling;
	

	layer_script_begin(global.LayerID_Tiles_Ceiling, PixelRender_Tiles_Ceiling);
	layer_script_end(global.LayerID_Tiles_Ceiling, PixelRender_Tiles_End);
	
	layer_script_begin(global.LayerID_Tiles_Highest, PixelRender_Tiles_Simple);
	layer_script_end(global.LayerID_Tiles_Highest, PixelRender_Tiles_End);
	
	layer_script_begin(global.LayerID_Tiles_Higher, PixelRender_Tiles_Simple);
	layer_script_end(global.LayerID_Tiles_Higher, PixelRender_Tiles_End);

	layer_script_begin(global.LayerID_Tiles_Decor_Upper, PixelRender_Tiles_Simple);
	layer_script_end(global.LayerID_Tiles_Decor_Upper, PixelRender_Tiles_End);

	layer_script_begin(global.LayerID_Tiles_Walls_Upper, PixelRender_Tiles_Simple);
	layer_script_end(global.LayerID_Tiles_Walls_Upper, PixelRender_Tiles_End);

	layer_script_begin(global.LayerID_Tiles_StairMonuments, PixelRender_Tiles_Floor_Upper);
	layer_script_end(global.LayerID_Tiles_StairMonuments, PixelRender_Tiles_End);

	layer_script_begin(global.LayerID_Tiles_StairMonumentsDecor, PixelRender_Tiles_Floor_Upper);
	layer_script_end(global.LayerID_Tiles_StairMonumentsDecor, PixelRender_Tiles_End);

	layer_script_begin(global.LayerID_Tiles_Water_Upper, PixelRender_Tiles_Floor_Upper);
	layer_script_end(global.LayerID_Tiles_Water_Upper, PixelRender_Tiles_End);
	
	layer_script_begin(global.LayerID_Tiles_Floor_Upper, PixelRender_Tiles_Floor_Upper);
	layer_script_end(global.LayerID_Tiles_Floor_Upper, PixelRender_Tiles_End);

	layer_script_begin(global.LayerID_Tiles_Decor_Lower, PixelRender_Tiles_Simple);
	layer_script_end(global.LayerID_Tiles_Decor_Lower, PixelRender_Tiles_End);

	layer_script_begin(global.LayerID_Tiles_Walls_Lower, PixelRender_Tiles_Simple);
	layer_script_end(global.LayerID_Tiles_Walls_Lower, PixelRender_Tiles_End);

	layer_script_begin(global.LayerID_Tiles_Water_Lower, PixelRender_Tiles_Floor_Lower);
	layer_script_end(global.LayerID_Tiles_Water_Lower, PixelRender_Tiles_End);
	
	layer_script_begin(global.LayerID_Tiles_Floor_Lower, PixelRender_Tiles_Floor_Lower);
	layer_script_end(global.LayerID_Tiles_Floor_Lower, PixelRender_Tiles_End);

	layer_script_begin(global.LayerID_Tiles_Pit, PixelRender_Tiles_Simple);
	layer_script_end(global.LayerID_Tiles_Pit, PixelRender_Tiles_End);
	
}

function Data_InitDoorCoordinates(){
	
	global.DoorCoordinates = Array_Create2D(24, 4);
	
	XYArray[RoomSize._1x1] = [168, 16,		//1
							  216, 56,
							  216, 112,
							  216, 168,
							  168, 216,
							  112, 216,		//6
							  56, 216,
							  16, 168,
							  16, 112,
							  16, 56,
							  56, 16,
							  112, 16,		//12
							  152, 40,		//13
							  192, 72,
							  192, 112,
							  192, 152,
							  152, 192,
							  112, 192,		//18
							  72, 192,
							  40, 152,
							  40, 112,
							  40, 72,
							  72, 40,
							  112, 40]		//24

	XYArray[RoomSize._1x2] = [168, 16,		//1
							  216, 112,
							  216, 240,
							  216, 368,
							  168, 472,
							  112, 472,		//6
							  56, 472,
							  16, 368,
							  16, 240,
							  16, 112,
							  56, 16,
							  112, 16,		//12
							  152, 40,		//13
							  192, 112,
							  192, 240,
							  192, 368,
							  152, 448,
							  112, 448,		//18
							  72, 448,
							  40, 368,
							  40, 240,
							  40, 112,
							  72, 40,
							  112, 40]		//24

	XYArray[RoomSize._2x1] = [368, 16,		//1
							  472, 56,
							  472, 112,
							  472, 168,
							  368, 216,
							  240, 216,		//6
							  112, 216,
							  16, 168,
							  16, 112,
							  16, 56,
							  112, 16,
							  240, 16,		//12
							  368, 40,		//13
							  448, 72,
							  448, 112,
							  448, 152,
							  368, 192,
							  240, 192,		//18
							  112, 192,
							  40, 152,
							  40, 112,
							  40, 72,
							  112, 40,
							  240, 40]		//24

	XYArray[RoomSize._2x2] = [368, 16,		//1
							  472, 112,
							  472, 240,
							  472, 368,
							  368, 472,
							  240, 472,		//6
							  112, 472,
							  16, 368,
							  16, 240,
							  16, 112,
							  112, 16,
							  240, 16,		//12
							  368, 40,		//13
							  448, 112,
							  448, 240,
							  448, 368,
							  368, 448,
							  240, 448,		//18
							  112, 448,
							  40, 368,
							  40, 240,
							  40, 112,
							  112, 40,
							  240, 40]		//24
							  
	for(var _RoomSize = 0; _RoomSize < 4; _RoomSize++){
		for(var _Position = 0; _Position < 24; _Position++){
			var _x = XYArray[_RoomSize][_Position * 2];
			var _y = XYArray[_RoomSize][(_Position * 2) + 1];
			global.DoorCoordinates[_RoomSize][_Position + 1] = new Data_CreateStruct_DoorCoordinate(_x, _y, _Position + 1);
		}
	}

	
}

function Data_CreateStruct_DoorCoordinate(_x, _y, _position) constructor{
	
	x = _x;
	y = _y;

	Level = (_position <= 12 ? "Upper" : "Lower");
	
	switch(_position){
		case 11: case 12: case 1: case 23: case 24: case 13:
			Location = "Top";
			break;
		case 2: case 3: case 4: case 14: case 15: case 16:
			Location = "Right";
			break;
		case 5: case 6: case 7: case 17: case 18: case 19:
			Location = "Bottom";
			break;
		case 8: case 9: case 10: case 20: case 21: case 22:
			Location = "Left";
			break;
	}
}