// Feather disable GM2064
event_inherited();


x = oLink.x;
ObjSetY(oLink.y - 6);

FloorLevel = oLink.FloorLevel;
FloorLevelStr = GetFloorLevelString(FloorLevel);

OutsideCameraDestroy = true;


Speed = 4.5;


switch(oLink.Facing){
	case UP:
		vy = -Speed;
		break;
	
	case DOWN:
		vy = Speed;
		break;
	
	case LEFT:
		vx = -Speed;
		break;
	
	case RIGHT:
		vx = Speed;
		break;
	
	
}

AllowCollision = false; //prevent collision for a few frames to get away from Link, otherwise the beam collides first before the sword.
alarm[0] = 4;

BeamEffectInst = instance_create_layer(x, y, layer, oSwordBeam_Effect, {RoomIndex : RoomIndex, Speed : Speed, FloorLevel : FloorLevel});

