if(Transformed) exit;

var inst = instance_place(x, y, oVillager_Treeman);
if(inst != noone){
	if(!global.Paused && !inst.Transform && !inst.Transformed){
		inst.TransformInit = true;
	}
	Transformed = true;
	exit;
}

if(image_index >= 6){
	var inst = instance_place(x, y, oEnemy);
	if(inst != noone){
		with(inst){

			//skip bosses
			if(Enemy_IsBoss(object_index)) exit;
			
			//skip certain enemies
			switch(object_index){
				case oEnemy_Wallmaster:
					exit;
					break;
			}
			
			if(Enemy_LinkWeaponHit(LinkWeaponClass.Transform, 0, inst, x, y, 0)){
				
				instance_create_layer(ObjCenterX(), ObjCenterY(), "ObjsHigher_" + GetFloorLevelString(FloorLevel), oPoof);
				instance_destroy(id);
				
				var _layer = "Objs_" + GetFloorLevelString(FloorLevel);
				
				switch(object_index){
					case oEnemy_Bubble:
						instance_create_layer(x, y_base, _layer, oItem_Fairy, {From : ItemFrom.Pot});
						break;
						
					case oEnemy_Rat:
						ItemExplosion(x, y_base, FloorLevel, ItemFrom.Enemy,, 1,,ItemHolding);
						break;
						
					default:
						var _FloorLevel = GetFloorLevelID(x, y_base - 4);
						var RatInst = instance_create_layer(x, y_base - 4, _layer, oEnemy_Rat, {FloorLevel : _FloorLevel, 
																								ItemHolding : ItemHolding, 
																								SectionID:  SectionID,
																								RoomIndex: RoomIndex});
						with(RatInst){
							Enemy_UpdateState(EnemyState.Standing);
						}						
						break;
					
				}

			}
		}
		Transformed = true;
	}
}