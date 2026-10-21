PixelRender(true, true, false, noone, 0, false, []);

draw_sprite(sShadow_Large, 0, x, y - 1);

draw_self();

shader_reset();

//DrawMask();
//draw_text(x, y, "DI: " + string(DialogueIndex))