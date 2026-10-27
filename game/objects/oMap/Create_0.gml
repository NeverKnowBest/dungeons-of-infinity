depth = -1000;

Alpha = 0;
AlphaSpeed = 0.18;

Open = true;
Close = false;

FrameX = oCamera.X + 26;
FrameY = oCamera.Y + 10;
MapX = FrameX + 6;
MapY = FrameY + 6;

LinkAlpha = 0;

global.Paused = true;

audio_play_sound(Sound_Map, 1, false);

if(!surface_exists(global.MapSurface)) global.MapSurface = surface_create(256, 256);
	
surface_set_target(global.MapSurface);
draw_clear_alpha(c_black, 0.0);

var _DirectionPendant = Map_DirectionPendantActive();
var _MapOwned = global.Inventory.ItemData[ItemClass.Map].Owns[0] || _DirectionPendant || oLink.StandingOnMap;
var _CompassOwned = global.Inventory.ItemData[ItemClass.Compass].Owns[0] || _DirectionPendant || oLink.StandingOnCompass;

if(_MapOwned) draw_sprite(global.Level.Map_Sprite_All, 0, 0, 0);
draw_sprite(global.Level.Map_Sprite_Explored, 0, 0, 0);

if(_CompassOwned){
	draw_sprite(global.Level.Map_Sprite_Doors_Explored, 0, 0, 0);	

	if(_MapOwned) draw_sprite(global.Level.Map_Sprite_Doors_All, 0, 0, 0);
}


//icons
var _PosX, _PosY;
if(_CompassOwned){

	if(global.Level.IsBossLevel){
		var _x = (global.Level.DungeonTemplate.Rooms[global.Level.RoomIndex_Boss].x / 8) + 9;
		var _y = (global.Level.DungeonTemplate.Rooms[global.Level.RoomIndex_Boss].y / 8) + 8;
		draw_sprite(sLargeMap_Boss, 0, _x, _y);
	}
			
	for(var i = 0; i < ds_list_size(global.LargeMapItems); i++){
			
		var inst = global.LargeMapItems[| i];
		//if(inst == noone) continue;
		
		if(global.Level.Rooms[inst.RoomIndex].Secret != -1 && !global.Level.Rooms[inst.RoomIndex].Visited) continue;

		var _x = round(inst.x / 8);
		var _y = round(inst.y / 8);
			
		switch(inst.object_index){
				
			case oCrystalSwitch:
				draw_sprite(sLargeMap_Crystal, global.Level.SwitchBlock_ActiveColor, _x, _y + 4);
				break;
				
			case oDoor:
				switch(inst.Location){
					case "Top":
					case "Bottom":
						_x += 2;
						break;
					case "Left":
					case "Right":
						_x += 1;
						_y += 1;
						break;
				}	
					
				switch(inst.Status){
					case DoorStatus.Locked:
						draw_sprite(sLargeMap_LockedDoor, 0, _x, _y + 1);
						break;
						
					case DoorStatus.Exit:
						draw_sprite(sLargeMap_Down, 0, _x, _y + 1);
						break;
				}
				break;
			
			case oKeyBlock:
				draw_sprite(sLargeMap_LockedDoor, 0, _x + 1, _y);
				break;
				
			case oShop:
				draw_sprite(sLargeMap_Shop, 0, _x + (inst.TileW / 2) - 1, _y + (inst.TileH / 2) - 1);	
				break;
			
			case oItem_Kinstone_Main:
				draw_sprite(sLargeMap_Kinstone, inst.Index, _x, _y + 4);					
				break;

			case oRodCharger:
				if(LevelDef.Special == LevelSpecial.Village){
					//if village, draw rod charger where it would be in the world, not in the room which is off view
					var _RoomIndex = global.Level.Map_RoomIndex[2][3];
					_PosX = global.Level.Rooms[_RoomIndex].MapX + 33;
					_PosY = global.Level.Rooms[_RoomIndex].MapY + 37;
					draw_sprite(sLargeMap_RodCharger, 0, _PosX, _PosY + 4);
				}else{
					draw_sprite(sLargeMap_RodCharger, 0, _x, _y);					
				}
				break;

			case oFairy_Health:
			case oItem_Fairy:
				_PosX = global.Level.Rooms[inst.RoomIndex].MapX + 7;
				_PosY = global.Level.Rooms[inst.RoomIndex].MapY + 7;
				draw_sprite(sLargeMap_Fairy, 0, _PosX, _PosY);
				break;
			
			case oGemPondWater:
				_PosX = global.Level.Rooms[inst.RoomIndex].MapX + 8;
				_PosY = global.Level.Rooms[inst.RoomIndex].MapY + 8;
				draw_sprite(sLargeMap_GemPond, 0, _PosX, _PosY);	
				break;
				
			case oWarp:
				draw_sprite(sLargeMap_Warp, 0, _x - 3, _y - 3);
				break;
				
		}

	}
}

MapSprite = sprite_create_from_surface(global.MapSurface, 0, 0, 256, 256, false, false, 0, 0);

draw_clear_alpha(c_black, 0.0);
draw_sprite(global.LinkSpr_MapIcon, 0, (oLink.House_Inside ? oLink.House_OldX : oLink.x) / 8, ((oLink.House_Inside ? oLink.House_OldY : oLink.y) / 8) + 12);
LinkSprite = sprite_create_from_surface(global.MapSurface, 0, 0, 256, 256, false, false, 0, 0);

surface_reset_target();