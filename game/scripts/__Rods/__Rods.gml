enum Rod{Stone, Ice, Fire, Bomb, Heart, Wealth}
global.RodNames = ["Stone", "Ice", "Fire", "Bombs", "Hearts", "Wealth"];

enum RodChargerState{Idle, DBStarted}

global.RodChargerSignText = "Place a rod into the slot to charge it from your magic meter.";

global.MaxRodCharge[Rod.Stone] = 20;
global.MaxRodCharge[Rod.Ice] = 16;
global.MaxRodCharge[Rod.Fire] = 16;
global.MaxRodCharge[Rod.Bomb] = 16;
global.MaxRodCharge[Rod.Heart] = 12;
global.MaxRodCharge[Rod.Wealth] = 12;

function Rod_Shoot(){
	

	//var _ItemClass = global.Inventory[global.Inventory_SlotIndex_Equiped].ItemClass;
	var _ItemIndex = Inventory_EquipedItem.ItemIndex;
	var _FloorLevelStr = GetFloorLevelString(FloorLevel);
	var _RodLayerName = (Facing == UP ? "ObjsDoors_" : "ObjsHigher_");
	
	var _WeaponInst = instance_create_layer(x, y, _RodLayerName + _FloorLevelStr, oRod_Cane, {Index : _ItemIndex, Facing : Facing, FloorLevel : FloorLevel});
	
	switch(_ItemIndex){
		case Rod.Stone:
		case Rod.Ice:
		case Rod.Fire:
			var _BeamInst = instance_create_layer(x, y, "ObjsHigher_" + _FloorLevelStr, oRodBeam, {FloorLevel : FloorLevel});
			break;
		case Rod.Bomb:
		case Rod.Heart:
		case Rod.Wealth:
			var _BeamInst = instance_create_layer(x, y, "ObjsHigher_" + _FloorLevelStr, oCaneBeam, {FloorLevel : FloorLevel});
			break;
			
	//	case ItemClass.Cane:
	//		var _WeaponInst = instance_create_layer(x, y, _RodLayerName + _FloorLevelStr, oRod_Cane, {Index : _ItemIndex, FloorLevel : FloorLevel});
	//		var _BeamInst = instance_create_layer(x, y, "ObjsHigher_" + _FloorLevelStr, oCaneBeam, {FloorLevel : FloorLevel});
	//		var _WeaponSprName = "sCane_";
	//		break;
			
		
		
	}

	_BeamInst.Index = _ItemIndex;
	with(_BeamInst){
		Rod_SetLightIndex();
	}
	
	switch(Facing){
		case LEFT:
			_WeaponInst.x = x - 19; _WeaponInst.y = y - 24;
			break;
		case RIGHT:
			_WeaponInst.x = x - 2; _WeaponInst.y = y - 24;
			break;
		case UP:
			_WeaponInst.x = x - 10; _WeaponInst.y = y - 28;
			break;
		case DOWN:
			_WeaponInst.x = x; _WeaponInst.y = y - 26;
			break;

	}
		


	with(_BeamInst){
		Dir = oLink.Facing;
		switch(Dir){
			case LEFT: x-=16; ObjSetY(y_base - 5); vx = -Speed; break;
			case RIGHT: x+=16; ObjSetY(y_base - 5); vx = Speed; break;
			case UP:
				x-=6; ObjSetY(y_base - 24); vy = -Speed;  
				layer = layer_get_id("ObjsFloor_" + _FloorLevelStr);
				alarm[11] = 3;
				break;
			case DOWN: x+=4; ObjSetY(y_base + 2); vy = Speed; break;
		}
	}
	
}

function Rod_SetLightIndex(){

	
	switch(Index){
		case Rod.Stone:
			LightIndex = Lighting_CreateLight(global.CurrentRoomIndex, x, y, 0.55, [0.7, 0.7, 0.7]);
			break;
		case Rod.Ice:
		case Rod.Bomb:
			LightIndex = Lighting_CreateLight(global.CurrentRoomIndex, x, y, 0.55, [0.1, 0.3, 0.8]);
			break;
		case Rod.Fire:
			LightIndex = Lighting_CreateLight(global.CurrentRoomIndex, x, y, 0.55, [0.8, 0.3, 0.1]);
			break;
		case Rod.Heart:
			LightIndex = Lighting_CreateLight(global.CurrentRoomIndex, x, y, 0.55, [0.8, 0.1, 0.2]);
			break;
		case Rod.Wealth:
			LightIndex = Lighting_CreateLight(global.CurrentRoomIndex, x, y, 0.55, [0.1, 0.8, 0.3]);
			break;
	}
	
}