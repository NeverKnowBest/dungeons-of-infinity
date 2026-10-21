PixelRender(true, true, false, noone, 0, false, []);

//Handle
if(oLink.Facing != UP) draw_sprite_ext(sHookshot_Handle, 0, StartPointX, StartPointY, 1, 1, Dir, c_white, 1);


for(var ChainIndex = 0; ChainIndex < Chains; ChainIndex++){
	
	draw_sprite(sHookshot_Chain, ChainAniFrame, ChainXList[| ChainIndex], ChainYList[| ChainIndex]);
	
}


if(oLink.Facing == UP && y_base > oLink.y - 20){ 
	//when facing up and close to Link, don't draw the hook, this is to prevent the hook from being drawn over link since it's a layer above
	
}else draw_sprite_ext(sprite_index, 0, x, y_base, 1, 1, Dir, c_white, 1);

shader_reset();

