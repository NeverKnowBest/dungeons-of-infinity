function ds_grid_delete_row(_Grid, _Row){

    var w = ds_grid_width(_Grid);
    var h = ds_grid_height(_Grid);
	
	if(h <= 1){
		ds_grid_resize(_Grid, w, 0);
	}else{
		ds_grid_set_grid_region(_Grid, _Grid, 0, _Row+1, w-1, h-1, 0, _Row);
		ds_grid_resize(_Grid, w, h-1);
	}
	
}

function ds_list_finddelete(_List, _Value){
	ds_list_delete(_List, ds_list_find_index(_List, _Value))	
}

function ds_list_finddelete_all(_List, _Value){
	while(1){
		var Pos = ds_list_find_index(_List, _Value);
		if(Pos == -1)
			break;
		else
			ds_list_delete(_List, Pos);
	}
}

function ds_list_create_sequence_shuffled(_Min, _Max){
	var _List = ds_list_create_sequence(_Min, _Max);
	ds_list_shuffle(_List);
	return _List
}

function ds_list_create_sequence(_Min, _Max){
	var _List = ds_list_create();
	for(var i = _Min; i <= _Max; i++){
		ds_list_add(_List, i);
	}
	return _List;
}

function array_create_sequence(_Min, _Max){
	A = array_create(_Max - _Min + 1);
	for(var i = _Min; i <= _Max; i++){
		A[i] = i;
	}
	return A
}

function array_create_sequence_shuffled(_Min, _Max){
	A = array_create_sequence(_Min, _Max);
	array_shuffle_ext(A);
	return A
}
