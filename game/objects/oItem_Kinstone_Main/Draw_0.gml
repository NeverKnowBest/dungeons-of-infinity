if(State == KinstoneState.TreasurePoof || State == KinstoneState.TreasureLight || State == KinstoneState.FuseDone) exit;

if(State == KinstoneState.Fuse || State == KinstoneState.FuseMerge || State == KinstoneState.TreasureDrop ){
	
	if(!MergeConnected) draw_sprite(sShadow_Large, 0, BaseX_Other, BaseY_Other);
	draw_sprite(sItem_Kinstone, image_index, BaseX_Other, SpriteY_Other);
}

if(State == KinstoneState.TreasureDrop || MergeConnected){
	draw_sprite(sShadow_Large, 0, BaseX - 3, BaseY);
}else{
	draw_sprite(sShadow_Large, 0, BaseX, BaseY);	
}

draw_sprite(sprite_index, image_index, BaseX, SpriteY);
