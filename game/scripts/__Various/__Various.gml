
global.AltTab = false;
global.AltTab_OldGain = 0;
global.OldWinFocus = false;

function AltTabCheck(){
	
	//fix for alt-tab vsync bug. If alt-tab then back in game, vsync gets turned off causing unsmooth scrolling
	var CurrentWinFocus = window_has_focus();
	if(!global.OldWinFocus && CurrentWinFocus){
		display_reset(0, true);
		display_set_timing_method(tm_countvsyncs);
	}
	global.OldWinFocus = CurrentWinFocus;
	
	if(!global.AltTabPause) exit;
	
	//mute the audio
	if(CurrentWinFocus && global.AltTab){
		audio_set_master_gain(0, global.AltTab_OldGain);
		global.AltTab = false;
	}

	if(!CurrentWinFocus && !global.AltTab){
		global.AltTab_OldGain = audio_get_master_gain(0);
		audio_set_master_gain(0, 0);
		global.AltTab = true;
	}

}

function EncodeDataToBuffer(_Data){

	var JSONStr = json_stringify(_Data);
	var Buffer = buffer_create( string_byte_length(JSONStr) + 1, buffer_fixed, 1);
	buffer_write(Buffer, buffer_string, JSONStr);
	return Buffer;
	
}

function RealToBool(_val){
	//converts _val	to true if non-zero, otherwise converts to false
	return _val != 0 ? true : false;
}

function AngleCheck(_Angle){
	if(_Angle < 0) return _Angle + 360;
	if(_Angle >= 360) return _Angle - 360;
	return _Angle;
}

function Array_Create2D(_SizeX, _SizeY, _DefaultValue = 0){
	
	var NewArray = 0;
	
	for(var _y = 0; _y < _SizeY; _y++){
		NewArray[_y] = array_create(_SizeX, _DefaultValue);
	}
	
	return NewArray
}

function Array_Create3D(_SizeX, _SizeY, _SizeZ, _DefaultValue = 0){
	
	var NewArray = 0;
	
	for(var _z = 0; _z < _SizeZ; _z++){
		for(var _y = 0; _y < _SizeY; _y++){
			NewArray[_z][_y] = array_create(_SizeX, _DefaultValue);
		}
		
	}
	
	return NewArray
}

function Surface_Clear(_Surface){
	surface_set_target(_Surface);
	draw_clear_alpha(c_black, 0.0);	
	surface_reset_target();	
}

function Surface_ClearToColor(_Surface, _Color){
	surface_set_target(_Surface);
	draw_clear_alpha(_Color, 1.0);	
	surface_reset_target();	
}

function dec_to_hex(dec, len = 1) 
{
    var hex = "";
 
    if (dec < 0) {
        len = max(len, ceil(logn(16, 2 * abs(dec))));
    }
 
    var dig = "0123456789ABCDEF";
    while (len-- || dec) {
        hex = string_char_at(dig, (dec & $F) + 1) + hex;
        dec = dec >> 4;
    }
 
    return hex;
}

function audio_play_sound_stopall(_SoundID, _Priority = 1, _Loop = false){
	if(audio_is_playing(_SoundID)) audio_stop_sound(_SoundID);
	audio_play_sound(_SoundID, _Priority, _Loop);			
}


		
function InitPreviewCam(){
	
	//F3 cam, set boundaries so it's full scale with the screen
	
	var _CamX1 = 100000;
	var _CamY1 = 100000;
	var _CamX2 = 0;
	var _CamY2 = 0;
	var _Rooms = array_length(global.Level.Rooms);
	for(var _RoomIndex = 0; _RoomIndex < _Rooms; _RoomIndex++){
			
		var _Room = global.Level.Rooms[_RoomIndex];
			
		var _RoomX1 = _Room.GridX * 256;
		var _RoomY1 = _Room.GridY * 256;
		var _RoomX2 = _RoomX1 + (_Room.GridW * 256);
		var _RoomY2 = _RoomY1 + (_Room.GridH * 256);
			
		if(_RoomX1 < _CamX1) _CamX1 = _RoomX1;
		if(_RoomY1 < _CamY1) _CamY1 = _RoomY1;
		if(_RoomX2 > _CamX2) _CamX2 = _RoomX2;
		if(_RoomY2 > _CamY2) _CamY2 = _RoomY2;
			
	}
	
	
	//make sure camera is square
	var _CamW = _CamX2 - _CamX1;
	var _CamH = _CamY2 - _CamY1;
	if(_CamW > _CamH) _CamH = _CamW;
	if(_CamH > _CamW) _CamW = _CamH;
	
	camera_set_view_size(view_camera[4], _CamW, _CamH);		
	
	//centre cam
	camera_set_view_pos(view_camera[4], _CamX1, _CamY1);
	
}
