if(Setup){

	var _Dir = (W > 16 ? HORIZONTAL : VERTICAL);

	switch(_Dir){
		
		case HORIZONTAL:
				
			var _TileW = W / 8;
			x += (irandom(_TileW - 2) * 8);
			vx = Speed;				

			break;
		
		case VERTICAL:
			
			var _TileH = H / 8;
			ObjSetY(y + (irandom(_TileH - 2) * 8));			
			vy = Speed;			

			break;
	}

	Setup = false;
}