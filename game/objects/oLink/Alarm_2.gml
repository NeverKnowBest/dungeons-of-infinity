/// @description Shock/Bounceback timer
switch(State){
	case LinkState.FallingOverEdge:
	case LinkState.Falling:
	case LinkState.Dead:
	case LinkState.Inventory:
	case LinkState.Star:
		exit;
	
}
	

if(State == LinkState.Shocked){
	LinkHit(point_direction(ShockEnemyX, ShockEnemyY, x, y), 1.25, 12, ShockEnemyAttack);
}else{
	BounceBack = false;
	with(oWall){
		if(IsStairs){
			BlockLink = false;
		}
	}
	UpdateState(LinkState.Standing);
}
