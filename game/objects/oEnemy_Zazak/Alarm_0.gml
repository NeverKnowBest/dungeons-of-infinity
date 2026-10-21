Soldier_UpdateDir(HeadDir);
Enemy_UpdateState(Enemy_LinkInSight(Dir, SightOffset, SightDist) && CanShoot ? EnemyState.Shooting : EnemyState.Walking);