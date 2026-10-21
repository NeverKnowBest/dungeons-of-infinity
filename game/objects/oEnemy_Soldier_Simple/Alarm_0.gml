
Soldier_UpdateDir(HeadDir);
Enemy_UpdateState(Enemy_LinkInSight(Dir, SightOffset, SightDist) ? EnemyState.Running : EnemyState.Walking);
