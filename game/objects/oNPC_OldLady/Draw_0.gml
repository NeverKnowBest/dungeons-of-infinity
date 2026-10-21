PixelRender(true, true, false, noone, 0, false, []);

if(State == NPCState_OldLady.Farewell && DeliveredLetter) draw_sprite(sItem_Letter, 0, x + 8, y + 26);

draw_self()

shader_reset();

if(TurningGrey){
	PixelRender(true, true, false, noone, 0, false, [],,TurningGreyAlpha);
	draw_sprite(sprite_index, 3, x, y);
	shader_reset();
}



//draw_text(x, y, string(State));

//DrawMask();