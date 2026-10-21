PixelRender_Dim(true, true, false, noone, 0, oBoss_Moldorm.State == EnemyState.Hit || oBoss_Moldorm.State == EnemyState.Killed, global.KnockBackColors[oBoss_Moldorm.KnockBackColorFrame]);

draw_self();

shader_reset();	

//DrawMask();

//draw_set_color(c_white);
//draw_set_font(global.Font_Small)
//draw_text(x, y, "HIT_STR: " + string(Hit_Started));
