Enemy_DrawShadow();

Enemy_PixelRender(true, sEnemy_Soldier_Palette, ColorIndex);

if(Dir == UP){
	with(WeaponInst) event_perform(ev_draw, 0); //draw sword here so that it allows the same depth draw as soldier
}

draw_self();

draw_sprite(HeadSpr, HeadIndex, x, y - 6 - (floor(image_index) mod 2) - (Dir == LEFT || Dir == RIGHT ? 2 : 0));

shader_reset();	

Obj_DrawInWater();

Enemy_PixelRender(true, sEnemy_Soldier_Palette, ColorIndex);

if(Dir != UP){
	with(WeaponInst) event_perform(ev_draw, 0); //draw sword here so that it allows the same depth draw as soldier
}

shader_reset();	

//DrawMask();
//draw_set_font(global.Font_Small);
//draw_text(x, y, "EI:" + string(EnergyIndex))
//draw_text(x, y+10, "E:" + string(Energy))
//draw_text(x, y+20, "EM:" + string(EnergyMax))
