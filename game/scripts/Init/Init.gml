enum VP{
	Screen,
	Main,
	Map
}


function INIT(){


	
	//var pid = ProcessExecuteAsync("Stockfish.exe");
	//a = 0;
	
	//ExecutedProcessWriteToStandardInput(pid, "position startpos moves e2e4\ngo movetime 2000\n")
	//var output = ExecutedProcessReadFromStandardOutput(pid)
	//output = string_copy(output, string_pos("bestmove", output), 30);
	//a = 0;

	////FreeExecutedProcessStandardOutput(pid);
	////FreeExecutedProcessStandardInput(pid);

	//ProcIdKill(pid);

	//var pid = ProcessExecuteAsync("Stockfish.exe");
	//a = 0;
	
	//ExecutedProcessWriteToStandardInput(pid, "position startpos moves e2e4 c7c5\ngo movetime 2000\n")
	//var output = ExecutedProcessReadFromStandardOutput(pid)
	//output = string_copy(output, string_pos("bestmove", output), 30);
	//a = 0;
	
	//FreeExecutedProcessStandardOutput(pid);
	//FreeExecutedProcessStandardInput(pid);
	
	//ProcIdKill(pid);


	
	//  var out = ExecutedProcessReadFromStandardOutput(pid);
	//my_zip = xzip_create(
	//	//Archive
	//	"C:\\Google Drive\\Omnitron Studios\\Zelda\\Code\\Archive\\Data.xz",
	//	//Files
	//	//"C:\\Google Drive\\Omnitron Studios\\Zelda\\Code\\Archive\\DoorCoordinates.json",
	//	"C:\\Google Drive\\Omnitron Studios\\Zelda\\Code\\Archive\\Dungeons.json",
	//	//"C:\\Google Drive\\Omnitron Studios\\Zelda\\Code\\Archive\\Room Templates.json",
	//	//"C:\\Google Drive\\Omnitron Studios\\Zelda\\Code\\Archive\\RoomTemplateTileset.json"
	//);
	
	//game_end();
	//exit;
	//var lst = ds_list_create();
	//ds_list_add(lst, 1,2,3,4,5,6,7,8,9);
	
	//random_set_seed(12345);

	//ds_list_shuffle(lst);
	//var a = irandom(100);
	//random_set_seed(12345);

	//ds_list_shuffle(lst);
	//clipboard_set_text(string(lst[|0]) + ", " + string(lst[|1]) + ", " + string(lst[|2]) + ", " + string(lst[|3]))
	//show_debug_message(string(lst[|0]) + ", " + string(lst[|1]) + ", " + string(lst[|2]) + ", " + string(lst[|3]))
	
	//game_end();
	
	
	randomize();
	
	Data_InitGlobals();
	
	//InitScreen();
	
	Data_LoadDungeons();
	
	Data_LoadRoomTemplates();
		
	GenerateRoomTemplateObjGrids();
	GenerateTemplateMapRoomSprites();
	
	Inventory_InitData();
	
	Items_InitData();	
	Enemies_InitData();	
	
	BlockPatterns_Init();
	RupeePatterns_Init();
	
	PixelRender_Init();
	
	Music_InitData();

	
}


function InitScreen(){
		
	var TestWindow = false;

	var Parameters = parameter_count() - 1;
	for (var i = 1; i <= Parameters; i++){
	
		switch(parameter_string(i)){
			
			case "-t": //test
				TestWindow = true;
				break;
			
			case "-d":
				global.Dungeon_Index = real(parameter_string(i + 1));
				break;
		}
	
	}

	if(TestWindow){
		//window_set_size(1200, 675);
		//window_set_position(1000, 200);	
	}else{
		//window_set_fullscreen(true);
		//window_set_cursor(cr_none);
	}

}

function Data_InitGlobals(){

	math_set_epsilon(0.000001); //add more precision. There were rounding issues with rare prob cases at the 5th decimal place
	
	global.OldLinkSprites = false;
	
	global.DoorCoordinates = json_parse(buffer_read(buffer_load("DoorCoordinates.json"), buffer_string));

	
	//SpecialObj Combos
	
	global.SpecialObjComboTypeList = ds_list_create();
	ds_list_add(global.SpecialObjComboTypeList, "Pots", "Treasures", "Crystals", "PotTreasures", "TreasureCrystals", "PotCrystals", "PotTreasureCrystals");
	global.SpecialObjComboTypes = ds_list_size(global.SpecialObjComboTypeList);
	
	//SpecialObjComboIDs that contain pots
	global.SpecialObjComboIDList_Pots = ds_list_create();	
	ds_list_add(global.SpecialObjComboIDList_Pots, SpecialObjCombo.Pot, SpecialObjCombo.PotTreasure, SpecialObjCombo.PotCrystal, SpecialObjCombo.PotTreasureCrystal);
	//SpecialObjComboIDs that contain treasures
	global.SpecialObjComboIDList_Treasures = ds_list_create();	
	ds_list_add(global.SpecialObjComboIDList_Treasures, SpecialObjCombo.Treasure, SpecialObjCombo.PotTreasure, SpecialObjCombo.TreasureCrystal, SpecialObjCombo.PotTreasureCrystal);	
	//SpecialObjComboIDs that contain crystals
	global.SpecialObjComboIDList_Crystals = ds_list_create();
	ds_list_add(global.SpecialObjComboIDList_Crystals, SpecialObjCombo.Crystal, SpecialObjCombo.PotCrystal, SpecialObjCombo.TreasureCrystal, SpecialObjCombo.PotTreasureCrystal);
	//List of each type of SpecialObjComboIDList
	global.ListOfSpecialObjComboIDLists = ds_list_create();
	ds_list_add(global.ListOfSpecialObjComboIDLists, global.SpecialObjComboIDList_Pots, global.SpecialObjComboIDList_Treasures, global.SpecialObjComboIDList_Crystals);	


	//Lighting map for village level.	
	global.VillageLightingMap[7] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]; 
	global.VillageLightingMap[6] = [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
	global.VillageLightingMap[5] = [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
	global.VillageLightingMap[4] = [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0];
	global.VillageLightingMap[3] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0];
	global.VillageLightingMap[2] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0];
	global.VillageLightingMap[1] = [0.0, 0.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0];
	global.VillageLightingMap[0] = [0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0];

	
	global.LargeMapItems = ds_list_create();
	
	global.UnusedPrisoners = ds_list_create(); 
	global.UnusedShopKeepers = ds_list_create(); 
	
	global.Intro = true;
	global.Continue = false;
	
	var i = 0;
	global.DungeonNames[i++] = "Break Into the Castle"; 
	global.DungeonNames[i++] = "Hyrule Castle"; 
	global.DungeonNames[i++] = "Castle Basement";
	global.DungeonNames[i++] = "Castle Prison"; 
	global.DungeonNames[i++] = "Catacombs";
	global.DungeonNames[i++] = "Sewers"; 
	global.DungeonNames[i++] = "Rebel Village"; 
	global.DungeonNames[i++] = "Lanmola's Lair"; 
	global.DungeonNames[i++] = "Ancient Ruins 1"; 
	global.DungeonNames[i++] = "Ancient Ruins 2"; 
	global.DungeonNames[i++] = "Ancient Ruins 3"; 
	global.DungeonNames[i++] = "Moldorm's Lair"; 
	global.DungeonNames[i++] = "Aghanim's Fortress 1"; 
	global.DungeonNames[i++] = "Aghanim's Fortress 2"; 
	global.DungeonNames[i++] = "Aghanim's Fortress 3"; 
	global.DungeonNames[i++] = "Aghanim"; 
		
	i = 0;
	global.Characters[i++] = "Link"; 
	global.Characters[i++] = "Girl"; 
	global.Characters[i++] = "Zelda";
	global.Characters[i++] = "OldMan"; 
	global.Characters[i++] = "HyruleKnight"; 
	global.Characters[i++] = "Stalfos"; 
	global.Characters[i++] = "Moblin";
	global.Characters[i++] = "Zora";
	global.Characters[i++] = "Monkey";
	global.Characters[i++] = "Bunny";
	global.Characters[i++] = "Fox"; 
	global.Characters[i++] = "Frog"; 
	global.Characters[i++] = "Mouse"; 
	global.Characters[i++] = "Penguin"; 
	global.Characters[i++] = "Wolf"; 
	global.Characters[i++] = "DrakeDragon";
	global.Characters[i++] = "Mario"; 
	global.Characters[i++] = "Luigi"; 
	global.Characters[i++] = "PrincessPeach"; 
	global.Characters[i++] = "Toad";
	global.Characters[i++] = "Bowser"; 
	global.Characters[i++] = "Yoshi"; 
	global.Characters[i++] = "Sonic"; 
	global.Characters[i++] = "Megaman"; 
	global.Characters[i++] = "Pikachu"; 
	global.Characters[i++] = "TMNT"; 
	global.Characters[i++] = "BlackMage"; 
	global.Characters[i++] = "Batman"; 
	global.Characters[i++] = "BobRoss";
	global.Characters[i++] = "Hotdog";
	global.Characters[i++] = "Ghost";
	global.Characters[i++] = "Astronaut";
	
}

function InitLayers(){

	global.LayerID_System = layer_get_id("System");
	global.LayerID_Tiles_Higher = layer_get_id("Tiles_Higher");
	global.LayerID_ObjsHigher_Upper = layer_get_id("ObjsHigher_Upper");
	global.LayerID_Objs_Upper = layer_get_id("Objs_Upper");
	global.LayerID_ObjsFloor_Upper = layer_get_id("ObjsFloor_Upper");
	global.LayerID_ObjsDoors_Upper = layer_get_id("ObjsDoors_Upper");
	global.LayerID_Tiles_Ceiling = layer_get_id("Tiles_Ceiling");
	global.LayerID_Tiles_UpperRails = layer_get_id("Tiles_UpperRails");
	global.LayerID_Tiles_Decor_Upper = layer_get_id("Tiles_Decor_Upper");	
	global.LayerID_Tiles_Walls_Upper = layer_get_id("Tiles_Walls_Upper");
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
	global.LayerID_Starfield = layer_get_id("Starfield");
	

	global.TMID_Higher = layer_tilemap_get_id(global.LayerID_Tiles_Higher);
	global.TMID_Ceiling = layer_tilemap_get_id(global.LayerID_Tiles_Ceiling);
	global.TMID_Decor_Upper = layer_tilemap_get_id(global.LayerID_Tiles_Decor_Upper);
	global.TMID_Walls_Upper = layer_tilemap_get_id(global.LayerID_Tiles_Walls_Upper);
	global.TMID_Water_Upper = layer_tilemap_get_id(global.LayerID_Tiles_Water_Upper);
	global.TMID_Floor_Upper = layer_tilemap_get_id(global.LayerID_Tiles_Floor_Upper);
	
	global.TMID_Decor_Lower = layer_tilemap_get_id(global.LayerID_Tiles_Decor_Lower);
	global.TMID_Walls_Lower = layer_tilemap_get_id(global.LayerID_Tiles_Walls_Lower);
	global.TMID_Water_Lower = layer_tilemap_get_id(global.LayerID_Tiles_Water_Lower);
	global.TMID_Floor_Lower = layer_tilemap_get_id(global.LayerID_Tiles_Floor_Lower);
	
	global.TMID_Pit = layer_tilemap_get_id(global.LayerID_Tiles_Pit);
	
	global.TMID[TileLayer.Pit] = global.TMID_Pit;
	global.TMID[TileLayer.Floor_Lower] = global.TMID_Floor_Lower;
	global.TMID[TileLayer.Water_Lower] = global.TMID_Water_Lower;
	global.TMID[TileLayer.Walls_Lower] = global.TMID_Walls_Lower;
	global.TMID[TileLayer.Decor_Lower] = global.TMID_Decor_Lower;
	global.TMID[TileLayer.Floor_Upper] = global.TMID_Floor_Upper;
	global.TMID[TileLayer.Water_Upper] = global.TMID_Water_Upper;
	global.TMID[TileLayer.Walls_Upper] = global.TMID_Walls_Upper;
	global.TMID[TileLayer.Decor_Upper] = global.TMID_Decor_Upper;
	global.TMID[TileLayer.Ceiling] = global.TMID_Ceiling;
	global.TMID[TileLayer.Higher] = global.TMID_Higher;
	
	
	layer_script_begin(global.LayerID_Tiles_Higher, PixelRender_Tiles_Simple);
	layer_script_end(global.LayerID_Tiles_Higher, PixelRender_Tiles_End);
	
	layer_script_begin(global.LayerID_Tiles_Ceiling, PixelRender_Tiles_Ceiling);
	layer_script_end(global.LayerID_Tiles_Ceiling, PixelRender_Tiles_End);

	layer_script_begin(global.LayerID_Tiles_Decor_Upper, PixelRender_Tiles_Simple);
	layer_script_end(global.LayerID_Tiles_Decor_Upper, PixelRender_Tiles_End);

	layer_script_begin(global.LayerID_Tiles_Walls_Upper, PixelRender_Tiles_Simple);
	layer_script_end(global.LayerID_Tiles_Walls_Upper, PixelRender_Tiles_End);

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


function Data_LoadDungeons(){
	
	global.Templates_Dungeon = array_create(4);
	
	global.Templates_Dungeon[Flip.None] = json_parse(buffer_read(buffer_load("Dungeons.json"), buffer_string));
	
	//var buf_Dungeons = xzip_read("C:\\Google Drive\\Omnitron Studios\\Zelda\\Code\\Archive\\Data.xz", "Dungeons.json");
	//if (buffer_exists(buf_Dungeons)) {
	//	global.Templates_Dungeon = json_parse(buffer_read(buf_Dungeons, buffer_string));		
	//}else{
	//	game_end();	
	//}
	
	ConvertDoorStatuses();
	

	//Create a copy of the dungeons, but flipped horizontally, vertically, and both. Make necessary changes to Room posititons, doors, sections, etc
	global.Templates_Dungeon[Flip.H] = StructCopy(global.Templates_Dungeon[Flip.None]);
	global.Templates_Dungeon[Flip.V] = StructCopy(global.Templates_Dungeon[Flip.None]);
	global.Templates_Dungeon[Flip.HV] = StructCopy(global.Templates_Dungeon[Flip.None]);

	//Horizontal flipped dungeon
	for(var DungeonIndex = 0; DungeonIndex < array_length(global.Templates_Dungeon[Flip.H]); DungeonIndex++){
		var RoomArray = global.Templates_Dungeon[Flip.H][DungeonIndex][$ "Rooms"];
		for(var RoomIndex = 0; RoomIndex < array_length(RoomArray); RoomIndex++){
			
			RoomArray[RoomIndex].GridX = DungeonGridW - RoomArray[RoomIndex].GridX - RoomArray[RoomIndex].GridW;
			RoomArray[RoomIndex].x = RoomArray[RoomIndex].GridX * 256;
			
			var RoomSizeIndex = GetRoomSizeIndex(RoomArray[RoomIndex].GridW, RoomArray[RoomIndex].GridH);
			
			//Flip Doors
			var DoorArray = RoomArray[RoomIndex].Doors;
			for(var DoorIndex = 0; DoorIndex < array_length(DoorArray); DoorIndex++){
				
				if(DoorArray[DoorIndex].Position <= 12){
					DoorArray[DoorIndex].Position = 12 - DoorArray[DoorIndex].Position;
					if(DoorArray[DoorIndex].Position < 1) DoorArray[DoorIndex].Position += 12;
				}else{
					DoorArray[DoorIndex].Position = 36 - DoorArray[DoorIndex].Position;
					if(DoorArray[DoorIndex].Position < 13) DoorArray[DoorIndex].Position += 12;
				}
				
				DoorArray[DoorIndex].x = global.DoorCoordinates[RoomSizeIndex][DoorArray[DoorIndex].Position].x
				DoorArray[DoorIndex].y = global.DoorCoordinates[RoomSizeIndex][DoorArray[DoorIndex].Position].y
				if(DoorArray[DoorIndex].Location == "Right") DoorArray[DoorIndex].Location = "Left";
				else if(DoorArray[DoorIndex].Location == "Left") DoorArray[DoorIndex].Location = "Right";
				
			}
			
			//Flip Section
			if(RoomArray[RoomIndex][$ "Section_ID"] > 0) RoomArray[RoomIndex][$ "Section_ID"] = GetTransformedSectionID(RoomArray[RoomIndex][$ "Section_ID"], ObjTransformation.FlipH);
			

		}
	}


	//Vertical flipped dungeon
	for(var DungeonIndex = 0; DungeonIndex < array_length(global.Templates_Dungeon[Flip.V]); DungeonIndex++){
		var RoomArray = global.Templates_Dungeon[Flip.V][DungeonIndex].Rooms;
		for(var RoomIndex = 0; RoomIndex < array_length(RoomArray); RoomIndex++){
			
			RoomArray[RoomIndex].GridY = DungeonGridW - RoomArray[RoomIndex].GridY - RoomArray[RoomIndex].GridH;
			RoomArray[RoomIndex].y = RoomArray[RoomIndex].GridY * 256;
			
			var RoomSizeIndex = GetRoomSizeIndex(RoomArray[RoomIndex].GridW, RoomArray[RoomIndex].GridH);
			
			//Flip Doors
			var DoorArray = RoomArray[RoomIndex].Doors;
			for(var DoorIndex = 0; DoorIndex < array_length(DoorArray); DoorIndex++){
				
				if(DoorArray[DoorIndex].Position <= 12){
					DoorArray[DoorIndex].Position = 6 - DoorArray[DoorIndex].Position;
					if(DoorArray[DoorIndex].Position < 1) DoorArray[DoorIndex].Position += 12;
				}else{
					DoorArray[DoorIndex].Position = 30 - DoorArray[DoorIndex].Position;
					if(DoorArray[DoorIndex].Position < 13) DoorArray[DoorIndex].Position += 12;
				}
				
				DoorArray[DoorIndex].x = global.DoorCoordinates[RoomSizeIndex][DoorArray[DoorIndex].Position].x
				DoorArray[DoorIndex].y = global.DoorCoordinates[RoomSizeIndex][DoorArray[DoorIndex].Position].y
				if(DoorArray[DoorIndex].Location == "Top") DoorArray[DoorIndex].Location = "Bottom";
				else if(DoorArray[DoorIndex].Location == "Bottom") DoorArray[DoorIndex].Location = "Top";
				
			}
			
			//Flip Section
			if(RoomArray[RoomIndex][$ "Section_ID"] > 0) RoomArray[RoomIndex][$ "Section_ID"] = GetTransformedSectionID(RoomArray[RoomIndex][$ "Section_ID"], ObjTransformation.FlipV);
			

		}
	}


	//Horizontal & Vertical flipped dungeon
	for(var DungeonIndex = 0; DungeonIndex < array_length(global.Templates_Dungeon[Flip.HV]); DungeonIndex++){
		var RoomArray = global.Templates_Dungeon[Flip.HV][DungeonIndex].Rooms;
		for(var RoomIndex = 0; RoomIndex < array_length(RoomArray); RoomIndex++){
			
			RoomArray[RoomIndex].GridX = DungeonGridW - RoomArray[RoomIndex].GridX - RoomArray[RoomIndex].GridW;
			RoomArray[RoomIndex].GridY = DungeonGridW - RoomArray[RoomIndex].GridY - RoomArray[RoomIndex].GridH;
			RoomArray[RoomIndex].x = RoomArray[RoomIndex].GridX * 256;
			RoomArray[RoomIndex].y = RoomArray[RoomIndex].GridY * 256;
			
			var RoomSizeIndex = GetRoomSizeIndex(RoomArray[RoomIndex].GridW, RoomArray[RoomIndex].GridH);
			
			//Flip Doors
			var DoorArray = RoomArray[RoomIndex].Doors;
			for(var DoorIndex = 0; DoorIndex < array_length(DoorArray); DoorIndex++){
				
				//first reposition horizontally
				if(DoorArray[DoorIndex].Position <= 12){
					DoorArray[DoorIndex].Position = 12 - DoorArray[DoorIndex].Position;
					if(DoorArray[DoorIndex].Position < 1) DoorArray[DoorIndex].Position += 12;
				}else{
					DoorArray[DoorIndex].Position = 36 - DoorArray[DoorIndex].Position;
					if(DoorArray[DoorIndex].Position < 13) DoorArray[DoorIndex].Position += 12;
				}
				//then reposition vertically
				if(DoorArray[DoorIndex].Position <= 12){
					DoorArray[DoorIndex].Position = 6 - DoorArray[DoorIndex].Position;
					if(DoorArray[DoorIndex].Position < 1) DoorArray[DoorIndex].Position += 12;
				}else{
					DoorArray[DoorIndex].Position = 30 - DoorArray[DoorIndex].Position;
					if(DoorArray[DoorIndex].Position < 13) DoorArray[DoorIndex].Position += 12;
				}
				
				DoorArray[DoorIndex].x = global.DoorCoordinates[RoomSizeIndex][DoorArray[DoorIndex].Position].x
				DoorArray[DoorIndex].y = global.DoorCoordinates[RoomSizeIndex][DoorArray[DoorIndex].Position].y
				if(DoorArray[DoorIndex].Location == "Right") DoorArray[DoorIndex].Location = "Left";
				else if(DoorArray[DoorIndex].Location == "Left") DoorArray[DoorIndex].Location = "Right";
				else if(DoorArray[DoorIndex].Location == "Top") DoorArray[DoorIndex].Location = "Bottom";
				else if(DoorArray[DoorIndex].Location == "Bottom") DoorArray[DoorIndex].Location = "Top";
				
			}
			
			//Flip Section
			if(RoomArray[RoomIndex][$ "Section_ID"] > 0) RoomArray[RoomIndex][$ "Section_ID"] = GetTransformedSectionID(RoomArray[RoomIndex][$ "Section_ID"], ObjTransformation.FlipHV);

		}
	}
		
}

function ConvertDoorStatuses(){
	
	//Convert door Statuses since the game has extra ones not represented in the editor.
	//In the game, Status 2 is door half open which is not used in the editor and Status 5 is Unlock half-open, 
	for(var DungeonIndex = 0; DungeonIndex < array_length(global.Templates_Dungeon[Flip.None]); DungeonIndex++){
		var RoomArray = global.Templates_Dungeon[Flip.None][DungeonIndex].Rooms;
		for(var RoomIndex = 0; RoomIndex < array_length(RoomArray); RoomIndex++){
			
			var DoorArray = RoomArray[RoomIndex].Doors;
			for(var DoorIndex = 0; DoorIndex < array_length(DoorArray); DoorIndex++){
				if(RoomIndex == global.Templates_Dungeon[Flip.None][DungeonIndex].EntranceRoomIndex && DoorArray[DoorIndex].Position == 6){
					DoorArray[DoorIndex].Status = DoorStatus.Entrance; 
				}else{
					var NewStatus = 0;
					switch(DoorArray[DoorIndex].Status){
						case 0: NewStatus = DoorStatus.Open; break; 
						case 1: NewStatus = DoorStatus.Closed; break;
						case 2: NewStatus = DoorStatus.Locked; break;
					}	
					DoorArray[DoorIndex].Status = NewStatus;
				}
			}
		}
	}	
}

