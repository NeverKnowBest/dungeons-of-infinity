
function OnStairs(_x, _y){
	
	var TilesY = global.Level.Rooms[global.CurrentRoomIndex].ForcedTheme == -1 ? LevelTilesY + 2 : (6 + global.Level.Rooms[global.CurrentRoomIndex].ForcedTheme * 6);
	if(CollideTileBlock(global.TMID_Walls_Lower, _x, _y, 54, TilesY, 2, 4)) return TOP;
	if(CollideTileBlock(global.TMID_Walls_Lower, _x, _y, 56, TilesY, 2, 4)) return BOTTOM;
	
	return NONE
	
}

function Dungeon_Draw_Stairs(_RoomIndex){
	
	if(!variable_struct_exists(Room.Template, "Stairs")) exit;
	
	var TilesX = 50;
	var TilesY = Room.ForcedTheme == -1 ? LevelTilesY + 2 : (6 + Room.ForcedTheme * 6);
	
	for(var StairIndex = 0; StairIndex < array_length(Room.Template.Stairs); StairIndex++){
		
		var _Stairs = Room.Template.Stairs[StairIndex];
		
		var TLCornerX = Room.x + _Stairs.x;
		var TLCornerY = Room.y + _Stairs.y;

		var _ShortStairs = (_Stairs.height == 24);
		
		switch(_Stairs.gid){
		
			case TemplateObjGID.StairsT:
				//Stair floors
				DrawTileBlock(global.TMID_Walls_Lower, TLCornerX + 8, TLCornerY, TilesX + 4, TilesY, 2, 1);							
				DrawTileBlock(global.TMID_Walls_Lower, TLCornerX + 8, TLCornerY + 8, TilesX + 4, TilesY + (_ShortStairs ? 2 : 1), 2, _ShortStairs ? 2 : 3);
				
				var inst = WallObj_Create("Objs_Upper", TLCornerX + 8, TLCornerY, 2, _ShortStairs ? 1 : 2);
				inst.FloorLevel = UPPER;
				inst.BlockLink = false;
				inst.BlockLinkCarry = false;
				inst.BlockProjectiles = false;
				inst.IsStairs = true;
				
				var inst = WallObj_Create("Objs_Lower", TLCornerX + 8, TLCornerY + (_ShortStairs ? 8 : 16), 2, 2);
				inst.FloorLevel = LOWER;
				inst.BlockLink = false;	
				inst.BlockLinkCarry = false;
				inst.BlockProjectiles = false;
				inst.IsStairs = true;
				
				//Stair rail L

				DrawTileBlock(global.TMID_Walls_Upper, TLCornerX, TLCornerY, TilesX, TilesY, 1, 1);
				DrawTileBlock(global.TMID_Walls_Lower, TLCornerX, TLCornerY + 8, TilesX, TilesY + 1, 1, _ShortStairs ? 2 : 3);
				var WallInst = WallObj_Create("Objs_Upper", TLCornerX, TLCornerY, 1, _ShortStairs ? 3 : 4);
				WallInst.FloorLevel = UPPERLOWER;
				
				//Stair rail R
				DrawTileBlock(global.TMID_Walls_Upper, TLCornerX + 24, TLCornerY, TilesX + 1, TilesY, 1, 1);
				DrawTileBlock(global.TMID_Walls_Lower, TLCornerX + 24, TLCornerY + 8, TilesX + 1, TilesY + 1, 1, _ShortStairs ? 2 : 3);
				var WallInst = WallObj_Create("Objs_Upper", TLCornerX + 24, TLCornerY, 1, _ShortStairs ? 3 : 4);
				WallInst.FloorLevel = UPPERLOWER;


				break;
			
			case TemplateObjGID.StairsB:

				//Stair floors
				DrawTileBlock(global.TMID_Walls_Lower, TLCornerX + 8, TLCornerY, TilesX + 6, TilesY, 2, _ShortStairs ? 2 : 3);
				DrawTileBlock(global.TMID_Walls_Lower, TLCornerX + 8, TLCornerY + (_ShortStairs ? 16 : 24), TilesX + 6, TilesY + 3, 2, 1);
				
				var inst = WallObj_Create("Objs_Lower", TLCornerX + 8, TLCornerY, 2, 2);
				inst.FloorLevel = LOWER;
				inst.BlockLink = false;
				inst.BlockLinkCarry = false;
				inst.BlockProjectiles = false;
				inst.IsStairs = true;
				
				var inst = WallObj_Create("Objs_Upper", TLCornerX + 8, TLCornerY + 16, 2, _ShortStairs ? 1 : 2);
				inst.FloorLevel = UPPER;
				inst.BlockLink = false;
				inst.BlockLinkCarry = false;
				inst.BlockProjectiles = false;
				inst.IsStairs = true;
				
				//Stair rail L
				DrawTileBlock(global.TMID_Walls_Lower, TLCornerX, TLCornerY, TilesX + 2, TilesY, 1, _ShortStairs ? 2 : 3);
				DrawTileBlock(global.TMID_Walls_Upper, TLCornerX, TLCornerY + (_ShortStairs ? 16 : 24), TilesX + 2, TilesY + 3, 1, 1);
				var WallInst = WallObj_Create("Objs_Upper", TLCornerX, TLCornerY, 1, _ShortStairs ? 3 : 4);
				WallInst.FloorLevel = UPPERLOWER;

				
				//Stair rail R
				DrawTileBlock(global.TMID_Walls_Lower, TLCornerX + 24, TLCornerY, TilesX + 3, TilesY, 1, _ShortStairs ? 2 : 3);
				DrawTileBlock(global.TMID_Walls_Upper, TLCornerX + 24, TLCornerY + (_ShortStairs ? 16 : 24), TilesX + 3, TilesY + 3, 1, 1);
				var WallInst = WallObj_Create("Objs_Upper", TLCornerX + 24, TLCornerY, 1, _ShortStairs ? 3 : 4);
				WallInst.FloorLevel = UPPERLOWER;	


				break;

	
		}

		
	}
			
}