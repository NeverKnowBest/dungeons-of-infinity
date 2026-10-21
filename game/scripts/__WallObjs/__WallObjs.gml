
function WallObj_Create(Layer, X, Y, TileW, TileH, Position = NONE, GID = 0, WallObj = oWall){
	
	WallInst = instance_create_layer(X, Y, Layer, WallObj);
	WallInst.image_xscale = TileW;
	WallInst.image_yscale = TileH;	
	WallInst.Position = Position;
	WallInst.GID = GID;
	
	//Use this method to determine floor level since there may be walls on lower floors with floors above, so using GetFloorLevelID() wouldn't work
	if(string_pos("Lower", Layer) != 0)	WallInst.FloorLevel = LOWER; //default is UPPER
	
	return WallInst;
	
}

function WallObj_Cutout_H(WallInst, X1, X2){

	//Split WallObj with a vertical slice into 2 oWall objs
		
	var LeftWallX1 = WallInst.x;
	var LeftWallX2 = X1 - 1;
		
	var RightWallX1 = X2 + 1;
	var RightWallX2 = WallInst.x + WallInst.sprite_width - 1;
	
	WallInst.image_xscale = (LeftWallX2 - LeftWallX1 + 1) / 8;

	var RightWallInst = WallObj_Create(WallInst.layer, RightWallX1, WallInst.y, (RightWallX2 - RightWallX1 + 1) / 8, WallInst.sprite_height / 8, WallInst.Position, WallInst.GID);

	RightWallInst.FloorLevel = WallInst.FloorLevel;
	
	//might not need these
	RightWallInst.BlockLink = WallInst.BlockLink;
	RightWallInst.BlockLinkCarry = WallInst.BlockLinkCarry;
	RightWallInst.BlockEnemies = WallInst.BlockEnemies;
	RightWallInst.BlockProjectiles = WallInst.BlockProjectiles;
	RightWallInst.BlockItems = WallInst.BlockItems;


	
}


function WallObj_Cutout_V(WallInst, Y1, Y2){

	//Split WallObj with a horizontal slice into 2 oWall objs
		
	var TopWallY1 = WallInst.y;
	var TopWallY2 = Y1 - 1;
		
	var BottomWallY1 = Y2 + 1;
	var BottomWallY2 = WallInst.y + WallInst.sprite_height - 1;
	
	WallInst.image_yscale = (TopWallY2 - TopWallY1 + 1) / 8;
	
	var BottomWallInst = WallObj_Create(WallInst.layer, WallInst.x, BottomWallY1, WallInst.sprite_width / 8, (BottomWallY2 - BottomWallY1 + 1) / 8, WallInst.Position, WallInst.GID);

	BottomWallInst.FloorLevel = WallInst.FloorLevel;
	
	//might not need these
	BottomWallInst.BlockLink = WallInst.BlockLink;
	BottomWallInst.BlockLinkCarry = WallInst.BlockLinkCarry;
	BottomWallInst.BlockEnemies = WallInst.BlockEnemies;
	BottomWallInst.BlockProjectiles = WallInst.BlockProjectiles;
	BottomWallInst.BlockItems = WallInst.BlockItems;
				
}