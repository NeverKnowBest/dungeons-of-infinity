
switch(State){
	
	case ClawMachineState.Reset:
		ClawImg = 0;
		DropItem = false;
		DropItemY = 0;
		DropItemSpeed = 0.25;
		
		Win = Prob(WinRate);
		
		break;

		
	case ClawMachineState.MoveClaw:
		
		if(input_check("left")){
			ClawDirX = -1;
		}else if(input_check("right")){
			ClawDirX = 1;
		}else{
			ClawDirX = 0;
			audio_stop_sound(Sound_ClawMachine_Motor);
		}

		ClawX += (ClawSpeedX * ClawDirX);
		
		if(ClawDirX != 0 && !audio_is_playing(Sound_ClawMachine_Motor)){
			audio_play_sound(Sound_ClawMachine_Motor, 1, true);
		}

		if(ClawX > 6 && input_check_pressed("sword")){
			State = ClawMachineState.Drop;
			ClawImg = 1;
			audio_stop_sound(Sound_ClawMachine_Motor);
			audio_play_sound(Sound_ClawMachine_Drop, 1, false);
		}

		
		break;
	
	case ClawMachineState.Drop:
	
		ClawY += ClawSpeedY;
		
		if(ClawY > 4){
			State = ClawMachineState.Grab;
			alarm[0] = 45;
			audio_play_sound(Sound_ClawMachine_Land, 1, false);			
		}
	
		break;
	
	case ClawMachineState.RaiseClaw:
		ClawX -= ClawSpeedX;
		ClawY -= ClawSpeedY;		
		if(ClawX <= 0 && ClawY <= 0){
			
			audio_stop_sound(Sound_ClawMachine_Raise);
			State = ClawMachineState.DropPrize;
			
			if(Win){
				audio_play_sound(Sound_ClawMachine_GotItem, 1, false);
				alarm[2] = 60;
			}else{
				audio_play_sound(Sound_ClawMachine_Lose, 1, false);
				alarm[3] = 100;
			}		
			
		}
		break;
		
	case ClawMachineState.DropPrize:
		if(DropItem){
			DropItemY += DropItemSpeed;
			DropItemSpeed += 0.02;
			if(DropItemY >= 12){
				State = ClawMachineState.ClaimPrize;
				alarm[3] = 45;
			}
		}
		break;
		
	case ClawMachineState.GameOver:
	
		audio_stop_sound(Music_ClawMachine);
		Music_Fade(1, 12);

		if(Win){
			
			var _PrizeList = ds_list_create();
			
			if(Item_Allowed(ItemClass.Food)){
				repeat(75){ds_list_add(_PrizeList, ItemClass.Food)};
			}else{
				repeat(15){ds_list_add(_PrizeList, ItemClass.Coupon)};
				repeat(15){ds_list_add(_PrizeList, ItemClass.Gem)};
				repeat(15){ds_list_add(_PrizeList, ItemClass.Kinstone)};
				repeat(15){ds_list_add(_PrizeList, ItemClass.MagicLarge)};				
				repeat(15){ds_list_add(_PrizeList, ItemClass.Orb)};				
			}
			repeat(4){ds_list_add(_PrizeList, ItemClass.Coupon)};
			repeat(4){ds_list_add(_PrizeList, ItemClass.Gem)};
			repeat(4){ds_list_add(_PrizeList, ItemClass.Kinstone)};
			repeat(4){ds_list_add(_PrizeList, ItemClass.MagicLarge)};
			repeat(4){ds_list_add(_PrizeList, ItemClass.Orb)};
			
			if(WishStoneAvailable) ds_list_add(_PrizeList, ItemClass.WishStone);
			if(Item_Allowed(ItemClass.HeartPiece) && HeartContainerAvailable){
				ds_list_add(_PrizeList, ItemClass.HeartPiece);
			}
			
			ds_list_shuffle(_PrizeList);
			
			var _PrizeClass = _PrizeList[| 0];
			var _PrizeIndex = 0;
			
			switch(_PrizeClass){
				case ItemClass.Food:
					_PrizeIndex = choose(Food.Candy, Food.Lollypop);
					break;
				case ItemClass.Coupon:
					_PrizeIndex = choose(	Coupon.Blue, Coupon.Blue, Coupon.Blue, Coupon.Blue, Coupon.Blue, Coupon.Blue, Coupon.Blue, Coupon.Blue,
											Coupon.Silver, Coupon.Silver, Coupon.Silver, Coupon.Silver,
											Coupon.Green,
											Coupon.Red,
											Coupon.Pink,
											Coupon.Gold);
					break;
				case ItemClass.Kinstone:
					_PrizeIndex = Kinstone_PickIndex();
					break;
										
				case ItemClass.Gem:
					_PrizeIndex = Gem_PickIndex();
					break;
						
				case ItemClass.Orb:
					_PrizeIndex = Orb.Fairy;
					break;
						
			}

			ds_list_destroy(_PrizeList);
			
			if(_PrizeClass == HeartContainerAvailable) HeartContainerAvailable = false;
			if(_PrizeClass == WishStoneAvailable) WishStoneAvailable = false;
			
			var _PrizeInst = instance_create_layer(x, y, "ObjsHigher_Upper", ObjIndexFromItemClass(_PrizeClass), {From : ItemFrom.Treasure});
			with(_PrizeInst){
				Setup = false;
				Amount = 1;
				Item_SetIndex(_PrizeIndex);				
			}
			
			HoldUpItem(_PrizeInst);
			
		}else{
			with(oLink) UpdateState(LinkState.Standing);
			global.Paused = false;
		}
		
		State = ClawMachineState.Reset;
		break;
			
}

ClawX = clamp(ClawX, 0, 11);
ClawY = clamp(ClawY, 0, 4);


if(DB_Init){
	
	global.DB_Inst = instance_create_layer(0,0, "System", oDialogueBox);

	global.DB_Inst.Script = DB_Script;

	DB_Init = false;
	DB_Started = true;

}

if(DB_Started){
	if(!instance_exists(global.DB_Inst)){
		
		if(global.DB_ExitCode == 1){
			
			Music_Fade(0.25, 12);
			with(oLink) UpdateState(LinkState.Idle);
			global.Paused = true;
			
			audio_play_sound(Music_ClawMachine, 1, true);
			
			State = ClawMachineState.MoveClaw;
			
			//var _Inst = instance_create_layer(x, y, "ObjsHigher_Upper", oItem_Pop);

			//HoldUpItem(_Inst);

			oHUD.AddRupees = -ClawMachineCost;

		}
		DB_Started = false;
	}
}