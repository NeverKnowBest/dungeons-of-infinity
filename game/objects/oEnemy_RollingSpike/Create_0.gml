event_inherited();

Speed = 1;
W = 12;
H = 12;
WallCollide_Bounce = true;
Dir = HORIZONTAL;

MaskSprite = noone;

InitialVX = 0;
InitialVY = 0;

SaveVariables = ["sprite_index", "W", "H", "vx", "vy", "InitialVX", "InitialVY", "Dir"];

Setup = true;

Enemy_UpdateState(EnemyState.Walking);

