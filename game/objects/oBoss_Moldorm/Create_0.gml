event_inherited();

visible = true;

RoomX = global.Level.Rooms[RoomIndex].x;
RoomY = global.Level.Rooms[RoomIndex].y;

Dir = 270;
DirV = 0;
EyeA = 270;

Speed[0] = 1.6;
Speed[1] = 2.2;
SpeedIndex = 0;
LowEnergy = 7; //when to start moving faster

KnockBackEnabled = false;
//KnockBackIgnoreDestroy = true;
WallCollide_Bounce = true;

CanHurtLink = false;
HuntLink = false;

var VarStruct = {FloorLevel : UPPER, ItemHolding : -1, SectionID: 0, RoomIndex : RoomIndex};

BodyInst[MoldormSection.BodyL1] = instance_create_layer(x, y, "ObjsHigher_Upper", oBoss_Moldorm_BodyL, VarStruct);
BodyInst[MoldormSection.BodyL2] = instance_create_layer(x, y, "ObjsHigher_Upper", oBoss_Moldorm_BodyL, VarStruct);
BodyInst[MoldormSection.BodyS] = instance_create_layer(x, y, "ObjsHigher_Upper", oBoss_Moldorm_BodyS, VarStruct);
BodyInst[MoldormSection.Tail] = instance_create_layer(x, y, "ObjsHigher_Upper", oBoss_Moldorm_Tail, VarStruct);

BodyInst[MoldormSection.BodyL1].depth = depth + 1;
BodyInst[MoldormSection.BodyL2].depth = depth + 2;
BodyInst[MoldormSection.BodyS].depth = depth + 3;
BodyInst[MoldormSection.Tail].depth = depth + 4;

//PP = Previous Point
PPX = array_create(49, x);
PPY = array_create(49, y);

PP[MoldormSection.BodyL1][0] = 16; PP[MoldormSection.BodyL1][1] = 10;
PP[MoldormSection.BodyL2][0] = 29; PP[MoldormSection.BodyL2][1] = 19;
PP[MoldormSection.BodyS][0] = 40; PP[MoldormSection.BodyS][1] = 26;
PP[MoldormSection.Tail][0] = 48; PP[MoldormSection.Tail][1] = 31;


FinalExplosions = 8;
ShowHead = true;
BossDestroyed = false;
HeartCollected = false;

Sound = noone;
SoundPaused = false;

ObjSetImageSpeed(image_speed);

Enemy_UpdateState(EnemyState.Sleep);

alarm[0] = 200;

Init = true;