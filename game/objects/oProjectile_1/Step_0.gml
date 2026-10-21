
if(global.Paused) exit;

//Check for walls

if(!WallCollideDelay){

	var WallInst = instance_place(x, y_base, oWall);

	if(WallInst != noone){
		if(FloorLevel == WallInst.FloorLevel && WallInst.BlockProjectiles){
			WallCollideDelay = true;
			if( (object_index == oPot && vy > 0) || object_index = oBone){ //allow more time to get into wall
				alarm[10] = 5;
			}else if(object_index == oArrow){
				alarm[10] = 1;
			}else{
				alarm[10] = 2;
			}
			
		}
	}
}

//check for door passage, will be used in their draw event to hide them when passing through a door
var DoorInst = instance_place(x + vx, y_base + vy, oDoor);
if(DoorInst != noone) DoorPassage = DoorInst.PassageArea;	

if(OutsideViewDestroy){
	if(!point_in_rectangle(x, y, global.CurrentRoom.x + 20, global.CurrentRoom.y + 20, global.CurrentRoom.x + global.CurrentRoom.width - 21, global.CurrentRoom.y + global.CurrentRoom.height - 21)){
		instance_destroy(self);
	}	
}