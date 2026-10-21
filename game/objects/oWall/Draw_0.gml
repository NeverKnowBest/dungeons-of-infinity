draw_sprite_ext(FloorLevel == UPPER ? sWallMask : (FloorLevel == LOWER ? sWallMask_Lower : sWallMask_UpperLower), 0, x, y, image_xscale, image_yscale, 0, c_white, 1);

//draw_text(ObjCenterX(), ObjCenterY(), string(BlockLink))
//draw_text(ObjCenterX(), ObjCenterY(), string(FloorLevel))
draw_text(ObjCenterX(), ObjCenterY(), string(BlockItems))