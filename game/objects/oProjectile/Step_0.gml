
if(global.Paused) exit;

if(OutsideDestroyed) exit;

//Check for walls

if(!WallCollideDelay){

	var WallInst = instance_place(x, y_base, oWall);

	if(WallInst != noone){
		
		var _WallCollide = true;
		
		switch(WallInst.GID){
			case TemplateObjGID.WallLowerSideT: 
			case TemplateObjGID.WallSideT: 		
				if(y >= WallInst.y + WallInst.sprite_height || vy == 0) _WallCollide = false; 
				break;
				
			case TemplateObjGID.WallLowerSideB: 
			case TemplateObjGID.WallSideB: 		
				if(y <= WallInst.y || vy == 0) _WallCollide = false; 
				break;				
				
			case TemplateObjGID.WallLowerSideL: 
			case TemplateObjGID.WallSideL: 	
				if(x >= WallInst.x + WallInst.sprite_width || vx == 0) _WallCollide = false; 				
				break;
				
			case TemplateObjGID.WallLowerSideR: 
			case TemplateObjGID.WallSideR: 	
				if(x <= WallInst.x || vx == 0) _WallCollide = false;
				break;				
				
			case TemplateObjGID.WallInnerTL: 
			case TemplateObjGID.WallLowerInnerTL: 
				if( (x >= WallInst.x + WallInst.sprite_width) || (y >= WallInst.y + WallInst.sprite_height)) _WallCollide = false;	
				break;				
				
			case TemplateObjGID.WallInnerTR: 
			case TemplateObjGID.WallLowerInnerTR: 
				if( (x <= WallInst.x) || (y >= WallInst.y + WallInst.sprite_height) ) _WallCollide = false;
				break;
				
			case TemplateObjGID.WallInnerBL: 
			case TemplateObjGID.WallLowerInnerBL: 
				if( (x >= WallInst.x + WallInst.sprite_width) || (y <= WallInst.y))	_WallCollide = false;
				break;
				
			case TemplateObjGID.WallInnerBR: 
			case TemplateObjGID.WallLowerInnerBR: 
				if(x <= WallInst.x || y <= WallInst.y) _WallCollide = false;
				break;
				
		}
		if(_WallCollide && (FloorLevel == WallInst.FloorLevel || WallInst.FloorLevel == UPPERLOWER) && WallInst.BlockProjectiles){
			
			//if(point_in_rectangle(x, y_base, WallInst.bbox_left + 1, WallInst.bbox_top + 1, WallInst.bbox_bottom - 1, WallInst.bbox_right - 1)){
			//	WallCollided = true;
			//}
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


if(OutsideRoomDestroy){
	if(!point_in_rectangle(x, y, global.CurrentRoom.x + 20, global.CurrentRoom.y + 20, global.CurrentRoom.x + global.CurrentRoom.width - 21, global.CurrentRoom.y + global.CurrentRoom.height - 21)){
		OutsideDestroyed = true;
		instance_destroy(id);
	}	
}

if(OutsideCameraDestroy){
	if(!point_in_rectangle(x, y, oCamera.X - 16, oCamera.Y - 16, oCamera.X2 + 16, oCamera.Y2 + 16)){
		OutsideDestroyed = true;
		instance_destroy(id);
	}
}