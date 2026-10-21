	
ObjectCount = 0;
ds_grid_resize(ObjGrid,2,1);
ds_grid_clear(ObjGrid, -1);

for(var ObjTypeIndex = 0; ObjTypeIndex < ObjTypes; ObjTypeIndex++){
		
	var ObjType = ObjTypeList[| ObjTypeIndex];	
	
	with(ObjType){

		if(layer == other.layer){	
			other.ObjectCount++;
			ds_grid_resize(other.ObjGrid, 2, other.ObjectCount);
			ds_grid_add(other.ObjGrid, 0, other.ObjectCount-1, self);
			ds_grid_add(other.ObjGrid, 1, other.ObjectCount-1, variable_instance_exists(self, "y_base") ? y_base : y);
			
		}
		
	}
	
}


if(ObjectCount > 0) ds_grid_sort(ObjGrid, 1, true);
	
Draw = (oLink.State != LinkState.Dead);
