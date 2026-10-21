event_inherited();

NormalLayer = layer;
PickupLayer = ( (FloorLevel == UPPER || FloorLevel == UPPERLOWER) ? global.LayerID_ObjsHigher_Upper : global.LayerID_ObjsHigher_Lower);

Speed = 0.75;
RunSpeed = 1.25;
SpeedThrow = 4;
JumpSpeed = 1.5;
CanHurtLink = false;

Egg = Prob(Chance_ChickenEgg) && !global.Challenges[Challenges.NoFood];
GoldenEgg = (Egg ? Prob(Chance_ChickenGoldenEgg) : false);

ObjSetImageSpeed(0.5);

WallCollide_Bounce = true;
ContainInRoom = true;
ContainInRoomBounce = false;
Hit_Sound = Sound_Chicken_Hit;
Hops = 0;

PickedUp = false;
Scared = false;

SaveVariables = ["Egg"];

Enemy_UpdateState(EnemyState.Walking);