event_inherited();

Size = EnemySize.Small;

Enemy_UpdateState(EnemyState.Walking);

Speed = 0.15;
BuzzBlob_UpdateDir();

CheckForWater = true;
InWaterSprW = sprite_width + 2;

WallCollide_Bounce = true;

ShockPal = 0;

LightIndex = Lighting_CreateLight(RoomIndex, x, y, 0.8, [0.5, 0.5, 0.5], false);
