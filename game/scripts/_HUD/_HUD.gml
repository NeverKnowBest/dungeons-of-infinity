
	

function HUD_SetPositions(_MainSide){
	
	with(oHUD){
		
		if(_MainSide == LEFT)
			MainSide = HUD_Left;
		else
			MainSide = HUD_Right;
		

		MapSide = (MainSide == HUD_Left ? HUD_Right : HUD_Left);
		SmallMapX = MapSide + 4;
		SmallMapY = 4;

		HeartsTLX = MainSide + 5; //TL = Top-Left
		HeartsTLY = 12;
	
		//precalulate all heart positions
		HeartsX = array_create(16);
		HeartsY = array_create(16);
		for(var i = 0; i < 16; i++){
			HeartsX[i] = HeartsTLX + ((i mod 8) * 8);
			HeartsY[i] = HeartsTLY + ((i div 8) * 8);
		}

		MMX = MainSide + 5; //Magic Meter
		MMY = HeartsTLY + 28;
	
		ItemX = MainSide + 4;
		ItemY = MMY + 12;
	
		AttackX = MainSide + 39;
		AttackY = 54;
		DefenseX = MainSide + 60;
		DefenseY = 54;
	
		RupeesX = MainSide + 38;
		RupeesY = 67;

		ArrowsX = MainSide + 10;
		ArrowsY = 80;

		BombsX = MainSide + 36;
		BombsY = 80;
		
		KeysX = MainSide + 61;
		KeysY = 80;


	
		Window1X = MainSide + 3;
		Window1Y = 93;
	
		//1st row

		SwordX = Window1X + 6;
		SwordY = Window1Y + 3;
	
		TunicX = Window1X + 26;
		TunicY = Window1Y + 4;

		ShieldX = Window1X + 47;
		ShieldY = Window1Y + 3;
		
		//2nd row
		MapItemX = Window1X + 6;
		MapItemY = Window1Y + 20;
	
		CompassX = Window1X + 27;
		CompassY = Window1Y + 21;
	
		GlovesX = Window1X + 47;
		GlovesY = Window1Y + 20;

		//3rd row
		MoonPearlX = Window1X + 7;
		MoonPearlY = Window1Y + 40;

		LampX = Window1X + 49;
		LampY = Window1Y + 38;
	
		MasterKeyX = Window1X + 26;
		MasterKeyY = Window1Y + 37;

		//precalculate pendants
		for(var i = 0; i < 12; i++){
			PendantsX[i] = MainSide + 6 + ((i mod 4) * 15);
			PendantsY[i] = 158 + ((i div 4) * 18);		
		}

		//precalculate skills
		SkillsY = 204;
		for(var i = 0; i < 3; i++){
			SkillsX[i] = MainSide + 9
			+ (i * 19);
		
		}
	
		DungeonX = MapSide + 2;
		DungeonY = 73;
	
		DungeonLinkX = DungeonX + 12;
		DungeonLinkY = DungeonY + 31;;
	
		DungeonBossIconsX = DungeonX + 26;
		DungeonBossIconsY[0] = DungeonY + 26;
		DungeonBossIconsY[1] = DungeonBossIconsY[0] + 36;
		DungeonBossIconsY[2] = DungeonBossIconsY[1] + 36;
		
	}

}

function HUD_DungeonLinkY(){
	
	return DungeonY + 23 + (max(global.Level.Index - 1, 0) * 9)	
}