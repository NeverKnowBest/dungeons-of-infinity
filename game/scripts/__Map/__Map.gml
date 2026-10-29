global.MapInst = noone;

global.MapHidden = false;

global.MapSurface = 0;

#macro MapColor_Clear #001E3C
#macro MapColor_OutOfBounds #003C5A
#macro MapColor_WallsUpper #005582
#macro MapColor_ExtraCeilings #005582

//Room map sprites start as -1. Sprites made with sprite_create_from_surface are "ref" handles,
//while plain numbers can be -1 (no sprite) or 0 from older saves (0 is a real sprite asset, not a map sprite).
function Map_SpriteValid(_Spr){
	if(is_undefined(_Spr)) return false;
	if(is_numeric(_Spr) && _Spr <= 0) return false;
	return sprite_exists(_Spr);
}

function Map_GenerateRoomSprite(_RoomIndex){
	
	if(!global.Level.IsBossLevel && TemplateCheck(_RoomIndex, RoomTemplateClass.Other, RoomTemplateClass_Other.Boss)) exit;

	RoomTemplates_Parse_GenerateObjGrids(_RoomIndex);
	RegionRoom_MapWalls(_RoomIndex);	//a painted room's walls are its solid tiles (roadmap F12b), once it is painted
	
	var RoomSprSurface = surface_create(Room.MapW, Room.MapH);
	var RoomSprSurface_Visited = surface_create(Room.MapW, Room.MapH);

	surface_set_target(RoomSprSurface);
	draw_clear_alpha(#242424, 1.0);
		
	for(var GridY = 2; GridY < Room.MapH - 2; GridY++){
		for(var GridX = 2; GridX < Room.MapW - 2; GridX++){
			if(!Room.TemplateObjGrid.OutOfBounds[GridY][GridX]) 
				draw_sprite_ext(sPixel, 0, GridX, GridY, 1, 1, 0, c_black, 1);
			if(Room.TemplateObjGrid.WallsUpper[GridY][GridX]){
				draw_sprite_ext(sPixel, 0, GridX, GridY, 1, 1, 0, c_dkgrey, 1);
			}
			if(Room.TemplateObjGrid.ExtraCeilings[GridY][GridX]) 
				draw_sprite_ext(sPixel, 0, GridX, GridY, 1, 1, 0, c_dkgrey, 1);

		}			
	}
	
	surface_reset_target(); //flush the drawing before copying the surface, otherwise the sprite can get uninitialized pixels (noise on the map)
	
	if(Map_SpriteValid(Room.MapSpr)) sprite_delete(Room.MapSpr);
	Room.MapSpr = sprite_create_from_surface(RoomSprSurface, 0, 0, Room.MapW, Room.MapH, false, false, 0, 0);
	surface_free(RoomSprSurface);
		
	surface_set_target(RoomSprSurface_Visited);
	draw_clear_alpha(MapColor_Clear, 1);
		
	for(var GridY = 2; GridY < Room.MapH - 2; GridY++){
		for(var GridX = 2; GridX < Room.MapW - 2; GridX++){
			if(!Room.TemplateObjGrid.OutOfBounds[GridY][GridX]) 
				draw_sprite_ext(sPixel, 0, GridX, GridY, 1, 1, 0, MapColor_OutOfBounds, 1);
			if(Room.TemplateObjGrid.WallsUpper[GridY][GridX]){
				draw_sprite_ext(sPixel, 0, GridX, GridY, 1, 1, 0, MapColor_WallsUpper, 1);
			}
			if(Room.TemplateObjGrid.ExtraCeilings[GridY][GridX]) 
				draw_sprite_ext(sPixel, 0, GridX, GridY, 1, 1, 0, MapColor_ExtraCeilings, 1);
		}			
	}
	
	surface_reset_target();
	
	if(Map_SpriteValid(Room.MapSpr_Visited)) sprite_delete(Room.MapSpr_Visited);
	Room.MapSpr_Visited = sprite_create_from_surface(RoomSprSurface_Visited, 0, 0, Room.MapW, Room.MapH, false, false, 0, 0);
	surface_free(RoomSprSurface_Visited);
	
}

//function RoomTemplates_GenerateImageSheet(){
	
//	var RoomW = 64;

//	var RoomGridW = 32;
//	var RoomGridH = 64;
	
//	var ImageW = RoomW * RoomGridW;
//	var ImageH = RoomW * RoomGridH;
	
//	var ImageSheetSurface = surface_create(ImageW, ImageH);
	
//	surface_set_target(ImageSheetSurface);
//	draw_clear_alpha(c_black, 0);
	
//	var PosIndex = 0;
//	//for(var _RoomTemplateClassIndex = 0; _RoomTemplateClassIndex < RoomTemplateClasses; _RoomTemplateClassIndex++){
		
//		for(var RoomTemplateIndex = 0; RoomTemplateIndex < array_length(global.Templates_Room[0][0]); RoomTemplateIndex++){	
		
//			var Template = global.Templates_Room[0][0][RoomTemplateIndex];
		
//			//if(Template[$ "type"] != "SplitRoom") continue;
		
//			var SprPosX = (PosIndex mod RoomGridW) * RoomW;
//			var SprPosY = (PosIndex div RoomGridW) * RoomW;
		
//			draw_sprite(Template.RoomMapSpr, 0, SprPosX, SprPosY);
		
//			PosIndex++;
		
//		}
		
//	//}
	
//	var FullSheetSpr = sprite_create_from_surface(ImageSheetSurface, 0, 0, ImageW, ImageH, false, false, 0, 0);
//	surface_reset_target();
//	surface_free(ImageSheetSurface);
	
//	sprite_save(FullSheetSpr, 0, "C:\\Omnitron\\Zelda\\" + "TemplateSheet.png");
//	sprite_delete(FullSheetSpr);
	
//}

function Map_Init(){

	if(!surface_exists(global.MapSurface)) global.MapSurface = surface_create(256, 256);
	
	surface_set_target(global.MapSurface);
	draw_clear_alpha(c_black, 0.0);
	
	//predraw full unexplored map
	var _Rooms = array_length(global.Level.Rooms);
	
	for(var _RoomIndex = 0; _RoomIndex < _Rooms; _RoomIndex++){

		var _House = TemplateCheck(_RoomIndex, RoomTemplateClass.Village, RoomTemplateClass_Village.House) || TemplateCheck(_RoomIndex, RoomTemplateClass.Mines, RoomTemplateClass_Mines.House);
		var _BossRoom = !global.Level.IsBossLevel && TemplateCheck(_RoomIndex, RoomTemplateClass.Other, RoomTemplateClass_Other.Boss);
		var _MineCave = LevelDef.Special == LevelSpecial.Mines && (Room.GridY >= 5 || (Room.GridY == 4 && Room.GridX != 4 && Room.GridX != 5));
		var _MineMapRoom = LevelDef.Special == LevelSpecial.Mines && Room.GridX == 5 && Room.GridY == 1;
		if(Room.Secret != -1 || _House || _BossRoom || _MineCave || _MineMapRoom){
			continue; //if it's a secret or house Room, don't draw it
		}		
		
		if(Map_SpriteValid(Room.MapSpr)) draw_sprite(Room.MapSpr, 0, Room.MapX, Room.MapY); 
		
	}
	
	surface_reset_target();
	if(sprite_exists(global.Level.Map_Sprite_All)) sprite_delete(global.Level.Map_Sprite_All);
	global.Level.Map_Sprite_All = sprite_create_from_surface(global.MapSurface, 0, 0, 256, 256, false, false, 0, 0);


	//predraw full door map

	surface_set_target(global.MapSurface);
	draw_clear_alpha(c_black, 0.0);

	for(var _RoomIndex = 0; _RoomIndex < _Rooms; _RoomIndex++){

		var _House = TemplateCheck(_RoomIndex, RoomTemplateClass.Village, RoomTemplateClass_Village.House) || TemplateCheck(_RoomIndex, RoomTemplateClass.Mines, RoomTemplateClass_Mines.House);
		var _BossRoom = !global.Level.IsBossLevel && TemplateCheck(_RoomIndex, RoomTemplateClass.Other, RoomTemplateClass_Other.Boss);
		
		if(_House || _BossRoom) continue;	

		if(Map_SpriteValid(Room.MapSpr_Doors))
			draw_sprite(Room.MapSpr_Doors, 0, Room.MapX, Room.MapY); 
		//if(sprite_exists(global.MapSpriteGrid_DoorsSecret[# _x, _y])) draw_sprite(global.MapSpriteGrid_DoorsSecret[# _x, _y], 0, Room.MapX, Room.MapY); 
		
	}
	
	surface_reset_target();
	if(sprite_exists(global.Level.Map_Sprite_Doors_All)) sprite_delete(global.Level.Map_Sprite_Doors_All);
	global.Level.Map_Sprite_Doors_All = sprite_create_from_surface(global.MapSurface, 0, 0, 256, 256, false, false, 0, 0);
	
}

function Map_UpdateExploredRooms(){

	if(!surface_exists(global.MapSurface)) global.MapSurface = surface_create(256, 256);
	
	surface_set_target(global.MapSurface);
	draw_clear_alpha(c_black, 0.0);
	
	global.Level.RoomsVisted = 0;
	
	for(var _RoomIndex = 0; _RoomIndex < global.Level.RoomCount; _RoomIndex++){
		
		//draw all explored Rooms on surface

		if(!Room.Visited) continue;
		if(LevelDef.Special != LevelSpecial.Intro){	
			if(TemplateCheck(_RoomIndex, RoomTemplateClass.Village, RoomTemplateClass_Village.House) || TemplateCheck(_RoomIndex, RoomTemplateClass.Mines, RoomTemplateClass_Mines.House)) continue;
		}
			
		if(Map_SpriteValid(Room.MapSpr_Visited)) draw_sprite(Room.MapSpr_Visited, 0, Room.MapX, Room.MapY); 
		
		global.Level.RoomsVisted++;	
		
	}
	
	global.Level.RoomsVistedPercent = global.Level.RoomsVisted / global.Level.RoomCount;
	
	surface_reset_target();
	if(sprite_exists(global.Level.Map_Sprite_Explored)) sprite_delete(global.Level.Map_Sprite_Explored);
	global.Level.Map_Sprite_Explored = sprite_create_from_surface(global.MapSurface, 0, 0, 256, 256, false, false, 0, 0);
	

	//Doors Explored
	
	surface_set_target(global.MapSurface);
	draw_clear_alpha(c_black, 0.0);

	//draw all explored Rooms on surface
	for(var _RoomIndex = 0; _RoomIndex < global.Level.RoomCount; _RoomIndex++){
		
		if(!Room.Visited) continue;

		if(Map_SpriteValid(Room.MapSpr_Doors)) draw_sprite(Room.MapSpr_Doors, 0, Room.MapX, Room.MapY); 

	}
	
	surface_reset_target();
	if(sprite_exists(global.Level.Map_Sprite_Doors_Explored)) sprite_delete(global.Level.Map_Sprite_Doors_Explored);
	global.Level.Map_Sprite_Doors_Explored = sprite_create_from_surface(global.MapSurface, 0, 0, 256, 256, false, false, 0, 0);
	
}

function Map_Clear(){
	
	if(is_struct(global.Level)){
		
		if(sprite_exists(global.Level.Map_Sprite_All)) sprite_delete(global.Level.Map_Sprite_All);
		if(sprite_exists(global.Level.Map_Sprite_Explored)) sprite_delete(global.Level.Map_Sprite_Explored);
		if(sprite_exists(global.Level.Map_Sprite_Doors_All)) sprite_delete(global.Level.Map_Sprite_Doors_All);
		if(sprite_exists(global.Level.Map_Sprite_Doors_Explored)) sprite_delete(global.Level.Map_Sprite_Doors_Explored);
		
		for(var _RoomIndex = 0; _RoomIndex < global.Level.RoomCount; _RoomIndex++){
			if(Map_SpriteValid(Room.MapSpr)) sprite_delete(Room.MapSpr);
			if(Map_SpriteValid(Room.MapSpr_Visited)) sprite_delete(Room.MapSpr_Visited);
			if(Map_SpriteValid(Room.MapSpr_Doors)) sprite_delete(Room.MapSpr_Doors);
		}
		
	}

	ds_list_clear(global.LargeMapItems);
	
}

/// @description Checks whether the Pendant of Direction is active. The pendant reveals the whole map, but does not work in the starting area because its map was not designed to be revealed and the pendant is normally unobtainable there.
/// @returns {Bool} Whether the Pendant of Direction is owned and the current level is not the starting area.
function Map_DirectionPendantActive(){
	return Pendant_Check(Pendant.Direction) && LevelDef.Special != LevelSpecial.Intro;
}

function Map_GetCoordinate_Small(i){
	//translates a real-world coordinate (x or y) to the relative small map coordinate
	return round(i / 32);
}
