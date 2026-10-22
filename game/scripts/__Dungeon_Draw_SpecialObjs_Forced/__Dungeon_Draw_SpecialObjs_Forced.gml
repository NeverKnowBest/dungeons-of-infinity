// Feather disable GM2064



function Dungeon_Draw_SpecialObjs_Forced(_RoomIndex){
	
	
	if(global.Level.Index != DungeonLevel.Start && global.Level.Index != DungeonLevel.Aghanim2){
		if(!variable_struct_exists(Room.Template, "Objs")) exit;
	}
	
	var SpecialRoomObjsArray = Room.Template.Objs;	
	
	var ObjCount = array_length(SpecialRoomObjsArray);
	
	var MonumentStyleSelected = false;
	var ColumnStyle = irandom(1);
	
	var MonumentStyle, inst, _x, WallInst, _y, SideXR, Inst, _TemplateClass, _TemplateSubClass, DoorWarpTemplateIndex, DoorWarpTemplateID, _TemplateArray, House_MapGridX, House_MapGridY, DoorRoomIndexWarp, ArcadeType, PosX, PosY, _WallInst, XPos, _Inst, WallObjInst, _DoorInst, _Index, _inst, _ObjLayer;
	for(var SpecialRoomObjIndex = 0; SpecialRoomObjIndex < ObjCount; SpecialRoomObjIndex++){
		
		var Obj = SpecialRoomObjsArray[SpecialRoomObjIndex];
		var ObjX = Room.x + Obj.x;
		var ObjY = Room.y + Obj.y;
		var ObjW = Obj.width;
		var ObjH = Obj.height;
		var ObjTileW = ObjW / 8;
		var ObjTileH = ObjH / 8;
		var ObjRot = Obj.rotation;
	
		var ObjX2 = ObjX + ObjW - 8; //coordinates of the opposite edge tiles
		var ObjY2 = ObjY + ObjH - 8;		
		
		var ObjGID = variable_struct_exists(Obj, "gid") ? Obj.gid : -1;
		var FloorTMID = GetFloorLevelTMID("Tiles_Floor", ObjX, ObjY); 
		var WaterTMID = GetFloorLevelTMID("Tiles_Water", ObjX, ObjY); 
		var WallTMID = GetFloorLevelTMID("Tiles_Walls", ObjX, ObjY);
		var DecorTMID = GetFloorLevelTMID("Tiles_Decor", ObjX, ObjY);
		var FloorLevel = GetFloorLevelID(ObjX, ObjY);
		var FloorLevelStr = GetFloorLevelString(FloorLevel);
		var PropertiesArray = Obj.properties;
		var ObjName = Obj[$ "name"];
		var ObjType = Obj[$ "type"];
		

		switch(ObjGID){
			
			case TemplateObjGID.Pot:
				Pot_Create(_RoomIndex, ObjX, ObjY, Probs_RandomItemClass_Pot(false));
				break;
				
			case TemplateObjGID.Monument:
				
				if(!MonumentStyleSelected){
					
					MonumentStyle = Decor_Monuments_AllowedStyle(ObjX, ObjY, true);
					
					switch(global.Level.Index){
						case DungeonLevel.Catacombs:
							if(MonumentStyle == 2) MonumentStyle = 3; //don't use graves in special rooms
							break;
						
					}
					
					MonumentStyleSelected = true;
				}
				
				if(ObjType != ""){
					MonumentStyle = real(ObjType); //force a style using the type field
				}
				var _DrawMonumentItems = true;
	
				var TileX = 116 + (MonumentStyle * 4);
				var TileY = LevelTilesY;
				var _Mirrored = FlipCoin_Bool();
				
				switch(global.Level.Index){

					case DungeonLevel.CastleJails:
						_DrawMonumentItems = false;
						break;
					
					case DungeonLevel.Village:
						if( (DungeonRoom.GridX == 6 && DungeonRoom.GridY == 6) ||
							(DungeonRoom.GridX == 7 && DungeonRoom.GridY == 1) ){ //secret exit room, rock monument only
							TileX = 120;
							_DrawMonumentItems = false;
						}
						break;
						
					case DungeonLevel.Mines:
						if( (DungeonRoom.GridX == 4 && DungeonRoom.GridY == 1) || //secret rooms, rock monument only
							(DungeonRoom.GridX == 7 && DungeonRoom.GridY == 3) ||
							(DungeonRoom.GridX == 7 && DungeonRoom.GridY == 4) ){
							TileX = 124;
							_DrawMonumentItems = false;
						}
						break;
						
					case DungeonLevel.Aghanim2:
						TileX = 134;
						TileY = VillageTilesY + 8;
						_Mirrored = false;
						break;
				}

				if(ObjName == "Fairy"){
					TileX = 28;
					TileY = 0;	
					_DrawMonumentItems = false;
					_Mirrored = false;
				}
						
				
				DrawTileBlock(WallTMID, ObjX, ObjY, TileX, TileY, 4, 4, _Mirrored);
			
				//Extra items on top
				if(_DrawMonumentItems) Decor_MonumentItems(DecorTMID, ObjX, ObjY, MonumentStyle, _Mirrored)
			
				var WallInst1 = WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, 4, 4);
				WallInst1.BlockProjectiles = false; 
				var WallInst2 = WallObj_Create("Objs_" + FloorLevelStr, ObjX + 8, ObjY + 8, 2, 2);
				WallInst2.BlockProjectiles = true; 
			
				break;
			
			case TemplateObjGID.Kinstone:

				var _RodCharger = (GetPropertyValue(PropertiesArray, "RodCharger") != -1) || (!global.Level.RodCharger && Prob(Chance_SpawnRodChargerSpecial) && GetPropertyValue(PropertiesArray, "NoCharger") == -1);
				
				DrawTileBlock(GetFloorLevelTMID("Tiles_Walls", ObjX, ObjY), ObjX, ObjY, 32 + (_RodCharger ? 4 : 0), 0, 4, 4);							
				
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, 1, 4);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX + 8, ObjY + 8, 2, 3);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX + 24, ObjY, 1, 4);
				WallInst = WallObj_Create("Objs_" + FloorLevelStr, ObjX + 8, ObjY, 2, 1);
				WallInst.BlockLink = false;

				if(_RodCharger){
					inst = instance_create_layer(ObjX + 16, ObjY + 14, "ObjsHigher_" + FloorLevelStr, oRodCharger, {RoomIndex : _RoomIndex});
					SignCreate(ObjX + 16, ObjY + 32, global.RodChargerSignText, true);
					global.Level.RodCharger = true;
				}else{
					inst = instance_create_layer(ObjX + 16, ObjY + 14, "ObjsHigher_" + FloorLevelStr, oItem_Kinstone_Main, {Index : Kinstone_PickIndex(), RoomIndex : _RoomIndex});
					var Color = GetPropertyValue(PropertiesArray, "Color");
					if(Color != -1){
						with(inst){
							switch(Color){
								case "G": KinstoneMain_SetIndex(KinstoneColor.Green); break;
								case "B": KinstoneMain_SetIndex(KinstoneColor.Blue); break;
								case "R": KinstoneMain_SetIndex(KinstoneColor.Red); break;
								case "Y": KinstoneMain_SetIndex(KinstoneColor.Gold); break;
								case "Random": KinstoneMain_SetIndex(irandom(3)); break;
							}
						}					
					}
					SignCreate(ObjX + 16, ObjY + 32, global.KinstoneSignText, true);
				}


				//add kinstone to large map items so we can draw the icon if Link has a compass
				ds_list_add(global.LargeMapItems, inst);
				
				break;
			
			case TemplateObjGID.Treasure:
			
				var _Item = RandomItem;
				var _ForcedItem = GetPropertyValue(PropertiesArray, "Item");

				if(_ForcedItem != -1){
					var _AssetIndex = asset_get_index(_ForcedItem);
					if(_AssetIndex != -1){
						_Item = ItemClassFromObjIndex(_AssetIndex);
					}
				}

				inst = Treasure_Create(_RoomIndex, ObjX, ObjY, _Item, true);
				
				break;

			case TemplateObjGID.TreasureLarge:
				Inst = instance_create_layer(ObjX, ObjY, "Objs_" + FloorLevelStr, oTreasureLarge);
				break;
				
			case TemplateObjGID.Altar:

				//first clear any blood or bones that may have been drawn in floor draw function which would be on water layer above
				ClearTileBlock(global.TMID_Water_Upper, ObjX, ObjY, ObjTileW, ObjTileH);
				ClearTileBlock(global.TMID_Water_Lower, ObjX, ObjY, ObjTileW, ObjTileH);
	
				//Draw floor
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						var FloorX = ObjX + (_x * 8);
						var FloorY = ObjY + (_y * 8);
						DrawTileBlock(FloorTMID, FloorX, FloorY, 111, LevelTilesY + 2, 1, 1);							
					}
				}
					
				//Draw Corners
				DrawTileBlock(WallTMID, ObjX, ObjY, 110, LevelTilesY + 1, 1, 1); //TL
				DrawTileBlock(WallTMID, ObjX + ObjW - 8, ObjY, 112, LevelTilesY + 1, 1, 1); //TR
				DrawTileBlock(WallTMID, ObjX, ObjY + ObjH - 8, 110, LevelTilesY + 3, 1, 1); //BL
				DrawTileBlock(WallTMID, ObjX + ObjW - 8, ObjY + ObjH - 8, 112, LevelTilesY + 3, 1, 1); //BR
					
				//Draw Top
				for(_x = 0; _x < ObjTileW - 2; _x++){
					var SideX = ObjX + 8 + (_x * 8);
					DrawTileBlock(WallTMID, SideX, ObjY, 111, LevelTilesY + 1, 1, 1);							
				}
				WallInst = WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, 1);
				WallInst.BlockProjectiles = false;
				WallInst.BlockItems = false;
	
				//Draw L/R sides
				for(_y = 0; _y < ObjTileH - 2; _y++){

						SideXR = ObjX + ObjW - 8;
						var SideY = ObjY + 8 + (_y * 8);
			
						DrawTileBlock(WallTMID, ObjX, SideY, 110, LevelTilesY + 2, 1, 1);
						DrawTileBlock(WallTMID, SideXR, SideY, 112, LevelTilesY + 2, 1, 1);
						
				}
				WallInst = WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, 1, ObjTileH);
				WallInst.BlockProjectiles = false;
				WallInst.BlockItems = false;
				WallInst = WallObj_Create("Objs_" + FloorLevelStr, SideXR, ObjY, 1, ObjTileH);
				WallInst.BlockProjectiles = false;
				WallInst.BlockItems = false;
	
				//Draw Stairs
				var StairsW = ObjTileW - 6;
				var StairsX = ObjX + (4 * (ObjTileW - StairsW));
				var StairsY = ObjY + ObjH - 16;
				for(_y = 0; _y < 2; _y++){
					for(_x = 0; _x < StairsW; _x++){
						var SX = StairsX + (_x * 8);
						var SY = StairsY + (_y * 8);
						DrawTileBlock(FloorTMID, SX, SY, 111, LevelTilesY, 1, 1);
					}
				}
	
				//Place an EnemyWall on stairs to prevent enemies from going through them
				//**Replace with WallObj_Create
				inst = WallObj_Create("Objs_" + FloorLevelStr, StairsX, StairsY, StairsW, 2);
				inst.FloorLevel = GetFloorLevelID(FloorLevelStr);
				inst.BlockLink = false;
				inst.BlockLinkCarry = false;
				inst.BlockProjectiles = false;
				inst.BlockItems = false;
	
	
				//Draw Stair Edges
				DrawTileBlock(WallTMID, StairsX - 8, StairsY, 112, LevelTilesY, 1, 1); //TL
				DrawTileBlock(WallTMID, StairsX + (StairsW * 8), StairsY, 110, LevelTilesY, 1, 1); //TR
				DrawTileBlock(WallTMID, StairsX - 8, StairsY + 8, 112, LevelTilesY + 3, 1, 1); //BL
				DrawTileBlock(WallTMID, StairsX + (StairsW * 8), StairsY + 8, 110, LevelTilesY + 3, 1, 1); //TR
				WallInst = WallObj_Create("Objs_" + FloorLevelStr, StairsX - 8, StairsY, 1, 2);
				WallInst.BlockProjectiles = false;
				WallInst.BlockItems = false;
				WallInst = WallObj_Create("Objs_" + FloorLevelStr, StairsX + (StairsW * 8), StairsY, 1, 2);
				WallInst.BlockProjectiles = false;
				WallInst.BlockItems = false;
	
				//Draw Bottom Sides
				var SideLen = (ObjTileW - StairsW - 4) / 2;
		
				for(_x = 0; _x < SideLen; _x++){
					DrawTileBlock(WallTMID, ObjX + 8 + (_x * 8), StairsY + 8, 111, LevelTilesY + 3, 1, 1); 
					DrawTileBlock(WallTMID, StairsX + (StairsW * 8) + 8 + (_x * 8), StairsY + 8, 111, LevelTilesY + 3, 1, 1); 
				}
				WallInst = WallObj_Create("Objs_" + FloorLevelStr, StairsX - 16, StairsY + 8, 2, 1);
				WallInst.BlockProjectiles = false;
				WallInst.BlockItems = false;
				WallInst = WallObj_Create("Objs_" + FloorLevelStr, StairsX + (StairsW * 8), StairsY + 8, 2, 1);
				WallInst.BlockProjectiles = false;
				WallInst.BlockItems = false;
				
				break;
			
			case TemplateObjGID.Shop:
				
				var _ShopType = GetShopType(ObjType);
				var ShopInst = instance_create_layer(ObjX, ObjY, "ObjsFloor_" + FloorLevelStr, oShop, {RoomIndex : _RoomIndex, ShopW : ObjW, ShopH : ObjH, ShopType : _ShopType});
				
				switch(_ShopType){
					case ShopTypes.Weapons:
					case ShopTypes.Foods:
					case ShopTypes.Potions:
					case ShopTypes.Treasures:
					case ShopTypes.Magic:
					case ShopTypes.Bombs:

						//draw bar
						//TL
						DrawTileBlock(WallTMID, ObjX, ObjY, 82, VillageTilesY + 4, 1, 1);
						//TR
						DrawTileBlock(WallTMID, ObjX2, ObjY, 84, VillageTilesY + 4, 1, 1);
						//BL
						DrawTileBlock(WallTMID, ObjX, ObjY2 - 8, 82, VillageTilesY + 5, 1, 2);
						//BL
						DrawTileBlock(WallTMID, ObjX2, ObjY2 - 8, 84, VillageTilesY + 5, 1, 2);
					
						//Sides
						DrawTileBlock(WallTMID, ObjX, ObjY + 8, 81, VillageTilesY + 5, 1, 1); //L
						DrawTileBlock(WallTMID, ObjX2, ObjY + 8, 80, VillageTilesY + 5, 1, 1); //R
					
						//Top/Bottom/counter edges
						for(var i = 0; i < ObjTileW - 2; i++){
							DrawTileBlock(WallTMID, ObjX + 8 + (i * 8), ObjY, 83, VillageTilesY + 4, 1, 1); //Top
							DrawTileBlock(WallTMID, ObjX + 8 + (i * 8), ObjY + 8, 85, VillageTilesY + 4, 1, 1); //Counter
							DrawTileBlock(WallTMID, ObjX + 8 + (i * 8), ObjY2 - 8, 83, VillageTilesY + 5, 1, 2); //Bottom
						}				
					
						//Create wall obj
						WallInst = WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ShopInst.TileW, ShopInst.TileH - 1,,,oShopWall);

						break;
					
					case ShopTypes.Various:
					
						//Draw floor

						//first clear any blood or bones that may have been drawn in floor draw function which would be on water layer above
						ClearTileBlock(global.TMID_Water_Upper, ObjX, ObjY, ObjTileW, ObjTileH);
						ClearTileBlock(global.TMID_Water_Lower, ObjX, ObjY, ObjTileW, ObjTileH);
				
						//TL Corner
						DrawTileBlock(FloorTMID, ObjX, ObjY, 15, 0, 1, 1);
						//TR Corner
						DrawTileBlock(FloorTMID, ObjX2, ObjY, 17, 0, 1, 1);
						//BL Corner
						DrawTileBlock(FloorTMID, ObjX, ObjY2, 15, 2, 1, 1);
						//BR Corner
						DrawTileBlock(FloorTMID, ObjX2, ObjY2, 17, 2, 1, 1);
	
						//Top & Bottom Edges
						for(_x = 1; _x < ObjTileW - 1; _x++){
							var FloorX = ObjX + (_x * 8);
							DrawTileBlock(FloorTMID, FloorX, ObjY, 16, 0, 1, 1);							
							DrawTileBlock(FloorTMID, FloorX, ObjY2, 16, 2, 1, 1);							
						}
	
						//Top & Bottom Edges
						for(_y = 1; _y < ObjTileH - 1; _y++){
							var FloorY = ObjY + (_y * 8);
							DrawTileBlock(FloorTMID, ObjX, FloorY, 15, 1, 1, 1);							
							DrawTileBlock(FloorTMID, ObjX2, FloorY, 17, 1, 1, 1);							
						}	
	
						//Main floor
						for(_y = 1; _y < ObjTileH - 1; _y++){
							for(_x = 1; _x < ObjTileW - 1; _x++){
								var FloorX = ObjX + (_x * 8);
								var FloorY = ObjY + (_y * 8);
								DrawTileBlock(FloorTMID, FloorX, FloorY, 16, 1, 1, 1);							
							}
						}
	
						//add shop to large map items so we can draw the icon if Link has a compass
						ds_list_add(global.LargeMapItems, ShopInst); 
						
						//Create wall obj
						WallInst = WallObj_Create("Objs_" + FloorLevelStr, ObjX + 8, ObjY + 8, ShopInst.TileW - 2, ShopInst.TileH - 2,,,oShopWall);

						global.Level.ShopCount++;
					
						//Room.Lighting = false;
						
						break;
				}

				WallInst.ShopInst = ShopInst;
				WallInst.BlockProjectiles = false;
					
				break;
			
			case TemplateObjGID.GemPond:
			case TemplateObjGID.WishPond:

				_inst = instance_create_layer(ObjX + 8, ObjY + 8, "ObjsFloor_" + FloorLevelStr, oGemPondWater, {RoomIndex : _RoomIndex, W : ObjW - 16, H : ObjH - 16, GID : ObjGID})
				
				//Draw Corners
				DrawTileBlock(WallTMID, ObjX, ObjY, 110, LevelTilesY + 1, 1, 1); //TL
				DrawTileBlock(WallTMID, ObjX + ObjW - 8, ObjY, 112, LevelTilesY + 1, 1, 1); //TR
				DrawTileBlock(WallTMID, ObjX, ObjY + ObjH - 8, 110, LevelTilesY + 3, 1, 1); //BL
				DrawTileBlock(WallTMID, ObjX + ObjW - 8, ObjY + ObjH - 8, 112, LevelTilesY + 3, 1, 1); //BR

				//Draw Top//bottom
				for(_x = 0; _x < ObjTileW - 2; _x++){
					var SideX = ObjX + 8 + (_x * 8);
					DrawTileBlock(WallTMID, SideX, ObjY, 111, LevelTilesY + 1, 1, 1);							
					DrawTileBlock(WallTMID, SideX, ObjY + ObjH - 8, 111, LevelTilesY + 3, 1, 1);							
				}
	
				//Draw L/R sides
				for(_y = 0; _y < ObjTileH - 2; _y++){

						SideXR = ObjX + ObjW - 8;
						var SideY = ObjY + 8 + (_y * 8);
			
						DrawTileBlock(WallTMID, ObjX, SideY, 110, LevelTilesY + 2, 1, 1);
						DrawTileBlock(WallTMID, SideXR, SideY, 112, LevelTilesY + 2, 1, 1);
						
				}

				WallInst = WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				WallInst.BlockProjectiles = false;
				WallInst.BlockItems = false;
				
				//sign
				var _SignText = "";
				switch(ObjGID){
					case TemplateObjGID.GemPond:
						_SignText = "-Zora's Gem Pond-^Throw in 2 gems to receive an item. No refunds!";
						//add GemPond to large map items so we can draw the icon if Link has a compass
						ds_list_add(global.LargeMapItems, _inst); 
						break;
					case TemplateObjGID.WishPond:
						_SignText = "-Wishing Pond-^Throw in a wishing stone and make a wish.";
						break;
					
				}

				SignCreate(ObjX + 24, ObjY + ObjH + 16, _SignText);
				
				break;
			
			case TemplateObjGID.Rupee5:
			case TemplateObjGID.Rupee10:
			case TemplateObjGID.Rupee20:
				
				var RupeeCountW = ObjTileW / 2;
				var RupeeCountH = ObjTileH / 2;
				var PatternSize = global.RupeePatternSizeID[RupeeCountW][RupeeCountH];
				var Patterns = array_length(global.RupeePatterns[PatternSize]);
				var Pattern = irandom(Patterns - 1);
				var PatternArray = global.RupeePatterns[PatternSize, Pattern];
	
				for(var RupeeY = 0; RupeeY < RupeeCountH; RupeeY++){
					for(var RupeeX = 0; RupeeX < RupeeCountW; RupeeX++){
			
						var PatternSymbol = string_char_at(PatternArray[RupeeY], RupeeX + 1);
			
						var RupeePosX = ObjX + (RupeeX * 16);
						var RupeePosY = ObjY + (RupeeY * 16);
			
						var SpawnRupee = false;
						var SpawnTreasure = false;
			
						switch(PatternSymbol){
				
							case "0": 
								SpawnRupee = true;
								break;
					
							case "T":
								if(SpawnTreasure){
						
								}else{
									SpawnRupee = true;
								}
								break;

				
							case "t":
								if(SpawnTreasure){
						
								}
								break;
						}
			
						if(SpawnRupee){
							Inst = instance_create_layer(RupeePosX + 8, RupeePosY + 14, "Objs_" + FloorLevelStr, oItem_Rupee, {From : ItemFrom.Pot});
							with(Inst){
								Setup = false;
								Rupee_Init(ObjGID == TemplateObjGID.Rupee5 ? 5 : (ObjGID == TemplateObjGID.Rupee10 ? 10 : 20));
								FloorLevel = GetFloorLevelID(FloorLevelStr);
							}			
						}

					}
				}			
			

				break;


				
			case TemplateObjGID.Column:
				
				var ColumnTileX_Base = 138 + (ColumnStyle * 8);
				var ColumnTileX_Top = 136 + (ColumnStyle * 4);
				
				//base
				DrawTileBlock(FloorTMID, ObjX, ObjY + 16, ColumnTileX_Base, LevelTilesY + 4, 2, 2);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY + 16, 2, 2);
				
				//top
				DrawTileBlock(global.TMID_Tiles_Highest, ObjX, ObjY, ColumnTileX_Top, LevelTilesY + 4, 2, 2);
				
				break;

			case TemplateObjGID.Fairy:
				
				if(Prob(Chance_LargeFairy)){
					Inst = instance_create_layer(ObjX + 16, ObjY + 14, "Objs_" + FloorLevelStr, oFairy_Health, {RoomIndex : _RoomIndex});
					ds_list_add(global.LargeMapItems, Inst); 
				}else{
					repeat(choose(2, 3)){
						Inst = instance_create_layer(ObjX + irandom_range(-8, 40), ObjY + irandom_range(16, 64), "Objs_" + FloorLevelStr, oItem_Fairy, {From : ItemFrom.Pot});
						Inst.Setup = false;
						Inst.ContainX1 = ObjX - 8;
						Inst.ContainX2 = ObjX + 40;
						Inst.ContainY1 = ObjY + 16;
						Inst.ContainY2 = ObjY + 64;
						ds_list_add(global.LargeMapItems, Inst); 
					}

				}
				
				var Monument1X = ObjX - 48;
				var Monument2X = ObjX + 48;				
				var MonumentY = ObjY + 48;
				
				DrawTileBlock(WallTMID, Monument1X, MonumentY, 28, 0, 4, 4);							
				WallObj_Create("Objs_" + FloorLevelStr, Monument1X, MonumentY, 4, 4);
				
				DrawTileBlock(WallTMID, Monument2X, MonumentY, 28, 0, 4, 4);							
				WallObj_Create("Objs_" + FloorLevelStr, Monument2X, MonumentY, 4, 4);				
				
				break;

			case TemplateObjGID.House:
				
				var WallStyle = GetPropertyValue(PropertiesArray, "Walls");
				var RoofStyle = GetPropertyValue(PropertiesArray, "Roof");
				
				//only use style 1(grass house) if house is exactly 12 tiles wide
				if(WallStyle == 1 && ObjTileW != 12) WallStyle = 0;
				
				var RoofX2 = ObjX + (ObjTileW * 8) - 8;
				var RoofY2 = ObjY + (ObjTileH * 8) - 32;
				
				switch(RoofStyle){
					case 0: //regular blue
					case 1: //regular red
					case 2:	//arcade			
					case 6:	//regular green			
						
						var XOffset = 0;
						var YOffset = 0;
						switch(RoofStyle){
							case 1: XOffset = 7; break;	
							case 2: YOffset = 8; break;	
							case 6: 
								XOffset = 18; 
								YOffset = 3; 
								break;	
						}
						
						var TileStartY = VillageTilesY + YOffset;
						
						//TL corner
						DrawTileBlock(global.TMID_Tiles_Higher, ObjX, ObjY, XOffset, TileStartY, 3, 1);
				
						//top//bottom edge
						for(_x = 0; _x < ObjTileW - 6; _x++){
							DrawTileBlock(global.TMID_Tiles_Higher, ObjX + 24 + (_x * 8), ObjY, 3 + XOffset, TileStartY, 1, 1); //top
							DrawTileBlock(global.TMID_Tiles_Higher, ObjX + 24 + (_x * 8), RoofY2 - 24, 3 + XOffset, TileStartY + 2, 1, 4); //Bottom
						}
				
						//TR corner
						DrawTileBlock(global.TMID_Tiles_Higher, RoofX2 - 16, ObjY, 4 + XOffset, TileStartY, 3, 1);
				
						//Left/Right side
						for(_y = 0; _y < ObjTileH - 8; _y++){
							DrawTileBlock(global.TMID_Tiles_Higher, ObjX, ObjY + 8 + (_y * 8), XOffset, TileStartY + 1, 3, 1); //Left
							DrawTileBlock(global.TMID_Tiles_Higher, RoofX2 - 16, ObjY + 8 + (_y * 8), 4 + XOffset, TileStartY + 1, 3, 1); //Right
						}				
				
						//Bottom Left corner
						DrawTileBlock(global.TMID_Tiles_Higher, ObjX , RoofY2 - 24, XOffset, TileStartY + 2, 3, 4);
				
						//BottomRight Corner
						DrawTileBlock(global.TMID_Tiles_Higher, RoofX2 - 16, RoofY2 - 24, 4 + XOffset, TileStartY + 2, 3, 4);
				
						//Top
						for(_y = 0; _y < ObjTileH - 8; _y++){
							for(_x = 0; _x < ObjTileW - 6; _x++){
								PosX = ObjX + 24 + (_x * 8);
								PosY = ObjY + 8 + (_y * 8);
								DrawTileBlock(global.TMID_Tiles_Higher, PosX, PosY, 3 + XOffset, TileStartY + 1, 1, 1);					
							}
						}
				
				
						//Four Cirlces
						DrawTileBlock(DecorTMID, ObjX + 24, ObjY + 8, 7, TileStartY + 6, 1, 1);
						DrawTileBlock(DecorTMID, RoofX2 - 24, ObjY + 8, 7, TileStartY + 6, 1, 1);
						DrawTileBlock(DecorTMID, ObjX + 24, RoofY2 - 32, 7, TileStartY + 6, 1, 1);
						DrawTileBlock(DecorTMID, RoofX2 - 24, RoofY2 - 32, 7, TileStartY + 6, 1, 1);
				
						//Rectangles (do this only if the house is the original smallest size)
						//DrawTileBlock(DecorTMID, ObjX + 24, ObjY + 8, 18, VillageTilesY + 5, 2, 3);
						//DrawTileBlock(DecorTMID, RoofX2 - 32, ObjY + 8, 18, VillageTilesY + 5, 2, 3);							
						
						break;
					
					case 3: //grass						

						
						//TL corner
						DrawTileBlock(global.TMID_Tiles_Higher, ObjX, ObjY, 7, VillageTilesY + 8, 1, 1);

						//top//bottom edge
						for(_x = 0; _x < ObjTileW - 2; _x++){
							XPos = ObjX + 8 + (_x * 8);
							var XTile = 8 + (_x mod 2);
							DrawTileBlock(global.TMID_Tiles_Higher, XPos, ObjY, XTile, VillageTilesY + 8, 1, 1); //top
							DrawTileBlock(global.TMID_Tiles_Higher, XPos, RoofY2, XTile, VillageTilesY + 11, 1, 1); //Bottom
						}

						//TR corner
						DrawTileBlock(global.TMID_Tiles_Higher, ObjX + (ObjTileW * 8) - 8, ObjY, 10, VillageTilesY + 8, 1, 1);

						//Left/Right side
						for(_y = 0; _y < ObjTileH - 4; _y++){
							PosY = ObjY + 8 + (_y * 8);
							DrawTileBlock(global.TMID_Tiles_Higher, ObjX, PosY, 7, VillageTilesY + 9, 1, 1); //Left
							DrawTileBlock(global.TMID_Tiles_Higher, RoofX2, PosY, 10, VillageTilesY + 9, 1, 1); //Right
						}	

						//Bottom Left corner
						DrawTileBlock(global.TMID_Tiles_Higher, ObjX , RoofY2, 7, VillageTilesY + 11, 1, 1);
				
						//BottomRight Corner
						DrawTileBlock(global.TMID_Tiles_Higher, RoofX2 , RoofY2, 10, VillageTilesY + 11, 1, 1);

						//Top
						for(_y = 0; _y < ObjTileH - 5; _y++){
							for(_x = 0; _x < ObjTileW - 2; _x++){
								PosX = ObjX + 8 + (_x * 8);
								PosY = ObjY + 8 + (_y * 8);
								DrawTileBlock(global.TMID_Tiles_Higher, PosX, PosY, 8 + (_x mod 2), VillageTilesY + 9 + (_y mod 2), 1, 1);					
							}
						}
						
						break;
					
					case 4: //wood

						//TL corner
						DrawTileBlock(global.TMID_Tiles_Higher, ObjX, ObjY, 11, VillageTilesY + 6, 1, 1);

						//top//bottom edge
						for(_x = 0; _x < ObjTileW - 2; _x++){
							XPos = ObjX + 8 + (_x * 8);
							DrawTileBlock(global.TMID_Tiles_Higher, XPos, ObjY, 12, VillageTilesY + 6, 1, 1); //top
							DrawTileBlock(global.TMID_Tiles_Higher, XPos, RoofY2, 12, VillageTilesY + 8, 1, 1); //Bottom
						}

						//TR corner
						DrawTileBlock(global.TMID_Tiles_Higher, ObjX + (ObjTileW * 8) - 8, ObjY, 13, VillageTilesY + 6, 1, 1);

						//Left/Right side
						for(_y = 0; _y < ObjTileH - 4; _y++){
							PosY = ObjY + 8 + (_y * 8);
							DrawTileBlock(global.TMID_Tiles_Higher, ObjX, PosY, 11, VillageTilesY + 7, 1, 1); //Left
							DrawTileBlock(global.TMID_Tiles_Higher, RoofX2, PosY, 13, VillageTilesY + 7, 1, 1); //Right
						}	

						//Bottom Left corner
						DrawTileBlock(global.TMID_Tiles_Higher, ObjX , RoofY2, 11, VillageTilesY + 8, 1, 1);
				
						//BottomRight Corner
						DrawTileBlock(global.TMID_Tiles_Higher, RoofX2 , RoofY2, 13, VillageTilesY + 8, 1, 1);

						//Top
						for(_y = 0; _y < ObjTileH - 5; _y++){
							for(_x = 0; _x < ObjTileW - 2; _x++){
								PosX = ObjX + 8 + (_x * 8);
								PosY = ObjY + 8 + (_y * 8);
								DrawTileBlock(global.TMID_Tiles_Higher, PosX, PosY, 12, VillageTilesY + 7, 1, 1);					
							}
						}
						
						break;

				}

				var WallY = ObjY + (ObjTileH * 8) - 24;
				var WallX2 = ObjX + (ObjTileW * 8) - 8;
				var DoorX = ObjX + (floor(ObjTileW / 2) * 8) - 16;
				var DoorY = WallY - 16;
				
				//determine which Room index the door will warp to
				DoorWarpTemplateID = GetPropertyValue(PropertiesArray, "House");
				
				switch(global.Level.Index){
					case DungeonLevel.Village:
						_TemplateClass = RoomTemplateClass.Village;
						_TemplateSubClass = RoomTemplateClass_Village.House;					
						break;
					
					case DungeonLevel.Mines:
						_TemplateClass = RoomTemplateClass.Mines;
						_TemplateSubClass = RoomTemplateClass_Mines.House;							
						break;
				
				}
				
				_TemplateArray = global.Templates_Room[_TemplateClass][_TemplateSubClass];
				for(var _RoomTemplateIndex = 0; _RoomTemplateIndex < global.Templates_Room_Count[_TemplateClass][_TemplateSubClass]; _RoomTemplateIndex++){
					var _Template = _TemplateArray[_RoomTemplateIndex];
					if(_Template.id == DoorWarpTemplateID){
						DoorWarpTemplateIndex = _RoomTemplateIndex;
						break;
					}
				}
				House_MapGridX = GetPropertyValue(_TemplateArray[DoorWarpTemplateIndex][$ "properties"], "House_MapGridX");
				House_MapGridY = GetPropertyValue(_TemplateArray[DoorWarpTemplateIndex][$ "properties"], "House_MapGridY");
				DoorRoomIndexWarp = global.Level.Map_RoomIndex[House_MapGridY][House_MapGridX];
				switch(WallStyle){
					case 0: //regular
					case 1: //arcade
						
						var TileStartY = VillageTilesY + (WallStyle == 1 ? 8 : 0);
						
						//Front Wall
						DrawTileBlock(WallTMID, ObjX, WallY, 0, TileStartY + 6, 1, 2);
				
						for(var i = 0; i < ObjTileW - 2; i++){
							DrawTileBlock(WallTMID, ObjX + 8 + (i * 8), WallY, 1 + (i mod 2), TileStartY + 6, 1, 2);
						}
				
						DrawTileBlock(WallTMID, WallX2, WallY, 6, TileStartY + 6, 1, 2);
				
						//Door
						DrawTileBlock(DecorTMID, DoorX, DoorY, 14, TileStartY, 4, 5);
						inst = instance_create_layer(DoorX + 8, DoorY + 16, "Objs_" + FloorLevelStr, oHouseDoor);
						inst.image_index = (WallStyle == 0 ? 0 : 1);
						inst.House_RoomIndex = DoorRoomIndexWarp;
						inst.House_X = House_MapGridX * 256;
						inst.House_Y = House_MapGridY * 256;
						
						//Windows
						DrawTileBlock(DecorTMID, DoorX - 24, DoorY + 16, 8, TileStartY + 6, 3, 2);
						DrawTileBlock(DecorTMID, DoorX + 32, DoorY + 16, 8, TileStartY + 6, 3, 2);
						
						break;
					
					case 2: //grass

						//Front Wall
						
						//Left side
						DrawTileBlock(WallTMID, ObjX, WallY, 7, VillageTilesY + 12, 4, 2);
						
						
						//Door sides
						DrawTileBlock(WallTMID, ObjX + 32, WallY, 10, VillageTilesY + 12, 1, 2);
						DrawTileBlock(WallTMID, ObjX + 56, WallY, 7, VillageTilesY + 12, 1, 2);
						//Door
						DrawTileBlock(WallTMID, ObjX + 40, WallY, 11, VillageTilesY + 11, 2, 2);
						inst = instance_create_layer(DoorX + 8, DoorY + 16, "Objs_" + FloorLevelStr, oHouseDoor);
						inst.image_index = 0;
						inst.House_RoomIndex = DoorRoomIndexWarp;
						inst.House_X = House_MapGridX * 256;
						inst.House_Y = House_MapGridY * 256;
						inst.PassageArea[3] = inst.y; //the top of the door passage is a little different from the other house doors, so change it here
						
						//Right side
						DrawTileBlock(WallTMID, WallX2 - 24, WallY, 7, VillageTilesY + 12, 4, 2);
						
						break;
					
					case 3: //red
					
						//Front Wall
						
						//Left side
						DrawTileBlock(WallTMID, ObjX, WallY, 11, VillageTilesY + 9, 1, 2);

						for(var i = 0; i < ObjTileW - 2; i++){
							DrawTileBlock(WallTMID, ObjX + 8 + (i * 8), WallY, 12, VillageTilesY + 9, 1, 2);
						}
						
						//Door
						DrawTileBlock(DecorTMID, DoorX, DoorY, 14, VillageTilesY, 4, 5);
						inst = instance_create_layer(DoorX + 8, DoorY + 16, "Objs_" + FloorLevelStr, oHouseDoor);
						inst.House_RoomIndex = DoorRoomIndexWarp;
						inst.House_X = House_MapGridX * 256;
						inst.House_Y = House_MapGridY * 256;
						
						//Right side
						DrawTileBlock(WallTMID, WallX2, WallY, 13, VillageTilesY + 9, 1, 2);

						//Tools
						for(var i = 0; i < (WallX2 - DoorX - 32) / 8; i++){
							DrawTileBlock(DecorTMID, DoorX + 32 + (i * 8), WallY, 13, VillageTilesY + 11, 1, 2);
						}
						
						break;
						
				}

						
				var Wall1TileW = ObjTileW - ((DoorX - ObjX) / 8) - 3;
				var Wall2TileW = ObjTileW - Wall1TileW - 2;
				var _DoorWallInst = WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY + 8, Wall1TileW, ObjTileH - 2);
				_DoorWallInst.BlockLinkCarry = true;
				WallObj_Create("Objs_" + FloorLevelStr, DoorX + 24, ObjY + 8, Wall2TileW, ObjTileH - 2);
				WallObj_Create("Objs_" + FloorLevelStr, DoorX + 8, ObjY + 8, 2, 2);
				
				break;
		
			
			case TemplateObjGID.StoreSign:
				_Index = GetPropertyValue(PropertiesArray, "Index");
				inst = instance_create_layer(ObjX, ObjY, "ObjsHigher_Upper", oStoreSign, {image_index : _Index});
				break;
				
			case TemplateObjGID.Temple:
				
				//TL corner
				DrawTileBlock(global.TMID_Tiles_Highest, ObjX, ObjY, 18, VillageTilesY + 13, 1, 1);	
						
				//top edge
				for(_x = 0; _x < 8; _x++){
					XPos = ObjX + 8 + (_x * 8);
					DrawTileBlock(global.TMID_Tiles_Highest, XPos, ObjY, 19, VillageTilesY + 13, 1, 1); //top
				}

				//TR corner
				DrawTileBlock(global.TMID_Tiles_Highest, ObjX2, ObjY, 20, VillageTilesY + 13, 1, 1);	

				//Left/Right side
				for(_y = 0; _y < 3; _y++){
					PosY = ObjY + 8 + (_y * 8);
					DrawTileBlock(global.TMID_Tiles_Highest, ObjX, PosY, 18, VillageTilesY + 14, 1, 1); //Left
					DrawTileBlock(global.TMID_Tiles_Highest, ObjX2, PosY, 20, VillageTilesY + 14, 1, 1); //Right
				}	
				DrawTileBlock(WallTMID, ObjX+16, ObjY2-32, 18, VillageTilesY + 14, 1, 1); //Left
				DrawTileBlock(WallTMID, ObjX2-16, ObjY2-32, 20, VillageTilesY + 14, 1, 1); //Right		

				//Bottom Left corner
				DrawTileBlock(WallTMID, ObjX, ObjY + 32, 18, VillageTilesY + 15, 1, 1);
				DrawTileBlock(WallTMID, ObjX + 16, ObjY2 - 24, 18, VillageTilesY + 15, 1, 1);

				//Bottom Right corner
				DrawTileBlock(WallTMID, ObjX2, ObjY + 32, 20, VillageTilesY + 15, 1, 1);
				DrawTileBlock(WallTMID, ObjX2 - 16, ObjY2 - 24, 20, VillageTilesY + 15, 1, 1);

				//Bottom edge
				for(_x = 0; _x < 4; _x++){
					XPos = ObjX + 24 + (_x * 8);
					DrawTileBlock(global.TMID_Tiles_Highest, XPos, ObjY2 - 24, 19, VillageTilesY + 15, 1, 1); 
				}
				DrawTileBlock(WallTMID, ObjX + 8, ObjY + 32, 19, VillageTilesY + 15, 1, 1); 
				DrawTileBlock(WallTMID, ObjX + 16, ObjY + 32, 17, VillageTilesY + 14, 1, 1); 
				DrawTileBlock(WallTMID, ObjX2 - 8, ObjY + 32, 19, VillageTilesY + 15, 1, 1); 
				DrawTileBlock(WallTMID, ObjX2 - 16, ObjY + 32, 17, VillageTilesY + 13, 1, 1); 
						
				//Top
				for(_y = 0; _y < 3; _y++){
					for(_x = 0; _x < 8; _x++){
						PosX = ObjX + 8 + (_x * 8);
						PosY = ObjY + 8 + (_y * 8);
						DrawTileBlock(global.TMID_Tiles_Highest, PosX, PosY, 19, VillageTilesY + 14, 1, 1);					
					}
				}
				for(_y = 0; _y < 2; _y++){
					for(_x = 0; _x < 4; _x++){
						PosX = ObjX + 24 + (_x * 8);
						PosY = ObjY + 32 + (_y * 8);
						DrawTileBlock(global.TMID_Tiles_Highest, PosX, PosY, 19, VillageTilesY + 14, 1, 1);					
					}
				}
						
						
				//columns
				DrawTileBlock(WallTMID, ObjX, ObjY2 - 32, 15, VillageTilesY + 13, 2, 3);
				DrawTileBlock(WallTMID, ObjX2 - 8, ObjY2 - 32, 15, VillageTilesY + 13, 2, 3);
				DrawTileBlock(WallTMID, ObjX + 16, ObjY2 - 16, 15, VillageTilesY + 13, 2, 3);
				DrawTileBlock(WallTMID, ObjX2 - 24, ObjY2 - 16, 15, VillageTilesY + 13, 2, 3);
						
				//door
				DrawTileBlock(WallTMID, ObjX + 32, ObjY2 - 16, 15, VillageTilesY + 10, 2, 1);
				DrawTileBlock(WallTMID, ObjX + 32, ObjY2 - 8, 17, VillageTilesY + 15, 1, 1);
				DrawTileBlock(WallTMID, ObjX + 40, ObjY2 - 8, 17, VillageTilesY + 15, 1, 1);

				//determine which Room index the door will warp to

				DoorWarpTemplateID = GetPropertyValue(PropertiesArray, "House");
				_TemplateArray = global.Templates_Room[RoomTemplateClass.Village][RoomTemplateClass_Village.House];
				for(var _RoomTemplateIndex = 0; _RoomTemplateIndex < global.Templates_Room_Count[RoomTemplateClass.Village][RoomTemplateClass_Village.House]; _RoomTemplateIndex++){
					var _Template = _TemplateArray[_RoomTemplateIndex];
					if(_Template.id == DoorWarpTemplateID){
						DoorWarpTemplateIndex = _RoomTemplateIndex;
						break;
					}
				}
				House_MapGridX = GetPropertyValue(_TemplateArray[DoorWarpTemplateIndex][$ "properties"], "House_MapGridX");
				House_MapGridY = GetPropertyValue(_TemplateArray[DoorWarpTemplateIndex][$ "properties"], "House_MapGridY");
				DoorRoomIndexWarp = global.Level.Map_RoomIndex[House_MapGridY][House_MapGridX];
				
				inst = instance_create_layer(ObjX + 32, ObjY2 - 16, "Objs_" + FloorLevelStr, oHouseDoor);
				inst.image_index = 2;
				inst.House_RoomIndex = DoorRoomIndexWarp;
				inst.House_X = House_MapGridX * 256;
				inst.House_Y = House_MapGridY * 256;
				inst.PassageArea[3] = inst.y; //the top of the door passage is a little different from the other house doors, so change it here
				
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY + 8, 4, ObjTileH - 3);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX2 - 24, ObjY + 8, 4, ObjTileH - 3);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX + 32, ObjY + 8, 2, 2);
				
				WallObj_Create("Objs_" + FloorLevelStr, ObjX + 16, ObjY2 - 8, 2, 2);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX2 - 24, ObjY2 - 8, 2, 2);
				
				break;
				
			case TemplateObjGID.Bridge:
				
				switch(ObjRot){
					
					case 0: //horizontal						

						//rails
						for(var i = 0; i < ObjTileW; i++){
							PosX = ObjX + (i * 8);
							//Top
							DrawTileBlock(DecorTMID, PosX, ObjY, 27 + (i mod 2), VillageTilesY, 1, 2);
							//Bottom
							DrawTileBlock(DecorTMID, PosX, ObjY2 - 8, 27 + (i mod 2), VillageTilesY + 3, 1, 2);
						}

						//Floor
						for(_y = 0; _y < ObjTileH - 4; _y++){
							for(_x = 0; _x < ObjTileW; _x++){
								PosX = ObjX + (_x * 8);
								PosY = ObjY + 16 + (_y * 8);
								//var Tile = (_x == 0 ? 29 : (_x == ObjTileW - 1 ? 29 : 27));
								DrawTileBlock(WallTMID, PosX, PosY, 28, VillageTilesY + 2, 1, 1);
							}
							
						}
						
						//draw the end rails only if there's no NoEnd_L or NoEnd_R
						if(GetPropertyValue(PropertiesArray, "NoEnd_L") == -1){		
							//TL
							DrawTileBlock(DecorTMID, ObjX, ObjY, 26, VillageTilesY, 1, 2);
							//BL
							DrawTileBlock(DecorTMID, ObjX, ObjY2 - 8, 26, VillageTilesY + 3, 1, 2);
							
							for(var i = 0; i < ObjTileH - 4; i++){
								DrawTileBlock(DecorTMID, ObjX, ObjY + 16 + (i * 8), 26, VillageTilesY + 2, 1, 1);
							}

						}
						if(GetPropertyValue(PropertiesArray, "NoEnd_R") == -1){		
							//TR
							DrawTileBlock(DecorTMID, ObjX2, ObjY, 29, VillageTilesY, 1, 2);
							//BR
							DrawTileBlock(DecorTMID, ObjX2, ObjY2 - 8, 29, VillageTilesY + 3, 1, 2);

							for(var i = 0; i < ObjTileH - 4; i++){
								DrawTileBlock(DecorTMID, ObjX2, ObjY + 16 + (i * 8), 29, VillageTilesY + 2, 1, 1);
							}
						}

						
						WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, 1); //top rail
						WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY2 - 8, ObjTileW, 1); //bottom rail
						
						break;
						
					case 90: //vertical

						//rails
						//TL
						DrawTileBlock(DecorTMID, ObjX, ObjY, 30, VillageTilesY, 2, 1);
						for(var i = 0; i < ObjTileH - 2; i++){
							PosY = ObjY + 8 + (i * 8);
							//Left
							DrawTileBlock(DecorTMID, ObjX, PosY, 30, VillageTilesY + 1 + (i mod 2), 2, 1);
							//Right
							DrawTileBlock(DecorTMID, ObjX2 - 8, PosY, 33, VillageTilesY + 1 + (i mod 2), 2, 1);
						}
						//TR
						DrawTileBlock(DecorTMID, ObjX2 - 8, ObjY, 33, VillageTilesY, 2, 1);	
						//BL
						DrawTileBlock(DecorTMID, ObjX, ObjY2, 30, VillageTilesY + 3, 2, 1);
						//BR
						DrawTileBlock(DecorTMID, ObjX2 - 8, ObjY2, 33, VillageTilesY + 3, 2, 1);

						//Floor
						for(_y = 0; _y < ObjTileH; _y++){
							for(_x = 0; _x < ObjTileW - 4; _x++){
								PosX = ObjX + 16 + (_x * 8);
								PosY = ObjY + (_y * 8);
								var Tile = VillageTilesY + (_y == 0 ? 0 : (_y == ObjTileH - 1 ? 3 : 1));
								DrawTileBlock(WallTMID, PosX, PosY, 32, Tile, 1, 1);
							}
							
						}

						WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, 1, ObjTileH); //left rail
						WallObj_Create("Objs_" + FloorLevelStr, ObjX2, ObjY, 1, ObjTileH); //right rail
						
						break;
				}

				
				break;
				
			case TemplateObjGID.Waterfall:
				inst = instance_create_layer(ObjX, ObjY, "ObjsHigher_Upper", oWaterfall, {W : ObjW, H : ObjH});
				break;
			
			case TemplateObjGID.Shadow:
				for(var i = 0; i < ObjTileH; i++){
					for(var j = 0; j < ObjTileW; j++){
						DrawTileBlock(global.TMID_Tiles_Higher, ObjX + (j * 8), ObjY + (i * 8), 37, VillageTilesY + 5, 1, 1);
					}
				}				
				break;
			
			case TemplateObjGID.VillageEntranceSign:
				DrawTileBlock(global.TMID_Tiles_Higher, ObjX, ObjY, 19, VillageTilesY, 6, 3);
				//shadow
				for(var i = 0; i < ObjTileW; i++){
					DrawTileBlock(global.TMID_Tiles_Higher, ObjX + (i * 8), ObjY + 32, 36, VillageTilesY + 5, 1, 1);
				}
				break;
				
			case TemplateObjGID.VillageFortWall:
				for(_x = 0; _x < ObjTileW; _x++){
					PosX = ObjX + (_x * 8);
					DrawTileBlock(global.TMID_Tiles_Higher, PosX, ObjY, 18, VillageTilesY, 1, 1);
					for(_y = 0; _y < ObjTileH - 2; _y++){
						PosY = ObjY + 8 + (_y * 8);
						DrawTileBlock(global.TMID_Tiles_Higher, PosX, PosY, 18, VillageTilesY + 1, 1, 1);
					}
					DrawTileBlock(WallTMID, PosX, ObjY2, 18, VillageTilesY + 2, 1, 1);
				}
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY2 - 1, ObjTileW, 1);
				break;
				
			case TemplateObjGID.Arcade:
				
				PosX = ObjX + 12;
				PosY = ObjY + 40;
				switch(ObjType){
					case "Pitfall": ArcadeType = oArcade_Pitfall; break;
					case "Zerberk": ArcadeType = oArcade_Zerberk; break;
					case "PopMachine": ArcadeType = oPopMachine; PosX = ObjX; PosY = ObjY; break;
					case "ClawMachine": ArcadeType = oClawMachine; PosX = ObjX; PosY = ObjY; break;
					case "Poker": ArcadeType = oArcade_Poker; break;
					case "Mothula": ArcadeType = oArcade_Mothula; break;
					case "ShredderTV": ArcadeType = oArcade_ShredderTV; break;
					default: ArcadeType = oArcade_Fake;	
				}
				inst = instance_create_layer(PosX, PosY, "Objs_" + FloorLevelStr, ArcadeType, {RoomIndex : _RoomIndex});
				break;

			case TemplateObjGID.PoolTable:
				inst = instance_create_layer(ObjX, ObjY, "Objs_Upper", oPoolTable);
				WallInst = WallObj_Create("Objs_Upper", ObjX, ObjY, ObjTileW, ObjTileH);
				WallInst.BlockProjectiles = false;
				break;
				
			case TemplateObjGID.Bar_Corner_TL:
				DrawTileBlock(WallTMID, ObjX, ObjY, 82, VillageTilesY + 4, 1, 1);
				DrawTileBlock(WallTMID, ObjX + 8, ObjY, 83, VillageTilesY + 4, 1, 1);
				DrawTileBlock(WallTMID, ObjX, ObjY + 8, 81, VillageTilesY + 5, 1, 1);
				DrawTileBlock(WallTMID, ObjX + 8, ObjY + 8, 80, VillageTilesY + 4, 1, 1);
				//Wall
				WallInst = WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				WallInst.BlockProjectiles = false;
				break;
				
			case TemplateObjGID.Bar_Corner_TR:
				DrawTileBlock(WallTMID, ObjX, ObjY, 83, VillageTilesY + 4, 1, 1);
				DrawTileBlock(WallTMID, ObjX + 8, ObjY, 84, VillageTilesY + 4, 1, 1);
				DrawTileBlock(WallTMID, ObjX, ObjY + 8, 81, VillageTilesY + 4, 1, 1);
				DrawTileBlock(WallTMID, ObjX + 8, ObjY + 8, 80, VillageTilesY + 5, 1, 1);
				//Wall
				WallInst = WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				WallInst.BlockProjectiles = false;
				break;
							
			case TemplateObjGID.Bar_Corner_BL:
				DrawTileBlock(WallTMID, ObjX, ObjY, 81, VillageTilesY + 5, 1, 1);
				DrawTileBlock(WallTMID, ObjX + 8, ObjY, 80, VillageTilesY + 6, 1, 1);
				DrawTileBlock(WallTMID, ObjX, ObjY + 8, 82, VillageTilesY + 5, 1, 2);
				DrawTileBlock(WallTMID, ObjX + 8, ObjY + 8, 83, VillageTilesY + 5, 1, 2);
				//Wall
				WallInst = WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				WallInst.BlockProjectiles = false;
				break;
						
			case TemplateObjGID.Bar_Corner_BR:
				DrawTileBlock(WallTMID, ObjX, ObjY, 81, VillageTilesY + 6, 1, 1);
				DrawTileBlock(WallTMID, ObjX + 8, ObjY, 80, VillageTilesY + 5, 1, 1);
				DrawTileBlock(WallTMID, ObjX, ObjY + 8, 83, VillageTilesY + 5, 1, 2);
				DrawTileBlock(WallTMID, ObjX + 8, ObjY + 8, 84, VillageTilesY + 5, 1, 2);
				//Wall
				WallInst = WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				WallInst.BlockProjectiles = false;
				break;
			
			case TemplateObjGID.Bar_Hor:
				//Hor
				for(var i = 0; i < ObjTileW; i++){
					PosX = ObjX + (i * 8);
					DrawTileBlock(WallTMID, PosX, ObjY, 83, VillageTilesY + 4, 1, 1);
					DrawTileBlock(WallTMID, PosX, ObjY + 8, 83, VillageTilesY + 5, 1, 2);
				}
				//Wall
				WallInst = WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				WallInst.BlockProjectiles = false;
				break;
				
			case TemplateObjGID.Bar_Ver:
				//Hor
				for(var i = 0; i < ObjTileH; i++){
					PosY = ObjY + (i * 8);
					DrawTileBlock(WallTMID, ObjX + 8, PosY, 80, VillageTilesY + 5, 1, 1);
					DrawTileBlock(WallTMID, ObjX, PosY, 81, VillageTilesY + 5, 1, 1);
				}
				//Wall
				WallInst = WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				WallInst.BlockProjectiles = false;
				break;

			case TemplateObjGID.Bar_L:
				DrawTileBlock(WallTMID, ObjX, ObjY, 82, VillageTilesY + 4, 1, 1);
				DrawTileBlock(WallTMID, ObjX, ObjY + 8, 82, VillageTilesY + 5, 1, 2);
				//Wall
				WallInst = WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				WallInst.BlockProjectiles = false;
				break;

			case TemplateObjGID.Bar_R:
				DrawTileBlock(WallTMID, ObjX, ObjY, 84, VillageTilesY + 4, 1, 1);
				DrawTileBlock(WallTMID, ObjX, ObjY + 8, 84, VillageTilesY + 5, 1, 2);
				//Wall
				WallInst = WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				WallInst.BlockProjectiles = false;
				break;

			case TemplateObjGID.Bar_T:
				DrawTileBlock(WallTMID, ObjX, ObjY, 82, VillageTilesY + 4, 1, 1);
				DrawTileBlock(WallTMID, ObjX + 8, ObjY, 84, VillageTilesY + 4, 1, 1);
				break;

			case TemplateObjGID.Bar_B:
				DrawTileBlock(WallTMID, ObjX, ObjY, 82, VillageTilesY + 5, 1, 2);
				DrawTileBlock(WallTMID, ObjX + 8, ObjY, 84, VillageTilesY + 5, 1, 2);
				//Wall
				WallInst = WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				WallInst.BlockProjectiles = false;
				break;

			case TemplateObjGID.CashRegister:
				DrawTileBlock(DecorTMID, ObjX, ObjY, 52, VillageTilesY + 10, 2, 2, ObjType == "Flip");
				break;
				
			case TemplateObjGID.Keg:
				var Style = real(ObjType);
				DrawTileBlock(DecorTMID, ObjX, ObjY, 74 + (Style * 2), VillageTilesY + 14, 2, 3);
				//Wall
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY + 8, ObjTileW, ObjTileH - 1);
				break;

			case TemplateObjGID.BlacksmithIron:		
				DrawTileBlock(WallTMID, ObjX, ObjY, 81, VillageTilesY + 10, 4, 4);
				//Wall
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				break;
				
			case TemplateObjGID.BlacksmithTools:		
				DrawTileBlock(DecorTMID, ObjX, ObjY, 80, VillageTilesY + 14, 6, 3);
				break;
				
			
			case TemplateObjGID.NPC:
				
				switch(ObjType){

					default:
						
						inst = instance_create_layer(ObjX, ObjY, "Objs_" + FloorLevelStr, asset_get_index("o" + ObjName), 
							{Name : ObjName, 
							 Dialogue : SplitStrToArray(GetPropertyValue(PropertiesArray, "Dialogue"), "\n"),
							 Response : SplitStrToArray(GetPropertyValue(PropertiesArray, "Response"), "\n"),
							 AddWall : GetPropertyValue(PropertiesArray, "NoWall") == -1
							 }); 
							 if(GetPropertyValue(PropertiesArray, "RandomizeDialogue") != -1){
								 inst.Dialogue = array_shuffle(inst.Dialogue);
							 }
						
						break;
					
					case "OldLady":
						inst = instance_create_layer(ObjX + 8, ObjY + 3, "Objs_" + FloorLevelStr, oNPC_OldLady);
						break;

					case "ShopKeeper":
						inst = instance_create_layer(ObjX, ObjY, "Objs_" + FloorLevelStr, oShopKeeper, {ShopType : GetShopType(ObjName)});
						inst.sprite_index = asset_get_index("sShopKeeper_" + ObjName);
						inst.x += sprite_get_xoffset(inst.sprite_index);
						inst.y += sprite_get_yoffset(inst.sprite_index);

						break;
					
				}
				break;
			
			case TemplateObjGID.Sign:
				SignCreate(ObjX + 8, ObjY + 16, GetPropertyValue(PropertiesArray, "Text"), GetPropertyValue(PropertiesArray, "Hidden") != -1);
				break;
				
			case TemplateObjGID.Statue:
				DrawTileBlock(global.TMID_Tiles_Higher, ObjX, ObjY, 36, VillageTilesY + 11, 4, 3);
				DrawTileBlock(WallTMID, ObjX, ObjY + 24, 36, VillageTilesY + 14, 4, 3);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY + 16, 4, 4);
				break;

			case TemplateObjGID.PillarLarge:
				//top
				DrawTileBlock(global.TMID_Tiles_Higher, ObjX, ObjY, 30, VillageTilesY + 10, 4, 3);
				DrawTileBlock(global.TMID_Tiles_Higher, ObjX2 - 24, ObjY, 30, VillageTilesY + 10, 4, 3, true);
				for(var i = 0; i < (ObjTileW - 8) / 2; i++){
					DrawTileBlock(global.TMID_Tiles_Higher, ObjX + 32 + (i * 8), ObjY, 34 + (i mod 2), VillageTilesY + 10, 1, 3);
					DrawTileBlock(global.TMID_Tiles_Higher, ObjX2 - 32 - (i * 8), ObjY, 34 + (i mod 2), VillageTilesY + 10, 1, 3, true);
					
				}
		
				//bases
				DrawTileBlock(WallTMID, ObjX, ObjY + 24, 30, VillageTilesY + 13, 4, 4);
				DrawTileBlock(WallTMID, ObjX2 - 24, ObjY + 24, 30, VillageTilesY + 13, 4, 4);

				//shadow
				for(var i = 0; i < ObjTileW - 8; i++){
					DrawTileBlock(global.TMID_Tiles_Higher, ObjX + 32 + (i * 8), ObjY + 40, 35, VillageTilesY + 3, 1, 2);					
				}		
				
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY + 24, 4, 4);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX2 - 24, ObjY + 24, 4, 4);
				break;
			
			case TemplateObjGID.BirdStatue:

				//bases
				DrawTileBlock(WallTMID, ObjX, ObjY + 24, 40, VillageTilesY + 13, 4, 4);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY + 24, 4, 4);
				
				//Bird
				DrawTileBlock(global.TMID_Tiles_Higher, ObjX, ObjY, 40, VillageTilesY + 10, 3, 3);
				//fan
				DrawTileBlock(global.TMID_Tiles_Higher, ObjX2, ObjY, 43, VillageTilesY + 11, 1, 2);
				break;

			case TemplateObjGID.Tree1:
				
				for(_y = 0; _y < floor(ObjTileH / 4); _y++){
					for(_x = 0; _x < floor(ObjTileW / 4); _x++){
						var _TreeX = ObjX + (_x * 32);
						var _TreeY = ObjY + (_y * 32);
						DrawTileBlock(WallTMID, _TreeX, _TreeY, 34 + (GetPropertyValue(PropertiesArray, "Pink") != -1 ? 4 : 0), VillageTilesY + 6, 4, 4);
					}
				}
				
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				
				break;
			
			case TemplateObjGID.Tree2:
				for(_y = 0; _y < floor(ObjTileH / 4); _y++){
					for(_x = 0; _x < floor(ObjTileW / 3); _x++){
						var _TreeX = ObjX + (_x * 24);
						var _TreeY = ObjY + (_y * 32);
						DrawTileBlock(WallTMID, _TreeX, _TreeY, 47, VillageTilesY, 3, 4);
					}
				}
				
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);			
				break;

			case TemplateObjGID.Tree3:
				for(_y = 0; _y < floor(ObjTileH / 3); _y++){
					for(_x = 0; _x < floor(ObjTileW / 2); _x++){
						var _TreeX = ObjX + (_x * 16);
						var _TreeY = ObjY + (_y * 24);
						DrawTileBlock(WallTMID, _TreeX, _TreeY, 45, VillageTilesY, 2, 3);
					}
				}
				
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);			
				break;
				
			case TemplateObjGID.Tree4:
				for(_y = 0; _y < floor(ObjTileH / 3); _y++){
					for(_x = 0; _x < floor(ObjTileW / 2); _x++){
						var _TreeX = ObjX + (_x * 16);
						var _TreeY = ObjY + (_y * 24);
						DrawTileBlock(WallTMID, _TreeX, _TreeY, 45, VillageTilesY + 3, 2, 3);
					}
				}
				
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);			
				break;
				
			case TemplateObjGID.FenceHor:

				for(_x = 0; _x < ObjTileW; _x++){
					PosX = ObjX + (_x * 8);
					if(_x mod 2 == 0)
						DrawTileBlock(WallTMID, PosX, ObjY, 26, VillageTilesY + 8, 1, 2);
					else
						DrawTileBlock(WallTMID, PosX, ObjY, 27, VillageTilesY + 8, 1, 1);
						
				}

				_WallInst = WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);			
				_WallInst.BlockProjectiles = false;
				break;
				
			case TemplateObjGID.FenceVer:

				for(_y = 0; _y < floor(ObjTileH / 2); _y++){
					PosY = ObjY + (_y * 16);
					DrawTileBlock(WallTMID, ObjX, PosY, 29, VillageTilesY + 8, 1, 2);						
				}
				
				DrawTileBlock(WallTMID, ObjX, ObjY2 - 8, 26, VillageTilesY + 8, 1, 2);
				
				_WallInst = WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				_WallInst.BlockProjectiles = false;
				
				break;
			
			//Hedges
			case TemplateObjGID.Hedge_TL:	
				DrawTileBlock(WallTMID, ObjX, ObjY, 40, VillageTilesY, 2, 2);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				break;
			case TemplateObjGID.Hedge_TR:	
				DrawTileBlock(WallTMID, ObjX, ObjY, 43, VillageTilesY, 2, 2);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				break;
			case TemplateObjGID.Hedge_BL:	
				DrawTileBlock(WallTMID, ObjX, ObjY, 40, VillageTilesY + 3, 2, 3);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				break;
			case TemplateObjGID.Hedge_BR:	
				DrawTileBlock(WallTMID, ObjX, ObjY, 43, VillageTilesY + 3, 2, 3);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				break;
			case TemplateObjGID.Hedge_Hor:
				for(var i = 0; i < ObjTileW; i++){
					DrawTileBlock(WallTMID, ObjX + (i * 8), ObjY, 42, VillageTilesY, 1, 3);
				}
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				break;
			case TemplateObjGID.Hedge_Ver:
				for(var i = 0; i < ObjTileH; i++){
					DrawTileBlock(WallTMID, ObjX, ObjY + (i * 8), 40, VillageTilesY + 2, 2, 1);
				}
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				break;
			case TemplateObjGID.Hedge_End_T:
				DrawTileBlock(WallTMID, ObjX, ObjY, 40, VillageTilesY, 1, 1);
				DrawTileBlock(WallTMID, ObjX + 8, ObjY, 44, VillageTilesY, 1, 1);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				break;
			case TemplateObjGID.Hedge_End_B:
				DrawTileBlock(WallTMID, ObjX, ObjY, 40, VillageTilesY + 4, 1, 2);
				DrawTileBlock(WallTMID, ObjX + 8, ObjY, 44, VillageTilesY + 4, 1, 2);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				break;
			case TemplateObjGID.Hedge_End_L:
				DrawTileBlock(WallTMID, ObjX, ObjY, 40, VillageTilesY, 1, 1);
				DrawTileBlock(WallTMID, ObjX, ObjY + 8, 40, VillageTilesY + 4, 1, 2);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				break;
			case TemplateObjGID.Hedge_End_R:
				DrawTileBlock(WallTMID, ObjX, ObjY, 44, VillageTilesY, 1, 1);
				DrawTileBlock(WallTMID, ObjX, ObjY + 8, 44, VillageTilesY + 4, 1, 2);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				break;
			
			
			case TemplateObjGID.Tombstone:
				DrawTileBlock(WallTMID, ObjX, ObjY, 46, VillageTilesY + 9, 4, 4);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				break;
				
			case TemplateObjGID.CemetaryWall:
				for(_y = 0; _y < floor(ObjTileH / 2); _y++){
					for(_x = 0; _x < floor(ObjTileW / 2); _x++){
						PosX = ObjX + (_x * 16);
						PosY = ObjY + (_y * 16);
						DrawTileBlock(WallTMID, PosX, PosY, 48, VillageTilesY + 13, 2, 2);
					}
				}
				
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				break;
				
			case TemplateObjGID.Pillar:

				DrawTileBlock(global.TMID_Tiles_Higher, ObjX, ObjY, 34, VillageTilesY + 13, 2, 1);
				DrawTileBlock(WallTMID, ObjX, ObjY + 8, 34, VillageTilesY + 14, 2, 3);
				
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY + 8, ObjTileW, ObjTileH - 1);			
				break;

			case TemplateObjGID.Gate:
				for(_x = 0; _x < ObjTileW; _x++){
					PosX = ObjX + (_x * 8);
					DrawTileBlock(WallTMID, PosX, ObjY, 48 + (_x mod 2), VillageTilesY + 4, 1, 3);
				}
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				break;

			case TemplateObjGID.AnimalBones:
				DrawTileBlock(WallTMID, ObjX, ObjY, 42, VillageTilesY + 6, 4, 4);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX + 8, ObjY, ObjTileW - 2, ObjTileH);
				break;

			case TemplateObjGID.WaterTrough1:
				DrawTileBlock(WallTMID, ObjX, ObjY, 26, VillageTilesY + 10, 4, 3);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				break;
			case TemplateObjGID.WaterTrough2:
				DrawTileBlock(WallTMID, ObjX, ObjY, 27, VillageTilesY + 13, 3, 3);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				break;
			
			case TemplateObjGID.VillageRiverDrain:
				DrawTileBlock(WallTMID, ObjX, ObjY, 142, 31, 4, 2);
				break;
				
			case TemplateObjGID.Bed1:
				DrawTileBlock(WallTMID, ObjX, ObjY, 50, VillageTilesY + 4, 4, 6);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, 4, 6);
				break;
			
			case TemplateObjGID.Bed2:
				DrawTileBlock(WallTMID, ObjX, ObjY, 58, VillageTilesY + 4, 4, 5);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, 4, 5);
				break;
			
			case TemplateObjGID.Table1:
				DrawTileBlock(DecorTMID, ObjX, ObjY, 50 + (real(ObjType) * 4), VillageTilesY, 4, 4);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, 4, 4);				
				break;
				
			case TemplateObjGID.Table2:
				DrawTileBlock(WallTMID, ObjX, ObjY, 66 + (real(ObjType) * 3), VillageTilesY, 3, 4);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, 3, 4);				
				break;
				
			case TemplateObjGID.Stove1:
				DrawTileBlock(DecorTMID, ObjX, ObjY, 72 + (real(ObjType) * 4), VillageTilesY, 4, 4);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, 4, 4);				
				break;
				
			case TemplateObjGID.Stove2:
				DrawTileBlock(DecorTMID, ObjX, ObjY, 80, VillageTilesY, 6, 3);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, 6, 3);				
				break;

			case TemplateObjGID.Cabinet1:
				DrawTileBlock(DecorTMID, ObjX, ObjY, 62, VillageTilesY + 4, 6, 5);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, 6, 5);				
				break;
				
			case TemplateObjGID.Cabinet2:
				DrawTileBlock(DecorTMID, ObjX, ObjY, 58 + (real(ObjType) * 4), VillageTilesY + 9, 4, 5);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, 4, 5);				
				break;
				
			case TemplateObjGID.Cabinet3:
				DrawTileBlock(DecorTMID, ObjX, ObjY, 66 + (real(ObjType) * 3), VillageTilesY + 9, 3, 5);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, 3, 5);				
				break;
			
			case TemplateObjGID.Furniture1:
				DrawTileBlock(DecorTMID, ObjX, ObjY, 58 + (real(ObjType) * 4), VillageTilesY + 14, 4, 3);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, 4, 3);						
				break;
			
			case TemplateObjGID.Furniture2:
				DrawTileBlock(DecorTMID, ObjX, ObjY, 66 + (real(ObjType) * 2), VillageTilesY + 14, 2, 3);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, 2, 3);						
				break;				
			
			case TemplateObjGID.Shelves:
				DrawTileBlock(DecorTMID, ObjX, ObjY, 68, VillageTilesY + 5, 6, 4);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY + 8, 6, 3);				
				break;

			case TemplateObjGID.Bench:
				DrawTileBlock(DecorTMID, ObjX, ObjY, 26, VillageTilesY + 6, ObjTileW, ObjTileH);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);				
				break;
				
			case TemplateObjGID.Painting:
				DrawTileBlock(DecorTMID, ObjX, ObjY, 54, VillageTilesY + 10 + (real(ObjType) * 2), ObjTileW, ObjTileH);
				break;
			
			case TemplateObjGID.Food:
				DrawTileBlock(DecorTMID, ObjX, ObjY, 50, VillageTilesY + 14, ObjTileW, ObjTileH);
				break;
			
			case TemplateObjGID.Crate:
				DrawTileBlock(DecorTMID, ObjX, ObjY, 48, VillageTilesY + 15, ObjTileW, ObjTileH);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				break;
			
			case TemplateObjGID.Chicken:
				var VarStruct = {FloorLevel : GetFloorLevelID(ObjX, ObjY), ItemHolding : -1, SectionID: 0, RoomIndex: _RoomIndex};
				instance_create_layer(ObjX, ObjY, "Objs_" + FloorLevelStr, oEnemy_Chicken, VarStruct);
				break;
			
			case TemplateObjGID.RuinWall:
				//Left edge
				DrawTileBlock(WallTMID, ObjX, ObjY, 46, VillageTilesY + 7, 1, 2);
				//middle
				for(var i = 0; i< ObjTileW - 2; i++){
					XPos = ObjX + 8 + (i * 8);
					DrawTileBlock(WallTMID, XPos, ObjY, 47 + (i mod 2), VillageTilesY + 7, 1, 2);
				}
				//Right edge
				DrawTileBlock(WallTMID, XPos + 8, ObjY, 49, VillageTilesY + 7, 1, 2);
				
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH);
				break;
				
			case TemplateObjGID.LibraryShelves:
				//top
				DrawTileBlock(global.TMID_Tiles_Higher, ObjX, ObjY, 74, VillageTilesY + 5, 6, 3);

				//bottom
				DrawTileBlock(DecorTMID, ObjX, ObjY + 24, 74, VillageTilesY + 8, 6, 1);
				
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY + 16, ObjTileW, 2);
				break;
			
			case TemplateObjGID.Book:
				inst = instance_create_layer(ObjX, ObjY, "Objs_" + FloorLevelStr, oBook);
				break;

			case TemplateObjGID.Garbage:
				DrawTileBlock(DecorTMID, ObjX, ObjY, 52, VillageTilesY + choose(14, 16), 2, 2, FlipCoin_Bool());
				break;

			case TemplateObjGID.Bottle1:
				DrawTileBlock(DecorTMID, ObjX, ObjY, 52, VillageTilesY + 12, 1, 2);
				break;

			case TemplateObjGID.Bottle2:
				DrawTileBlock(DecorTMID, ObjX, ObjY, 53, VillageTilesY + 12, 1, 2);
				break;

				
			case TemplateObjGID.Decor_Mural_T:
				if(ObjType == "Light"){
					var _LightInst = instance_create_layer(ObjX, ObjY + 8, "ObjsDoors_Upper", oWallLight, {RoomIndex : _RoomIndex, Location : TOP, Status: global.ChallengeOptions[ChallengeOption.Darkness] != ChallengeOption_Darkness.NoLights || GetPropertyValue(PropertiesArray, "AlwaysLit") != -1});
					if(Room.ForcedTheme != -1) _LightInst.PaletteIndex = Room.ForcedTheme + 1;
				}else
					DrawTileBlock(DecorTMID, ObjX, ObjY, 132, 4 + ((global.Level.Index - 1) * 6), 4, 3);
				break;
				
			case TemplateObjGID.Decor_Mural_B:
				if(ObjType == "Light"){
					var _LightInst = instance_create_layer(ObjX, ObjY, "ObjsDoors_Upper", oWallLight, {RoomIndex : _RoomIndex, Location : BOTTOM, Status: global.ChallengeOptions[ChallengeOption.Darkness] != ChallengeOption_Darkness.NoLights || GetPropertyValue(PropertiesArray, "AlwaysLit") != -1});
					if(Room.ForcedTheme != -1) _LightInst.PaletteIndex = Room.ForcedTheme + 1;
				}else
					DrawTileBlock(DecorTMID, ObjX, ObjY, 132, 4 + ((global.Level.Index - 1) * 6) + 3, 4, 3);				
				break;
				
			case TemplateObjGID.Decor_Mural_L:
				if(ObjType == "Light"){
					var _LightInst = instance_create_layer(ObjX + 8, ObjY, "ObjsDoors_Upper", oWallLight, {RoomIndex : _RoomIndex, Location : LEFT, Status: global.ChallengeOptions[ChallengeOption.Darkness] != ChallengeOption_Darkness.NoLights || GetPropertyValue(PropertiesArray, "AlwaysLit") != -1});
					if(Room.ForcedTheme != -1) _LightInst.PaletteIndex = Room.ForcedTheme + 1;
				}else
					DrawTileBlock(DecorTMID, ObjX, ObjY, 136, 4 + ((global.Level.Index - 1) * 6), 3, 4);					
				break;
				
			case TemplateObjGID.Decor_Mural_R:
				if(ObjType == "Light"){
					var _LightInst = instance_create_layer(ObjX, ObjY, "ObjsDoors_Upper", oWallLight, {RoomIndex : _RoomIndex, Location : RIGHT, Status: global.ChallengeOptions[ChallengeOption.Darkness] != ChallengeOption_Darkness.NoLights || GetPropertyValue(PropertiesArray, "AlwaysLit") != -1});
					if(Room.ForcedTheme != -1) _LightInst.PaletteIndex = Room.ForcedTheme + 1;
				}else
					DrawTileBlock(DecorTMID, ObjX, ObjY, 139, 4 + ((global.Level.Index - 1) * 6), 3, 4);				
				break;
			
			
			case TemplateObjGID.Tree_Large_T:
				DrawTileBlock(global.TMID_Tiles_Highest, ObjX, ObjY, 94, VillageTilesY, 6, 5);
				WallInst = WallObj_Create("Objs_Upper", ObjX, ObjY + 8, ObjTileW, 8);
				WallInst.FloorLevel = UPPER;
				break;
			case TemplateObjGID.Tree_Large_B:
				//DrawTileBlock(global.TMID_Tiles_Higher, ObjX, ObjY, 94, VillageTilesY + 5, 6, 2);
				DrawTileBlock(global.TMID_Walls_Upper, ObjX, ObjY, 94, VillageTilesY + 5, 6, 5);
				break;
			case TemplateObjGID.Tree_Large_L:
				DrawTileBlock(global.TMID_Tiles_Highest, ObjX, ObjY, 93, VillageTilesY + 1, 1, 5);
				DrawTileBlock(global.TMID_Walls_Upper, ObjX, ObjY + 40, 93, VillageTilesY + 6, 1, 2);
				break;
			case TemplateObjGID.Tree_Large_R:
				DrawTileBlock(global.TMID_Tiles_Highest, ObjX, ObjY, 100, VillageTilesY + 1, 1, 5);
				DrawTileBlock(global.TMID_Walls_Upper, ObjX, ObjY + 40, 100, VillageTilesY + 6, 1, 2);
				break;
			
			case TemplateObjGID.CastleWallH:
				for(var i = 0; i < ObjTileW; i++){
					var _PosX = ObjX + (i * 8);
					DrawTileBlock(global.TMID_Tiles_Higher, _PosX, ObjY, 88, VillageTilesY + 11, 1, 5);
					DrawTileBlock(global.TMID_Walls_Upper, _PosX, ObjY + 40, 88, VillageTilesY + 16, 1, 2);
				}
				break;
			
			case TemplateObjGID.CastleWallV:
				DrawTileBlock(global.TMID_Walls_Upper, ObjX, ObjY, 89, VillageTilesY + 5, 4, 13);
				break;
			
			case TemplateObjGID.CastleWallFloor:
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						DrawTileBlock(global.TMID_Walls_Upper, ObjX + (_x * 8), ObjY + (_y * 8), 93, VillageTilesY + 11, 1, 1);
					}
				}
				break;
			
			case TemplateObjGID.CastleWallDoor:
				instance_create_layer(ObjX, ObjY, "ObjsDoors_Upper", oCastleWallDoor);
				break;
			
			case TemplateObjGID.Bush:
				
				var BushInst = instance_create_layer(ObjX + 8, ObjY + 15, "ObjsDoors_" + FloorLevelStr, oBush);
				
				var _RandomItem = true;
				var BushItem = GetPropertyValue(PropertiesArray, "Item");
				if(BushItem != -1){
					var _AssetIndex = asset_get_index(BushItem);
					if(_AssetIndex != -1){
						BushInst.ContentsObj = ItemClassFromObjIndex(_AssetIndex);
						_RandomItem = false;
					}
				}
				if(_RandomItem) BushInst.ContentsObj = Probs_RandomItemClass_Pot(false, true);
				
				var BushStyle = GetPropertyValue(PropertiesArray, "Purple");
				if(BushStyle != -1){
					DrawTileBlock(WaterTMID, ObjX, ObjY, 7, 2, 2, 2);
					BushInst.Index = 1;
				}else{
					DrawTileBlock(WaterTMID, ObjX, ObjY, 7, 0, 2, 2);
				}
				BushInst.image_index = BushInst.Index;
				
				WallInst = WallObj_Create("ObjsFloor_" + FloorLevelStr, ObjX, ObjY, 2, 2);				
				WallInst.BlockItems = false;
				WallInst.BlockProjectiles = false;
				BushInst.WallObj = WallInst; //Save wall inst so we can destroy it after bush is grabbed
				break;
			
			
			case TemplateObjGID.TMNT_Couch1:
				DrawTileBlock(global.TMID_Walls_Lower, ObjX, ObjY, 10, VillageTilesY + 18, ObjTileW, ObjTileH);
				WallObj_Create("Objs_Lower", ObjX, ObjY, ObjTileW - 1, ObjTileH);					
				break;
				
			case TemplateObjGID.TMNT_Couch2:
				DrawTileBlock(global.TMID_Walls_Lower, ObjX, ObjY, 13, VillageTilesY + 20, ObjTileW, ObjTileH);
				WallObj_Create("Objs_Lower", ObjX, ObjY, ObjTileW, ObjTileH);				
				break;
				
			case TemplateObjGID.TMNT_ElectricalPanel:
				DrawTileBlock(global.TMID_Decor_Upper, ObjX, ObjY, 17, VillageTilesY + 16, ObjTileW, 1);
				DrawTileBlock(global.TMID_Decor_Lower, ObjX, ObjY + 8, 17, VillageTilesY + 17, ObjTileW, ObjTileH - 1);
				break;
				
			case TemplateObjGID.TMNT_FootSoldierFloor:
				DrawTileBlock(global.TMID_Water_Lower, ObjX, ObjY, 6, VillageTilesY + 18, ObjTileW, ObjTileH);
				WallObj_Create("Objs_Lower", ObjX + 8, ObjY, 2, 1);	
				instance_create_layer(ObjX + 15, ObjY, "ObjsHigher_Lower", oEnemy_FootSoldier, {FloorLevel : LOWER, 
							   																	ItemHolding : -1, 
																								 SectionID: 0,
																								RoomIndex: _RoomIndex});
				break;
				
			case TemplateObjGID.TMNT_Mutagen:
				DrawTileBlock(global.TMID_Decor_Lower, ObjX, ObjY, 13, VillageTilesY + 16, ObjTileW, ObjTileH);
				WallObj_Create("Objs_Lower", ObjX, ObjY, ObjTileW, ObjTileH);
				break;
				
			case TemplateObjGID.TMNT_Sewer:
				DrawTileBlock(global.TMID_Decor_Upper, ObjX, ObjY, 0, VillageTilesY + 17, ObjTileW, ObjTileH - 3);
				DrawTileBlock(global.TMID_Decor_Lower, ObjX, ObjY + 24, 0, VillageTilesY + 20, ObjTileW, ObjTileH - 3);
				break;
				
			case TemplateObjGID.TMNT_Sword:
				DrawTileBlock(global.TMID_Decor_Upper, ObjX, ObjY, 9, VillageTilesY + 17, ObjTileW, ObjTileH);
				break;
				
			case TemplateObjGID.TMNT_TV:
				DrawTileBlock(global.TMID_Walls_Upper, ObjX + 8, ObjY, 19, VillageTilesY + 19, 2, 1);
				DrawTileBlock(global.TMID_Walls_Lower, ObjX, ObjY + 8, 18, VillageTilesY + 20, ObjTileW, ObjTileH - 2);
				DrawTileBlock(global.TMID_Water_Lower, ObjX, ObjY + 24, 18, VillageTilesY + 22, ObjTileW, 1);
				WallObj_Create("Objs_Lower", ObjX, ObjY + 8, ObjTileW, ObjTileH - 2);				
				break;
			
			case TemplateObjGID.TMNT_Pizza:
				var PizzaInst = instance_create_layer(ObjX + 8, ObjY + 16, "Objs_Lower", oItem_Food, {From : ItemFrom.Treasure});
				with(PizzaInst){
					Item_SetIndex(Food.Pizza);
					FloorLevel = LOWER;
					ShadowOffsetY -= 2;
				}
				break;
			
			case TemplateObjGID.Gem:
				if(global.Level.Index == DungeonLevel.Mines){
					_Inst = instance_create_layer(ObjX + 8, ObjY + 16, "Objs_" + FloorLevelStr, oItem_Gem, {From : ItemFrom.Treasure});
				}else{
					_Inst = instance_create_layer(ObjX + 8, ObjY + 16, "Objs_" + FloorLevelStr, choose(oItem_Gem, oItem_Gem, oItem_Kinstone), {From : ItemFrom.Treasure});
				}
				//most of the time, make sure gem or kinstone isn't the same as others in the room
				
				if(Prob(1)){
					
					var _InstIndex = _Inst.Index;
					
					with(_Inst.object_index){
						
						if(RoomIndex != _RoomIndex) continue;
						
						if(_Inst.id == id) continue;
						
						if(_InstIndex == Index){
							_InstIndex = ((_InstIndex + 1) mod (_Inst.object_index == oItem_Gem ? GemCount : 4));
						}						
						
					}	
					
					with(_Inst){								
						Item_SetIndex(_InstIndex);
					}
				}
				break;
				
			case TemplateObjGID.Torch:
				
				if(global.ChallengeOptions[ChallengeOption.Darkness] == ChallengeOption_Darkness.NoLights) break;
				
				var _Lit = GetPropertyValue(PropertiesArray, "Lit");
				var TorchInst = instance_create_layer(ObjX, ObjY, "Objs_" + FloorLevelStr, oTorch, {RoomIndex : _RoomIndex, Lit: _Lit != -1});
				break;
			
			case TemplateObjGID.Column_T:
				DrawTileBlock(DecorTMID, ObjX, ObjY, 152, LevelTilesY, 2, 3);	
				DrawTileBlock(WaterTMID, ObjX, ObjY+24, 152, LevelTilesY + 3, 2, 1);
				break;
			case TemplateObjGID.Column_B:
				DrawTileBlock(WaterTMID, ObjX, ObjY, 154, LevelTilesY, 2, 1);	
				DrawTileBlock(DecorTMID, ObjX, ObjY + 8, 154, LevelTilesY + 1, 2, 3);
				break;
			case TemplateObjGID.Column_L:
				DrawTileBlock(DecorTMID, ObjX, ObjY, 152, LevelTilesY + 4, 3, 2);
				DrawTileBlock(WaterTMID, ObjX + 24, ObjY, 155, LevelTilesY + 4, 1, 2);				
				break;
			case TemplateObjGID.Column_R:
				DrawTileBlock(WaterTMID, ObjX, ObjY, 148, LevelTilesY + 4, 1, 2);
				DrawTileBlock(DecorTMID, ObjX + 8, ObjY, 149, LevelTilesY + 4, 3, 2);				
				break;
			
			case TemplateObjGID.Mine_CoalPit:
				var TileX2 = ObjX + ((ObjTileW - 1) * 8);
				var TileY2 = ObjY + ((ObjTileH - 2) * 8);
				//TL Corner
				DrawTileBlock(WallTMID, ObjX, ObjY, 118, VillageTilesY, 1, 1);
				//Top
				for(_x = 0; _x < ObjTileW - 2; _x++){
					var _PosX = ObjX + 8 + (_x * 8);
					DrawTileBlock(WallTMID, _PosX, ObjY, 119, VillageTilesY, 1, 1);
				}
				//TR Corner
				DrawTileBlock(WallTMID, TileX2 , ObjY, 120, VillageTilesY, 1, 1);
				
				//Sides
				for(_y = 0; _y < ObjTileH - 3; _y++){
					var _PosY = ObjY + 8 + (_y * 8);
					DrawTileBlock(WallTMID, ObjX, _PosY, 118, VillageTilesY + 1, 1, 1);
					DrawTileBlock(WallTMID, TileX2, _PosY, 120, VillageTilesY + 1, 1, 1);
				}

				//BL Corner
				DrawTileBlock(WallTMID, ObjX, TileY2, 118, VillageTilesY + 2, 1, 2);
				
				//BR Corner
				DrawTileBlock(WallTMID, TileX2, TileY2, 121, VillageTilesY + 2, 1, 2);

				//Bottom
				for(_x = 0; _x < ObjTileW - 2; _x++){
					var _PosX = ObjX + 8 + (_x * 8);
					DrawTileBlock(WallTMID, _PosX, TileY2, 119 + (_x mod 2), VillageTilesY + 2, 1, 2);
				}
				//middle
				for(_y = 0; _y < ObjTileH - 3; _y++){
					for(_x = 0; _x < ObjTileW - 2; _x++){
						var _PosX = ObjX + 8 + (_x * 8);
						var _PosY = ObjY + 8 + (_y * 8);
						DrawTileBlock(WallTMID, _PosX, _PosY, 119, VillageTilesY + 1, 1, 1);
					}
				}
				
				var CoalInst = instance_create_layer(ObjX + 8, ObjY + 8, "Objs_" + FloorLevelStr, oCoal, {RoomIndex : _RoomIndex, W : ObjW - 16, H : ObjH - 24});
				
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, ObjTileH - 1);
				
				Room.Heat = true;
				
				break;

			case TemplateObjGID.DoorT:

				ClearTileBlock(WallTMID, ObjX + 8, ObjY + 8, 2, 2);

				WallObjInst = collision_point(ObjX, ObjY, oWall, false, true);
				if(WallObjInst != noone) WallObj_Cutout_H(WallObjInst, ObjX + 8, ObjX + 23);
				
				_DoorInst = instance_create_layer(ObjX, ObjY, "ObjsDoors_" + FloorLevelStr, oDoor);
				_DoorInst.FloorLevel = FloorLevel;
				_DoorInst.Location = "Top";
				_DoorInst.AddTracks = GetPropertyValue(PropertiesArray, "AddTrack") != -1;
				Door_SetPassageArea(_DoorInst);	
				break;
			
			case TemplateObjGID.DoorB:

				ClearTileBlock(WallTMID, ObjX + 8, ObjY, 2, 2);

				WallObjInst = collision_point(ObjX, ObjY, oWall, false, true);
				if(WallObjInst != noone) WallObj_Cutout_H(WallObjInst, ObjX + 8, ObjX + 23);
				
				_DoorInst = instance_create_layer(ObjX, ObjY, "ObjsDoors_" + FloorLevelStr, oDoor);
				_DoorInst.FloorLevel = FloorLevel;
				_DoorInst.Location = "Bottom";
				_DoorInst.AddTracks = GetPropertyValue(PropertiesArray, "AddTrack") != -1;
				Door_SetPassageArea(_DoorInst);	
				break;
				
			case TemplateObjGID.DoorL:
			
				ClearTileBlock(WallTMID, ObjX + 16, ObjY + 8, 2, 2);

				WallObjInst = collision_point(ObjX, ObjY, oWall, false, true);
				if(WallObjInst != noone) WallObj_Cutout_V(WallObjInst, ObjY + 8, ObjY + 23);

				_DoorInst = instance_create_layer(ObjX, ObjY, "ObjsDoors_" + FloorLevelStr, oDoor);
				_DoorInst.FloorLevel = FloorLevel;
				_DoorInst.Location = "Left";
				_DoorInst.AddTracks = GetPropertyValue(PropertiesArray, "AddTrack") != -1;
				Door_SetPassageArea(_DoorInst);
				break;
				
			case TemplateObjGID.DoorR:

				ClearTileBlock(WallTMID, ObjX + 8, ObjY + 8, 2, 2);

				WallObjInst = collision_point(ObjX, ObjY, oWall, false, true);
				if(WallObjInst != noone) WallObj_Cutout_V(WallObjInst, ObjY + 8, ObjY + 23);

				_DoorInst = instance_create_layer(ObjX, ObjY, "ObjsDoors_" + FloorLevelStr, oDoor);
				_DoorInst.FloorLevel = FloorLevel;
				_DoorInst.Location = "Right";
				_DoorInst.AddTracks = GetPropertyValue(PropertiesArray, "AddTrack") != -1;
				Door_SetPassageArea(_DoorInst);
				break;

			case TemplateObjGID.Mine_Cart:
				var _Dir = GetPropertyValue(PropertiesArray, "Dir");				
				var CartInst = instance_create_layer(ObjX, ObjY, "Objs_" + FloorLevelStr, oMineCart, {Dir : _Dir});
				break;
				
			case TemplateObjGID.Mine_DwarfWorker:
				var _Flip = GetPropertyValue(PropertiesArray, "Flip") != -1;	
				var WorkerInst = instance_create_layer(ObjX, ObjY, "Objs_" + FloorLevelStr, oDwarfWorker, {Flip: _Flip});
				break;
				
			case TemplateObjGID.Mine_GemRock:
				_Index = irandom(9);//GetPropertyValue(PropertiesArray, "Index");
				var GemRockInst = instance_create_layer(ObjX + 8, ObjY + 16, "ObjsFloor_" + FloorLevelStr, oGemRock, {image_index: _Index});
				break;
				
			case TemplateObjGID.Mine_GemWall:
				_Index = irandom(9);//GetPropertyValue(PropertiesArray, "Index");
				DrawTileBlock(DecorTMID, ObjX, ObjY, 118 + ((_Index mod 5) * 2), VillageTilesY + 4 + ((_Index div 5) * 2), 2, 2, Prob(0.5));
				break;
				
			case TemplateObjGID.Mine_Mushrooms:
				_Index = GetPropertyValue(PropertiesArray, "Index") * 2;
				_Index = choose(_Index, _Index + 1)
				DrawTileBlock(DecorTMID, ObjX, ObjY, 128 + ((_Index mod 4) * 2), VillageTilesY + 4 + ((_Index div 4) * 2), 2, 2, Prob(0.5));
				break;
				
			case TemplateObjGID.Mine_DrawBridgeH:
				for(_x = 0; _x < ObjTileW; _x++){
					var _PosX = ObjX + (_x * 8);
					DrawTileBlock(DecorTMID, _PosX, ObjY, 134, VillageTilesY + 18, 1, 4);
				}
				_ObjLayer = "Objs_" + FloorLevelStr;
				WallObj_Create(_ObjLayer, ObjX, ObjY - 12, ObjTileW, 1);
				WallObj_Create(_ObjLayer, ObjX, ObjY2, ObjTileW, 1);
				
				_inst = instance_create_layer(ObjX, ObjY, _ObjLayer, oDrawBridgeArea);
				_inst.image_xscale = ObjTileW;
				_inst.image_yscale = ObjTileH;
				break;
				
			case TemplateObjGID.Mine_DrawBridgeV:
				for(_y = 0; _y < ObjTileH; _y++){
					var _PosY = ObjY + (_y * 8);
					DrawTileBlock(DecorTMID, ObjX, _PosY, 130, VillageTilesY + 22, 4, 1);
				}		
				_ObjLayer = "Objs_" + FloorLevelStr;
				WallObj_Create(_ObjLayer, ObjX - 5, ObjY, 1, ObjTileH);
				WallObj_Create(_ObjLayer, ObjX2 + 5, ObjY, 1, ObjTileH);

				_inst = instance_create_layer(ObjX, ObjY, _ObjLayer, oDrawBridgeArea);
				_inst.image_xscale = ObjTileW;
				_inst.image_yscale = ObjTileH;
				
				break;
			
			case TemplateObjGID.Jail:
				Dungeon_Draw_Jail(_RoomIndex, ObjX, ObjY, ObjTileW, ObjTileH, choose(JailType.Prisoner, JailType.Open, JailType.Open));
				break;
			
			case TemplateObjGID.SaveTent:
				var TentInst = instance_create_layer(ObjX, ObjY, "Objs_" + FloorLevelStr, oSaveTent);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY + 8, 4, 3);
				break;

			case TemplateObjGID.Frogs:
				var FrogsInst = instance_create_layer(ObjX, ObjY, "Objs_" + FloorLevelStr, oSimonFrogs);
				WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, ObjTileW, 1);
				break;
				
		}
		
		switch(ObjName){
			case "MineCartAction":
				var _Val1 = GetPropertyValue(PropertiesArray, "Val1");
				var _Val2 = GetPropertyValue(PropertiesArray, "Val2");
				var _MineCartActionInst = instance_create_layer(ObjX, ObjY, "Objs_" + FloorLevelStr, oMineCartAction, {Action : ObjType, Value1 : _Val1, Value2 : _Val2});				
				break;
			
		}
			
	
	}
	
}