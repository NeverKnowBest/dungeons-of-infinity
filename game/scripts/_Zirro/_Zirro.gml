function Zirro_Shoot(){
	
	if(oLink.Cape) exit;
	
	var BombInst;
	switch(DirFaceLink()){
		case UP: 
			BombInst = instance_create_layer(x, y_base - 12, "ObjsHighest", oEnemy_Zirro_Bomb);
			BombInst.vy = -BombInst.Speed; 
			break;
		case DOWN:
			BombInst = instance_create_layer(x, y_base, "ObjsHighest", oEnemy_Zirro_Bomb);
			BombInst.vy = BombInst.Speed;
			break;
		case LEFT:
			BombInst = instance_create_layer(x - 6, y_base, "ObjsHighest", oEnemy_Zirro_Bomb);
			BombInst.vx = -BombInst.Speed;
			BombInst.z = 18;
			break;
		case RIGHT:
			BombInst = instance_create_layer(x + 6, y_base, "ObjsHighest", oEnemy_Zirro_Bomb);
			BombInst.vx = BombInst.Speed;
			BombInst.z = 18;
			break;
	}
	
}