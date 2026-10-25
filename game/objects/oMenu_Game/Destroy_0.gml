// Character previews built by the wardrobe menu
if(variable_instance_exists(id, "CharPreview") && sprite_exists(CharPreview)) sprite_delete(CharPreview);

global.MenuInst = noone;
global.Paused = false;
if(!global.LinkDead){
	with(oLink) UpdateState(LinkState.Standing);
}

if(audio_is_playing(oLink.LowHealthSound)) audio_resume_sound(oLink.LowHealthSound);

Time_PauseEnd();