function Error(_msg, _GameEnd){
	show_message(_msg);
	if(_GameEnd) game_end();
}

function Error_Spawn(_RoomIndex, _ItemStr, _GameEnd = false){

	Error("Can't spawn " + _ItemStr + " for dungeon index " + string(global.Level.DungeonTemplate_Index) + ", Room index " + string(_RoomIndex) + ", template id " + string(TemplateRoom[$ "id"]), _GameEnd)

}