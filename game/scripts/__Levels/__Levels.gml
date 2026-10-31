// Level sheet (roadmap F4): what makes each level of a run different, in one place.
// global.LevelDefs[DungeonLevel.X] holds one struct per level; the code reads the current level's entry through the
// macro LevelDef. A new level is a new DungeonLevel member and an entry here (recipe in docs/dev/receitas.md).
//
// Three fields point at another level on purpose, so a new level can borrow from an existing one:
//   Theme		whose art it uses: the tile rows of the tileset (LevelTilesY) and every decoration rule that depends on
//				those tiles (floors and floor decor, monuments, cracks, curtains, carpets, wall decor, pots, palettes).
//				The decoration rules are the switch(LevelDef.Theme) blocks in the scripts __Dungeon_Draw_* and __Decor.
//   BaseTheme	whose door frames, holes, floor trims and stairs it uses (LevelTilesY_Base); Agahnim borrows the fortress ones
//   EnemyStats	whose stats the enemies take (the variants of __EnemyArch: soldier colours and energy, rope sprites; and the
//				per-level code of Poe, Wizzrobe, Beamos, the Type of Bari, Keese...). EnemyVariants overrides a variant here
// A region's own art (roadmap F6b) does not need a level to borrow from: TilesBand names an imported band of sTiles
// (global.TileBands, scripts/__Tiles) that takes the place of the Theme's rows in LevelTilesY, laid out like the Theme's
// band so the Theme's decoration rules still fit; RegionTiles names a region tileset (ts_<Name>, RegionTiles_*), the
// tiles painted one by one in 16x16 blocks, with a class per tile for collision.
// Depth is how far into the run the level is (1 = Hyrule Castle); difficulty formulas use it. Each depth is a chapter,
// and the levels with the same Depth are its variants (roadmap F4b).
//
// Exits (roadmap F4b): pools of [value, weight] (weight = tickets in the draw, Level_PoolPick) say where each exit leads
// (NextPool, a variant of the next chapter), how many exits there are (ExitCount) and whether the extra one is hidden in
// a secret room (ExitHidden). Only a level whose NextPool has more than one level draws anything; the generator side is
// Dungeon_PlanExits. ExitLook is how the exits that lead to THIS level look, a key of global.ExitLooks (__Doors).

#macro LevelDef global.LevelDefs[global.Level.Index]
#macro LevelTilesY (LevelDef.TilesBand == "" ? (4 + ((LevelDef.Theme - 1) * 6)) : global.TileBands[$ LevelDef.TilesBand])
#macro LevelTilesY_Base (4 + ((LevelDef.BaseTheme - 1) * 6))	// door frames, holes, floor trims and stairs

enum LevelSpecial{
	None,
	Intro,		// the rainy night outside the castle (oIntro), start of every run
	Village,	// Rebel Village: fixed layout, houses, village NPCs
	Mines,		// Dwarven Mining Town: fixed layout, houses, mine caves
	FinalBoss	// Agahnim: the hall and the final fight
}

enum LevelLayout{
	Dungeon,	// rooms joined by doors with frames in the walls
	Outdoor		// rooms joined by open passages at the door positions, no frames (roadmap F12b)
}

enum LevelDark{
	Never,		// rooms are never dark
	Low,		// dark only with the Darkness challenge
	Normal,		// 25% (+ DarkBonus, + the Darkness challenge)
	Always
}

enum LevelWater{
	None,
	WetBandits,	// only the rooms with the Wet Bandits, all of their water
	Random,		// WaterChance per room, random parts of the template's water
	Always		// all the water of every template
}

/// Level of an index, or undefined past the last level
function Level_Get(_Level){
	return (_Level >= 0 && _Level < array_length(global.LevelDefs)) ? global.LevelDefs[_Level] : undefined;
}

function Level_Depth(_Level){
	return global.LevelDefs[_Level].Depth;
}

/// A value drawn from a pool of [value, weight] pairs. A pool with a single entry uses no random number, so a level
/// without branches is built exactly as before F4b. undefined for an empty pool.
function Level_PoolPick(_Pool){
	var _N = array_length(_Pool);
	if(_N == 0) return undefined;
	if(_N == 1) return _Pool[0][0];
	var _Total = 0;
	for(var i = 0; i < _N; i++) _Total += _Pool[i][1];
	var _Ticket = irandom(_Total - 1);
	for(var i = 0; i < _N; i++){
		_Ticket -= _Pool[i][1];
		if(_Ticket < 0) return _Pool[i][0];
	}
	return _Pool[_N - 1][0];
}

/// True when the exits of a level can lead to more than one level (a branch of the run)
function Level_Branches(_Def){
	var _Pool = _Def.NextPool;
	var _First = undefined;
	for(var i = 0; i < array_length(_Pool); i++){
		if(_Pool[i][1] <= 0) continue;
		if(_First == undefined) _First = _Pool[i][0];
		else if(_Pool[i][0] != _First) return true;
	}
	return false;
}

/// Level the run goes to next: where the exit Link took leads (global.RunPath.Next), or the sheet's Next
function Level_NextIndex(){
	return (global.RunPath.Next != -1) ? global.RunPath.Next : LevelDef.Next;
}

/// How likely an enemy is to be picked for a room of the current level (0 = never)
function Level_EnemyWeight(_ObjIndex){
	var _W = LevelDef.EnemyWeights;
	return _ObjIndex < array_length(_W) ? _W[_ObjIndex] : 0;
}

/// Default entry: a normal dungeon level. Levels_Init overrides what differs.
function Level_Create(_Index, _Name) constructor{
	Index = _Index;
	Name = _Name;
	Depth = _Index;
	Next = _Index + 1;
	Theme = _Index;
	BaseTheme = _Index;
	EnemyStats = _Index;
	TilesBand = "";						// imported band of sTiles used instead of the Theme's rows (a key of global.TileBands)
	RegionTiles = "";					// region tileset painted in blocks (data/tiles/<Name>.json, tileset ts_<Name>)
	Special = LevelSpecial.None;

	// Layout
	Layout = LevelLayout.Dungeon;		// Outdoor: an open door is a passage in the painted walls, drawn with no frame (roadmap F12b)
	Class = DungeonClass.Castle;		// dungeon template class (global.Templates_Dungeon)
	Template = -1;						// for DungeonClass.Special: index of the fixed layout
	Transform = true;					// dungeon template may be flipped and rotated
	RoomSet = "";						// room set (roadmap F11): the level's own room templates (rooms/sets/<RoomSet>), tried before the shared ones
	RoomSetFallback = true;				// a room no template of the set fits takes a shared one; false: the level cannot be built
	StartDir = (_Index mod 2 == 1) ? UP : DOWN;	// Link comes in from the bottom (UP) or the top (DOWN)
	SaveBefore = false;					// a save level (rest stop) comes before this level
	RunStart = false;					// first level of a run: front door and entrance wall, falling leaves, a sure bonus treasure, no kinstones, counts a game played
	Ceiling = true;						// rooms get the ceiling tiles around them
	FairyRooms = true;					// fairy and gem pond rooms may appear
	TMNTRoom = false;					// the TMNT secret room may appear
	Jails = false;						// rooms may get jail cells with prisoners
	Spikes = true;						// spike floors may be spawned in rooms
	ShopBesideBoss = true;				// a shop may be in the room next to the boss room
	ShopKeeperSprite = -1;				// sprite of every shop keeper, -1 for the usual random ones
	JustinShop = false;					// the first shop keeper of the level is Justin (once per run)
	Curses = true;						// treasures may be cursed
	ObstacleRooms = true;				// rooms may take an obstacle template (false: a Main_Upper one, e.g. the painted rooms of an outdoor level)
	Obstacles = [RoomObstacle.Holes];	// obstacle templates, picked at random (repeat one to make it more likely)
	MovingFloors = [];					// added to Obstacles in rooms without special objects

	// Exits (roadmap F4b). Pools are [value, weight] lists. Weights of today's levels: docs/roadmap.md (F4b).
	NextPool = undefined;				// [[level, weight], ...]: where each exit leads (variants of the next chapter); undefined = [[Next, 1]]
	ExitCount = [[1, 2], [2, 1]];		// how many exits, only drawn when NextPool can lead to more than one level
	ExitHidden = [[false, 1], [true, 1]];	// whether the extra exit is in a secret room behind a bombable wall
	ExitMinDistance = 2;				// grid columns between the two exits, which are also on opposite sides of the map's middle
	ExitLook = "StairsDown";			// how the exits that lead to this level look: a key of global.ExitLooks (__Doors)
	OwnExitLooks = undefined;			// {Top, Bottom}: looks of this level's own exits, in place of the destination's, where
										// the room has them painted (outdoor levels: a gate out of the wall, Door_ExitLook)
	ArriveLook = "";					// the look Link arrives through in this level, in place of the exit he took ("" keeps it)
	ExitWall = "";						// "Top": the main exit moves to the top wall of its room where nothing is behind it, and
										// the extra exit only goes there (Dungeon_ExitToTop)

	// Boss
	Boss = false;
	BossSpawn = undefined;				// {Obj, X, Y, Layer}: boss object created in the boss room (offset from its corner)
	BossRoomTemplate = "Default";		// Other/Boss room template
	BossDoorFrame = 48;					// tile x of the boss door frame (40 Armos, 44 Lanmola, 48 Moldorm)
	BossAchievement = "";
	ReachAchievement = "";

	// Mood
	Song = SongIndex.Dungeon1;
	Dark = LevelDark.Normal;
	DarkBonus = 0;
	Water = LevelWater.None;
	Weather = undefined;				// {Rain, Leaves, Lightning, Thunder, Tint, ...}: oWeather over the level, fields missing take Weather_Defaults (__Weather)
	WaterChance = 0.75;
	WaterNeedsGore = false;				// the water is blood: none when gore is off
	WaterTileX = 86;
	InWaterSprite = sInWater;
	SecretDoorType = -1;				// SecretDoor type of every secret door, -1 for the usual random one
	PotStyle = 0;
	GuruBarType = 0;

	// Enemies: [object, weight] (weight = how many tickets in the draw), and pack points that differ from the enemy's
	Enemies = [];
	PackPoints = {};
	EnemyWeights = [];
	EnemyVariants = {};					// {oEnemy_X: {...}}: this level's own variant of an enemy (colour, energy, attack...), see scripts/__EnemyArch

}

function Levels_Init(){
	var _L = [];
	_L[DungeonLevel.Start] = new Level_Create(DungeonLevel.Start, "Destroy Agahnim");
	_L[DungeonLevel.Castle] = new Level_Create(DungeonLevel.Castle, "Hyrule Castle");
	_L[DungeonLevel.CastleBasement] = new Level_Create(DungeonLevel.CastleBasement, "Castle Basement");
	_L[DungeonLevel.CastleJails] = new Level_Create(DungeonLevel.CastleJails, "Castle Prison");
	_L[DungeonLevel.Catacombs] = new Level_Create(DungeonLevel.Catacombs, "Catacombs");
	_L[DungeonLevel.Sewers] = new Level_Create(DungeonLevel.Sewers, "Sewers");
	_L[DungeonLevel.Village] = new Level_Create(DungeonLevel.Village, "Rebel Village");
	_L[DungeonLevel.LanmolasLair] = new Level_Create(DungeonLevel.LanmolasLair, "Lanmola's Lair");
	_L[DungeonLevel.Ruins] = new Level_Create(DungeonLevel.Ruins, "Ancient Ruins");
	_L[DungeonLevel.WaterTemple] = new Level_Create(DungeonLevel.WaterTemple, "Water Temple");
	_L[DungeonLevel.Mines] = new Level_Create(DungeonLevel.Mines, "Dwarven Mining Town");
	_L[DungeonLevel.MoldormsLair] = new Level_Create(DungeonLevel.MoldormsLair, "Moldorm's Lair");
	_L[DungeonLevel.Aghanim1] = new Level_Create(DungeonLevel.Aghanim1, "Agahnim's Fortress");
	_L[DungeonLevel.Aghanim2] = new Level_Create(DungeonLevel.Aghanim2, "Agahnim");
	_L[DungeonLevel.CastleTop] = new Level_Create(DungeonLevel.CastleTop, "Castle Rooftops");
	global.LevelDefs = _L;
	global.RunPath = {Next: -1};	// the level the exit Link took leads to (Level_NextIndex), kept through the rest stop

	with(_L[DungeonLevel.Start]){
		Special = LevelSpecial.Intro;
		Class = DungeonClass.Special;
		Template = 0;
		Transform = false;
		StartDir = UP;
		Ceiling = false;
		Song = SongIndex.Start;
		Dark = LevelDark.Never;
		Weather = {Leaves: true};	// the rainy night (oWeather, made by oIntro)
	}

	with(_L[DungeonLevel.Castle]){
		Class = DungeonClass.Castle;
		RunStart = true;
		Spikes = false;
		Curses = false;
		FairyRooms = false;
		Song = SongIndex.Castle;
		Dark = LevelDark.Low;
		SecretDoorType = SecretDoor.Crack;
		Enemies = [[oEnemy_Soldier_Advanced, 2], [oEnemy_Soldier_Simple, 3]];
		NextPool = [[DungeonLevel.CastleBasement, 2], [DungeonLevel.CastleTop, 1]];	// each exit leads to the rooftops 1 time in 3
	}

	with(_L[DungeonLevel.CastleBasement]){
		Class = DungeonClass.CastleBasement;
		Spikes = false;
		Song = SongIndex.Castle;
		DarkBonus = 0.1;
		Enemies = [[oEnemy_Keese, 1], [oEnemy_Rat, 2], [oEnemy_Rope, 1], [oEnemy_Soldier_Advanced, 3], [oEnemy_Soldier_Simple, 3]];
	}

	with(_L[DungeonLevel.CastleJails]){
		Class = DungeonClass.CastleJails;
		Boss = true;
		BossSpawn = {Obj: oBoss_Armos_C, X: 20, Y: 20, Layer: "System"};
		BossDoorFrame = 40;
		BossAchievement = "BossArmos";
		Jails = true;
		Spikes = false;
		Obstacles = [RoomObstacle.Blocks];
		Song = SongIndex.Castle;
		DarkBonus = 0.1;
		Water = LevelWater.WetBandits;
		Enemies = [[oEnemy_Keese, 1], [oEnemy_Rat, 1], [oEnemy_Rope, 1], [oEnemy_Soldier_Advanced, 3], [oEnemy_Soldier_Simple, 2], [oEnemy_Soldier_Mace, 1]];
	}

	with(_L[DungeonLevel.Catacombs]){
		Class = DungeonClass.CatacombsSewers;
		SaveBefore = true;
		ReachAchievement = "ReachCatacombs";
		Obstacles = [RoomObstacle.Blocks, RoomObstacle.Holes, RoomObstacle.Spikes];
		Dark = LevelDark.Always;
		PotStyle = 1;
		Enemies = [[oEnemy_Keese, 2], [oEnemy_Poe, 2], [oEnemy_Rat, 1], [oEnemy_Rope, 1], [oEnemy_Skeleton, 2], [oEnemy_Gibdo, 2], [oEnemy_Guru_Bar, 1], [oEnemy_Soldier_Advanced, 2]];
	}

	with(_L[DungeonLevel.Sewers]){
		Class = DungeonClass.CatacombsSewers;
		TMNTRoom = true;
		Spikes = false;
		Obstacles = [RoomObstacle.Blocks, RoomObstacle.Blocks, RoomObstacle.Holes, RoomObstacle.Holes, RoomObstacle.Holes, RoomObstacle.Holes, RoomObstacle.Holes, RoomObstacle.Holes, RoomObstacle.Holes];
		DarkBonus = 0.15;
		Water = LevelWater.Random;
		Enemies = [[oEnemy_Buzz, 1], [oEnemy_Hover, 3], [oEnemy_Keese, 1], [oEnemy_Rat, 2], [oEnemy_Rope, 1], [oEnemy_Bari, 2], [oEnemy_Zol, 2], [oEnemy_BuzzBlob, 1], [oEnemy_Pikit, 2], [oEnemy_Popo, 3], [oEnemy_Crab, 2], [oEnemy_Cannon, 1], [oEnemy_Kyameron_Emitter, 2]];
		PackPoints = {oEnemy_Rat: 1, oEnemy_Buzz: 2};	// infested with rats (normally 2), fewer Buzz (normally 1)
	}

	with(_L[DungeonLevel.Village]){
		Special = LevelSpecial.Village;
		Class = DungeonClass.Special;
		Template = 2;
		Transform = false;
		SaveBefore = true;
		FairyRooms = false;
		Curses = false;
		ReachAchievement = "ReachVillage";
		Song = SongIndex.Village_Cave;
		Water = LevelWater.Always;
		SecretDoorType = SecretDoor.Blank;
	}

	with(_L[DungeonLevel.LanmolasLair]){
		Class = DungeonClass.BossesRuins;
		Boss = true;
		BossSpawn = {Obj: oBoss_Lanmola_C, X: 20, Y: 20, Layer: "System"};
		BossDoorFrame = 44;
		BossAchievement = "BossLanmola";
		Obstacles = [RoomObstacle.Blocks, RoomObstacle.Spikes, RoomObstacle.SpikeBlocks];
		Song = SongIndex.Dungeon2;
		PotStyle = 1;
		Enemies = [[oEnemy_Bubble, 2], [oEnemy_Buzz, 2], [oEnemy_Hoarder, 1], [oEnemy_BuzzBlob, 1], [oEnemy_Pikit, 1], [oEnemy_Crab, 1], [oEnemy_Gibdo, 3], [oEnemy_Leever, 2], [oEnemy_Octorok, 2], [oEnemy_Ropa, 2], [oEnemy_SnapDragon, 1], [oEnemy_Geldman, 2], [oEnemy_Beamos, 3], [oEnemy_Cannon, 1], [oEnemy_Guru_Bar, 1], [oEnemy_Medusa, 2], [oEnemy_RollingSpike, 1], [oEnemy_MovingSpikeBlock, 1]];
	}

	with(_L[DungeonLevel.Ruins]){
		Class = DungeonClass.BossesRuins;
		SaveBefore = true;
		Obstacles = [RoomObstacle.Blocks, RoomObstacle.Blocks, RoomObstacle.Blocks, RoomObstacle.Holes, RoomObstacle.Holes, RoomObstacle.Holes, RoomObstacle.Holes, RoomObstacle.Holes, RoomObstacle.Spikes, RoomObstacle.Spikes, RoomObstacle.Spikes];
		DarkBonus = 0.2;
		Enemies = [[oEnemy_Bubble, 1], [oEnemy_Buzz, 1], [oEnemy_Hoarder, 2], [oEnemy_Keese, 2], [oEnemy_Poe, 2], [oEnemy_Rat, 1], [oEnemy_BuzzBlob, 1], [oEnemy_Helmasaur, 2], [oEnemy_Kodongo, 2], [oEnemy_Goriya, 3], [oEnemy_Zirro, 2], [oEnemy_Beamos, 3], [oEnemy_Cannon, 1], [oEnemy_Guru_Bar, 1], [oEnemy_Medusa, 1], [oEnemy_RollingSpike, 1], [oEnemy_MovingSpikeBlock, 1]];
	}

	with(_L[DungeonLevel.WaterTemple]){
		Class = DungeonClass.BossesRuins;
		Spikes = false;
		Obstacles = [RoomObstacle.Blocks, RoomObstacle.Holes];
		MovingFloors = [RoomObstacle.MovingFloorsHoles, RoomObstacle.MovingFloorsHoles, RoomObstacle.MovingFloorsHoles];
		DarkBonus = 0.15;
		Water = LevelWater.Random;
		GuruBarType = 1;
		Enemies = [[oEnemy_Bubble, 1], [oEnemy_Hover, 2], [oEnemy_Keese, 2], [oEnemy_Poe, 1], [oEnemy_Bari, 1], [oEnemy_Zol, 1], [oEnemy_Wizzrobe, 3], [oEnemy_HardhatBeetle, 3], [oEnemy_Zazak, 2], [oEnemy_Eyegore, 3], [oEnemy_Beamos, 3], [oEnemy_Cannon, 1], [oEnemy_Guru_Bar, 2], [oEnemy_Kyameron_Emitter, 2], [oEnemy_Medusa, 1], [oEnemy_RollingSpike, 1], [oEnemy_MovingSpikeBlock, 1], [oEnemy_Soldier_Advanced, 2]];
	}

	with(_L[DungeonLevel.Mines]){
		Special = LevelSpecial.Mines;
		Class = DungeonClass.Special;
		Template = 3;
		Transform = false;
		SaveBefore = true;
		FairyRooms = false;
		Curses = false;
		ShopKeeperSprite = sShopKeeper_Mines;
		ReachAchievement = "ReachMines";
		Song = SongIndex.Mines;
		Water = LevelWater.Always;
		WaterTileX = 92;
		InWaterSprite = sInMineWater;
		SecretDoorType = SecretDoor.Blank;
	}

	with(_L[DungeonLevel.MoldormsLair]){
		Class = DungeonClass.BossesRuins;
		Boss = true;
		BossSpawn = {Obj: oBoss_Moldorm, X: 128, Y: 80, Layer: "ObjsHigher_Upper"};
		BossRoomTemplate = "Moldorm";
		BossAchievement = "BossMoldorm";
		Obstacles = [RoomObstacle.Blocks, RoomObstacle.Blocks, RoomObstacle.Holes, RoomObstacle.Holes, RoomObstacle.Spikes, RoomObstacle.Spikes, RoomObstacle.SpikeBlocks, RoomObstacle.SpikeBlocks, RoomObstacle.SpikeBlocks];
		MovingFloors = [RoomObstacle.MovingFloorsHoles, RoomObstacle.MovingFloorsSpikes, RoomObstacle.MovingFloorsSpikeBlocks];
		Song = SongIndex.Dungeon2;
		Dark = LevelDark.Always;
		PotStyle = 1;
		GuruBarType = 2;
		Enemies = [[oEnemy_Bubble, 1], [oEnemy_Hoarder, 3], [oEnemy_BuzzBlob, 1], [oEnemy_Kodongo, 3], [oEnemy_Moldorm, 4], [oEnemy_Octorok, 2], [oEnemy_Ropa, 3], [oEnemy_Tektite, 2], [oEnemy_Cannon, 1], [oEnemy_Guru_Bar, 1], [oEnemy_Medusa, 1], [oEnemy_RollingSpike, 1], [oEnemy_MovingSpikeBlock, 1]];
	}

	with(_L[DungeonLevel.Aghanim1]){
		Class = DungeonClass.Aghanim;
		SaveBefore = true;
		ShopBesideBoss = false;
		JustinShop = true;
		Obstacles = [RoomObstacle.Blocks, RoomObstacle.Blocks, RoomObstacle.Blocks, RoomObstacle.Blocks, RoomObstacle.Blocks, RoomObstacle.Holes, RoomObstacle.Spikes, RoomObstacle.SpikeBlocks, RoomObstacle.SpikeBlocks];
		MovingFloors = [RoomObstacle.MovingFloorsHoles, RoomObstacle.MovingFloorsSpikes, RoomObstacle.MovingFloorsSpikeBlocks];
		Song = SongIndex.Dungeon3;
		DarkBonus = 0.15;
		Water = LevelWater.Random;
		WaterChance = 0.55;
		WaterNeedsGore = true;
		WaterTileX = 98;
		InWaterSprite = sInBlood;
		PotStyle = 1;
		GuruBarType = 2;
		Enemies = [[oEnemy_Bubble, 1], [oEnemy_Poe, 2], [oEnemy_Bari, 2], [oEnemy_Kodongo, 1], [oEnemy_Ropa, 1], [oEnemy_Wizzrobe, 2], [oEnemy_SnapDragon, 2], [oEnemy_Zirro, 1], [oEnemy_Tektite, 2], [oEnemy_Armos, 3], [oEnemy_Hinox, 5], [oEnemy_Beamos, 4], [oEnemy_Cannon, 1], [oEnemy_Guru_Bar, 1], [oEnemy_Medusa, 1], [oEnemy_RollingSpike, 1], [oEnemy_MovingSpikeBlock, 1], [oEnemy_Soldier_Advanced, 5], [oEnemy_Soldier_Mace, 2]];
		PackPoints = {oEnemy_Bari: 1.75};	// more Baris (normally 3)
	}

	with(_L[DungeonLevel.Aghanim2]){
		Special = LevelSpecial.FinalBoss;
		Class = DungeonClass.Special;
		Template = 1;
		Transform = false;
		Next = -1;
		BaseTheme = DungeonLevel.Aghanim1;
		Boss = true;
		Ceiling = false;
		Song = SongIndex.Boss_Final_Hallway;
		Dark = LevelDark.Never;
	}

	// Chapter 2 variant: the castle rooftops in the rain (docs/regioes/topo-do-castelo.md), seen from above like ALttP's
	// overworld area 0x1B, its rooms painted with ts_CastleTop (room set CastleTop, roadmap F12b-1). Hyrule Castle's
	// exits lead to it with weight 1 beside the basement's 2; it rains and thunders like the night of the run's start.
	with(_L[DungeonLevel.CastleTop]){
		Depth = 2;
		Next = DungeonLevel.CastleJails;
		Theme = DungeonLevel.Castle;
		BaseTheme = DungeonLevel.Castle;
		EnemyStats = DungeonLevel.Castle;
		RegionTiles = "CastleTop";
		Layout = LevelLayout.Outdoor;
		RoomSet = "CastleTop";
		Ceiling = false;
		Class = DungeonClass.Castle;
		StartDir = DOWN;
		Spikes = false;
		Curses = false;
		FairyRooms = false;
		Song = SongIndex.Castle;
		Dark = LevelDark.Never;
		Weather = {Thunder: true};
		ObstacleRooms = false;
		SecretDoorType = SecretDoor.Crack;
		ExitLook = "StairsUp";
		// in and out by the palace door of area 0x1B (the way to Agahnim's tower), which only fits the top wall; an
		// exit that cannot go there leaves by the stairs out of the castle's front gate (Guilherme, oct/2026)
		OwnExitLooks = {Top: "Gate", Bottom: "GateStairs"};
		ArriveLook = "Gate";
		ExitWall = "Top";
		Enemies = [[oEnemy_Soldier_Advanced, 2], [oEnemy_Soldier_Simple, 3], [oEnemy_Keese, 1]];
	}

	// Enemy weights by object index, for Level_EnemyWeight, and the default exit pool (the sheet's Next)
	for(var _Level = 0; _Level < array_length(_L); _Level++){
		var _Def = _L[_Level];
		if(_Def.NextPool == undefined) _Def.NextPool = (_Def.Next == -1) ? [] : [[_Def.Next, 1]];
		_Def.EnemyWeights = array_create(array_length(global.EnemyData), 0);
		for(var j = 0; j < array_length(_Def.Enemies); j++){
			var _Obj = _Def.Enemies[j][0];
			if(_Obj >= array_length(_Def.EnemyWeights)) array_resize(_Def.EnemyWeights, _Obj + 1);
			_Def.EnemyWeights[_Obj] = _Def.Enemies[j][1];
		}
	}
}
