enum ArmosWaypoints{
	Circle,
	CircleRotate,
	TopLine,
	BottomLine	
}

function Armos_Waypoints_Set(){
	
	for(var i = 0; i < ArmosCount; i++){
		if(instance_exists(ArmosInst[i])){
			if(ArmosInst[i].Energy > 0){
				ArmosInst[i].CircleAngle = CircleAngleStart[i];
				ArmosInst[i].WaypointX = Armos_ClampWaypointX(WaypointsX[WaypointScriptIndex][i]);
				ArmosInst[i].WaypointY = Armos_ClampWaypointY(WaypointsY[WaypointScriptIndex][i]);
				Armos_Waypoints_Calculate(ArmosInst[i]);
			}
		}
	}
	
	CircleRotate = false;
	CircleExpand = false;
	
	alarm[0] = WaypointScript[# 1, WaypointScriptIndex];
	
	if(WaypointScriptIndex == ArmosWaypoints.Circle) alarm[3] = 220; //set the circle shrink delay
	
}

function Armos_Waypoints_Calculate(Inst){
	var D = point_direction(Inst.x, Inst.y_base, Inst.WaypointX, Inst.WaypointY);
	Inst.vx = lengthdir_x(oBoss_Armos_C.MoveSpeed, D);
	Inst.vy = lengthdir_y(oBoss_Armos_C.MoveSpeed, D);
}

function Armos_MoveToWaypoint(_Inst){
	
	with(_Inst){
		if(x != WaypointX || y_base != WaypointY){
			
			if(vx != 0){
				if( (vx > 0 && x + vx >= WaypointX) || (vx < 0 && x + vx <= WaypointX)){
					x = WaypointX;
					vx = 0;
				}
			}
			
			if(vy != 0){
				if( (vy > 0 && y_base + vy >= WaypointY) || (vy < 0 && y_base + vy <= WaypointY)){
					ObjSetY(WaypointY);
					vy = 0;
				}
			}
			
		}

		return x == WaypointX && y_base == WaypointY;
	}
	
}

function Armos_Last_JumpInit(_Inst){
	
	with(_Inst){
		WaypointX = Armos_ClampWaypointX(oLink.x); //clamp since last armos can't reach Link if he's by a wall because of wall collision, so restrict his waypoint
		WaypointY = Armos_ClampWaypointY(oLink.y);
		var Dir = point_direction(x, y_base, WaypointX, WaypointY);
		var Dist = point_distance(x, y_base, WaypointX, WaypointY);
		vx = lengthdir_x(Dist, Dir) / oBoss_Armos_C.LastArmos_JumpTime;
		vy = lengthdir_y(Dist, Dir) / oBoss_Armos_C.LastArmos_JumpTime;
		oBoss_Armos_C.vz = oBoss_Armos_C.LastArmos_VZ_Jump;
		oBoss_Armos_C.LastArmos_Jump = true;
		Hit_Allowed = false;
	}
	
}

function Armos_ClampWaypointX(_Waypoint){
	return clamp(_Waypoint, oBoss_Armos_C.RoomX + 56, oBoss_Armos_C.RoomX + 200)
}
function Armos_ClampWaypointY(_Waypoint){
	return clamp(_Waypoint, oBoss_Armos_C.RoomY + 64, oBoss_Armos_C.RoomY + 208)
}