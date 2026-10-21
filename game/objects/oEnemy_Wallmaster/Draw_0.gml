if(SpawnWait || Invisible) exit;

Enemy_DrawShadow(,Alpha);

Enemy_PixelRender(,,,,Alpha);

draw_sprite_ext(sprite_index, image_index, x, y, Dir, 1, 0, c_white, 1);

shader_reset();

//var _y = y
//draw_text(x, _y, string(RoomIndexTL));  _y += 12;
//draw_text(x, _y, string(RoomIndexTR));  _y += 12;
//draw_text(x, _y, string(RoomIndexBL));  _y += 12;
//draw_text(x, _y, string(RoomIndexBR));  _y += 12;