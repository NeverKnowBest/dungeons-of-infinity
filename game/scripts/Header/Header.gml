
#macro DEBUG true

#macro NONE 0

#macro UP 1
#macro TOP 1
#macro DOWN 2
#macro BOTTOM 2
#macro LEFT 3
#macro RIGHT 4
#macro ALLDIR 5

#macro TOP_BOTTOM 0
#macro LEFT_RIGHT 1

#macro TOP_LEFT 0
#macro TOP_RIGHT 1
#macro BOTTOM_LEFT 2
#macro BOTTOM_RIGHT 3

#macro HORIZONTAL 1
#macro VERTICAL 2

#macro LOWER 0
#macro UPPER 1
#macro UPPERLOWER 2

#macro NO 0
#macro YES 1


#macro TilesetW 156
#macro LevelTilesY (4 + ((global.Level.Index - 1) * 6))
#macro VillageTilesY 88
#macro WaterTileS (global.Level.Index == DungeonLevel.Aghanim3 ? 92 : 86)


#macro MaxHearts 16


enum Flip{
	None,
	H,
	V,
	HV
}

enum Section{
	Main,
	Other
}

enum SectionWallType{
	Rail,
	SwitchBlock
}

enum SwitchBlockColor{
	Red,
	Blue,
	Green	
}



