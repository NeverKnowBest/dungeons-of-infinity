Enemy_PixelRender(true, sEnemy_Soldier_Palette, ColorIndex);

draw_sprite(sShadow_Large, 0, x, y);

draw_self();

if(Dir == UP){
	with(WeaponInst) event_perform(ev_draw, 0); //draw sword here so that it allows the same depth draw as soldier
}

draw_sprite(HeadSpr, HeadIndex, x, y - 8);

if(Dir == LEFT)	draw_sprite(sSoldierArm, 0, x, y - 6);
if(Dir == RIGHT) draw_sprite(sSoldierArm_Mirrored, 0, x, y - 6);

if(Dir != UP){
	with(WeaponInst) event_perform(ev_draw, 0); //draw sword here so that it allows the same depth draw as soldier
}

shader_reset();	
