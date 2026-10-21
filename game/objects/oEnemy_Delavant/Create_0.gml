event_inherited();

FloorLevelStr = GetFloorLevelString(FloorLevel);

Size = EnemySize.Large;

Index = choose(0, 1);

AllowSpawn = false;

KnockBackEnabled = false;

DirtInst = noone;

ShootDelay = 60;

ShootCounter = 0;

Visible = false;

SaveVariables = ["Index"];

Enemy_UpdateState(EnemyState.Idle);