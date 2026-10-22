PauseImageExit

if(DirSwitch){
	if(instance_exists(DirSwitchInst)){
		exit;
	}else{
		DirSwitch = false;
		DirSwitchInst = noone;	
		Dir = DirSwitchNextDir;
	}
}

vx = 0;
vy = 0;

switch(Dir){
	case LEFT: vx = -Speed; break;
	case RIGHT: vx = Speed;	break;
	case UP: vy = -Speed; break;
	case DOWN: vy = Speed; break;
}

var _MineCartActionInst = instance_place(x + vx, y + vy, oMineCartAction);
if(_MineCartActionInst != noone){
	
	switch(_MineCartActionInst.Action){
			
		case "Destroy":
			instance_destroy(id);
			exit;
			
		case "DirSwitch":
			switch(Dir){
				case LEFT:
					x = _MineCartActionInst.bbox_right;
					// Feather disable once GM2064
					DirSwitchInst = instance_create_layer(x, y, layer, oMineCartDirSwitch, {sprite_index : _MineCartActionInst.Value1 == UP ? sMineCartDirSwitch_LeftToUp: sMineCartDirSwitch_LeftToDown});
					break;
		
				case RIGHT:
					x = _MineCartActionInst.bbox_left - sprite_width;
					// Feather disable once GM2064
					DirSwitchInst = instance_create_layer(x, y, layer, oMineCartDirSwitch, {sprite_index : _MineCartActionInst.Value1 == UP ? sMineCartDirSwitch_RightToUp: sMineCartDirSwitch_RightToDown});
					break;
		
				case UP:
					y = _MineCartActionInst.bbox_bottom;
					// Feather disable once GM2064
					DirSwitchInst = instance_create_layer(x, y, layer, oMineCartDirSwitch, {sprite_index : _MineCartActionInst.Value1 == LEFT ? sMineCartDirSwitch_UpToLeft: sMineCartDirSwitch_UpToRight});
					break;
		
				case DOWN:
					y = _MineCartActionInst.bbox_top - sprite_height;
					// Feather disable once GM2064
					DirSwitchInst = instance_create_layer(x, y, layer, oMineCartDirSwitch, {sprite_index : _MineCartActionInst.Value1 == LEFT ? sMineCartDirSwitch_DownToLeft: sMineCartDirSwitch_DownToRight});
					break;	
	
			}

			DirSwitch = true;
			DirSwitchNextDir = _MineCartActionInst.Value1;
			exit;
			
	
	}
	

	
	
	
}else{
	
	x += vx;
	y += vy;
	
}

switch(Dir){
	case LEFT:
		sprite_index = sMineCart_Left;
		DwarfSprite = sMineCart_Dwarf_Left;
		RockSprite = sMineRocks_H;
		RockDirX = -1;
		break;
		
	case RIGHT:
		sprite_index = sMineCart_Right;
		DwarfSprite = sMineCart_Dwarf_Right;
		RockSprite = sMineRocks_H;
		RockDir = 1;
		break;
		
	case UP:
		sprite_index = sMineCart_Up;
		DwarfSprite = sMineCart_Dwarf_Up;
		RockSprite = sMineRocks_V;
		RockDirX = 1;
		break;
		
	case DOWN:
		sprite_index = sMineCart_Down;
		DwarfSprite = sMineCart_Dwarf_Down;
		RockSprite = sMineRocks_V;
		RockDirX = 1;
		break;	
	
}