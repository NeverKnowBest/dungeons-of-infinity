


var _ShieldSpr, _ShieldX, _ShieldY, SwordSprite;
if(global.MosaicDo){
	
	if(!surface_exists(Mosaic_ScreenBuffer)) Mosaic_ScreenBuffer = surface_create(1024, 896);
	
	surface_set_target(Mosaic_ScreenBuffer);
	
		draw_clear_alpha(c_black, 0);
		
		shader_set(shd_mosaic);
			shader_set_uniform_f(uMosaic_Size, Mosaic_Size);
			shader_set_uniform_f(uMosaic_Brightness, Mosaic_Warp ? 1.0 - (Mosaic_SizeIndex / (Mosaic_SizeCount - 1)) : 1.0);
			
			gpu_set_blendenable(false);
			draw_surface_part(application_surface, 289, 0, 1023, 896, 0, 0);
			gpu_set_blendenable(true);
			
		shader_reset();
	
		with(oLink){
		
			var _x = ((x - oCamera.X) * 4);
			var _y = ((y - oCamera.Y) * 4);
		
			draw_sprite_ext(sShadow_Large, 0, _x, _y, 4, 4, 0, c_white, 1);
			
			if(Cape) break;
			
			var _image_index = floor(image_index);
			
			var _TunicIndex = max(global.Inventory.ItemData[ItemClass.Tunic].Index, 0);
			if(other.Mosaic_Type == MosaicType.Shock && ShockDrawSword){ //Sword Shock
				SwordSprite = asset_get_index("sSword" + string(global.Inventory.ItemData[ItemClass.Sword].Index) + "_Shock");
				//sword (draw sword before drawing link only for UP
				if(Facing == UP) draw_sprite_ext(SwordSprite, _image_index, _x, _y - 64, 4, 4, 0, c_white, 1);
				PixelRender(false, false, PaletteSpr != noone, PaletteSpr, _TunicIndex, image_index > 1, KB_In);
			}else if(global.Cursed){
				PixelRender(false, false, PaletteSpr != noone, PaletteSpr,_TunicIndex, true, KB_Gr);			
			}else{
				PixelRender(false, false, PaletteSpr != noone, PaletteSpr, _TunicIndex, false, []);
			
			}		
			
			var _DrawShield = (global.Inventory.ItemData[ItemClass.Shield].Index >= 0 && ItemHolding == noone);
			
			if(_DrawShield){
				ShieldDir = Facing;
				_ShieldSpr = ShieldSprite[global.Inventory.ItemData[ItemClass.Shield].Index][ShieldDir];
				_ShieldX = _x + (ShieldOffsetX[LinkState.Standing][Facing][0] * 4);
				_ShieldY = _y + (ShieldOffsetY[LinkState.Standing][Facing][0] * 4);
			
				if(ShieldDir == UP && other.Mosaic_Type == MosaicType.Warp){
					draw_sprite_ext(_ShieldSpr, 0, _ShieldX, _ShieldY, 4, 4, 0, c_white, 1);
				}
			}
			
			draw_sprite_ext(sprite_index, image_index, _x, _y, 4, 4, 0, c_white, 1);
			
			if(_DrawShield){
				if(ShieldDir != UP && other.Mosaic_Type == MosaicType.Warp){
					draw_sprite_ext(_ShieldSpr, 0, _ShieldX, _ShieldY, 4, 4, 0, c_white, 1);
				}
			}
			
			if(ItemHolding != noone){
				var _PosX = ((ItemHolding.x - oCamera.X) * 4);
				var _PosY = ((ItemHolding.y - oCamera.Y) * 4);
				draw_sprite_ext(ItemHolding.sprite_index, ItemHolding.Index, _PosX, _PosY, 4, 4, 0, c_white, 1);				
			}
			
			with(oPoof_NoSound){
				var _PoofX = ((x - oCamera.X) * 4);
				var _PoofY = ((y - oCamera.Y) * 4);
				draw_sprite_ext(sprite_index, image_index, _PoofX, _PoofY, 4, 4, 0, c_white, 1);			
			}
			shader_reset();
		
			if(other.Mosaic_Type == MosaicType.Shock && ShockDrawSword){ //Sword Shock
		
				switch(Facing){
					case LEFT:
						draw_sprite_ext(SwordSprite, _image_index, _x - 32, _y - 20, 4, 4, 90, c_white, 1);
						break;
					case RIGHT:
						draw_sprite_ext(SwordSprite, _image_index, _x + 32, _y - 20, 4, -4, 90, c_white, 1);
						break;
					case DOWN:
						draw_sprite_ext(SwordSprite, _image_index, _x, _y + 8, 4, -4, 0, c_white, 1);
						break;
				}
			}

		}
	
	surface_reset_target();	
	
	surface_set_target(application_surface);
		
		gpu_set_blendenable(false);
		draw_surface(Mosaic_ScreenBuffer, 288, 0);
		gpu_set_blendenable(true);
		
	surface_reset_target();	
	
}


if(HeatDo){
	
	if(!surface_exists(Mosaic_ScreenBuffer)) Mosaic_ScreenBuffer = surface_create(1024, 896);
	
	surface_set_target(Mosaic_ScreenBuffer);
	
	draw_clear_alpha(c_black, 0);
		
	draw_surface_part(application_surface, 289, 0, 1023, 896, 0, 0);
		
	shader_set(shd_mosaic);
		shader_set_uniform_f(uMosaic_Size, HeatIndex);			
		gpu_set_blendenable(false);
		draw_surface_part(application_surface, 289, 0, 1023, 896, 0, 0);	
		gpu_set_blendenable(true);			
	shader_reset();

	
	surface_reset_target();	
	
	surface_set_target(application_surface);
		
		gpu_set_blendenable(false);
		draw_surface(Mosaic_ScreenBuffer, 288, 0);
		gpu_set_blendenable(true);
		
	surface_reset_target();		
	
}

if(global.RoomFadeBlackOut || global.FadeIn || global.FadeOut){
	
	if(!surface_exists(global.RoomFadeSurface)) global.RoomFadeSurface = surface_create(256, 224);
	
	draw_set_color(c_black);
	
	surface_set_target(global.RoomFadeSurface);
	
		draw_rectangle(0, 0, 256, 224, false);
		
		if(!global.RoomFadeBlackOut){
			gpu_set_blendmode(bm_subtract);
			
			if(global.FadeRadius > 0){
				var CentreX = oLink.x - oCamera.X - 1; 
				var CentreY = oLink.y - oCamera.Y - 8; 
				draw_ellipse(CentreX - global.FadeRadius, CentreY - (global.FadeRadius * 0.5), CentreX + global.FadeRadius, CentreY + (global.FadeRadius * 0.5), false);
			}

			gpu_set_blendmode(bm_normal);
		}
		
	surface_reset_target();	
			
	surface_set_target(application_surface);
		draw_surface_ext(global.RoomFadeSurface, 288, 0, 4, 4, 0, c_white, 1);
	surface_reset_target();	
		
}

if(oCamera.ShakeAmount != 0){
	//hide the 1 pixel border showing from the other rooms surrounding while the camera is shaking
	surface_set_target(application_surface);
		draw_set_color(#000000);
		var _x1 = 288;
		var _y1 = 0;
		var _w = 1024;
		var _h = 896;
		var _x2 = _x1 + _w - 1;
		var _y2 = _y1 + _h - 1;
		draw_rectangle(_x1, _y1, _x2, _y2, true);
		draw_rectangle(_x1 + 1, _y1 + 1, _x2 - 1, _y2 - 1, true);
		draw_rectangle(_x1 + 2, _y1 + 2, _x2 - 2, _y2 - 2, true);
		draw_rectangle(_x1 + 3, _y1 + 3, _x2 - 3, _y2 - 3, true);
		draw_set_color(#FFFFFF);
	surface_reset_target();	
}

if(global.Users[global.UserIndex].Prefs[Pref.CRT]){
	CRT_Do(application_surface, 0, 0, CRT_Sizes, false, 0.04, false, 0.03, 80.0, true, false, true, 0.04);
}else{
	draw_surface(application_surface, 0, 0);
}


//Render arcade screen
if(global.ArcadeVP_Show){
	//Dim the Room
	draw_set_color(c_black);
	draw_set_alpha(0.5);
	draw_rectangle(View1X, 0, View1X2, View1Y2, false);
	draw_set_color(c_white);
	draw_set_alpha(1.0);
	CRT_Do_Stretch(global.ArcadeVP_Surface, global.ArcadeVP_RenderX, global.ArcadeVP_RenderY, global.ArcadeVP_RenderW, global.ArcadeVP_RenderH, global.ArcadeVP_Sizes, true, 0.2, true, 0.025, 80.0, true, true, true, 0.04);
}



if(DEBUG){

	if(Stats){
	
		draw_set_color(c_dkgray);
		draw_set_alpha(1);
		draw_rectangle(0,0,288,1120,false);
	
		draw_set_color(c_white);
		draw_set_font(Font1);
		draw_set_halign(fa_left);
	
		var _y = 5;
		draw_text(5, _y, "FPS: " + string(round(FPS_Real))); _y+=15;
		//draw_text(5, _y, "MouseX: " + string(mouse_x)); _y+=15;
		//draw_text(5, _y, "MouseY: " + string(mouse_y)); _y+=15;
		draw_text(5, _y, "Paused: " + string(global.Paused)); _y+=15;
		//draw_text(5, _y, "Mosaic Size: " + string(Mosaic_Size)); _y+=15;

	
		draw_text(10, _y, "Dungeon Index: " + string(global.Level.DungeonTemplate_Index)); _y+=15;
		draw_text(10, _y, "Dungeon Depth: " + string(global.Level.Index)); _y+=15;
		draw_text(10, _y, "DungeonGrid: " + string(oCamera.DungeonGridX) + "," +string(oCamera.DungeonGridY)); _y+=15;
		
		draw_text(10, _y, "Room Index: " + string(global.Level.Map_RoomIndex[oCamera.DungeonGridY][oCamera.DungeonGridX])); _y+=15;
		draw_text(10, _y, "Room Template: " + string(global.CurrentRoom.Template)); _y+=15;
		draw_text(10, _y, "Room X: " + string(global.CurrentRoom.x)); _y+=15;
		draw_text(10, _y, "Room Y: " + string(global.CurrentRoom.y)); _y+=15;
		draw_text(10, _y, "Room W: " + string(global.CurrentRoom.width)); _y+=15;
		draw_text(10, _y, "Room H: " + string(global.CurrentRoom.height)); _y+=15;
		draw_text(10, _y, "Rooms Visited: " + string(global.Level.RoomsVisted)); _y+=15;
		draw_text(10, _y, "Rooms Visited %: " + string(global.Level.RoomsVistedPercent)); _y+=15;
		
		draw_text(10, _y, "Cam Trans: " + string(oCamera.RoomTransition)); _y+=15;
		draw_text(10, _y, "Cam TransInit: " + string(oCamera.RoomTransitionInit)); _y+=15;
		draw_text(10, _y, "Cam X: " + string(oCamera.X)); _y+=15;
		draw_text(10, _y, "Cam Y: " + string(oCamera.Y)); _y+=15;
		draw_text(10, _y, "Cam End X: " + string(oCamera.TransitionEndX)); _y+=15;
		draw_text(10, _y, "Cam End Y: " + string(oCamera.TransitionEndY)); _y+=15;
		draw_text(10, _y, "Cur Room Ind: " + string(global.CurrentRoomIndex)); _y+=15;
		draw_text(10, _y, "Trn Room Ind: " + string(global.TransitionRoomIndex)); _y+=15;
		draw_text(10, _y, "Instances: " + string(instance_count)); _y+=15;
		draw_text(10, _y, "Swordless: " + string(global.Swordless)); _y+=15;
		draw_text(10, _y, "BonusItem: " + string(global.StartingGear)); _y+=15;
		
		
		//draw_text(10, _y, "Timing: " + string(display_get_timing_method())); _y+=15;
		//draw_text(10, _y, "Timing Sleep: " + string(tm_sleep)); _y+=15;
		//draw_text(10, _y, "Timing VSync: " + string(tm_countvsyncs)); _y+=15;
		//draw_text(10, _y, "Final Boss: " + string(global.FinalBoss)); _y+=15;
		
		//with(oCape){
		//	draw_text(10, _y, "Cape drain alarm: " + string(alarm[0])); _y+=15;
		//}
		//with(oBoss_Armos_C){
		//	draw_text(10, _y, "ArmosLeft: " + string(ArmosLeft)); _y+=15;
		//}
		//draw_text(10, _y, "oTitle: " + string(instance_exists(oTitle))); _y+=15;
		//draw_text(10, _y, "oKing: " + string(instance_exists(oVillager_King))); _y+=15;
		
		//draw_text(10, _y, "Max Atk: " + string(MaxAttackPointsThatExist())); _y+=15;
		//draw_text(10, _y, "Max Def: " + string(MaxDefensePointsThatExist())); _y+=15;
		//draw_text(10, _y, "Bag Index: " + string(global.Inventory.ItemData[ItemClass.Bag].Index)); _y+=15;
		
		//draw_text(10, _y, "Wall Instances: " + string(instance_number(oWall))); _y+=15;
		//draw_text(10, _y, "Slot Index Equiped: " + string(global.Inventory_SlotIndex_Equiped)); _y+=15;
		//draw_text(10, _y, "Open Transition: " + string(oCamera.OpenTransition)); _y+=15;
		
		
		
		_y+=15;
		draw_text(10, _y, "Link Health: " + string(LinkHealth) ); _y+=15;
		draw_text(10, _y, "Link State: " + GetStateName(oLink.State) ); _y+=15;
		draw_text(10, _y, "Link X/Y: " + string(oLink.x) + "," + string(oLink.y) ); _y+=15;
		draw_text(10, _y, "Link VX: " + string(oLink.vx)); _y+=15;
		draw_text(10, _y, "Link VY: " + string(oLink.vy)); _y+=15;
		draw_text(10, _y, "Link Invincible: " + string(oLink.Invincible) ); _y+=15;
		draw_text(10, _y, "Link Floor: " + string(oLink.FloorLevel)); _y+=15;
		draw_text(10, _y, "Link Layer: " + string(oLink.layer)); _y+=15;
		draw_text(10, _y, "Link Item Holding: " + string(oLink.ItemHolding)); _y+=15;
		//draw_text(10, _y, "Link Invincible: " + string(oLink.Invincible)); _y+=15;
		//draw_text(10, _y, "Link Sword Charge: " + string(oLink.SwordSpin_Charge)); _y+=15;
		//draw_text(10, _y, "Link image_index: " + string(oLink.image_index)); _y+=15;
		//draw_text(10, _y, "Link image_speed: " + string(oLink.image_speed)); _y+=15;
		//draw_text(10, _y, "Slot Selected: " + string(global.Inventory_SlotIndex_Selected)); _y+=15;
		draw_text(10, _y, "Link InDoor: " + string(oLink.InDoor)); _y+=15;
		draw_text(10, _y, "Link InDoor_Full: " + string(oLink.InDoor_Full)); _y+=15;
		draw_text(10, _y, "Link InDoor_Facing: " + string(oLink.InDoor_Facing)); _y+=15;
		draw_text(10, _y, "Link oHouseDoor: " + string(oLink.InDoor_House)); _y+=15;
		draw_text(10, _y, "Link InDoor_Aligned: " + string(oLink.InDoor_Aligned)); _y+=15;
		
		draw_text(10, _y, "Link Sword Charge: " + string(oLink.SwordCharge)); _y+=15;
		draw_text(10, _y, "Link Sword Charge Allowed: " + string(oLink.SwordChargeAllowed)); _y+=15;
		draw_text(10, _y, "Link Depth: " + string(oLink.depth)); _y+=15;
		with(oSword){
			draw_text(10, _y, "Sword Depth: " + string(depth)); _y+=15;
		}
		
		//draw_text(10, _y, "Link BB_L: " + string(oLink.bbox_left)); _y+=15;
		//draw_text(10, _y, "Link BB_T: " + string(oLink.bbox_top)); _y+=15;
		//draw_text(10, _y, "Link BB_R: " + string(oLink.bbox_right)); _y+=15;
		//draw_text(10, _y, "Link BB_B: " + string(oLink.bbox_bottom)); _y+=15;
		//draw_text(10, _y, "Link BounceBack: " + string(oLink.BounceBack)); _y+=15;
		//draw_text(10, _y, "Bombbag: " + string(global.Inventory.ItemData[ItemClass.BombBag].Owns[0])); _y+=15;
		//draw_text(10, _y, "Link LampDim: " + string(oLink.LampDim)); _y+=15;
		//draw_text(10, _y, "Link keyUp: " + string(oLink.keyUp)); _y+=15;
		//draw_text(10, _y, "Link keyDown: " + string(oLink.keyDown)); _y+=15;
		//draw_text(10, _y, "Link keyLeft: " + string(oLink.keyLeft)); _y+=15;
		//draw_text(10, _y, "Link keyRight: " + string(oLink.keyRight)); _y+=15;
		//draw_text(10, _y, "Link Action KeyUp: " + string(oLink.Action[ActionKey.Up])); _y+=15;
		//draw_text(10, _y, "Link Action KeyDown: " + string(oLink.Action[ActionKey.Down])); _y+=15;
		//draw_text(10, _y, "Link Action KeyLeft: " + string(oLink.Action[ActionKey.Left])); _y+=15;
		//draw_text(10, _y, "Link Action KeyRight: " + string(oLink.Action[ActionKey.Right])); _y+=15;
		//draw_text(10, _y, "Link MoveAssist: " + string(oLink.MoveAssist)); _y+=15;
		//draw_text(10, _y, "Link MoveAssistDir: " + string(oLink.MoveAssistDir)); _y+=15;
		//draw_text(10, _y, "Link AutoMoveFrames: " + string(oLink.AutoMoveFrames)); _y+=15;
		//draw_text(10, _y, "Attack " + string(oLink.AttackPoints)); _y+=15;
		//draw_text(10, _y, "Defense " + string(oLink.DefensePoints)); _y+=15;
		//draw_text(10, _y, "Sword Index: " + string(global.Inventory.ItemData[ItemClass.Sword].Index)); _y+=15;
		//draw_text(10, _y, "Arrow Quiver: " + string(global.Inventory.ItemData[ItemClass.ArrowQuiver].Owns[0])); _y+=15;
		//draw_text(10, _y, "Bomb Bag: " + string(global.Inventory.ItemData[ItemClass.BombBag].Owns[0])); _y+=15;
		//draw_text(10, _y, "Link KGreen: " + string(oLink.Kinstones[KinstoneColor.Green])); _y+=15;
		//draw_text(10, _y, "Link KBlue: " + string(oLink.Kinstones[KinstoneColor.Blue])); _y+=15;
		//draw_text(10, _y, "Link KRed: " + string(oLink.Kinstones[KinstoneColor.Red])); _y+=15;
		//draw_text(10, _y, "Link KGold: " + string(oLink.Kinstones[KinstoneColor.Gold])); _y+=15;

		_y+=15;

		//with(oMusic){
		//	draw_text(10, _y, "State: " + string(State)); _y+=15;
		//	draw_text(10, _y, "Mute: " + string(Mute)); _y+=15;
		//	draw_text(10, _y, "Playing Index: " + string(SongPlaying_Index)); _y+=15;
		//	draw_text(10, _y, "Playing Inst: " + string(SongPlaying_Inst)); _y+=15;
		//	draw_text(10, _y, "Playing Intro: " + string(SongPlaying_Intro)); _y+=15;
		//	draw_text(10, _y, "Playing Gain: " + string(SongPlaying_Gain)); _y+=15;
		//	draw_text(10, _y, "SongIndexAssets.Intro: " + string(SongIndexAssets.Intro)); _y+=15;
		//	draw_text(10, _y, "SongIndexAssets.Main: " + string(SongIndexAssets.Main)); _y+=15;
		//	draw_text(10, _y, "Fade: " + string(Fade)); _y+=15;
		//	draw_text(10, _y, "Fade Next Song Index: " + string(Fade_NextSongIndex)); _y+=15;
		//}

		//with(oEnemy){
			draw_text(10, _y, "Enemies: " + string(instance_number(oEnemy))); _y+=15;
		
		//}
		
		//draw_text(10, _y, "Ice Towers: " + string(instance_number(oIceTower))); _y+=15;
		//draw_text(10, _y, "Input X: " + string(input_x("left", "right", "up", "down"))); _y+=15;
		//draw_text(10, _y, "Input Y: " + string(input_y("left", "right", "up", "down"))); _y+=15;

		//draw_text(10, _y, "CheckPendentSecret: " + string(oHUD.CheckPendentSecret)); _y+=15;
		//draw_text(10, _y, "RoomIsSecret: " + string(global.Level.Rooms[global.CurrentRoomIndex].Secret)); _y+=15;
		//draw_text(10, _y, "global.Continue " + string(global.Continue)); _y+=15;
		//draw_text(10, _y, "Curse Task " + string(global.CurseTask)); _y+=15;
		//draw_text(10, _y, "Curse Task Count " + string(global.CurseTaskCount)); _y+=15;
		
		
		
		//_y+=15;
		//draw_text(10, _y, "LinkLightXY: " + string(global.Lighting.LinkLight.Pos[0]) + "," + string(global.Lighting.LinkLight.Pos[1])); _y+=15;
		//draw_text(10, _y, "LinkLightRad: " + string(global.Lighting.LinkLight.Pos[2])); _y+=15;
		//draw_text(10, _y, "LinkLightRGB: " + string(global.Lighting.LinkLight.RGB[0])+"-"+string(global.Lighting.LinkLight.RGB[1]) + "-" + string(global.Lighting.LinkLight.RGB[2])); _y+=15;
		//draw_text(10, _y, "LinkLightSta: " + string(global.Lighting.LinkLight.Status)); _y+=15;
		
		//_y+=15;
		//if(global.Lighting.LightArray_Count > 0){
		//	draw_text(10, _y, "LightArray0_XY: " + string(global.Lighting.LightArray_Pos[0]) + "," + string(global.Lighting.LightArray_Pos[1])); _y+=15;
		//	draw_text(10, _y, "LightArray0_RGB: " + string(global.Lighting.LightArray_RGB[0])+"-"+string(global.Lighting.LightArray_RGB[1]) + "-" + string(global.Lighting.LightArray_RGB[2])); _y+=15;
		//}
		//_y+=15;
	
		
		//var WallInst = instance_position(mouse_x, mouse_y, oWall);
		//if(WallInst != noone){
		//	draw_text(10, _y, "Wall BlockLink: " + string(WallInst.BlockLink)); _y+=15;
		//}
		//var DoorInst = instance_position(mouse_x, mouse_y, oDoor);
		//if(DoorInst != noone){
		//	draw_text(10, _y, "Door Status: " + string(DoorInst.Status)); _y+=15;
		//}
		//with(oBoss_Armos_C){
		//	//for(var i = 0; i < 6; i++){
		//	//	draw_text(10, _y, "A" + string(i) + " Status: " + string(ArmosStatus[i]) ); _y+=15;	
		//	//}
		//	draw_text(10, _y, "State:" + string(State) ); _y+=15;	
		//	draw_text(10, _y, "z:" + string(z) ); _y+=15;	
		//	draw_text(10, _y, "vz:" + string(vz) ); _y+=15;	
		//	if(instance_exists(LastArmos_Inst)){
		//		draw_text(10, _y, "LA_State:" + string(LastArmos_Inst.State) ); _y+=15;	
		//		draw_text(10, _y, "LA_Jump:" + string(LastArmos_Jump) ); _y+=15;	
		//		draw_text(10, _y, "LA_Stomp:" + string(LastArmos_Stomp) ); _y+=15;	
		//	}
		//}

		//for(var i = 0; i < global.ItemObjIndexes; i++){
		//	var ObjIndex = global.ItemObjIndexList[| i];
		//	draw_text(10, _y, string(i) + ": Limit Min: " + string(global.ItemData[ObjIndex].LimitMin) + ", Limit Count: " + string(global.ItemData[ObjIndex].LimitCount)); _y+=15;
		//}

		//_y+=25;



	}


}

if (global.CheatsEnabled) {
	draw_set_alpha(0.07);
	draw_set_colour(c_black);
	draw_rectangle(floor(CheatWatermarkX), floor(CheatWatermarkY), floor(CheatWatermarkX + CheatWatermarkSize), floor(CheatWatermarkY + CheatWatermarkSize), false);
}

