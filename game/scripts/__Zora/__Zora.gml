
function Zora_Splash(){

	var Splashes = 8;
	var SplashAngleDiff = 360 / Splashes;

	for(i = 0; i < Splashes; i++){
		var _Angle = i * SplashAngleDiff;
		var _x = x + lengthdir_x(16, _Angle);
		var _y = y + lengthdir_y(16, _Angle);
		instance_create_layer(_x, _y, "Objs_" + FloorLevelStr, oZoraSplash, {Angle : _Angle})
	}

	instance_create_layer(x, y, "Objs_" + FloorLevelStr, oZora_SplashLarge);
	
	audio_play_sound(Sound_Water_Zora, 1, false);
	
}