draw_sprite_stretched(Active ? sMenu : sMenu_Innactive, 0, x, y, sprite_width, sprite_height);

draw_set_font(oMenu.TitleFont);
draw_set_halign(fa_center);
draw_text(x + (sprite_width / 2), y + 8.5, Title);
draw_set_halign(fa_left);