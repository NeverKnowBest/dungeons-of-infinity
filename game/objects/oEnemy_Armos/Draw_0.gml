Enemy_DrawShadow();

switch(State){
	default: Enemy_PixelRender(); break;
	case EnemyState.Wake: PixelRender_Dim(true, true, false, noone, 0, true, WakeColors[WakeColorFrame]); break;
}

draw_sprite(sprite_index, image_index, x, y);

shader_reset();	

Obj_DrawInWater();

//var _y = y;
//draw_text(x, y, "vz:" + string(vz)); _y+=10;
//draw_text(x, y + 10, string(Energy)); 
//draw_text(x, _y, "GS:" + string(GravityStatus)); _y+=10;

//draw_set_font(global.Font_Small);
//draw_text(x, y, "EI:" + string(EnergyIndex))
//draw_text(x, y+10, "E:" + string(Energy))
//draw_text(x, y+20, "EM:" + string(EnergyMax))
