function Error(_msg, _GameEnd = false){
	
	if(global.TestMode){ //no message box in a test, it would wait for a click
		Test_Fail("error " + _msg);
		if(_GameEnd) Test_Finish("error");
		exit;
	}
	
	show_message(_msg);
	show_debug_message(_msg);
	if(_GameEnd) game_end();
	var file = file_text_open_append("Errors.txt");
    file_text_write_string(file, _msg);
    file_text_writeln(file);
	file_text_close(file);
}

function Error_Spawn(_RoomIndex, _ItemStr, _GameEnd = false){

	Error("Can't spawn " + _ItemStr + " dungeon level " + string(global.Level.Index) + " for dungeon index " + string(global.Level.DungeonTemplate_Index) + ", Room index " + string(_RoomIndex) + ", template id " + string(Room.Template[$ "id"]), _GameEnd)
	
}