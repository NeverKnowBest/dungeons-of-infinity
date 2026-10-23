

AltTabCheck();


if(input_check_pressed("hud")){
	global.Users[global.UserIndex].Prefs[Pref.HUD] = !global.Users[global.UserIndex].Prefs[Pref.HUD];
	User_Save();
}


var NormalLinkState = !global.ArcadeVP_Show && (oLink.State == LinkState.Standing || oLink.State == LinkState.Walking || oLink.State == LinkState.Inventory) && !global.LinkDead && oLink.State != LinkState.Dead && !global.DisableMenus;


if(NormalLinkState){// && !global.FinalBoss){
	
	if(input_check_pressed("inventory") && !input_check("action")){
		if(!instance_exists(oDialogueBox) && global.DB_Inst == noone){
			if(!instance_exists(oMap) && !instance_exists(oMenu_Game) && oCamera.RoomTransition == NONE){
				if(instance_exists(oInventory)){
					if(global.Inventory.Bags[InventoryBag.Main].Status == InventoryBagStatus.Open){
						global.Inventory.Bags[InventoryBag.Main].Status = InventoryBagStatus.Closing;
						if(!audio_is_playing(Sound_Throw)) audio_play_sound(Sound_Throw, 1, false);
					}
				}else{
					global.InventoryInst = instance_create_layer(0, 0, layer, oInventory);
					with(oLink) UpdateState(LinkState.Inventory);				
				}
			}

		}
	}
	

	if(input_check_pressed("map")){
		if(!instance_exists(oDialogueBox) && global.DB_Inst == noone){
			if(!instance_exists(oInventory) && !instance_exists(oMenu_Game) && oCamera.RoomTransition == NONE){
				if(instance_exists(oMap)){
					if(!global.MapInst.Open){
						global.MapInst.Close = true;
						audio_play_sound(Sound_Throw, 1, false);
					}				
				}else{
					global.MapInst = instance_create_layer(0, 0, layer, oMap);
					with(oLink) UpdateState(LinkState.Inventory);				
				}
			}
			
		}		
		
		
	}
}



if(NormalLinkState){
	if(input_check_pressed("menu_access") || global.AltTab){
		if(!instance_exists(oDialogueBox) && !instance_exists(oInventory) && !instance_exists(oMap) && oCamera.RoomTransition == NONE){
			if(!instance_exists(oMenu_Game)){
				global.MenuInst = instance_create_layer(0, 0, layer, oMenu_Game);
				with(oLink) UpdateState(LinkState.Inventory);
			}
		}		
		
		
	}	
}

//if(DEBUG) exit;

if(DEBUG){

	
	if(Restart){
		with(oLink){
			UpdateState(LinkState.Standing);
			//Link_SetStartingItems();
		}
		global.Paused = false;
		Dungeon_InitLevel(global.Level.Index);
		Restart = false;
		exit;
	}
	
	
	
	//Restart = true;
	
	if(keyboard_check_pressed(ord("R"))){// || (input_gamepad_check(input_player_get_gamepad(), gp_shoulderlb) && input_gamepad_check_pressed(input_player_get_gamepad(), gp_shoulderrb))){
	
		if(keyboard_check(vk_shift)){
			game_restart();
			exit;
		}
	
		Restart = true;	//only resart a frame later above, we need to reactivate all objects in order to destroy them, which is done in oGame End Draw event
		
	} else if(keyboard_check(vk_control) && keyboard_check(ord("R"))){
		Restart = true;	
	}
	
	if(mouse_check_button(mb_left)){

		
		//Item_Get(ItemClass.Sword, Swords.Master);
		//ItemSpawn(Probs_RandomItemClass(ItemFrom.Treasure), oLink.x, oLink.y, ItemFrom.Treasure, ItemSpawnType.DropScatter, UPPER);
		//oHUD.BossesDefeated = (oHUD.BossesDefeated + 1) mod 4;
		var inst = instance_create_layer(mouse_x, mouse_y, "Objs_Upper", oItem_Stopwatch);
		//inst.vy = -inst.Speed;
		//inst.Rot = 90;		
	////	//audio_play_sound(Sound_HeartContainer, 1, false);
	
	}
	
	//if(keyboard_check_pressed(ord("F"))){
	//	if(keyboard_check(vk_shift)){
	//		oRender.FadeOut();
	//	}else{
	//		oRender.FadeIn();
	//	}
	//}

	if(keyboard_check_pressed(vk_f2)){

	
		global.Users[global.UserIndex].Prefs[Pref.CRT] = !global.Users[global.UserIndex].Prefs[Pref.CRT];
		//***Cam 1 needs to be 1 pixel less high, and viewport 1 needs to be 4 less high(4 since GUI is 4x larger) and shifted 4 pixels down.
		//So Cam 1: 256x223 instead of 256x224, and VP1: 1024x892 instead of 1024x896, with VP1 at (288,4).
		//This leaves a 1-pixel blank space at the top and bottom to prevent the CRT ghosting artifact from happening
		//camera_set_view_size(1, 256, 224 - (global.CRT ? 1 : 0));
		//view_set_hport(1, 896 - (global.CRT ? 4 : 0));
		//view_set_yport(1, global.CRT ? 4 : 0);
	
		User_Save();
	
	}

	//if(keyboard_check(vk_control)){
	//	if(keyboard_check_pressed(ord("S"))) instance_create_layer(0, 0, "System", oSave);
	//}else{
		if(keyboard_check_pressed(ord("S"))) oRender.Stats = !oRender.Stats;
		
	//}
	
	
	if(keyboard_check_pressed(ord("L"))) global.GlobalLighting = !global.GlobalLighting;
	
	if(keyboard_check_pressed(ord("B"))){
		ItemSpawn(ItemClass.Crystal, -100, -100, ItemFrom.Enemy, ItemSpawnType.DropSky, UPPER);
	}
	
	//if(keyboard_check_pressed(ord("W"))) oLink.SwordIndex = (oLink.SwordIndex + 1) mod global.MaxItemIndex_Sword;
	if(keyboard_check_pressed(ord("H"))){
		with(oLink){
			Item_Get(ItemClass.Heart);
		}
	}
	if(keyboard_check_pressed(ord("O"))) global.Inventory.ItemData[ItemClass.Compass].Owns[0] = !global.Inventory.ItemData[ItemClass.Compass].Owns[0];
	if(keyboard_check_pressed(ord("P"))) global.Inventory.ItemData[ItemClass.Map].Owns[0] = !global.Inventory.ItemData[ItemClass.Map].Owns[0];
	if(keyboard_check_pressed(ord("C"))) global.Clip = !global.Clip;
	
	
	if(keyboard_check_pressed(ord("K"))) Item_Consume(ItemClass.Key, 0, 1);

	
	if(keyboard_check_pressed(vk_apostrophe)){
		global.Inventory.ItemData[ItemClass.Tunic].Index = (global.Inventory.ItemData[ItemClass.Tunic].Index + 1) mod 4;
	}
	if(keyboard_check_pressed(vk_fslash)){
		global.Inventory.ItemData[ItemClass.Tunic].Index--;
		if(global.Inventory.ItemData[ItemClass.Tunic].Index < 0) global.Inventory.ItemData[ItemClass.Tunic].Index = 3;
	}
	
	if(keyboard_check(vk_home)) RupeesAdd(5, false);
	if(keyboard_check(vk_end)) RupeesAdd(-5, false);

	if(keyboard_check_pressed(vk_pageup)) HealthAdd(0.25);
	if(keyboard_check_pressed(vk_pagedown)) HealthAdd(-0.25);

	
	if(keyboard_check_pressed(vk_f3)){

		view_visible[4] = !view_visible[4]
		
		//if(view_visible[4]) InitPreviewCam();
		
	}
	
	//if(keyboard_check_pressed(vk_f4)) HUD_SetPositions(oHUD.MainSide == oHUD.HUD_Left ? RIGHT : LEFT);
	
	if(keyboard_check_pressed(vk_f7)){
		with(oWall) visible = !visible;
	//	layer_set_visible(global.LayerID_Tiles_Floor_Upper, !layer_get_visible(global.LayerID_Tiles_Floor_Upper));
	}
	


	if(keyboard_check_pressed(vk_f8)){
		with(oProbStats){
			visible = !visible;
			if(visible) Reset = true;
		}
		with(oTreasureLimiter){
			visible = !visible;
		}
	}
	if(keyboard_check_pressed(vk_f9)){
		with(oProbStats){
			Reset = true;
		}
	}

	if(keyboard_check_pressed(vk_f10)){
		global.ShowLinkMask = !global.ShowLinkMask;
		//global.ShowUsedSpaces = !global.ShowUsedSpaces;
	}

	
	//if(keyboard_check(vk_f9)){
	//	oRender.MosaicAmount -= 0.05;
	//}
	//if(keyboard_check(vk_f10)){
	//	oRender.MosaicAmount += 0.05;
	//}
	
	if(keyboard_check_pressed(vk_f11)){
		global.Swordless = !global.Swordless;
	}
	
	if(keyboard_check_pressed(vk_f12)){
		global.DeactivateObjs = !global.DeactivateObjs;
	}	
	
}


