

function CRT_Do(Surface, SurfaceX, SurfaceY, Sizes, Radial_Distortion_Use, Radial_Distortion_Amount, Border_Use, Border_CornerSize, Border_CornerSmoothness, Scanlines_Use, RGBSep_Use, Noise_Use, Noise_Strength) {

	shader_set(shdCRT);
	
	shader_set_uniform_f(global.uni_crt_sizes,                Sizes[0], Sizes[1], Sizes[2], Sizes[3]);
		
	//shader_set_uniform_f(global.uni_brightness,			   clamp(Brightness, 0, 2));
		
	shader_set_uniform_f(global.uni_use_radial_distortion,    Radial_Distortion_Use);
	shader_set_uniform_f(global.uni_radial_distortion_amount, clamp(Radial_Distortion_Amount, -2, 2));  
	  
	shader_set_uniform_f(global.uni_use_border,               Border_Use);
	shader_set_uniform_f(global.uni_border_corner_size,       Border_CornerSize);
	shader_set_uniform_f(global.uni_border_corner_smoothness, Border_CornerSmoothness);
		
	shader_set_uniform_f(global.uni_use_scanlines,            Scanlines_Use);
		
	shader_set_uniform_f(global.uni_use_RGB_separation,       RGBSep_Use);
		
	shader_set_uniform_f(global.uni_use_noise,				   Noise_Use);
	shader_set_uniform_f(global.uni_noise_strength,		   clamp(Noise_Strength, 0, 1));
	shader_set_uniform_f(global.uni_timer, get_timer());
	
	draw_surface(Surface, SurfaceX, SurfaceY);

	shader_reset();
	
}

function CRT_Do_Stretch(Surface, SurfaceX, SurfaceY, StretchW, StretchH, Sizes, Radial_Distortion_Use, Radial_Distortion_Amount, Border_Use, Border_CornerSize, Border_CornerSmoothness, Scanlines_Use, RGBSep_Use, Noise_Use, Noise_Strength) {

	shader_set(shdCRT);
	
	shader_set_uniform_f(global.uni_crt_sizes,                Sizes[0], Sizes[1], Sizes[2], Sizes[3]);
		
	//shader_set_uniform_f(global.uni_brightness,			   clamp(Brightness, 0, 2));
		
	shader_set_uniform_f(global.uni_use_radial_distortion,    Radial_Distortion_Use);
	shader_set_uniform_f(global.uni_radial_distortion_amount, clamp(Radial_Distortion_Amount, -2, 2));  
	  
	shader_set_uniform_f(global.uni_use_border,               Border_Use);
	shader_set_uniform_f(global.uni_border_corner_size,       Border_CornerSize);
	shader_set_uniform_f(global.uni_border_corner_smoothness, Border_CornerSmoothness);
		
	shader_set_uniform_f(global.uni_use_scanlines,            Scanlines_Use);
		
	shader_set_uniform_f(global.uni_use_RGB_separation,       RGBSep_Use);
		
	shader_set_uniform_f(global.uni_use_noise,				   Noise_Use);
	shader_set_uniform_f(global.uni_noise_strength,		   clamp(Noise_Strength, 0, 1));
	shader_set_uniform_f(global.uni_timer, get_timer());
	
	draw_surface_stretched(Surface, SurfaceX, SurfaceY, StretchW, StretchH);

	shader_reset();
	
}

