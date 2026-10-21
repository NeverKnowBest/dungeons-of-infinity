/// @description Star color cycle

if(oLink.State == LinkState.Star){
	
	StarColorIndex = (StarColorIndex + 1) mod array_length(StarColors);
	StarLightIndex = (StarLightIndex + 0.5) mod array_length(StarLightColors);

	repeat(4){
		instance_create_layer(x + irandom_range(-StarSparkleDist, StarSparkleDist), y + irandom_range(-StarSparkleDist, StarSparkleDist), "Objs_" + GetFloorLevelString(FloorLevel), oSparkle);
	}

	alarm[7] = StarColorDelay;
	
}

//start fading song about 90 frames from ending
if(alarm[8] <= 90){
	var RoomSongIndex = global.Level.Rooms[global.CurrentRoomIndex].RoomSongIndex;
	Music_Fade(0, 90, RoomSongIndex);
}