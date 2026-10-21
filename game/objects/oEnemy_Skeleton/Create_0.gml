event_inherited(); 

Size = EnemySize.Medium;

WalkSpeed = 1;
JumpSpeed = 2.5;
KnockBackV = JumpSpeed + 0.25;
Gravity = -0.175;
KnockBackTimeLen = 24;
KnockBackIgnoreZRule = true;
Type = FlipCoin_Bin();

Dir = RandomDir();
NextDir = Dir;
HeadDir = Dir;
Shoot = false;

WalkingLayer = layer;

SaveVariables = ["Type"];

Enemy_UpdateState(choose(EnemyState.Standing, EnemyState.Walking));

