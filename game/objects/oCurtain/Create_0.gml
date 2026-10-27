//curtains should only be on upper levels
FloorLevel = UPPER;

sprite_index = asset_get_index("sCurtain_" + Location);

switch(LevelDef.Theme){
	case DungeonLevel.Castle: LevelIndex = 0; 	break;
	case DungeonLevel.CastleJails: LevelIndex = 1; break;
	case DungeonLevel.Sewers: 
		BeamTileX = 121;
		LevelIndex = 2; 
		break;
	case DungeonLevel.Ruins: 
		BeamTileX = 125;
		LevelIndex = 3; 
		break;
}

image_index = LevelIndex;
		
Revealed = false;
RevealedDone = false;


with(DoorInst){
	CurtainInst = other;
	Status = DoorStatus.Curtain;
}

	