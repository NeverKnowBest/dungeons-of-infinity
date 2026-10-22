enum Bow{
	Normal,
	Spread
}

function Bow_Set(){
	
	BowSprite = sBow;
	BowArrow = Bow.Normal;
			
	if(Inventory_ItemIsEquiped){
		
		switch(Inventory_EquipedItem.ItemIndex){
						
			case Bow.Spread:
				BowSprite = sBow_Spread;
				BowArrow = Bow.Spread;						
				break;
		}
	}
			
}

function Arrow_Create(){

	var _A;
	switch(BowArrow){

		default:
			instance_create_layer(x, y, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oArrow);
			break;
			
		case Bow.Spread:
			
			_A = instance_create_layer(x, y, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oArrow);
			_A.Index = 2;
						
			var _V = 1.25;
						
			_A = instance_create_layer(x, y, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oArrow);
			_A.Index = 2;
						
			switch(Facing){
				case UP: case DOWN : _A.vx -= _V; break;
				case LEFT: case RIGHT: _A.vy -= _V; break;
			}
					
			_A = instance_create_layer(x, y, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oArrow);
			_A.Index = 2;
						
			switch(Facing){
				case UP: case DOWN : _A.vx += _V; break;
				case LEFT: case RIGHT: _A.vy += _V; break;
			}

					
			break;
					

	}


}