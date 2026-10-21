enum SoldierHead{
	Normal,
	Knight,
	Warrior,
	Skull,
	Pig,
	Pig2,
	Dragon,
	Demon
}

enum SoldierColor{
	Blue,
	Green,	
	Red,
	Grey,
	Gold
}

enum SoldierWeapon{
	Sword,
	Spear,
	Fork,
	Stick
}
global.SoldierWeaponStr[SoldierWeapon.Sword] = "Sword";
global.SoldierWeaponStr[SoldierWeapon.Spear] = "Spear";
global.SoldierWeaponStr[SoldierWeapon.Fork] = "Fork";
global.SoldierWeaponStr[SoldierWeapon.Stick] = "Stick";


function Soldier_UpdateHead(_Dir){
	HeadDir = _Dir;
	switch(_Dir){
		case LEFT: HeadSpr = sEnemy_Soldier_Head_Left; break;
		case RIGHT: HeadSpr = sEnemy_Soldier_Head_Right; break;
		case UP: HeadSpr = sEnemy_Soldier_Head_Up; break;
		case DOWN: HeadSpr = sEnemy_Soldier_Head_Down; break;		
	}
}

function Soldier_Advanced_UpdateRunningDir(_UpdateWeapon = true){
	Soldier_UpdateDir(DirFaceLink());
	var DirToLink = point_direction(x, y, oLink.x, oLink.y);
	vx = lengthdir_x(Speed, DirToLink);
	vy = lengthdir_y(Speed, DirToLink);
	if(_UpdateWeapon) Soldier_UpdateWeaponSprite();
	Strafe = false;
	alarm[1] = 20;	
}

function Soldier_UpdateDir(_Dir){

	Dir = _Dir;
	Soldier_UpdateHead(Dir);
	Enemy_UpdateSprite(State);
	Enemy_UpdateV(Speed);
	
}

function Soldier_UpdateWeaponSprite(){
	
	switch(Dir){
		case UP: WeaponInst.sprite_index = asset_get_index("sSoldierWeapon_" + global.SoldierWeaponStr[Weapon] + "_Up"); break;	
		case DOWN: WeaponInst.sprite_index = asset_get_index("sSoldierWeapon_" + global.SoldierWeaponStr[Weapon] + "_Down"); break;	
		case LEFT: WeaponInst.sprite_index = asset_get_index("sSoldierWeapon_" + global.SoldierWeaponStr[Weapon] + "_Left"); break;	
		case RIGHT: WeaponInst.sprite_index = asset_get_index("sSoldierWeapon_" + global.SoldierWeaponStr[Weapon] + "_Right"); break;			
	}
	
}

function Soldier_Simple_LookSideDir(_Dir){
	switch(_Dir){
		case LEFT: 
		case RIGHT: return choose(UP, DOWN);
		case UP: 
		case DOWN: return choose(LEFT, RIGHT);
		
	}	
	
}

