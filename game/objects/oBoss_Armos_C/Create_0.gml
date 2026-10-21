
//Setup = false;
State = EnemyState.Idle;

RoomX = global.Level.Rooms[RoomIndex].x;
RoomY = global.Level.Rooms[RoomIndex].y;

alarm[1] = 160;

vz = 0;
z = 0;
MoveSpeed = 1.25;
JumpSpeed = 3;

ShakeOffset = 0;
ShakeDir = 1;

ArmosCount = 6;
ArmosLeft = ArmosCount;

WaypointPatterns = 4;

WaypointsX = array_create(WaypointPatterns);
WaypointsY = array_create(WaypointPatterns);
WaypointsX[ArmosWaypoints.Circle] = array_create(ArmosCount);
WaypointsY[ArmosWaypoints.Circle] = array_create(ArmosCount);
WaypointsX[ArmosWaypoints.CircleRotate] = array_create(ArmosCount);
WaypointsY[ArmosWaypoints.CircleRotate] = array_create(ArmosCount);
WaypointsX[ArmosWaypoints.TopLine] = array_create(ArmosCount);
WaypointsY[ArmosWaypoints.TopLine] = array_create(ArmosCount);
WaypointsX[ArmosWaypoints.BottomLine] = array_create(ArmosCount);
WaypointsY[ArmosWaypoints.BottomLine] = array_create(ArmosCount);

WaypointScript = ds_grid_create(2, WaypointPatterns);
var Line = 0;
WaypointScript[# 0, Line] = ArmosWaypoints.Circle;			WaypointScript[# 1, Line] = 130;	Line++
WaypointScript[# 0, Line] = ArmosWaypoints.CircleRotate;	WaypointScript[# 1, Line] = 460;	Line++
WaypointScript[# 0, Line] = ArmosWaypoints.TopLine;			WaypointScript[# 1, Line] = 170;	Line++
WaypointScript[# 0, Line] = ArmosWaypoints.BottomLine;		WaypointScript[# 1, Line] = 120;

WaypointScriptIndex = 0;

CircleX = RoomX + 128;
CircleY = RoomY + 128;
CircleRadius = 75;
CircleRadiusMin = 40;
CircleRadiusMax = 75;
CircleAngleStart[0] = -120;
CircleAngleStart[1] = -60;
CircleAngleStart[2] = 0;
CircleAngleStart[3] = -180;
CircleAngleStart[4] = -240;
CircleAngleStart[5] = -300;
CircleRotate = false;
CircleShrink = false;
CircleExpand = false;

LastArmos_Inst = noone;
LastArmos_Jump = false;
LastArmos_JumpTime = 22;
LastArmos_JumpZ = 30;
LastArmos_Stomp = false;
LastArmos_VZ_Jump = LastArmos_JumpZ / LastArmos_JumpTime;
LastArmos_VZ_Stomp = -4;
LastArmos_HeartSpawned = false;
LastArmos_X = 0;
LastArmos_Y = 0;

BossDestroyed = false;

	
var VarStruct = {FloorLevel : UPPER, ItemHolding : -1, SectionID: SectionID, RoomIndex : RoomIndex};
	
for(var i = 0; i < ArmosCount; i++){
	
	ArmosInst[i] = instance_create_layer(RoomX + 80 + ((i mod 3) * 48), RoomY + 100 + ((i div 3) * 48), "ObjsHighest", oBoss_Armos, VarStruct);
	ArmosInst[i].ID = i;
	ArmosStatus[i] = true; //dead or alive
	WaypointsX[ArmosWaypoints.Circle][i] = round(CircleX + (CircleRadius * dcos(CircleAngleStart[i])));
	WaypointsY[ArmosWaypoints.Circle][i] = round(CircleY + (CircleRadius * dsin(CircleAngleStart[i])));
	WaypointsX[ArmosWaypoints.CircleRotate][i] = round(CircleX + (CircleRadius * dcos(CircleAngleStart[i])));
	WaypointsY[ArmosWaypoints.CircleRotate][i] = round(CircleY + (CircleRadius * dsin(CircleAngleStart[i])));
	WaypointsX[ArmosWaypoints.TopLine][i] = RoomX + 53 + (i * 30);
	WaypointsY[ArmosWaypoints.TopLine][i] = RoomY + 64;
	WaypointsX[ArmosWaypoints.BottomLine][i] = RoomX + 53 + (i * 30);
	WaypointsY[ArmosWaypoints.BottomLine][i] = RoomY + 216;
		
}

Sound = noone;
SoundPaused = false;