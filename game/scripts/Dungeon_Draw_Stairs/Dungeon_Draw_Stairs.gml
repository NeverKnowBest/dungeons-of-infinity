
function Dungeon_Draw_Stairs(_RoomIndex){

	
	for(var StairIndex = 0; StairIndex < array_length(TemplateRoom.Stairs); StairIndex++){

		var TLCornerX = Room.x + TemplateRoom.Stairs[StairIndex].x;
		var TLCornerY = Room.y + TemplateRoom.Stairs[StairIndex].y;
		var StairGID = TemplateRoom.Stairs[StairIndex].gid;
			
		switch(StairGID){
		
			case TemplateObjGID.StairsT:
				//Stair floors
				DrawTileBlock(global.TMID_Walls_Lower, TLCornerX + 8, TLCornerY, 54, LevelTilesY + 2, 2, 4);			

				var inst = instance_create_layer(TLCornerX + 8, TLCornerY, "Objs_Upper", oWall);
				inst.image_xscale = 2;
				inst.image_yscale = 2;
				inst.FloorLevel = UPPER;
				inst.BlockLink = false;
				inst.BlockProjectiles = false;
				
				var inst = instance_create_layer(TLCornerX + 8, TLCornerY + 16, "Objs_Lower", oWall);
				inst.image_xscale = 2;
				inst.image_yscale = 2;
				inst.FloorLevel = LOWER;
				inst.BlockLink = false;	
				inst.BlockProjectiles = false;
				
				//Stair rail L
				DrawTileBlock(global.TMID_Walls_Lower, TLCornerX, TLCornerY, 50, LevelTilesY + 2, 1, 4);
				var WallInst = instance_create_layer(TLCornerX, TLCornerY, "Objs_Upper", oWall);
				WallInst.image_yscale = 4;
				WallInst.FloorLevel = UPPERLOWER;
			
				
				//Stair rail R
				DrawTileBlock(global.TMID_Walls_Lower, TLCornerX + 24, TLCornerY, 51, LevelTilesY + 2, 1, 4);
				var WallInst = instance_create_layer(TLCornerX + 24, TLCornerY, "Objs_Upper", oWall);
				WallInst.image_yscale = 4;
				WallInst.FloorLevel = UPPERLOWER;


				break;
			
			case TemplateObjGID.StairsB:

				//Stair floors
				DrawTileBlock(global.TMID_Walls_Lower, TLCornerX + 8, TLCornerY, 56, LevelTilesY + 2, 2, 4);
				var inst = instance_create_layer(TLCornerX + 8, TLCornerY, "Objs_Lower", oWall);
				inst.image_xscale = 2;
				inst.image_yscale = 2;
				inst.FloorLevel = LOWER;
				inst.BlockLink = false;
				inst.BlockProjectiles = false;
				
				var inst = instance_create_layer(TLCornerX + 8, TLCornerY + 16, "Objs_Upper", oWall);
				inst.image_xscale = 2;
				inst.image_yscale = 2;
				inst.FloorLevel = UPPER;
				inst.BlockLink = false;
				inst.BlockProjectiles = false;
				
				//Stair rail L
				
				DrawTileBlock(global.TMID_Walls_Lower, TLCornerX, TLCornerY, 52, LevelTilesY + 2, 1, 4);
				var WallInst = instance_create_layer(TLCornerX, TLCornerY, "Objs_Upper", oWall);
				WallInst.image_yscale = 4;
				WallInst.FloorLevel = UPPERLOWER;

				
				//Stair rail R
				DrawTileBlock(global.TMID_Walls_Lower, TLCornerX + 24, TLCornerY, 53, LevelTilesY + 2, 1, 4);
				var WallInst = instance_create_layer(TLCornerX + 24, TLCornerY, "Objs_Upper", oWall);
				WallInst.image_yscale = 4;
				WallInst.FloorLevel = UPPERLOWER;	


				break;

	
		}

		
	}
			
}