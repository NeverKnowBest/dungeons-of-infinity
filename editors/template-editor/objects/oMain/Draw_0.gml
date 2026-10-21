//Draw Template No
if(!global.EditMode){
	draw_set_font(fnt_button);
	draw_set_color(make_color_rgb(0,100,200))
	var Templates = array_length(global.Data_RoomTemplates[global.CurrentTemplateSizeID][global.CurrentTemplateTrans]);
	var Str = string(global.CurrentTemplate + 1) + (Templates < 10 ? " / " : "/") + string(Templates);
	var StrW = string_width(Str);
	draw_text((view_xport[1] / 2) + 16 + ((64 - StrW) / 2), 8, Str);
	draw_set_color(c_white);
}

//for(var i = 1; i <= 24; i++){
//	draw_text(5, 30 + (i * 15), string(i) + ": " + string(global.DoorStatus[i]));
//	if(global.DoorStatus[i]) Door_Draw(i);	
//}
//draw_text(0, 0, "counter: " + string(global.tempcounter));

//draw_text(30, 1100, string(mouse_x) + "," + string(mouse_y));
//draw_text(600,330, string(window_view_mouse_get_x(1)) + "," + string(window_view_mouse_get_y(1)));
//draw_text(600,360, "Cam:" + string(camera_get_view_x(view_camera[1])) + "," + string(camera_get_view_y(view_camera[1])));

//draw_text(5, 5, "FPS: " + string(round(fps_real))); 
//draw_text(5, 50, "Edit Mode: " + string(global.Data_RoomTemplates[global.CurrentTemplate].EditMode));