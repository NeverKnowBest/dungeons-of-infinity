event_inherited();

Size = EnemySize.Tiny;

NormalSpeed = 0.8;
AngrySpeed = NormalSpeed + 0.25;
Speed = NormalSpeed;
Angle = irandom(360);
ChargeAngle = Angle;
RotateSpeed = 5;
ChangeDirDelayMin = 10;
ChangeDirDelayMax = 30;

Enemy_UpdateState(EnemyState.Walking);