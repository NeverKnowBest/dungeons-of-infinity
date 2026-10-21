if(StopWatch) exit;

Enemy_ShootRedBall(x, y);

ShootCounter++;

if(ShootCounter >= 3)
	Enemy_UpdateState(EnemyState.Sleep);
else
	alarm[2] = ShootDelay;