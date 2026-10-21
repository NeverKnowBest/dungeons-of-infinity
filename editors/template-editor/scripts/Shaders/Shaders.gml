function SetBrightness(_brightness){

		shader_set(shd_bright_contrast);
		var shader_param = shader_get_uniform(shd_bright_contrast, "brightness_amount");
		shader_set_uniform_f(shader_param, _brightness);
		
		
}

