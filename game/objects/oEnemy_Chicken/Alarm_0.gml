/// @description Stand delay

if(PickedUp || Scared || State == EnemyState.Jumping) exit;

Enemy_UpdateState(EnemyState.Walking);