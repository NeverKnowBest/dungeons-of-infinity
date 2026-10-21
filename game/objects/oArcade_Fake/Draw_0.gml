PixelRender(true, true, false, noone, 0, false, []);

draw_self();

draw_sprite(sArcadeFront, Front, x, y);

draw_sprite(MiniScreen_Sprite, MiniScreen_SpriteIndex, x - 6, y - 27);

draw_sprite(sShadow_Large, 0, x, PlayerY);
draw_sprite(Player, PlayerImageIndex, x, PlayerY);

shader_reset();