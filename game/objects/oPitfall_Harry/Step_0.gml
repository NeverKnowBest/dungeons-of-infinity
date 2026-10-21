
if(Killed || global.Arcade_ActiveInst.State != ArcadeState.GameStarted) exit;

actionMoveLeft = false;
actionMoveRight = false;


if(!actionJumping){
	if(input_check("left")) actionMoveLeft = true;
	if(input_check("right")) actionMoveRight = true;
	if(input_check_pressed("sword")){
		actionJumping = true;
		vy = -1.5;
		audio_play_sound(Pitfall_Sound_Jump, 1, false);
	}
}
	


if(actionMoveRight){
	Dir = 1;
	vx = 1;
	sprite_index = sPitfall_Harry_Running;
}else if(actionMoveLeft){
	Dir = -1
	vx = -1;
	sprite_index = sPitfall_Harry_Running;

}else if(actionJumping){
	vy += 0.1;
	sprite_index = sPitfall_Harry_Jumping;
	
}else{
	sprite_index = sPitfall_Harry_Standing;
	vx = 0;
}

x += vx;
y += vy;

if(x < global.Arcade_ActiveInst.CamXMin + 8) x = global.Arcade_ActiveInst.CamXMin + 8;
if(vy != 0 && y >= global.Arcade_ActiveInst.HarryStartY){
	y = global.Arcade_ActiveInst.HarryStartY;
	actionJumping = false;
	vy = 0;
}



var TreasureInst = instance_place(x, y, oPitfall_Treasure);
if(TreasureInst != noone){
	
	audio_play_sound(Pitfall_Sound_Treasure, 1, false);
	if(audio_is_playing(Pitfall_Music2)){
		audio_stop_sound(global.Arcade_ActiveInst.Music);
		global.Arcade_ActiveInst.Music = audio_play_sound(Pitfall_Music1, 0.5, false);
	}
	
	global.Arcade_ActiveInst.Score+=TreasureInst.Points;
	
	instance_destroy(TreasureInst);	
	
}

var EnemyInst = instance_place(x, y, oPitfall_Enemy);
if(EnemyInst != noone){
	
	audio_stop_sound(global.Arcade_ActiveInst.Music);
	audio_play_sound(Pitfall_Sound_Killed, 1, false);
	sprite_index = sPitfall_Harry_Standing;
	KilledFlashCounter = 12;
	alarm[0] = 10;
	Killed = true;	
	
}
