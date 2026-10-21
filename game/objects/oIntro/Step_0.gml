
switch(State){
	
	case IntroState.Intro:

		if(DialogueActive){
			if(!instance_exists(global.DB_Inst)){
				if(DialogueIndex < array_length(Dialogue)){
					alarm[4] = 45;
				}else{
					Intro_ShowLink();					
				}
			}	
		}
		break;
	
	case IntroState.Fade:
		DarkScreenAlpha -= 0.075;
		if(DarkScreenAlpha <= 0){
			DarkScreenAlpha = 0;
			oHUD.ShowLevelName = true;
			State = IntroState.Start;
			//global.Intro = false;
		}
		break;
		
	case IntroState.Start:
	
		if(!CreatedWall && oLink.State != LinkState.AutoMove){
			oLink.Castle_EntranceWallInst = WallObj_Create("Objs_Upper", oCamera.X, oCamera.Y + 212, 32, 4);
			CreatedWall = true;
		}
	
		//check to see if you ran out of bombs
		if(!oCastleWallDoor.Opened){
			if(!NoMoreBombs && instance_number(oBush) == 0 && instance_number(oBush_Destroy) == 0 && instance_number(oItem_Bombs) == 0 && instance_number(oBomb) == 0 && instance_number(oBombExplosion) == 0 && global.Inventory.ItemData[ItemClass.Bombs].Amount[0] == 0){
				MsgBox(NoMoreBombsText);
				NoMoreBombs = true;
			}

		}
		
		break;
		
}

				





