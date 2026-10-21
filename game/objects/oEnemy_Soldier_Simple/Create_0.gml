event_inherited();

Dir = RandomDir();

Size = EnemySize.Medium;

switch(global.Level.Index){
	
	case DungeonLevel.Castle: 
		HeadIndex = SoldierHead.Normal;
		ColorIndex = SoldierColor.Green;
		Enemy_SetEnergy(1);
		Attack = 0.5;
		break;
	case DungeonLevel.CastleBasement: 
		HeadIndex = SoldierHead.Normal;
		ColorIndex = SoldierColor.Blue; 
		Enemy_SetEnergy(1);
		Attack = 0.5;
		break;
	case DungeonLevel.CastleJails: 
		HeadIndex = SoldierHead.Normal;
		ColorIndex = SoldierColor.Grey; 
		Enemy_SetEnergy(2);
		Attack = 0.5;
		break;
}


HeadDir = Dir;
HeadSpr = noone;
HeadX = x;

WalkSpeed = 0.5;
RunSpeed = 1;

//Enemy_UpdateState(choose(EnemyState.Standing, EnemyState.Walking));

Enemy_UpdateState(EnemyState.Walking);

//temp 
//var LinkInSight = Enemy_LinkInSight(SightOffset, SightDist); //just to activate the first sight coordinates, can be removed after testing
