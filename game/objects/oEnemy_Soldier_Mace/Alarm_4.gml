//Choose random dir while standing
if(State != EnemyState.Standing) exit;

Dir = RandomDir();
Enemy_UpdateState(EnemyState.Standing);