
function Dungeon_Draw_FloorObjs(_RoomIndex){
	

	var FloorObjArray = TemplateRoom.FloorObjs;

	for(var FloorObjIndex = 0; FloorObjIndex < array_length(FloorObjArray); FloorObjIndex++){
		
		var Obj = FloorObjArray[FloorObjIndex];
		var ObjX = Room.x + Obj.x;
		var ObjY = Room.y + Obj.y;
		var ObjW = Obj.width;
		var ObjH = Obj.height;
		var ObjTileW = ObjW / 8;
		var ObjTileH = ObjH / 8;
		
		var ObjRot = Obj.rotation;
		var OldObjTileW = ObjTileW;
		var OldObjTileH = ObjTileH;
		switch(ObjRot){
			case 90:
				//transform Tiled incorrect coordinates when rotated
				ObjX -= Obj.height;
				ObjW = Obj.height;
				ObjH = Obj.width;
				ObjTileW = OldObjTileH;
				ObjTileH = OldObjTileW;
				break;
				
			case 180:
				ObjX -= Obj.width;
				ObjY -= Obj.height;
				break;
			
			case -90: //270
				ObjY -= Obj.width;
				ObjW = Obj.height;
				ObjH = Obj.width;
				ObjTileW = OldObjTileH;
				ObjTileH = OldObjTileW;
				break;
			
		}
		
		var ObjX2 = ObjX + ObjW - 8; //coordinates of the opposite edge tiles
		var ObjY2 = ObjY + ObjH - 8;	
		var ObjGID = Obj.gid;
		var UpperFloorCheck = tilemap_get_at_pixel(global.TMID_Floor_Upper, ObjX, ObjY);
		var FloorLevelStr = (UpperFloorCheck ? "Upper" : "Lower");
		var FloorTMID = GetFloorLevelTMID("Tiles_Floor", ObjX, ObjY);
		var DecorTMID = GetFloorLevelTMID("Tiles_Decor", ObjX, ObjY);
		var WaterTMID = GetFloorLevelTMID("Tiles_Water", ObjX, ObjY);
		var WallsTMID = GetFloorLevelTMID("Tiles_Walls", ObjX, ObjY);
		
		switch(ObjGID){
				
			case TemplateObjGID.Carpet_V:
				for(var _y = 0; _y < ObjTileH; _y++){
					for(var _x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(FloorTMID, GetTileID(111, LevelTilesY + 2), _TileX, _TileY);
						if(_x == 0 || _x == ObjTileW - 1) tilemap_set_at_pixel(FloorTMID, GetTileID(110, LevelTilesY + 4), _TileX, _TileY);
					}
				}
				break;

			case TemplateObjGID.Rug:
				//TL Corner
				DrawTileBlock(FloorTMID, ObjX, ObjY, 27, 0, 1, 1);
				//TR Corner
				DrawTileBlock(FloorTMID, ObjX2, ObjY, 29, 0, 1, 1);
				//BL Corner
				DrawTileBlock(FloorTMID, ObjX, ObjY2, 27, 2, 1, 1);
				//BR Corner
				DrawTileBlock(FloorTMID, ObjX2, ObjY2, 29, 2, 1, 1);
	
				//Top & Bottom Edges
				for(var _x = 0; _x < ObjTileW - 2; _x++){
					var FloorX = ObjX + 8 + (_x * 8);
					DrawTileBlock(FloorTMID, FloorX, ObjY, 28, 0, 1, 1);							
					DrawTileBlock(FloorTMID, FloorX, ObjY2, 28, 2, 1, 1);							
				}
	
				//Top & Bottom Edges
				for(var _y = 0; _y < ObjTileH - 2; _y++){
					var FloorY = ObjY + 8 + (_y * 8);
					DrawTileBlock(FloorTMID, ObjX, FloorY, 27, 1, 1, 1);							
					DrawTileBlock(FloorTMID, ObjX2, FloorY, 29, 1, 1, 1);							
				}	
	
				//Main floor
				for(var _y = 0; _y < ObjTileH - 2; _y++){
					for(var _x = 0; _x < ObjTileW - 2; _x++){
						var FloorX = ObjX + 8 + (_x * 8);
						var FloorY = ObjY + 8 + (_y * 8);
						DrawTileBlock(FloorTMID, FloorX, FloorY, 28, 1, 1, 1);							
					}
				}		
				break;
				
			case TemplateObjGID.Path1:
				for(var _y = 0; _y < ObjTileH; _y++){
					for(var _x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(FloorTMID, GetTileID(30 + (_x mod 2), VillageTilesY + 4 + (_y mod 2)), _TileX, _TileY);
					}
				}
				break;
				
			case TemplateObjGID.Path2:
				for(var _y = 0; _y < ObjTileH; _y++){
					for(var _x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(DecorTMID, GetTileID(32, VillageTilesY + 5), _TileX, _TileY);
					}
				}	
				break;
			case TemplateObjGID.Path3:
				for(var _y = 0; _y < ObjTileH; _y++){
					for(var _x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(DecorTMID, GetTileID(30 + (_x mod 2), VillageTilesY + 6 + (_y mod 2)), _TileX, _TileY);
					}
				}	
				break;

			case TemplateObjGID.Path4:
				for(var _y = 0; _y < ObjTileH; _y++){
					for(var _x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(WaterTMID, GetTileID(32, VillageTilesY + 7), _TileX, _TileY);
					}
				}	
				break;

			case TemplateObjGID.Path5:
				for(var _y = 0; _y < ObjTileH; _y++){
					for(var _x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(WaterTMID, GetTileID(33 + (_x mod 2), VillageTilesY + 4 + (_y mod 2)), _TileX, _TileY);
					}
				}	
				break;

			case TemplateObjGID.Path6:
				for(var _y = 0; _y < ObjTileH; _y++){
					for(var _x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(WaterTMID, GetTileID(32, VillageTilesY + 6), _TileX, _TileY);
					}
				}	
				break;

			case TemplateObjGID.Path7:
				for(var _y = 0; _y < ObjTileH; _y++){
					for(var _x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(WaterTMID, GetTileID(32, VillageTilesY + 8), _TileX, _TileY);
					}
				}	
				break;

			case TemplateObjGID.Path8:
				for(var _y = 0; _y < ObjTileH; _y++){
					for(var _x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(WaterTMID, GetTileID(32, VillageTilesY + 9), _TileX, _TileY);
					}
				}	
				break;

			case TemplateObjGID.Path9:
				for(var _y = 0; _y < ObjTileH; _y++){
					for(var _x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(DecorTMID, GetTileID(30 + (_x mod 2), VillageTilesY + 8), _TileX, _TileY);
					}
				}	
				break;

			case TemplateObjGID.Path10:
				for(var _y = 0; _y < ObjTileH; _y++){
					for(var _x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(DecorTMID, GetTileID(15 + (_x mod 2), VillageTilesY + 4), _TileX, _TileY);
					}
				}	
				break;
				
			case TemplateObjGID.PathTrim:
				for(var _y = 0; _y < ObjTileH; _y++){
					for(var _x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						tilemap_set_at_pixel(WaterTMID, GetTileID(32, VillageTilesY + 4), _TileX, _TileY);
					}
				}	
				break;
			
			case TemplateObjGID.Dirt:
				for(var _y = 0; _y < ObjTileH; _y++){
					for(var _x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						
						if(Prob(0.3)){ //normal dirt
							var Tile = GetTileID(37, VillageTilesY + 2);
							
						}else if(Prob(0.9)){ //other dirt 
							var Tile = choose(GetTileID(37, VillageTilesY + 1), GetTileID(36, VillageTilesY + 2), GetTileID(38, VillageTilesY + 2),  GetTileID(37, VillageTilesY + 3));
							
						}else{ //rocks
							var Tile = choose(GetTileID(35, VillageTilesY), GetTileID(39, VillageTilesY), GetTileID(35, VillageTilesY + 1), GetTileID(39, VillageTilesY + 1));
						}

						tilemap_set_at_pixel(WaterTMID, Tile, _TileX, _TileY);
					}
				}	
				break;
			
			case TemplateObjGID.Dirt_Edge1:
				var Tx = (global.Level.Index == DungeonLevel.Start ? 89 : 36);
				for(var _y = 0; _y < ObjTileH; _y++){
					for(var _x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						
						switch(ObjRot){
							case 0:		var Tile = GetTileID(Tx, VillageTilesY + 1); break;
							case 90:	var Tile = GetTileID(Tx + 2, VillageTilesY + 1); break;
							case -90:	var Tile = GetTileID(Tx, VillageTilesY + 3); break;
							case 180:	var Tile = GetTileID(Tx + 2, VillageTilesY + 3); break;
						}

						tilemap_set_at_pixel(WaterTMID, Tile, _TileX, _TileY);
					}
				}
				break;

			case TemplateObjGID.Dirt_Edge2:
				var Tx = (global.Level.Index == DungeonLevel.Start ? 89 : 36);
				for(var _y = 0; _y < ObjTileH; _y++){
					for(var _x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						
						switch(ObjRot){
							case 0:		var Tile = GetTileID(Tx, VillageTilesY); break;
							case 90:	var Tile = GetTileID(Tx + 2, VillageTilesY); break;
							case -90:	var Tile = GetTileID(Tx, VillageTilesY + 4); break;
							case 180:	var Tile = GetTileID(Tx + 2, VillageTilesY + 4); break;
						}

						tilemap_set_at_pixel(WaterTMID, Tile, _TileX, _TileY);
					}
				}
				break;

			case TemplateObjGID.Dirt_Edge3:
				var Tx = (global.Level.Index == DungeonLevel.Start ? 88: 35);
				for(var _y = 0; _y < ObjTileH; _y++){
					for(var _x = 0; _x < ObjTileW; _x++){
						var _TileX = ObjX + (_x * 8);
						var _TileY = ObjY + (_y * 8);
						
						switch(ObjRot){
							case 0:		var Tile = GetTileID(Tx + 2, VillageTilesY); break;
							case 90:	var Tile = GetTileID(Tx + 4, VillageTilesY + 2); break;
							case -90:	var Tile = GetTileID(Tx, VillageTilesY + 2); break;
							case 180:	var Tile = GetTileID(Tx + 2, VillageTilesY + 4); break;
						}

						tilemap_set_at_pixel(WaterTMID, Tile, _TileX, _TileY);
					}
				}
				break;
			
			case TemplateObjGID.Sand:
				for(var _y = 0; _y < ObjTileH; _y++){
					for(var _x = 0; _x < ObjTileW; _x++){
						var TileX = ObjX + (_x * 8);
						var TileY = ObjY + (_y * 8);
						DrawTileBlock(FloorTMID, TileX, TileY, 42 + ((TileX / 8) mod 2), 40 + ((TileY / 8) mod 2), 1, 1);	
					}
				}
				break;

			case TemplateObjGID.MedallionPlatform:
				DrawTileBlock(WaterTMID, ObjX, ObjY, 44, VillageTilesY + 13, 4, 4);	
				break;


			case TemplateObjGID.Seat:
				DrawTileBlock(FloorTMID, ObjX, ObjY, 50, VillageTilesY + 10, 2, 2);	
				WallObj_Create("ObjsFloor_" + FloorLevelStr, ObjX, ObjY, 2, 2);
				break;
				
		}
		
	}
	

	
}