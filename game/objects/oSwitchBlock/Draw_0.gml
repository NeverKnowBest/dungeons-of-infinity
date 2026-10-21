PixelRender_Dim(true, true, true, sPalette_SwitchBlock, Color, false, []);

if(Corner_TL) draw_sprite(sprite_index, ImgIndex, X1, Y1);
if(Corner_TR) draw_sprite(sprite_index, ImgIndex, X2 - 15, Y1);
if(Corner_BL) draw_sprite(sprite_index, ImgIndex, X1, Y2 - 15);
if(Corner_BR) draw_sprite(sprite_index, ImgIndex, X2 - 15, Y2 - 15);

if(Segment_L) draw_sprite_stretched(sprite_index, ImgIndex, X1, Segment_L_Y, 16, Segment_L_H);	
if(Segment_R) draw_sprite_stretched(sprite_index, ImgIndex, X2 - 15, Segment_R_Y, 16, Segment_R_H);	
if(Segment_T) draw_sprite_stretched(sprite_index, ImgIndex, Segment_T_X, Y1, Segment_T_W, 16);	
if(Segment_B) draw_sprite_stretched(sprite_index, ImgIndex, Segment_B_X, Y2 - 15, Segment_B_W, 16);	


shader_reset();

