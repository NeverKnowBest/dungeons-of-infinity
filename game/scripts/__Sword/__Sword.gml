enum Swords{Basic, Steel, Long, Dragon, Blood, Master}

#macro SwordChargeReady 0.95

global.SwordName = ["Basic", "Steel", "Long", "Dragon", "Blood", "Master"];

global.SwordSound = [Sound_Sword1, Sound_Sword2, Sound_Sword3, Sound_Sword4, Sound_Sword5, Sound_Sword6];

//Steel: 
//Long: Break pots
//Dragon: Shock resistance
//Blood: Destroy more enemy types
//Master: Sword beam

global.SwordCollisionList = ds_list_create();

function SwordLevel(_SwordIndex){
	return global.Inventory.ItemData[ItemClass.Sword].Index >= _SwordIndex	
}

function SwordCollision(_Obj, _List = noone){


	switch(oLink.State){

		default:
			if(oLink.SwordCharge == 0) break;	
		case LinkState.Sword: 
			if(_List == noone){
				return ObjCollision(x, y, _Obj, FloorLevel)
			}else{
				ObjCollision_List(_List, x, y, _Obj, FloorLevel);
			}
			break;
			
		case LinkState.Star:  
		case LinkState.SwordSpin:  
			if(_List == noone){
				return ObjCollision_Circle(StarCollisionX, StarCollisionY, StarCollisionRadius, _Obj, FloorLevel)
			}else{
				ObjCollision_Circle_List(_List, StarCollisionX, StarCollisionY, StarCollisionRadius, _Obj, FloorLevel);
			}
			break;
	}
	
	return noone
	
}

function Sword_DoSwordPoke(){

	with(oLink){
		
		if(SwordCharge > 0){
			UpdateState(LinkState.SwordPoke);
			return true;
		}
	}
	
	return false;
	
}

function Sword_ResetCharge(_DestroySword = true){
	SwordCharge = 0;
	SwordChargePlaySound = true;
	if(_DestroySword) instance_destroy(oSword);
}