audio_stop_all();

User_SaveStats();

Inventory_ClearAll();

Dungeon_Clear();

Dungeon_DestroyLevel();

TreasureLimiter_Reset();

instance_destroy(self);

gc_collect();

global.SaveLevel = false;
global.HubLevel = false;

switch(QuitTo){
	case 0:
		global.HubPending = true; //"New Game" goes back to the Sanctuary
		room_goto(Room_Dungeon);
		break;
	case 1:
		room_goto(Room_Title);
		break;
	case 2:
		game_end();
		break;
	
}


