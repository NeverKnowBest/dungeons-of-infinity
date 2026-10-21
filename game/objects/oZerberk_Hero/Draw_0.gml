if(global.Arcade_ActiveInst.State != ArcadeState.GameStarted && global.Arcade_ActiveInst.State != ArcadeState.Special) exit;

surface_set_target(global.Arcade_ActiveInst.GameSurface);

var _x = floor(x);
var _y = floor(y);

draw_sprite_ext(sprite_index, image_index, _x, _y, Dir, 1, 0, c_white, 1);

surface_reset_target();