if(global.LinkDead) exit;


Enemy_PixelRender();


if(Angle == 0 || Angle == 180){
	var Spr = sEnemy_Pikit_Tongue_H;
	var D = (Angle == 0 ? 1 : -1);
	var Spread = (Dist / Inc) * 1.6;
	for(var i = 0; i < 4; i++){
		draw_sprite(Spr, 0, StartX + (i * Spread * D), StartY);
	}
}else if(Angle == 45 || Angle == 225){
	var Spr = sEnemy_Pikit_Tongue_DR;
	var D = (Angle == 45 ? 1 : -1);
	var Spread = (Dist / Inc) * 1.2;
	for(var i = 0; i < 4; i++){
		draw_sprite(Spr, 0, StartX + (i * Spread * D), StartY + (i * Spread * -D));
	}
}else if(Angle == 90 || Angle == 270){
	var Spr = sEnemy_Pikit_Tongue_V;
	var D = (Angle == 90 ? -1 : 1);
	var Spread = (Dist / Inc) * 1.6;
	for(var i = 0; i < 4; i++){
		draw_sprite(Spr, 0, StartX, StartY + (i * Spread * D));
	}
}else{
	var Spr = sEnemy_Pikit_Tongue_DL;
	var D = (Angle == 135 ? -1 : 1);
	var Spread = (Dist / Inc) * 1.2;
	for(var i = 0; i < 4; i++){
		draw_sprite(Spr, 0, StartX + (i * Spread * D), StartY + (i * Spread * D));
	}
}


draw_sprite(sprite_index, 0, x, y);

shader_reset();	

//draw_text(x, y, "Fl:" + string(FloorLevel))
//draw_text(x, y + 12, "Ly:" + string(layer))