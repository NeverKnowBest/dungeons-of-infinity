Enemy_DrawShadow();

Enemy_PixelRender(true, sEnemy_Soldier_Palette, ColorIndex);

draw_self();

draw_sprite(HeadSpr, HeadIndex, x, y - 10);

shader_reset();	

//DrawMask();
//draw_set_font(global.Font_Small);
//draw_text(x, y, "EI:" + string(Energy))
//draw_text(x, y+10, "E:" + string(Energy))
//draw_text(x, y+20, "EM:" + string(EnergyMax))


//draw_rectangle(global.SightX1, global.SightY1, global.SightX2, global.SightY2, true);
//draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);