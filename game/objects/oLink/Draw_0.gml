//DrawMask();
//exit;

if(global.MosaicDo) exit;

if(HitFlashingStatus) exit;


//Use surface if descending so we can dim the sprite, something we can't do because of the shader
var LinkSpr;
if(State == LinkState.Descending){
	LinkSpr = surface_create(sprite_width, sprite_height);	
	surface_set_target(LinkSpr);
	draw_clear_alpha(c_black, 0.0);	
}


Link_PixelRender();


if(State != LinkState.Descending && State != LinkState.Falling && !InWater){
	draw_sprite(sShadow_Large, 0, x, y);
}


//draw certain items in front of link when facing up
if(ShieldDir == UP) Shield_Draw();

if(Facing == UP){
	
	switch(State){

		case LinkState.Bow:
			draw_sprite_ext(BowSprite, 2, x - 12, y - 8, 1, -1, 0, c_white, 1.0);		
			break;
		
		//case LinkState.Rod:
		//	draw_sprite(RodSpr[UP][RodIndex], min(image_index, 2), x - 10, y - 28);
		//	break;
		
	}
	
}

draw_set_alpha(0.5);
if(State == LinkState.Descending)
	draw_sprite(sprite_index, image_index, sprite_xoffset, sprite_yoffset);
else{
	
	if(!Cape) draw_sprite(sprite_index, image_index, x, y);

}
draw_set_alpha(1);

shader_reset();

PixelRender(Lighting, Lighting, false, noone, 0, false, 0);
//star was affecting InWater color, so seperate render
if(InWater) draw_sprite(global.InWaterSprite, global.InWaterImgIndex, x, y);

shader_reset();

Link_PixelRender();

if(ShieldDir != UP) Shield_Draw();
	

if(Facing != UP){
	switch(State){
		
		case LinkState.Bow:
			
			switch(image_index){
				case 0:
					switch(Facing){
						case LEFT:
							draw_sprite_ext(BowSprite, 0, x + 5, y - 10, -1, 1, 0, c_white, 1.0);
							break;
						case RIGHT:
							draw_sprite(BowSprite, 0, x - 5, y - 10);
							break;
						case DOWN:
							draw_sprite(BowSprite, 1, x + 2, y - 12);
							break;

					}
					break;
				default:
					switch(Facing){
						case LEFT:
							draw_sprite_ext(BowSprite, 1, x - 4, y - 14, -1, 1, 0, c_white, 1.0);
							break;
						case RIGHT:
							draw_sprite(BowSprite, 1, x + 4, y - 14);
							break;
						case DOWN:
							draw_sprite(BowSprite, 2, x - 6, y - 7);
							break;
					}
			
					break;
			}
			break;
	
		//case LinkState.Rod:
		//	switch(Facing){
		//		case LEFT:
		//			draw_sprite(RodSpr[LEFT][RodIndex], min(image_index, 2), x - 19, y - 24);
		//			break;
		//		case RIGHT:
		//			draw_sprite(RodSpr[RIGHT][RodIndex], min(image_index, 2), x - 2, y - 24);
		//			break;
		//		case DOWN:
		//			draw_sprite(RodSpr[DOWN][RodIndex], min(image_index, 2), x, y - 26);
		//			break;

		//	}
		//	break;
	}
}


var c;
if(State == LinkState.Descending){
	//progressively dim the sprite when going down
	surface_reset_target();
	if(DescendingPhase == 1) c = 255 - (image_index * 10);
	else c = 80 + (image_index * 10);
	//For some reason, the surface is pushed 1 pixel when DescendingPhase == 1 && DescendingLocation == BOTTOM, so subtract 1 if that's the case
	draw_surface_ext(LinkSpr, x - sprite_xoffset, y - sprite_yoffset - (DescendingPhase == 1 && DescendingLocation == BOTTOM ? 1 : 0), 1, 1, 0, make_color_rgb(c, c, c), 1);
	surface_free(LinkSpr);
}


shader_reset();

if(DEBUG){
	
	if(global.ShowLinkMask) DrawMask(,0.5);
	
	//draw_text(x, y, string(floor(image_index)));
	//draw_text(x, y + 8, string(SwordCharge));
	//draw_rectangle(global.CurrentRoom.x + 48, global.CurrentRoom.y + 48, global.CurrentRoom.x + 48 + global.CurrentRoom.width - 96, global.CurrentRoom.y + 48 + global.CurrentRoom.height - 96, true);

	//draw_circle(x, y, 32, true);

}


