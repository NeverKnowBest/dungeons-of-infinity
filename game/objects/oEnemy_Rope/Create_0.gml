event_inherited(); //parent: oEnemy

Size = EnemySize.Tiny;
WalkSpeed = 0.75;
RunSpeed = 1.25;

CheckForWater = true;

Enemy_UpdateState(choose(EnemyState.Walking, EnemyState.Running));

