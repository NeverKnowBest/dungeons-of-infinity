if(Lit){
	draw_self();
}else{
	PixelRender_Dim(true, true, false, noone, 0, false, []);
	draw_self();
	shader_reset();
}


