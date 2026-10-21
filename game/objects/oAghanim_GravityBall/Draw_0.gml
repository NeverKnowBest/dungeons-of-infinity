if(Init && oBoss_Aghanim.alarm[6] > 7){
	
	PixelRender(false, false, true, sPalette_Aghanim_EnergyBall, oBoss_Aghanim.EnergyBall_PalIndex, false, 0);
	draw_sprite(sEnergyBall, 0, x, y);
	shader_reset();
	
}

draw_self();