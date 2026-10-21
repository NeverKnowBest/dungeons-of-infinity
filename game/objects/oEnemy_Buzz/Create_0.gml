//Mask shouldn't be full image, it was 16x16, but in some rare cases buzz could slip through walls when in 16 wide cracks next to monuments. 
//Setting the mask to 14x14 solved this. Not sure what the issue is, something with collision

event_inherited();

Size = EnemySize.Tiny;

Gravity = -0.2;

WalkSpeed = 1.5;
JumpSpeed = 2.25;
Speed = 0;

CheckForWater = true;
InWaterSprYOffset = 1;

WallCollide_Bounce = true;

Hops = 0;
Dir = RandomDir();
Enemy_UpdateState(choose(EnemyState.Standing, EnemyState.Standing, EnemyState.Walking));

	

