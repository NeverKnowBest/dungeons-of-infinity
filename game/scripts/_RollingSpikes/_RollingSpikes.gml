function RollingSpikes_SetMaskSprite(){

	var MaskSurface = surface_create(W, H);
	surface_set_target(MaskSurface);
	draw_clear_alpha(c_white, 1);
	surface_reset_target();
	MaskSprite = sprite_create_from_surface(MaskSurface, 0, 0, W, H, false, false, 0, 0);
	sprite_collision_mask(MaskSprite, false, 0, 0, 0, W - 1, H - 1, bboxkind_rectangular, 0);
	surface_free(MaskSurface);
	mask_index = MaskSprite;
	
}