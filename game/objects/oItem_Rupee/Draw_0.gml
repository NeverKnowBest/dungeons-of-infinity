PixelRender_Dim(true, true, true, sPalette_Rupee, PaletteIndex, false, noone, false, 0);

if(From == ContainerType.Pot) draw_sprite(sShadow_Small, 0, x, y);

//adding floor makes it less smooth and more like the real game, looks too smooth otherwise
z = floor(SpawnZ);

draw_sprite(sprite_index, image_index, x, y - z);

if(ShowValue){	
	var ItemNumberIndex = GetItemNumberIndex(Value);
	draw_sprite(sItemNumbers, ItemNumberIndex, x, y - z - 6); 
}

shader_reset();