
function CopyBlockFromAbsoluteTileset(){

	//Temporary function that copies tiles from all the 'Absolute' tilesets and places them in all coresponding tilesets for each color at a certain position
	
	//Output folder: C:\Users\justi\AppData\Local\Zelda
	
	//Transfer data block
	                                            //StartX, StartY, BlockW, BlockH, DestX, DestY
	
	//=========================== Current Job - Edit for your needs ======================
	Transfer[0] = ds_list_create();	ds_list_add(Transfer[0], 280, 440, 8, 8, 32, 32);
	//Transfer[1] = ds_list_create();	ds_list_add(Transfer[1], 456, 720, 32, 8, 32, 80);
	//Transfer[2] = ds_list_create();	ds_list_add(Transfer[2], 488, 720, 32, 8, 32, 88);
	//Transfer[3] = ds_list_create();	ds_list_add(Transfer[3], 488, 720, 32, 8, 32, 96);
	
	//Transfer[4] = ds_list_create();	ds_list_add(Transfer[4], 488, 688, 16, 8, 40, 72);
	//Transfer[5] = ds_list_create();	ds_list_add(Transfer[5], 504, 688, 16, 8, 40, 80);
	//Transfer[6] = ds_list_create();	ds_list_add(Transfer[6], 488, 704, 16, 8, 40, 88);
	//Transfer[7] = ds_list_create();	ds_list_add(Transfer[7], 504, 704, 16, 8, 40, 96);
	
	//Transfer[8] = ds_list_create();	ds_list_add(Transfer[8], 584, 336, 16, 16, 32, 104);

	var Transfers = 1;
	
	var TilesetName = "Floors_Common";
	//======================================================================================
	
	var TilesetAssetName = "sTiles_" + TilesetName;
	
		
	for(var ColorNoIndex = 0; ColorNoIndex <= 17; ColorNoIndex++){

		if(ColorNoIndex < 10)
			var ColorNum = "0" + string(ColorNoIndex);
		else
			var ColorNum = string(ColorNoIndex);
		
		var ColorSufix = "_Color" + ColorNum;
		var AbsoluteTileset = asset_get_index("sAbsolute" + ColorNum);
		var DestFilename = TilesetName + ColorSufix;
		var DestTileset = asset_get_index(TilesetAssetName + ColorSufix);
		
		var DestTilesetSurface = surface_create(sprite_get_width(DestTileset), sprite_get_height(DestTileset));
		
		for(var TransferIndex = 0; TransferIndex < Transfers; TransferIndex++){
		
			var StartX = Transfer[TransferIndex][| 0];
			var StartY = Transfer[TransferIndex][| 1];
			var BlockW = Transfer[TransferIndex][| 2];
			var BlockH = Transfer[TransferIndex][| 3];
			var DestX = Transfer[TransferIndex][| 4];
			var DestY = Transfer[TransferIndex][| 5];
			// sTiles_Walls_Common_Color00
	
			var FromBlock = surface_create(BlockW, BlockH);

			//draw the block we'll be copying to tileset
			surface_set_target(FromBlock);	
			draw_sprite_part(AbsoluteTileset, 0, StartX, StartY, BlockW, BlockH, 0, 0);
			surface_reset_target()
	
			//Draw the whole tileset to a surface before adding the block
			surface_set_target(DestTilesetSurface);	
			draw_sprite(DestTileset, 0, 0, 0);
			
			draw_surface(FromBlock, DestX, DestY);
			//surface_copy(DestTilesetSurface, DestX, DestY, FromBlock);
			
			surface_reset_target()
			
			surface_free(FromBlock);
			
		}
		
		surface_save(DestTilesetSurface, DestFilename + ".png");
		
		surface_free(DestTilesetSurface);
			
	}
	

}

