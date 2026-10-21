

global.DoorInstances = array_create(0);

for(var DoorPosition = 1; DoorPosition <= 24; DoorPosition++){
	var PosX = global.DoorCoordinates[0][DoorPosition].x - 16;
	var PosY = global.DoorCoordinates[0][DoorPosition].y - 16;
	switch(DoorPosition){
		case 1: case 11: case 12: case 13: case 23: case 24: var DoorSpr = sDoor_Top; break;
		case 2: case 3: case 4: case 14: case 15: case 16: var DoorSpr = sDoor_Right; break;
		case 5: case 6: case 7: case 17: case 18: case 19: var DoorSpr = sDoor_Bottom; break;
		case 8: case 9: case 10: case 20: case 21: case 22: var DoorSpr = sDoor_Left; break;
	}
	var DoorInst = instance_create_layer(x + PosX, y + PosY, "UI", oRoom_Door);
	DoorInst.sprite_index = DoorSpr;
	DoorInst.W = DoorInst.sprite_width;
	DoorInst.H = DoorInst.sprite_height;	
	DoorInst.Position = DoorPosition;
	DoorInst.depth--;
	array_insert(global.DoorInstances, DoorPosition, DoorInst);
}

SelectedDoor = noone;


chkLowerFloor = CreateButton(x, y + sprite_height + 8, true, "Lower Floor", fnt_button);


//btnEntrance = CreateButton(x + 140, y + sprite_height + 8, false, "Entrance", fnt_button);
//btnEntrance.Enabled = false;	
//btnEntrance.visible = false;	





