visible = false; //all children object should have visible set to false so DepthDrawObjs can sort and draw everything manually
				 //If objects doesn't get sorted by DepthDrawObjs, manually set visible back to true


layer = ( (FloorLevel == UPPER || FloorLevel == UPPERLOWER) ? global.LayerID_Objs_Upper : global.LayerID_Objs_Lower);

y_base = y; //Where shadow centre is. If z > 0, shift y by z so mask follows, but draw shadow at y_base

vx = 0;
vy = 0;
vz = 0;
z = 0;
vx_extra = 0;
vy_extra = 0;

OldPosX = 0;
OldPosY = 0;

Gravity = 0;
GravityStatus = false;

EnergyIndex = 0;
EnergyMax = 1;
Energy = 1;
Attack = 0;

if(is_struct(global.EnemyData[object_index])){
	Enemy_SetEnergy(global.EnemyData[object_index].EnergyIndex);	
	Attack = global.EnemyData[object_index].Attack;
}

Speed = 0;

Type = 0;
ColorIndex = 0;

Dir = DOWN;

Size = EnemySize.Medium;

Hit = false;
Hit_Allowed = true;
Hit_AllowedTimer = 0;
Hit_LinkWeaponClass = -1;
Hit_LinkWeaponIndex = 0;
Hit_LinkWeaponEffect = 0;
Hit_DirX = 0;
Hit_DirY = 0;
Hit_PosX = 0;
Hit_PosY = 0;
Hit_Stun = false;
Hit_HitBox = false;
Hit_Sound = Sound_Enemy_Hit;
Hit_PlaySound = true;
Hit_Started = false;

KnockBackEnabled = true;
KnockBackTime = 0;
KnockBackTimeLen = 20;
KnockBackV = 4.5;
KnockBackIgnoreZRule = false; //Ignores the if z is greater than 0 case: if(KnockBackTime == 10){..	if(z > 0).. Some enemies like Zirro should still stop after being hit regardless of their height since they're always flying
KnockBackIgnoreDestroy = false; //ignore the destroy phase, enemy handles it on its own (Lanmola)
KnockBackDone = false;
KnockBackColorFrame = 0;

Pushback = false;
PushbackTime = 0;
PushbackTimeLen = 12;
PushbackV = 3;
PushbackDone = false;

StunnedStart = false;
StunnedShake = false;
StunnedShakeIniX = 0;
StunnedShakeDir = 1;
UnStunWhenHit = false;
StunTime = 240;
StunCounter = 0;
StunDone = false;

FrozenSparkleTime = 40;
FrozenSparkleCounter = 0;

OnFireTime = 80;
OnFireCounter = 0;
OnFireInst = noone;

CheckForWater = false;
InWaterSprW = sprite_width;
InWaterSprXOffset = 0;
InWaterSprYOffset = -3;
InWater = false;

StopWatch = false;
Stoned = false;

CanHurtLink = true;

CanShock = false;
ShockCounter = 0;
ShockDone = false;

PreDestroyed = false;
Destroyed = false;
DestroyObj = oEnemy_Destroy;
DestroySound = Sound_Enemy_Kill;
DestroyIgnore = false;

IgnoreWalls = false;
ContainInRoom = false;
ContainInRoomBounce = true;
CollidedWallList = ds_list_create();
WallCollide_X = false;
WallCollide_Y = false;
WallCollide_Bounce = false;
WallCollide_Bounce_NewVFactor = 1; //what percentage of the old speed will the new speed be after colliding (0-1)

Sight = true;
SightDist = 100;
SightOffset = 10;

JumpLanded = false;

LightIndex = -1;

Reset_StartX = x;
Reset_StartY = y;

LastImageSpeed = image_speed;

State = EnemyState.Idle;

SaveVariables = []; //variable names that should be saved / reset after reloading (color, type, etc)



