event_inherited();

var i = ds_list_find_index(global.LargeMapItems, id);
if(i != -1){
	ds_list_delete(global.LargeMapItems, i);
	
}

if(instance_number(oItem_Fairy) <= 1 && global.Level.Rooms[global.CurrentRoomIndex].RoomSongIndex == SongIndex.Fairy){
	//if that was last fairy in room, and it was a fairy room, change the room music back to dungeon music	
	global.Level.Rooms[global.CurrentRoomIndex].RoomSongIndex = LevelDef.Song;		
}

