enum AghanimScript{
	Pause,
	ChargeL,
	ChargeR,
	ChargeLR,
	Shoot,
	Move,
	Bombs,
	GravityBall
}

enum AghanimWeapon{
	EnergyBall,
	BlueBalls
	
}

global.AghanimHandPos[UP] = [-9, -28, 9, -28];
global.AghanimHandPos[DOWN] = [11, -22, -11, -22];
global.AghanimHandPos[LEFT] = [-8,-17,-8,-23];
global.AghanimHandPos[RIGHT] = [8,-23,8,-17];
global.AghanimHandPos[BOTTOMLEFT] = [-3,-14,-11,-22];
global.AghanimHandPos[BOTTOMRIGHT] = [11,-22,3,-14];


function Aghanim_FacingLinkDir(){
	
	var _Dir = point_direction(x, y, oLink.x, oLink.y);
	
	if(_Dir >= 45 && _Dir < 135) return UP
	else if( (_Dir >= 0 && _Dir < 45) || (_Dir >= 330 && _Dir <= 360) ) return RIGHT
	else if(_Dir >= 135 && _Dir < 210) return LEFT
	else if(_Dir >= 210 && _Dir < 235) return BOTTOMLEFT
	else if(_Dir >= 235 && _Dir < 305) return DOWN
	else if(_Dir >= 305 && _Dir < 330) return BOTTOMRIGHT 
		
}

function Aghanim_SetSprite(){
	
	switch(Dir){
		case UP: sprite_index = sBoss_Aghanim_Up; break;
		case DOWN: sprite_index = sBoss_Aghanim_Down; break;
		case LEFT: sprite_index = sBoss_Aghanim_Left; break;
		case RIGHT: sprite_index = sBoss_Aghanim_Right; break;
		case BOTTOMLEFT: sprite_index = sBoss_Aghanim_DownLeft; break;
		case BOTTOMRIGHT: sprite_index = sBoss_Aghanim_DownRight; break;		
	}
	
}

function Aghanim_UpdateCharge(){

	var _Lerp = clamp(Charge_PosIndex - 0.25, 0, Charge_Lerp);

	if(Charge_PosIndex < 0.5){
		Charge_ImageIndex = 2;
	}else if(Charge_PosIndex < 0.75){
		Charge_ImageIndex = 1;
	}else{
		Charge_ImageIndex = 0;
	}

	var _HandPosLX = global.AghanimHandPos[Dir][0];
	var _HandPosLY = global.AghanimHandPos[Dir][1];
	var _HandPosRX = global.AghanimHandPos[Dir][2];
	var _HandPosRY = global.AghanimHandPos[Dir][3];
	
	with(Charge_InstL){
		
		switch(other.Dir){

			case LEFT: 
				depth = other.depth - 5;
				break;
				
			case UP:
			case RIGHT: 
				depth = other.depth + 5;			
				break;

			case BOTTOMRIGHT:
				depth = other.depth - 3;
				break;
				
			default: 
				depth = other.depth - 5;
				break;
		}

		x = other.x + lerp(_HandPosLX, _HandPosRX, _Lerp);
		y = other.y + lerp(_HandPosLY, _HandPosRY, _Lerp);
		
		image_index = other.Charge_ImageIndex;
		
	}

	with(Charge_InstR){
		
		switch(other.Dir){

			case LEFT:  
				depth = other.depth + 5;
				break;
				
			case UP:
				depth = other.depth + 5;					
				break;
			
			case BOTTOMLEFT:
				depth = other.depth - 3;
				break;
				
			default: 
				depth = other.depth - 5;
				break;
		}

		x = other.x + lerp(_HandPosRX, _HandPosLX, _Lerp);
		y = other.y + lerp(_HandPosRY, _HandPosLY, _Lerp);
		
		image_index = other.Charge_ImageIndex;
		
	}


}


function Aghanim_DropBomb(_x, _y){
	
	
	var _BombInst = instance_create_layer(_x, _y, "Objs_Upper", oBomb);
	with(_BombInst){
		z = 48;
		vz = -0.5;
		State = PickupObjState.Travelling;
		Red = true;
		ObjSetY(y);
		alarm[0] = 55;
	}
	
	var _PoofInst = instance_create_layer(_x, _y - 32, EffectLayer(UPPER), oPoof_NoSound);
	
	audio_play_sound(Sound_SwordBeam, 1, false);
	
	audio_play_sound(Sound_Fall, 1, false);

	
}

function Aghanim_TakingItems(){
	
	if(global.Level.Index == DungeonLevel.Aghanim2){ //once AGhanim grabs items, don't draw shield. Shield form inventory will eventually be destroyed, so this only applies during the taking phase
		with(oBoss_Aghanim){
			if(Intro && TakeItems && TakeItems_ShowBag){
				return true;
			}
		}		
	}	
	
	return false;
	
}