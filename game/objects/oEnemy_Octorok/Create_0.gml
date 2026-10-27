event_inherited(); //parent: oEnemy

Size = EnemySize.Small;

Type = (LevelDef.EnemyStats > DungeonLevel.LanmolasLair ? 1 : 0);

switch(Type){
	case 0:
		Sprite_Left = sEnemy_Octorok_Left;
		Sprite_Right = sEnemy_Octorok_Right;
		Sprite_Up = sEnemy_Octorok_Up;
		Sprite_Down = sEnemy_Octorok_Down;
		Sprite_Mouth_Left = sEnemy_Octorok_Mouth_Left;
		Sprite_Mouth_Right = sEnemy_Octorok_Mouth_Right;
		Sprite_Mouth_Down = sEnemy_Octorok_Mouth_Down;
		Speed = 1.5;
		ShotDelay = 20;
		Attack = 1.5;
		Enemy_SetEnergy(4);
		break;
		
	case 1:
		Sprite_Left = sEnemy_Slarok_Left;
		Sprite_Right = sEnemy_Slarok_Right;
		Sprite_Up = sEnemy_Slarok_Up;
		Sprite_Down = sEnemy_Slarok_Down;
		Sprite_Mouth_Left = sEnemy_Slarok_Mouth_Left;
		Sprite_Mouth_Right = sEnemy_Slarok_Mouth_Right;
		Sprite_Mouth_Down = sEnemy_Slarok_Mouth_Down;
		Speed = 1.75;
		ShotDelay = 12;
		Attack = 2;
		Enemy_SetEnergy(5);
		break;
}



WallCollide_Bounce = true;
ShotCount = 0;
MouthFrame = 0;
MouthFrameDelay = 8;

Enemy_UpdateState(EnemyState.Walking);