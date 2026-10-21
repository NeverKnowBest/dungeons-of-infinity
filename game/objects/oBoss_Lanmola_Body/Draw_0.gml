if(!Draw) exit;

Enemy_DrawShadow();

PixelRender(true, true, false, noone, 0, false, 0);

image_index = (oBoss_Lanmola_C.Hit[ID] ? oBoss_Lanmola_C.FlashFrame : 0);

draw_self();

shader_reset();
