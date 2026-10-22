event_inherited();

IgnoreWalls = true;
KnockBackEnabled = false;
KnockBackIgnoreZRule = true;
KnockBackIgnoreDestroy = true;
StartX = x;
StartY = y;

Path = choose(LanmolaPath1, LanmolaPath2, LanmolaPath3);

//calculate good angles and store them in a list
var AngleList = ds_list_create()
var AngleMultiples = 5;
var AngleDivs = floor(360 / AngleMultiples);

var MaxDistance;
for(var i = 0; i < AngleDivs; i++){
	
	var A = i * AngleMultiples; 
	
	//if angle is between 240 and 300, don't add to list, as head movement is too much for those angles
	if(A >= 240 && A <= 300) continue;
	
	switch(Path){
		//Max Distance needed for each path
		
		//****NOTE******: 
		//If Speed, or vz/time in Lanmola_Update() under switch(Path), or GM Paths change, you have to recalculate the maximums as they depend on those variables.
		//See Lanmola_Update().
		case LanmolaPath1: MaxDistance = 107; break;
		case LanmolaPath2: MaxDistance = 122; break;
		case LanmolaPath3: MaxDistance = 52; break;
	}
	
	//for each angle, check if there's a wall collision at that distance. If so, don't add
	MaxDistance += 24;  //add a bit of buffer
	
	if(collision_line(StartX, StartY, StartX + lengthdir_x(MaxDistance, A), StartY + lengthdir_y(MaxDistance, A), oWall, false, true) == noone){
		ds_list_add(AngleList, A);
	}	
}

if(ds_list_empty(AngleList)){
	//if the list is empty, it's most likely because the point is in the centre and the longer distance paths would always touching a wall, so no angles were added.
	//So pick the short path since it will always be ok from the centre, and put back angles in list
	Path = LanmolaPath3;
	for(var i = 0; i < AngleDivs; i++){
		var A = i * AngleMultiples; //only use multiples of 5 degrees
		if(A >= 240 && A <= 300) continue;
		ds_list_add(AngleList, A);
	}
}

var RandomAngle = irandom(ds_list_size(AngleList) - 1);
StartAngle = AngleList[| RandomAngle];


ds_list_destroy(AngleList);

Angle = StartAngle;
Speed = 0.75;
StartVX = lengthdir_x(Speed, Angle);
StartVY = lengthdir_y(Speed, Angle);
vx = StartVX;
vy = StartVY;
Time = 0;
SectionCount = 0;
SectionSpawnTime = 8;
DestroySelf = false;
alarm[0] = SectionSpawnTime;

Enemy_UpdateState(EnemyState.Jumping);