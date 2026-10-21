event_inherited();

Size = EnemySize.Small;

Speed = 1;
Angle = 0;
ChargeAngle = 0;
RotateSpeed = 3;
ChangeDirDelayMin = 10;
ChangeDirDelayMax = 40;
PushbackTimeLen = 15;

UpdateFacingSpriteDelayMin = 5;
UpdateFacingSpriteDelayMax = 10;
alarm[2] = irandom_range(15, 60);
Enemy_UpdateState(EnemyState.Standing);
Helmasaur_UpdateDir();

