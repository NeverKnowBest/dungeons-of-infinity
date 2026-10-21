
if(InitStars){
	
	for(var LayerIndex = 0; LayerIndex < 3; LayerIndex++){
		
		repeat( (50 - (LayerIndex * 10)) * (RoomH / 256)){
			var GridY = ds_grid_height(Stars[LayerIndex]);
			ds_grid_resize(Stars[LayerIndex], 2, GridY + 1);
		
			ds_grid_add(Stars[LayerIndex], 0, GridY, x + irandom(255));
			ds_grid_add(Stars[LayerIndex], 1, GridY, y + irandom(RoomH));
		}
	
	}
	
	InitStars = false;
	
}

for(var LayerIndex = 0; LayerIndex < 3; LayerIndex++){
	for(var i = 0; i < ds_grid_height(Stars[LayerIndex]); i++){
		Stars[LayerIndex][# 1, i] += Speed[LayerIndex];
		if(Stars[LayerIndex][# 1, i] > y + RoomH) Stars[LayerIndex][# 1, i] = y;
	}
}