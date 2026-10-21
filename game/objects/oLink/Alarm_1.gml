/// @description Push Init Delay

if(global.Paused) exit; //this might still activate if paused after this alarm was set, so exit

if(State == LinkState.Star) exit;

UpdateState(LinkState.Pushing);

var Walls = ds_list_size(CollidedWallList);
var WallsTouchingList = ds_list_create();

//if there's more than 1 wall we're colliding with, it's still possible to move if Link is more in front of one than the other.
//We only need to check this if there's more than 1 wall
if(Walls > 1){
	
	//Check a gap in front of link to make sure there's only mostly 1 block in front. This prevents a block from being pushed if standing in front of 2 touching blocks

	var W = 10;
	switch(Facing){
		case LEFT:	var WallsTouching = collision_rectangle_list(bbox_left - 4, bbox_top + W, bbox_left, bbox_bottom - W, oPushBlock, false, true, WallsTouchingList, false); break;
		case RIGHT:	var WallsTouching = collision_rectangle_list(bbox_right, bbox_top + W, bbox_right + 4, bbox_bottom - W, oPushBlock, false, true, WallsTouchingList, false);	break;
		case UP: var WallsTouching = collision_rectangle_list(bbox_left + W, bbox_top - 4, bbox_right - W, bbox_top, oPushBlock, false, true, WallsTouchingList, false); break;
		case DOWN: var WallsTouching = collision_rectangle_list(bbox_left + W, bbox_bottom, bbox_right - W, bbox_bottom + 4, oPushBlock, false, true, WallsTouchingList, false); break;			
	}
		
	if(WallsTouching != 1){  //we're touching more than 1 wall in that narrow space, so we can't move it
		ds_list_destroy(WallsTouchingList);
		exit;
	}else{
		var WallInst = WallsTouchingList[| 0];
	}
	
}else{
	
	var WallInst = CollidedWallList[| 0];
	
}

ds_list_destroy(WallsTouchingList);

if(!instance_exists(WallInst)) exit;

//check to see if the wall inst is a block, if so move it	
if(WallInst.object_index == oPushBlock){
	
	var Allowed = (Facing == WallInst.AllowedDir || WallInst.AllowedDir == ALLDIR);
	
	if(Allowed && !WallInst.Moved && !WallInst.Move_Start){
		//check if there's another wall where block is moving. If not, move the block
		var WallCheckDistX = PushingDirX * 16;
		var WallCheckDistY = PushingDirY * 16;			
		if(!collision_rectangle(WallInst.x + WallCheckDistX, WallInst.y + WallCheckDistY, WallInst.x + 15 + WallCheckDistX, WallInst.y + 15 + WallCheckDistY, oWall, false, true)){
			WallInst.Move_Start = true;
			WallInst.MoveX = PushingDirX * 0.75;
			WallInst.MoveY = PushingDirY * 0.75;
			ClearTileBlock(WallInst.TMID, WallInst.x, WallInst.y, 2, 2);
		}
	}

}






