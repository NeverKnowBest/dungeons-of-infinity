// Weather (castle rooftops pilot): rain, splashes, blowing leaves, lightning with thunder and the night tint over the
// screen, made by oWeather for every level whose sheet has a Weather struct (LevelDef.Weather, __Levels). The intro
// (oIntro) starts it itself, where it used to set up its own rain, so the rainy night of the run's start stays the same.

/// The fields a level's Weather struct may give; the ones it leaves out take these
function Weather_Defaults(){
	return {
		Rain : true,			// rain drops and splashes over the camera, and the rain sound
		Leaves : false,			// leaves blowing in from the top (the intro)
		Lightning : true,		// the screen flashes white for 2 or 3 frames every 30 to 180
		Thunder : false,		// Sound_Thunder a few frames after each flash (ALttP plays it on frame 36 of the flash cycle)
		ThunderDelay : 12,
		ThunderGain : 0.6,
		Tint : true,			// the dark blue night tint over the screen ("Night" is a macro, __Chess)
		Volume : 0.3			// of the rain sound
	};
}

/// Makes the level's weather if its sheet has one and it is not there yet; returns the instance or noone
function Weather_Start(){
	if(LevelDef.Weather == undefined) return noone;
	if(instance_exists(oWeather)) return instance_find(oWeather, 0);
	Test_Event("weather level=" + string(LevelDef.Index) + " " + json_stringify(LevelDef.Weather));
	return instance_create_depth(-100, -100, layer_get_depth("System") + 1, oWeather);	// drawn under oIntro's fade from black
}

/// No more flashes (they look glitchy while the screen fades out)
function Weather_StopLightning(){
	with(oWeather){
		alarm[1] = -1;
		alarm[2] = -1;
		alarm[6] = -1;
		global.GlobalLighting = true;
	}
}
