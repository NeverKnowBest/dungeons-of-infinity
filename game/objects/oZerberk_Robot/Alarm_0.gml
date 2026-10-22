// Feather disable GM2064
/// @description Shoot

if(oZerberk_Hero.Dead) exit;

audio_play_sound(Sound_Zerberk_Robot_Laser, 0.5, false);
	
Shooting = true;

var _AlarmMin = 60 - min(2 + (ceil(oArcade_Zerberk.Level / 3) * 2), 30);
var _AlarmMax = 150 - min(5 + (ceil(oArcade_Zerberk.Level / 3) * 5), 100);
alarm[0] = irandom_range(_AlarmMin, _AlarmMax);	

var _Dir = (round(HeroDir / 45) * 45) mod 360;

switch(_Dir){
	case 0:
		instance_create_layer(x + 4, y - 10, layer, oZerberk_Laser, {image_index : 4, vx : LaserV, vy : 0, From : 1});
		break;
	
	case 45:
		instance_create_layer(x + 3, y - 11, layer, oZerberk_Laser, {image_index : 7, vx : LaserV * .75, vy : -LaserV * .75, From : 1});	
		break;
	
	case 90:
		instance_create_layer(x, y - 13, layer, oZerberk_Laser, {image_index : 6, vx : 0, vy : -LaserV, From : 1});		
		break;
	
	case 135:
		instance_create_layer(x - 3, y - 11, layer, oZerberk_Laser, {image_index : 5, vx : -LaserV * .75, vy : -LaserV * .75, From : 1});
		break;
	
	case 180:
		instance_create_layer(x - 4, y - 10, layer, oZerberk_Laser, {image_index : 4, vx : -LaserV, vy : 0, From : 1});
		break;
	
	case 225:
		instance_create_layer(x - 3, y - 8, layer, oZerberk_Laser, {image_index : 7, vx : -LaserV * .75, vy : LaserV * .75, From : 1});
		break;
	
	case 270:
		instance_create_layer(x, y - 4, layer, oZerberk_Laser, {image_index : 6, vx : 0, vy : LaserV, From : 1});
		break;
		
	case 315:
		instance_create_layer(x + 2, y - 8, layer, oZerberk_Laser, {image_index : 5, vx : LaserV * .75, vy : LaserV * .75, From : 1});
		break;
		
}
