if(ShowBeam){
	
	F = floor(Frame);

	if(F == 1){
		draw_sprite(sFinalBossGate_Beam, 0, BeamX, BeamY);
		draw_sprite(sFinalBossGate_Beam, 0, BeamX + 16, BeamY);
	
		draw_sprite_ext(sFinalBossGate_Beam, 0, Beam2X, BeamY, -1, 1, 0, c_white, 1);
		draw_sprite_ext(sFinalBossGate_Beam, 0, Beam2X + 16, BeamY, -1, 1, 0, c_white, 1);
	
	}else if(F == 3){
		draw_sprite(sFinalBossGate_Beam, 1, BeamX, BeamY);
		draw_sprite(sFinalBossGate_Beam, 1, BeamX + 16, BeamY);

		draw_sprite_ext(sFinalBossGate_Beam, 1, Beam2X, BeamY, -1, 1, 0, c_white, 1);
		draw_sprite_ext(sFinalBossGate_Beam, 1, Beam2X + 16, BeamY, -1, 1, 0, c_white, 1);
	}
	
	PixelRender(true, true, false, noone, 0, false, []);
	
	draw_sprite(sFinalBossGate_Pole, F div 2, x, y);
	draw_sprite(sFinalBossGate_Pole, F div 2, x + PoleDist, y);
	
	shader_reset();
	
	draw_sprite(sFinalBossGate_Bat, F div 2, BatX, y - 2);
	
}else{
	
	PixelRender(true, true, false, noone, 0, false, []);
	
	draw_sprite(sFinalBossGate_Pole, 0, x, y);
	draw_sprite(sFinalBossGate_Pole, 0, x + PoleDist, y);
	
	shader_reset();
	
}

