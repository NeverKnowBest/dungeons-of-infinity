switch(Index){
	case Rod.Stone:
		sprite_index = asset_get_index("sRod_Stone_" + global.DirStr[Facing]);
		break;
	case Rod.Ice:
		sprite_index = asset_get_index("sRod_Ice_" + global.DirStr[Facing]);
		break;
	case Rod.Fire:
		sprite_index = asset_get_index("sRod_Fire_" + global.DirStr[Facing]);
		break;
	case Rod.Bomb:
		sprite_index = asset_get_index("sRod_Bomb_" + global.DirStr[Facing]);
		break;
	case Rod.Heart:
		sprite_index = asset_get_index("sRod_Heart_" + global.DirStr[Facing]);
		break;
	case Rod.Wealth:
		sprite_index = asset_get_index("sRod_Wealth_" + global.DirStr[Facing]);
		break;
	
	
}