instance_create_layer(oCamera.X + 32 + irandom(192), oCamera.Y + 16 + irandom(192), "ObjsHighest", oExplosion_Large);
Explosions--;
if(Explosions == 0){
	//CollisionList = ds_list_create();
	//var Enemies = collision_rectangle_list(oCamera.X + 8, oCamera.Y + 8, oCamera.X + CAM_W - 16, oCamera.Y + CAM_H - 16, oEnemy, false, true, CollisionList, false);
	//for(var i = 0; i < Enemies; i++){
	//	var Enemy = CollisionList[| i];
		with(oEnemy){
			//skip bosses
			if(Enemy_IsBoss(object_index)) continue;
			Enemy_LinkWeaponHit(LinkWeaponClass.Fire, 0, self, x, y, -0);
		}		
	//}
	//ds_list_destroy(CollisionList);
	if(instance_exists(oMedallion)) instance_destroy(oMedallion);
	instance_destroy(id);
	
}else
	alarm[0] = 8;