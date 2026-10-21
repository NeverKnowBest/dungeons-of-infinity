event_inherited();

Size = EnemySize.Large;

Speed = 0.75;
JumpVZ = 2;
Gravity = -0.2;
GravityStatus = true;

WakeColors = array_create(0);
array_insert(WakeColors, 0, KB_R,KB_G,KB_B);
WakeColorFrame = 0;

CheckForWater = true;
InWaterSprW = sprite_width + 4;

Enemy_UpdateState(EnemyState.Idle);