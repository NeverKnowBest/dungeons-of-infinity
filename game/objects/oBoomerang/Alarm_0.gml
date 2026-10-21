/// @description Wall Collide Delay
vx *= -0.75;
vy *= -0.75;

instance_create_layer(x, y, "EffectsProjectiles_" + GetFloorLevelString(oLink.FloorLevel), oWallHit);