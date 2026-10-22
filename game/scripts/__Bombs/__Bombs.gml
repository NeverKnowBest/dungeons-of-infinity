#macro Bomb_IgniteDelay 50 //when placing a bomb down
#macro Bomb_IgniteDelayQuick 40 //when throwing, it will ignite quicker
#macro Bomb_IgniteDelayWand 30

function Bomb_CheckLinkDamage(_FloorLevel, _Radius = 24, _MaxDamage = 2){
	
	if(Pendant_Check(Pendant.Protection)) exit;
	
	var _LinkInst = ObjCollision_Circle(x, y, _Radius, oLink, _FloorLevel);
	
	if(_LinkInst == noone) exit;
	
	var _DistToLink = point_distance(x, y, oLink.x, oLink.y - 6);
	var _DamageFactor = floor(_DistToLink / 3) * 0.25;
	var _Damage = clamp(_MaxDamage + 1 - _DamageFactor, 0.5, _MaxDamage);
	if(_Damage > 0){
		with(_LinkInst){
			LinkHit(point_direction(other.x, other.y, x, y - 6), 0.5 + _Damage, 8 + floor(_Damage * 3), _Damage);
		}
	}


}

function Bombs_PickAmount(_From){
	
	switch(_From){

		case ItemFrom.EnemyTiny:
		case ItemFrom.EnemySmall:
		case ItemFrom.Pot:
			return choose(1,1,1,1,1,2);
			
		case ItemFrom.EnemyMedium:
			return choose(1, 1, 1, 2);
			
		case ItemFrom.EnemyLarge:
			return choose(1, 1, 2, 3);
			
		case ItemFrom.Treasure:
		case ItemFrom.KinstoneGreen:
			return choose(3,3,4,5,6,8);
		
		case ItemFrom.Shop:
		case ItemFrom.WeaponStore:
			return choose(3,4,5,6,8,10);
							
	}	
	
	return 1
	
}