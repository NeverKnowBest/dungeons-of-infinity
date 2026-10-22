// Feather disable GM2064

if(global.Arcade_ActiveInst.State != ArcadeState.GameStarted && global.Arcade_ActiveInst.State != ArcadeState.Special) exit;

vx = 0;
vy = 0;

if(Shooting || Dead) exit;

if(MiniArcade){
	
	if(oZerberk_MiniArcade_Game.State == MiniArcadeState.Start){
		if(input_check_pressed("menu_access")){
			input_clear_momentary(true);
			instance_destroy(MiniAracdeInst);
			MiniArcade = false;
			global.Arcade_ActiveInst.State = ArcadeState.GameStarted;
		}
		exit;
	}
	
	
	
}


	

var KeyUp = input_check("up");
var KeyDown = input_check("down");
var KeyLeft = input_check("left");
var KeyRight = input_check("right");		

				


if(KeyLeft){
	vx = -Speed;
	Dir = -1;
}
if(KeyRight){
	vx = Speed
	Dir = 1;
}
if(KeyUp){
	vy = -Speed;
}
if(KeyDown){
	vy = Speed;
}

if(input_check_pressed("sword")){
	
	sprite_index = sZerberk_Hero_Shooting;
	
	audio_play_sound(Sound_Zerberk_Hero_Laser, 0.5, false);
	
	Shooting = true;
	alarm[0] = 16;		

	if(KeyRight && KeyDown){
		image_index = 3;
		instance_create_layer(x + 2, y - 11, layer, oZerberk_Laser, {image_index : 1, vx : LaserV, vy : LaserV, From : 0});
		exit;
	}
	if(KeyRight && KeyUp){
		image_index = 1;
		instance_create_layer(x + 2, y - 13, layer, oZerberk_Laser, {image_index : 3, vx : LaserV, vy : -LaserV, From : 0});
		exit;
	}
	if(KeyLeft && KeyDown){
		image_index = 3;
		instance_create_layer(x - 3, y - 11, layer, oZerberk_Laser, {image_index : 3, vx : -LaserV, vy : LaserV, From : 0});
		exit;
	}
	if(KeyLeft && KeyUp){
		image_index = 1;
		instance_create_layer(x - 3, y - 13, layer, oZerberk_Laser, {image_index : 1, vx : -LaserV, vy : -LaserV, From : 0});
		exit;
	}
	
	if(KeyRight){
		image_index = 2;
		instance_create_layer(x + 4, y - 12, layer, oZerberk_Laser, {image_index : 0, vx : LaserV, vy : 0, From : 0});
		exit;
	}
	if(KeyLeft){
		image_index = 2;
		instance_create_layer(x - 5, y - 12, layer, oZerberk_Laser, {image_index : 0, vx : -LaserV, vy : 0, From : 0});
		exit;
	}
	if(KeyUp){
		image_index = 0;
		instance_create_layer(x + (Dir == 1 ? 2 : -3), y - 16, layer, oZerberk_Laser, {image_index : 2, vx : 0, vy : -LaserV, From : 0});
		exit;
	}
	if(KeyDown){
		image_index = 4;
		instance_create_layer(x + (Dir == 1 ? 2 : -3), y - 7, layer, oZerberk_Laser, {image_index : 2, vx : 0, vy : LaserV, From : 0});
		exit;
	}

	if(Dir == 1){
		image_index = 2;
		instance_create_layer(x + 4, y - 12, layer, oZerberk_Laser, {image_index : 0, vx : LaserV, vy : 0, From : 0});
		exit;		
	}else{
		image_index = 2;
		instance_create_layer(x - 5, y - 12, layer, oZerberk_Laser, {image_index : 0, vx : -LaserV, vy : 0, From : 0});
		exit;		
	}
}


if(vx == 0 && vy == 0){
	sprite_index = sZerberk_Hero_Standing;
}else{
	if(vx != 0 && vy != 0){
		vx *= 0.8;
		vy *= 0.8;
	}
	sprite_index = sZerberk_Hero_Running;
	x += vx;
	y += vy;
}

if(Zerberk_WallCollisionX(id) || Zerberk_WallCollisionY(id) || place_meeting(x, y, oZerberk_Robot)){
	Zerberk_Hero_Death();
	exit;	
}

var MiniArcadeCollide = place_meeting(x, y, oZerberk_MiniArcade);
if(MiniArcadeCheck && MiniArcadeCollide){
	MiniAracdeInst = instance_create_layer(0, 0, layer, oZerberk_MiniArcade_Game);
	MiniAracdeInst.depth = depth - 10;
	MiniArcade = true;
	MiniArcadeCheck = false;
	sprite_index = sZerberk_Hero_Standing;
	global.Arcade_ActiveInst.State = ArcadeState.Special;
}

if(!MiniArcadeCheck && !MiniArcadeCollide){
	
	if(MiniAracdeInst != noone){
		instance_destroy(MiniAracdeInst);
		global.Arcade_ActiveInst.State = ArcadeState.GameStarted;
	}
	
	MiniArcade = false;			
	MiniArcadeCheck = true;
	
}