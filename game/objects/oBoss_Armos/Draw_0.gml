
PixelRender(true, true, false, noone, 0, false, 0);
var ShadowFrame = (z <= 7 ? 0 : (z <= 14 ? 1 : (z <= 21 ? 2 : 3)));
draw_sprite(sShadow_Armos, ShadowFrame, x + oBoss_Armos_C.ShakeOffset, y_base);
shader_reset();

Enemy_PixelRender();
draw_sprite(sBoss_Armos, image_index, x + oBoss_Armos_C.ShakeOffset, y);
shader_reset();



	//draw_set_alpha(0.5);
	//draw_set_color(c_red);
	//draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
	//draw_set_color(c_white);
	//draw_set_alpha(1);

//var _y = y + 8;
//draw_text(x - 4, _y, string(Energy)); _y+=8;
//draw_text(x - 4, _y, string(oBoss_Armos_C.State)); _y+=8;
//draw_text(x - 4, _y, string(State)); _y+=8;
//draw_text(x - 4, _y, string(id)); _y+=8;
//draw_text(x - 4, _y, string(oBoss_Armos_C.LastArmos_Inst)); _y+=8;

//draw_set_font(global.Font_Small);
//draw_text(x, y, "EI:" + string(EnergyIndex))
//draw_text(x, y+10, "E:" + string(Energy))
//draw_text(x, y+20, "EM:" + string(EnergyMax))

//draw_circle(WaypointX, WaypointY, 5, false);


