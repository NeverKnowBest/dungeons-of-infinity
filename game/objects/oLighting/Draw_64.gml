if(!global.Lighting) exit;

if(!surface_exists(global.Surface_Canvas)) global.Surface_Canvas = surface_create(1024, 896);
//if(!surface_exists(global.Surface_Canvas2)) global.Surface_Canvas2 = surface_create(256, 224);

surface_set_target(global.Surface_Canvas);
draw_clear_alpha(c_black,0);


Lighting_SetAmbiance(0.0, 0.0, 0.0);
//Lighting_SetAmbiance(0.015,0.015,0.05);
//Lighting_SetAmbiance(0.2,0.1,0.1);


shader_set(shdLighting);

shader_set_uniform_i(global.Uniform_LightCount, global.Lights);
	
shader_set_uniform_f_array(global.Uniform_LightPos, global.LightData_Pos);
shader_set_uniform_f_array(global.Uniform_LightCol, global.LightData_Col);
shader_set_uniform_f_array(global.Uniform_LightParams, global.LightData_Params);
//shader_set_uniform_f(global.Uniform_LightCam, oCamera.CamX, oCamera.CamY);
shader_set_uniform_f(global.Uniform_LightAmbiance, global.Ambiance_R, global.Ambiance_G, global.Ambiance_B);


draw_surface(application_surface, 0, 0);

shader_reset();

surface_reset_target();



//surface_set_target(global.Surface_Canvas2);
//draw_clear_alpha(c_black,0);

//Lighting_SetAmbiance(0.15,0.15,0.15);
//shader_set(shdLightingAmb);
//shader_set_uniform_f(global.Uniform_LightAmbiance, global.Ambiance_R, global.Ambiance_G, global.Ambiance_B);
//draw_tilemap(global.TMID_Ceiling, -oCamera.CamX, -oCamera.CamY)
//shader_reset();




//surface_reset_target();

//surface_set_target(global.Surface_Canvas);
//draw_surface_stretched(global.Surface_Canvas2, 0, 0, 1024, 896);	

//surface_reset_target();

//surface_set_target(application_surface);
draw_clear_alpha(c_black,0);
draw_surface(global.Surface_Canvas, 0, 0);

//surface_reset_target();

//draw_surface_stretched(global.Surface_Canvas, 0, 0, 1024, 896);	

//draw_sprite(oLink.sprite_index, oLink.image_index, 80, 80)

//draw_text(50,50, "FlDist:" + string(FlickerDist));
//draw_text(50,70, "FlDir:" + string(FlickerDir));


