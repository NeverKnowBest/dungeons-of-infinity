if(!ShowHead) exit;

Moldorm_PixelRender();

draw_self();

var A1 = Dir + 20;
var A2 = Dir - 20;
	
if(State != EnemyState.Walking){
	var Eye1A = EyeA;
	var Eye2A = EyeA;
}else{
	var Eye1A = A1;
	var Eye2A = A2;
}
draw_sprite_ext(sBoss_Moldorm_Eye, 0, x + lengthdir_x(16, A1), y + lengthdir_y(16, A1), 1, 1, Eye1A, c_white, 1);
draw_sprite_ext(sBoss_Moldorm_Eye, 0, x + lengthdir_x(16, A2), y + lengthdir_y(16, A2), 1, 1, Eye2A, c_white, 1);


shader_reset();	

//draw_set_font(global.Font_Small);
//draw_text(x, y, "EI:" + string(EnergyIndex))
//draw_text(x, y+10, "E:" + string(Energy))
//draw_text(x, y+20, "EM:" + string(EnergyMax))

//draw_set_color(c_white);
//draw_text(x, y, "E: " + string(Energy));
//if(instance_exists(oBoss_Moldorm_Tail))
//	draw_text(x, y, string(oBoss_Moldorm_Tail.LargeBodyCollision));