enum Cane{Rupees, Bombs, Hearts}

global.CaneNames = ["Rupees", "Bombs", "Hearts"];

//function Rod_InitPos(_Inst){
//	with(_Inst){
//		Dir = oLink.Facing;
//		switch(Dir){
//			case LEFT: x-=16; ObjSetY(y_base - 5); vx = -Speed; break;
//			case RIGHT: x+=16; ObjSetY(y_base - 5); vx = Speed; break;
//			case UP:
//				x-=6; ObjSetY(y_base - 24); vy = -Speed;  
//				layer = layer_get_id("ObjsFloor_" + GetFloorLevelString(FloorLevel));
//				alarm[11] = 3;
//				break;
//			case DOWN: x+=4; ObjSetY(y_base + 2); vy = Speed; break;
//		}
//	}
	
//}