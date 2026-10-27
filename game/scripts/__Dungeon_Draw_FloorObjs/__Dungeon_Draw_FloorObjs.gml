// Feather disable GM2064

function Dungeon_Draw_FloorObjs(_RoomIndex){
	
	if(!variable_struct_exists(Room.Template, "FloorObjs")) exit;
	
	var FloorObjArray = Room.Template.FloorObjs;

	var Tile, Tx, TileY, _x, _y;
	for(var FloorObjIndex = 0; FloorObjIndex < array_length(FloorObjArray); FloorObjIndex++){
		
		var Obj = FloorObjArray[FloorObjIndex];
		var ObjX = Room.x + Obj.x;
		var ObjY = Room.y + Obj.y;
		var ObjW = Obj.width;
		var ObjH = Obj.height;
		var ObjTileW = ObjW / 8;
		var ObjTileH = ObjH / 8;
		var ObjRot = Obj.rotation;		
		var ObjX2 = ObjX + ObjW - 8; //coordinates of the opposite edge tiles
		var ObjY2 = ObjY + ObjH - 8;	
		var ObjGID = Obj.gid;
		var ObjName = Obj[$ "name"];
		var ObjType = Obj[$ "type"];
		var UpperFloorCheck = tilemap_get_at_pixel(global.TMID_Floor_Upper, ObjX, ObjY);
		var FloorLevelStr = (UpperFloorCheck ? "Upper" : "Lower");
		var FloorTMID = GetFloorLevelTMID("Tiles_Floor", ObjX, ObjY);
		var DecorTMID = GetFloorLevelTMID("Tiles_Decor", ObjX, ObjY);
		var WaterTMID = GetFloorLevelTMID("Tiles_Water", ObjX, ObjY);
		var WallsTMID = GetFloorLevelTMID("Tiles_Walls", ObjX, ObjY);
		var PropertiesArray = Obj.properties;
		
		switch(ObjGID){
			
			case TemplateObjGID.MovingFloorUp:
			case TemplateObjGID.MovingFloorDown:
			case TemplateObjGID.MovingFloorLeft:
			case TemplateObjGID.MovingFloorRight:
				
				if(!ObstacleRoomCheck(_RoomIndex, RoomObstacleClass.MovingFloors) || global.SpawnedWater) break;
				
				var MovingFloorInst = instance_create_layer(ObjX, ObjY, "ObjsFloor_" + FloorLevelStr, oMovingFloor, {W : ObjW, H : ObjH});
				switch(ObjGID){
					case TemplateObjGID.MovingFloorLeft:
						MovingFloorInst.sprite_index = sMovingFloorLeft;
						MovingFloorInst.DirX = -1;
						break;
					case TemplateObjGID.MovingFloorRight:
						MovingFloorInst.sprite_index = sMovingFloorRight;
						MovingFloorInst.DirX = 1;
						break;
					case TemplateObjGID.MovingFloorUp:
						MovingFloorInst.sprite_index = sMovingFloorUp;
						MovingFloorInst.DirY = -1;
						break;
					case TemplateObjGID.MovingFloorDown:
						MovingFloorInst.sprite_index = sMovingFloorDown;
						MovingFloorInst.DirY = 1;
						break;
				}

				global.SpawnedMovingFloors = true;
				
				break;

				
			case TemplateObjGID.Carpet_V:
				
				//don't draw carpets for certain levels
				if(LevelDef.Theme == DungeonLevel.Catacombs || LevelDef.Theme == DungeonLevel.Sewers || LevelDef.Theme == DungeonLevel.MoldormsLair) break;
				
				TileY = LevelTilesY_Base;
				
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(FloorTMID, GetTileID(111, TileY + 2), _TileX, _TileY);
						if(_x == 0 || _x == ObjTileW - 1) tilemap_set_at_pixel(FloorTMID, GetTileID(110, TileY + 4), _TileX, _TileY);
					}
				}
				break;

			case TemplateObjGID.Rug:

				//don't draw carpets for certain levels
				if(LevelDef.Theme == DungeonLevel.Catacombs || LevelDef.Theme == DungeonLevel.Sewers || LevelDef.Theme == DungeonLevel.MoldormsLair) break;
				
				//TL Corner
				DrawTileBlock(FloorTMID, ObjX, ObjY, 15, 0, 1, 1);
				//TR Corner
				DrawTileBlock(FloorTMID, ObjX2, ObjY, 17, 0, 1, 1);
				//BL Corner
				DrawTileBlock(FloorTMID, ObjX, ObjY2, 15, 2, 1, 1);
				//BR Corner
				DrawTileBlock(FloorTMID, ObjX2, ObjY2, 17, 2, 1, 1);
	
				//Top & Bottom Edges
				for(_x = 0; _x < ObjTileW - 2; _x++){
					var FloorX = ObjX + 8 + (_x * 8);
					DrawTileBlock(FloorTMID, FloorX, ObjY, 16, 0, 1, 1);							
					DrawTileBlock(FloorTMID, FloorX, ObjY2, 16, 2, 1, 1);							
				}
	
				//Top & Bottom Edges
				for(_y = 0; _y < ObjTileH - 2; _y++){
					var FloorY = ObjY + 8 + (_y * 8);
					DrawTileBlock(FloorTMID, ObjX, FloorY, 15, 1, 1, 1);							
					DrawTileBlock(FloorTMID, ObjX2, FloorY, 17, 1, 1, 1);							
				}	
	
				//Main floor
				for(_y = 0; _y < ObjTileH - 2; _y++){
					for(_x = 0; _x < ObjTileW - 2; _x++){
						var FloorX = ObjX + 8 + (_x * 8);
						var FloorY = ObjY + 8 + (_y * 8);
						DrawTileBlock(FloorTMID, FloorX, FloorY, 16, 1, 1, 1);							
					}
				}		
				break;
				
			case TemplateObjGID.Path1:
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(FloorTMID, GetTileID(30 + (_x mod 2), VillageTilesY + 4 + (_y mod 2)), _TileX, _TileY);
					}
				}
				break;
				
			case TemplateObjGID.Path2:
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(DecorTMID, GetTileID(32, VillageTilesY + 5), _TileX, _TileY);
					}
				}	
				break;
			case TemplateObjGID.Path3:
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(DecorTMID, GetTileID(30 + (_x mod 2), VillageTilesY + 6 + (_y mod 2)), _TileX, _TileY);
					}
				}	
				break;

			case TemplateObjGID.Path4:
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(WaterTMID, GetTileID(32, VillageTilesY + 7), _TileX, _TileY);
					}
				}	
				break;

			case TemplateObjGID.Path5:
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(WaterTMID, GetTileID(33 + (_x mod 2), VillageTilesY + 4 + (_y mod 2)), _TileX, _TileY);
					}
				}	
				break;

			case TemplateObjGID.Path6:
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(WaterTMID, GetTileID(32, VillageTilesY + 6), _TileX, _TileY);
					}
				}	
				break;

			case TemplateObjGID.Path7:
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(WaterTMID, GetTileID(32, VillageTilesY + 8), _TileX, _TileY);
					}
				}	
				break;

			case TemplateObjGID.Path8:
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(WaterTMID, GetTileID(32, VillageTilesY + 9), _TileX, _TileY);
					}
				}	
				break;

			case TemplateObjGID.Path9:
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(DecorTMID, GetTileID(30 + (_x mod 2), VillageTilesY + 8), _TileX, _TileY);
					}
				}	
				break;

			case TemplateObjGID.Path10:
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(DecorTMID, GetTileID(15 + (_x mod 2), VillageTilesY + 4), _TileX, _TileY);
					}
				}	
				break;
				
			case TemplateObjGID.PathTrim:
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(WaterTMID, GetTileID(32, VillageTilesY + 4), _TileX, _TileY);
					}
				}	
				break;
			
			case TemplateObjGID.Dirt:
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						
						if(Prob(0.3)){ //normal dirt
							Tile = GetTileID(37, VillageTilesY + 2);
							
						}else if(Prob(0.9)){ //other dirt 
							Tile = choose(GetTileID(37, VillageTilesY + 1), GetTileID(36, VillageTilesY + 2), GetTileID(38, VillageTilesY + 2),  GetTileID(37, VillageTilesY + 3));
							
						}else{ //rocks
							Tile = choose(GetTileID(35, VillageTilesY), GetTileID(39, VillageTilesY), GetTileID(35, VillageTilesY + 1), GetTileID(39, VillageTilesY + 1));
						}

						tilemap_set_at_pixel(WaterTMID, Tile, _TileX, _TileY);
					}
				}	
				break;
			
			case TemplateObjGID.Dirt_Edge1:
				Tx = (LevelDef.Theme == DungeonLevel.Start ? 89 : 36);
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						
						switch(ObjRot){
							case 0:		Tile = GetTileID(Tx, VillageTilesY + 1); break;
							case 90:	Tile = GetTileID(Tx + 2, VillageTilesY + 1); break;
							case -90:	Tile = GetTileID(Tx, VillageTilesY + 3); break;
							case 180:	Tile = GetTileID(Tx + 2, VillageTilesY + 3); break;
						}

						tilemap_set_at_pixel(WaterTMID, Tile, _TileX, _TileY);
					}
				}
				break;

			case TemplateObjGID.Dirt_Edge2:
				Tx = (LevelDef.Theme == DungeonLevel.Start ? 89 : 36);
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						
						switch(ObjRot){
							case 0:		Tile = GetTileID(Tx, VillageTilesY); break;
							case 90:	Tile = GetTileID(Tx + 2, VillageTilesY); break;
							case -90:	Tile = GetTileID(Tx, VillageTilesY + 4); break;
							case 180:	Tile = GetTileID(Tx + 2, VillageTilesY + 4); break;
						}

						tilemap_set_at_pixel(WaterTMID, Tile, _TileX, _TileY);
					}
				}
				break;

			case TemplateObjGID.Dirt_Edge3:
				Tx = (LevelDef.Theme == DungeonLevel.Start ? 88: 35);
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						
						switch(ObjRot){
							case 0:		Tile = GetTileID(Tx + 2, VillageTilesY); break;
							case 90:	Tile = GetTileID(Tx + 4, VillageTilesY + 2); break;
							case -90:	Tile = GetTileID(Tx, VillageTilesY + 2); break;
							case 180:	Tile = GetTileID(Tx + 2, VillageTilesY + 4); break;
						}

						tilemap_set_at_pixel(WaterTMID, Tile, _TileX, _TileY);
					}
				}
				break;
			
			case TemplateObjGID.Sand:
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						var TileX = ObjX + (_x * 8);
						TileY = ObjY + (_y * 8);
						DrawTileBlock(FloorTMID, TileX, TileY, 42 + ((TileX / 8) mod 2), 40 + ((TileY / 8) mod 2), 1, 1);	
					}
				}
				break;

			case TemplateObjGID.MedallionPlatform:
				DrawTileBlock(WaterTMID, ObjX, ObjY, 44, VillageTilesY + 13, 2, 2);	
				break;


			case TemplateObjGID.Seat:
				DrawTileBlock(FloorTMID, ObjX, ObjY, 50, VillageTilesY + 10 + (real(ObjType) * 2), 2, 2);	
				WallObj_Create("ObjsFloor_" + FloorLevelStr, ObjX, ObjY, 2, 2);
				break;

			case TemplateObjGID.Mine_Track_H:
				for(_x = 0; _x < ObjTileW; _x++){
					var _PosX = ObjX + (_x * 8);
					DrawTileBlock(WaterTMID, _PosX, ObjY, 122, VillageTilesY + 1, 1, 2);
				}				
				break;
			case TemplateObjGID.Mine_Track_V:
				for(_y = 0; _y < ObjTileH; _y++){
					var _PosY = ObjY + (_y * 8);
					DrawTileBlock(WaterTMID, ObjX, _PosY, 122, VillageTilesY, 2, 1);
				}				
				break;
			case TemplateObjGID.Mine_Track_TL:				
				DrawTileBlock(WaterTMID, ObjX, ObjY, 124, VillageTilesY, 2, 2);								
				break;
			case TemplateObjGID.Mine_Track_TR:				
				DrawTileBlock(WaterTMID, ObjX, ObjY, 126, VillageTilesY, 2, 2);								
				break;
			case TemplateObjGID.Mine_Track_BL:				
				DrawTileBlock(WaterTMID, ObjX, ObjY, 124, VillageTilesY + 2, 2, 2);								
				break;
			case TemplateObjGID.Mine_Track_BR:				
				DrawTileBlock(WaterTMID, ObjX, ObjY, 126, VillageTilesY + 2, 2, 2);								
				break;
			
			case TemplateObjGID.Mine_Lava:
				for(_y = 0; _y < ObjTileH; _y++){
					for(_x = 0; _x < ObjTileW; _x++){
						var TileX = ObjX + (_x * 8);
						TileY = ObjY + (_y * 8);
						DrawTileBlock(global.TMID_Lava, TileX, TileY, 126 + ((TileX / 8) mod 2), VillageTilesY + 18 + ((TileY / 8) mod 2), 1, 1);	
					}
				}
				instance_create_layer(ObjX + (ObjW / 2), ObjY + (ObjH / 2), "Objs_" + FloorLevelStr, oCoalLight, {RoomIndex : _RoomIndex, R : 0.7, G : 0.4, B : 0.4, LightStrength : GetPropertyValue(PropertiesArray, "LightStrength")});
				Room.Heat = true;
				break;
				
		}
		
	}
	

	
}