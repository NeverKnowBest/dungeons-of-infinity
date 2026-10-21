
if(keyboard_check_pressed(vk_f1)) Test(0);
if(keyboard_check_pressed(vk_f2)) Test(1);
if(keyboard_check_pressed(vk_f3)) Test(2);
if(keyboard_check_pressed(vk_f4)) Test(3);


if(keyboard_check(vk_escape)) game_end();


if(keyboard_check(vk_control) && keyboard_check_pressed(ord("S"))) Save();



if(++FPS_UpdateCounter mod 30 == 0){
	FPS = fps_real;
	FPS_Updates++;
	FPS_AverageAddition += FPS;
	FPS_Average = FPS_AverageAddition / FPS_Updates;
}


