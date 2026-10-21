event_inherited();

Size = EnemySize.Small;

Color = FlipCoin_Bin();
Speed = 0.5 + (Color * 0.25);

InitialWakeDone = false;

Enemy_UpdateState(EnemyState.Idle);
alarm[0] = irandom_range(45, 180);
