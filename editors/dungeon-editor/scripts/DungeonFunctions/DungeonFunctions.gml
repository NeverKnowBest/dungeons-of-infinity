function NewDungeon(){

	var Dungeons = array_length(global.Data_Dungeons[global.DungeonClass]);
	array_push(global.Data_Dungeons[global.DungeonClass], new init_Dungeon());
	global.DungeonIndex = Dungeons;
	global.ActiveRoom = 0;
	RoomButtons_GridCreate();
	RoomButton_Activate();
	
}