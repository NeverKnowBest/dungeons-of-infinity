
global.Paused = false;

global.MenuInst = noone;

global.DisableMenus = false;

global.LinkDead = false;

global.FinalBoss = false;

global.GameBeaten = false;

global.Swordless = false;

global.ShopkeeperJustin = false;

if(DEBUG){
	
	global.TestGame = false;
	
	global.Swordless = false;
	
	Restart = false;
	global.Clip = false;
	global.ShowUsedSpaces = false;
	global.ShowLinkMask = false;
	global.DeactivateObjs = true;
	
	//if(!instance_exists(oProbStats)) instance_create_layer(0, 0, "System", oProbStats);
	//if(!instance_exists(oNonDuplicatableList)) instance_create_layer(0, 0, "System", oNonDuplicatableList);
	//if(!instance_exists(oTreasureLimiter)) instance_create_layer(0, 0, "System", oTreasureLimiter);
	//alarm[0] = 60;
}

User_UpdateMusicSFX();

Time_PlayingStart();

Time_PauseStart();

if(global.Continue){
	global.SaveLevel = true;
	User_LoadGame();
	Dungeon_InitSaveLevel(global.ContinueLevel);
	oRender.FadeIn();
}else if(global.HubPending){
	global.HubPending = false;
	Dungeon_InitHubLevel();
	oRender.FadeIn();
}else if(global.TestMode){
	Test_StartLevel();
}else{
	if(DEBUG){		
		Dungeon_InitLevel(DungeonLevel.Aghanim2);
	}else{
		Dungeon_InitLevel(DungeonLevel.Start);
	}
}

if(!DEBUG) User_DelSaveData();



Time_PauseEnd();