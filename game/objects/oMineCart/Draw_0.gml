PixelRender_Dim(true, true, false, noone, 0, false, []);

if(Dir == DOWN && !DirSwitch) draw_sprite(DwarfSprite, 0, x, y);

if(!DirSwitch) draw_sprite(sprite_index, image_index, x, y);

var _RockY = DirSwitch ? y : y + (image_index >= 1 && image_index < 3 ? 1 : 0);
draw_sprite_ext(RockSprite, RockIndex, x + (Dir == LEFT ? 16 : 0), _RockY, RockDirX, 1, 0, c_white, 1);

if(Dir != DOWN && !DirSwitch) draw_sprite(DwarfSprite, image_index div 2, x, y);

shader_reset();