Goriya_UpdateDir(RandomDir());

Enemy_UpdateState(State == EnemyState.Standing ? EnemyState.Walking : choose(EnemyState.Standing, EnemyState.Walking, EnemyState.Walking));
