var i = floor(image_index);
Lighting_UpdateLight_Pos(RoomIndex, LightIndex, x, y);
Lighting_UpdateLight_Radius(RoomIndex, LightIndex, S[i] + (i <= 8 ? random_range(-0.1, 0.1) : 0) );
Lighting_UpdateLight_RGB(RoomIndex, LightIndex, [R[i], G[i], B[i]]);

if(image_index < 10){

	ds_list_clear(CollisionList);
	var Enemies = instance_place_list(x, y, oEnemy, CollisionList, false);
	if(Enemies > 0){
		for(var EnemyIndex = 0; EnemyIndex < Enemies; EnemyIndex++){
			
			var EnemyInst = CollisionList[| EnemyIndex];
			
			switch(EnemyInst.object_index){
				case oEnemy_Wallmaster:
					continue;
				default:
					//skip bosses
					if(Enemy_IsBoss(EnemyInst.object_index)) continue;	
					break;
			}			
			
			Enemy_LinkWeaponHit(LinkWeaponClass.Fire, 0, EnemyInst, x, y, 0);
		}
	}

	var inst = ObjCollision(x, y, oTorch, FloorLevel);
	if(inst != noone) inst.Lighting = true;
		
	PickupObj_CheckExplosions(x, y, FloorLevel, 16, CollisionList);
	
}