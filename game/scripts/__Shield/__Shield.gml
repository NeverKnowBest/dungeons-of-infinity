global.ShieldNames = ["Wooden", "Triforce", "Mirror", "Golden"];

function Shield_InitData(){

	ShieldSprite[0][UP] = sShield0_Up; ShieldSprite[0][DOWN] = sShield0_Down; ShieldSprite[0][LEFT] = sShield0_Left; ShieldSprite[0][RIGHT] = sShield0_Right;
	ShieldSprite[1][UP] = sShield1_Up; ShieldSprite[1][DOWN] = sShield1_Down; ShieldSprite[1][LEFT] = sShield1_Left; ShieldSprite[1][RIGHT] = sShield1_Right;
	ShieldSprite[2][UP] = sShield2_Up; ShieldSprite[2][DOWN] = sShield2_Down; ShieldSprite[2][LEFT] = sShield2_Left; ShieldSprite[2][RIGHT] = sShield2_Right;
	ShieldSprite[3][UP] = sShield3_Up; ShieldSprite[3][DOWN] = sShield3_Down; ShieldSprite[3][LEFT] = sShield3_Left; ShieldSprite[3][RIGHT] = sShield3_Right;

	//offsets relative to Link's x/y for each animation frame

	ShieldOffsetX[LinkState.Standing][UP][0] = 5; ShieldOffsetX[LinkState.Standing][UP][1] = 5; 
	ShieldOffsetY[LinkState.Standing][UP][0] = -7; ShieldOffsetY[LinkState.Standing][UP][1] = -7; 
	ShieldOffsetX[LinkState.Standing][DOWN][0] = -5; ShieldOffsetX[LinkState.Standing][DOWN][1] = -5; 
	ShieldOffsetY[LinkState.Standing][DOWN][0] = -4; ShieldOffsetY[LinkState.Standing][DOWN][1] = -4; 
	ShieldOffsetX[LinkState.Standing][LEFT][0] = -6; ShieldOffsetX[LinkState.Standing][LEFT][1] = -6; 
	ShieldOffsetY[LinkState.Standing][LEFT][0] = -8; ShieldOffsetY[LinkState.Standing][LEFT][1] = -8; 
	ShieldOffsetX[LinkState.Standing][RIGHT][0] = 6; ShieldOffsetX[LinkState.Standing][RIGHT][1] = 6; 
	ShieldOffsetY[LinkState.Standing][RIGHT][0] = -8; ShieldOffsetY[LinkState.Standing][RIGHT][1] = -8; 
	
	ShieldOffsetX[LinkState.Walking][UP][0] = 5;	ShieldOffsetX[LinkState.Walking][UP][1] = 5;	ShieldOffsetX[LinkState.Walking][UP][2] = 5;	ShieldOffsetX[LinkState.Walking][UP][3] = 5;	ShieldOffsetX[LinkState.Walking][UP][4] = 5;	ShieldOffsetX[LinkState.Walking][UP][5] = 5;	ShieldOffsetX[LinkState.Walking][UP][6] = 5;	ShieldOffsetX[LinkState.Walking][UP][7] = 5;
	ShieldOffsetY[LinkState.Walking][UP][0] = -6;	ShieldOffsetY[LinkState.Walking][UP][1] = -7;	ShieldOffsetY[LinkState.Walking][UP][2] = -8;	ShieldOffsetY[LinkState.Walking][UP][3] = -6;	ShieldOffsetY[LinkState.Walking][UP][4] = -6;	ShieldOffsetY[LinkState.Walking][UP][5] = -7;	ShieldOffsetY[LinkState.Walking][UP][6] = -8;	ShieldOffsetY[LinkState.Walking][UP][7] = -6;
	ShieldOffsetX[LinkState.Walking][DOWN][0] = -5;	ShieldOffsetX[LinkState.Walking][DOWN][1] = -5;	ShieldOffsetX[LinkState.Walking][DOWN][2] = -5;	ShieldOffsetX[LinkState.Walking][DOWN][3] = -5;	ShieldOffsetX[LinkState.Walking][DOWN][4] = -5;	ShieldOffsetX[LinkState.Walking][DOWN][5] = -5;	ShieldOffsetX[LinkState.Walking][DOWN][6] = -5;	ShieldOffsetX[LinkState.Walking][DOWN][7] = -5;
	ShieldOffsetY[LinkState.Walking][DOWN][0] = -3;	ShieldOffsetY[LinkState.Walking][DOWN][1] = -4;	ShieldOffsetY[LinkState.Walking][DOWN][2] = -5;	ShieldOffsetY[LinkState.Walking][DOWN][3] = -3;	ShieldOffsetY[LinkState.Walking][DOWN][4] = -3;	ShieldOffsetY[LinkState.Walking][DOWN][5] = -4;	ShieldOffsetY[LinkState.Walking][DOWN][6] = -5;	ShieldOffsetY[LinkState.Walking][DOWN][7] = -3;
	ShieldOffsetX[LinkState.Walking][LEFT][0] = -6;	ShieldOffsetX[LinkState.Walking][LEFT][1] = -6;	ShieldOffsetX[LinkState.Walking][LEFT][2] = -6;	ShieldOffsetX[LinkState.Walking][LEFT][3] = -6;	ShieldOffsetX[LinkState.Walking][LEFT][4] = -6;	ShieldOffsetX[LinkState.Walking][LEFT][5] = -6;	ShieldOffsetX[LinkState.Walking][LEFT][6] = -6;	ShieldOffsetX[LinkState.Walking][LEFT][7] = -6;
	ShieldOffsetY[LinkState.Walking][LEFT][0] = -8;	ShieldOffsetY[LinkState.Walking][LEFT][1] = -9;	ShieldOffsetY[LinkState.Walking][LEFT][2] = -9;	ShieldOffsetY[LinkState.Walking][LEFT][3] = -8;	ShieldOffsetY[LinkState.Walking][LEFT][4] = -8;	ShieldOffsetY[LinkState.Walking][LEFT][5] = -9;	ShieldOffsetY[LinkState.Walking][LEFT][6] = -9;	ShieldOffsetY[LinkState.Walking][LEFT][7] = -8;
	ShieldOffsetX[LinkState.Walking][RIGHT][0] = 6;	ShieldOffsetX[LinkState.Walking][RIGHT][1] = 6;	ShieldOffsetX[LinkState.Walking][RIGHT][2] = 6;	ShieldOffsetX[LinkState.Walking][RIGHT][3] = 6;	ShieldOffsetX[LinkState.Walking][RIGHT][4] = 6;	ShieldOffsetX[LinkState.Walking][RIGHT][5] = 6;	ShieldOffsetX[LinkState.Walking][RIGHT][6] = 6;	ShieldOffsetX[LinkState.Walking][RIGHT][7] = 6;
	ShieldOffsetY[LinkState.Walking][RIGHT][0] = -8;ShieldOffsetY[LinkState.Walking][RIGHT][1] = -9;ShieldOffsetY[LinkState.Walking][RIGHT][2] = -9;ShieldOffsetY[LinkState.Walking][RIGHT][3] = -8;ShieldOffsetY[LinkState.Walking][RIGHT][4] = -8;ShieldOffsetY[LinkState.Walking][RIGHT][5] = -9;ShieldOffsetY[LinkState.Walking][RIGHT][6] = -9;ShieldOffsetY[LinkState.Walking][RIGHT][7] = -8;					

	ShieldOffsetX[LinkState.Sword][UP][0] = 7;	ShieldOffsetX[LinkState.Sword][UP][1] = 7;	ShieldOffsetX[LinkState.Sword][UP][2] = 7;	ShieldOffsetX[LinkState.Sword][UP][3] = 7;	ShieldOffsetX[LinkState.Sword][UP][4] = 7;	ShieldOffsetX[LinkState.Sword][UP][5] = 7;	ShieldOffsetX[LinkState.Sword][UP][6] = 7;	ShieldOffsetX[LinkState.Sword][UP][7] = 7;	ShieldOffsetX[LinkState.Sword][UP][8] = 7;	ShieldOffsetX[LinkState.Sword][UP][9] = 7; ShieldOffsetX[LinkState.Sword][UP][10] = 7; ShieldOffsetX[LinkState.Sword][UP][11] = 7; ShieldOffsetX[LinkState.Sword][UP][12] = 7; ShieldOffsetX[LinkState.Sword][UP][13] = 7;
	ShieldOffsetY[LinkState.Sword][UP][0] = -5;	ShieldOffsetY[LinkState.Sword][UP][1] = -5;	ShieldOffsetY[LinkState.Sword][UP][2] = -7;	ShieldOffsetY[LinkState.Sword][UP][3] = -7;	ShieldOffsetY[LinkState.Sword][UP][4] = -8;	ShieldOffsetY[LinkState.Sword][UP][5] = -11;ShieldOffsetY[LinkState.Sword][UP][6] = -11;ShieldOffsetY[LinkState.Sword][UP][7] = -11;ShieldOffsetY[LinkState.Sword][UP][8] = -11;ShieldOffsetY[LinkState.Sword][UP][9] = -8; ShieldOffsetY[LinkState.Sword][UP][10] = -7; ShieldOffsetY[LinkState.Sword][UP][11] = -7; ShieldOffsetY[LinkState.Sword][UP][12] = -7; ShieldOffsetY[LinkState.Sword][UP][13] = -7;
	ShieldOffsetX[LinkState.Sword][DOWN][0] = -8;	ShieldOffsetX[LinkState.Sword][DOWN][1] = -8;	ShieldOffsetX[LinkState.Sword][DOWN][2] = -8;	ShieldOffsetX[LinkState.Sword][DOWN][3] = -8;	ShieldOffsetX[LinkState.Sword][DOWN][4] = -8;	ShieldOffsetX[LinkState.Sword][DOWN][5] = -8;	ShieldOffsetX[LinkState.Sword][DOWN][6] = -8;	ShieldOffsetX[LinkState.Sword][DOWN][7] = -8;	ShieldOffsetX[LinkState.Sword][DOWN][8] = -8;	ShieldOffsetX[LinkState.Sword][DOWN][9] = -8; ShieldOffsetX[LinkState.Sword][DOWN][10] = -8; ShieldOffsetX[LinkState.Sword][DOWN][11] = -8; ShieldOffsetX[LinkState.Sword][DOWN][12] = -8; ShieldOffsetX[LinkState.Sword][DOWN][13] = -8;
	ShieldOffsetY[LinkState.Sword][DOWN][0] = -9;	ShieldOffsetY[LinkState.Sword][DOWN][1] = -9;	ShieldOffsetY[LinkState.Sword][DOWN][2] = -7;	ShieldOffsetY[LinkState.Sword][DOWN][3] = -7;	ShieldOffsetY[LinkState.Sword][DOWN][4] = -6;	ShieldOffsetY[LinkState.Sword][DOWN][5] = -4;	ShieldOffsetY[LinkState.Sword][DOWN][6] = -4;	ShieldOffsetY[LinkState.Sword][DOWN][7] = -4;	ShieldOffsetY[LinkState.Sword][DOWN][8] = -4;	ShieldOffsetY[LinkState.Sword][DOWN][9] = -6; ShieldOffsetY[LinkState.Sword][DOWN][10] = -6; ShieldOffsetY[LinkState.Sword][DOWN][11] = -6; ShieldOffsetY[LinkState.Sword][DOWN][12] = -6; ShieldOffsetY[LinkState.Sword][DOWN][13] = -6;
	ShieldOffsetX[LinkState.Sword][LEFT][0] = -2;	ShieldOffsetX[LinkState.Sword][LEFT][1] = -2;	ShieldOffsetX[LinkState.Sword][LEFT][2] = -2;	ShieldOffsetX[LinkState.Sword][LEFT][3] = -2;	ShieldOffsetX[LinkState.Sword][LEFT][4] = -2;	ShieldOffsetX[LinkState.Sword][LEFT][5] = -2;	ShieldOffsetX[LinkState.Sword][LEFT][6] = -2;	ShieldOffsetX[LinkState.Sword][LEFT][7] = -2;	ShieldOffsetX[LinkState.Sword][LEFT][8] = -2;	ShieldOffsetX[LinkState.Sword][LEFT][9] = -2; ShieldOffsetX[LinkState.Sword][LEFT][10] = -2; ShieldOffsetX[LinkState.Sword][LEFT][11] = -2; ShieldOffsetX[LinkState.Sword][LEFT][12] = -2; ShieldOffsetX[LinkState.Sword][LEFT][13] = -2;
	ShieldOffsetY[LinkState.Sword][LEFT][0] = -9;	ShieldOffsetY[LinkState.Sword][LEFT][1] = -9;	ShieldOffsetY[LinkState.Sword][LEFT][2] = -7;	ShieldOffsetY[LinkState.Sword][LEFT][3] = -7;	ShieldOffsetY[LinkState.Sword][LEFT][4] = -6;	ShieldOffsetY[LinkState.Sword][LEFT][5] = -4;	ShieldOffsetY[LinkState.Sword][LEFT][6] = -4;	ShieldOffsetY[LinkState.Sword][LEFT][7] = -4;	ShieldOffsetY[LinkState.Sword][LEFT][8] = -4;	ShieldOffsetY[LinkState.Sword][LEFT][9] = -6; ShieldOffsetY[LinkState.Sword][LEFT][10] = -6; ShieldOffsetY[LinkState.Sword][LEFT][11] = -6; ShieldOffsetY[LinkState.Sword][LEFT][12] = -6; ShieldOffsetY[LinkState.Sword][LEFT][13] = -6;
	ShieldOffsetX[LinkState.Sword][RIGHT][0] = 0;	ShieldOffsetX[LinkState.Sword][RIGHT][1] = 0;	ShieldOffsetX[LinkState.Sword][RIGHT][2] = 0;	ShieldOffsetX[LinkState.Sword][RIGHT][3] = 0;	ShieldOffsetX[LinkState.Sword][RIGHT][4] = 0;	ShieldOffsetX[LinkState.Sword][RIGHT][5] = 0;	ShieldOffsetX[LinkState.Sword][RIGHT][6] = 0;	ShieldOffsetX[LinkState.Sword][RIGHT][7] = 0;	ShieldOffsetX[LinkState.Sword][RIGHT][8] = 0;	ShieldOffsetX[LinkState.Sword][RIGHT][9] = 0; ShieldOffsetX[LinkState.Sword][RIGHT][10] = 0; ShieldOffsetX[LinkState.Sword][RIGHT][11] = 0; ShieldOffsetX[LinkState.Sword][RIGHT][12] = 0; ShieldOffsetX[LinkState.Sword][RIGHT][13] = 0;
	ShieldOffsetY[LinkState.Sword][RIGHT][0] = -9;	ShieldOffsetY[LinkState.Sword][RIGHT][1] = -9;	ShieldOffsetY[LinkState.Sword][RIGHT][2] = -7;	ShieldOffsetY[LinkState.Sword][RIGHT][3] = -7;	ShieldOffsetY[LinkState.Sword][RIGHT][4] = -6;	ShieldOffsetY[LinkState.Sword][RIGHT][5] = -4;	ShieldOffsetY[LinkState.Sword][RIGHT][6] = -4;	ShieldOffsetY[LinkState.Sword][RIGHT][7] = -4;	ShieldOffsetY[LinkState.Sword][RIGHT][8] = -4;	ShieldOffsetY[LinkState.Sword][RIGHT][9] = -6; ShieldOffsetY[LinkState.Sword][RIGHT][10] = -6; ShieldOffsetY[LinkState.Sword][RIGHT][11] = -6; ShieldOffsetY[LinkState.Sword][RIGHT][12] = -6; ShieldOffsetY[LinkState.Sword][RIGHT][13] = -6;

	ShieldOffsetX[LinkState.SwordPoke][UP][0] = 7; ShieldOffsetX[LinkState.SwordPoke][UP][1] = 7; ShieldOffsetX[LinkState.SwordPoke][UP][2] = 7; 
	ShieldOffsetY[LinkState.SwordPoke][UP][0] = -8; ShieldOffsetY[LinkState.SwordPoke][UP][1] = -9; ShieldOffsetY[LinkState.SwordPoke][UP][2] = -8;
	ShieldOffsetX[LinkState.SwordPoke][DOWN][0] = -7; ShieldOffsetX[LinkState.SwordPoke][DOWN][1] = -7; ShieldOffsetX[LinkState.SwordPoke][DOWN][2] = -7; 
	ShieldOffsetY[LinkState.SwordPoke][DOWN][0] = -7; ShieldOffsetY[LinkState.SwordPoke][DOWN][1] = -6; ShieldOffsetY[LinkState.SwordPoke][DOWN][2] = -7; 
	ShieldOffsetX[LinkState.SwordPoke][LEFT][0] = -3; ShieldOffsetX[LinkState.SwordPoke][LEFT][1] = -4; ShieldOffsetX[LinkState.SwordPoke][LEFT][2] = -3; 
	ShieldOffsetY[LinkState.SwordPoke][LEFT][0] = -7; ShieldOffsetY[LinkState.SwordPoke][LEFT][1] = -6; ShieldOffsetY[LinkState.SwordPoke][LEFT][2] = -7; 
	ShieldOffsetX[LinkState.SwordPoke][RIGHT][0] = 3; ShieldOffsetX[LinkState.SwordPoke][RIGHT][1] = 4; ShieldOffsetX[LinkState.SwordPoke][RIGHT][2] = 3; 
	ShieldOffsetY[LinkState.SwordPoke][RIGHT][0] = -7; ShieldOffsetY[LinkState.SwordPoke][RIGHT][1] = -6; ShieldOffsetY[LinkState.SwordPoke][RIGHT][2] = -7; 
	
	ShieldOffsetX_SwordCharge_Stand[UP][0] = 7; 
	ShieldOffsetY_SwordCharge_Stand[UP][0] = -8;
	ShieldOffsetX_SwordCharge_Stand[DOWN][0] = -7;
	ShieldOffsetY_SwordCharge_Stand[DOWN][0] = -7;
	ShieldOffsetX_SwordCharge_Stand[LEFT][0] = -2;
	ShieldOffsetY_SwordCharge_Stand[LEFT][0] = -7;
	ShieldOffsetX_SwordCharge_Stand[RIGHT][0] = 1;
	ShieldOffsetY_SwordCharge_Stand[RIGHT][0] = -7;
	
	ShieldOffsetX_SwordCharge_Walk[UP][0] = 7; ShieldOffsetX_SwordCharge_Walk[UP][1] = 7; ShieldOffsetX_SwordCharge_Walk[UP][2] = 7; ShieldOffsetX_SwordCharge_Walk[UP][3] = 7; ShieldOffsetX_SwordCharge_Walk[UP][4] = 7; ShieldOffsetX_SwordCharge_Walk[UP][5] = 7;
	ShieldOffsetY_SwordCharge_Walk[UP][0] = -7; ShieldOffsetY_SwordCharge_Walk[UP][1] = -6; ShieldOffsetY_SwordCharge_Walk[UP][2] = -8; ShieldOffsetY_SwordCharge_Walk[UP][3] = -7; ShieldOffsetY_SwordCharge_Walk[UP][4] = -6; ShieldOffsetY_SwordCharge_Walk[UP][5] = -8;
	ShieldOffsetX_SwordCharge_Walk[DOWN][0] = -7; ShieldOffsetX_SwordCharge_Walk[DOWN][1] = -7; ShieldOffsetX_SwordCharge_Walk[DOWN][2] = -7; ShieldOffsetX_SwordCharge_Walk[DOWN][3] = -7; ShieldOffsetX_SwordCharge_Walk[DOWN][4] = -7; ShieldOffsetX_SwordCharge_Walk[DOWN][5] = -7;
	ShieldOffsetY_SwordCharge_Walk[DOWN][0] = -6; ShieldOffsetY_SwordCharge_Walk[DOWN][1] = -5; ShieldOffsetY_SwordCharge_Walk[DOWN][2] = -7; ShieldOffsetY_SwordCharge_Walk[DOWN][3] = -6; ShieldOffsetY_SwordCharge_Walk[DOWN][4] = -5; ShieldOffsetY_SwordCharge_Walk[DOWN][5] = -7;
	ShieldOffsetX_SwordCharge_Walk[LEFT][0] = -2; ShieldOffsetX_SwordCharge_Walk[LEFT][1] = -2; ShieldOffsetX_SwordCharge_Walk[LEFT][2] = -2;
	ShieldOffsetY_SwordCharge_Walk[LEFT][0] = -6; ShieldOffsetY_SwordCharge_Walk[LEFT][1] = -5; ShieldOffsetY_SwordCharge_Walk[LEFT][2] = -7;
	ShieldOffsetX_SwordCharge_Walk[RIGHT][0] = 1; ShieldOffsetX_SwordCharge_Walk[RIGHT][1] = 1; ShieldOffsetX_SwordCharge_Walk[RIGHT][2] = 1;
	ShieldOffsetY_SwordCharge_Walk[RIGHT][0] = -6; ShieldOffsetY_SwordCharge_Walk[RIGHT][1] = -5; ShieldOffsetY_SwordCharge_Walk[RIGHT][2] = -7;
	
	ShieldOffsetX[LinkState.Hookshot][UP][0] = 7; 
	ShieldOffsetY[LinkState.Hookshot][UP][0] = -8; 
	ShieldOffsetX[LinkState.Hookshot][DOWN][0] = -6;
	ShieldOffsetY[LinkState.Hookshot][DOWN][0] = -8; 
	ShieldOffsetX[LinkState.Hookshot][LEFT][0] = 0; 
	ShieldOffsetY[LinkState.Hookshot][LEFT][0] = -6; 
	ShieldOffsetX[LinkState.Hookshot][RIGHT][0] = 0; 
	ShieldOffsetY[LinkState.Hookshot][RIGHT][0] = -6; 

	ShieldOffsetX[LinkState.Boomerang][UP][0] = 5; ShieldOffsetX[LinkState.Boomerang][UP][1] = 7; ShieldOffsetX[LinkState.Boomerang][UP][2] = 7; 
	ShieldOffsetY[LinkState.Boomerang][UP][0] = -7; ShieldOffsetY[LinkState.Boomerang][UP][1] = -7; ShieldOffsetY[LinkState.Boomerang][UP][2] = -7; 
	ShieldOffsetX[LinkState.Boomerang][DOWN][0] = -5; ShieldOffsetX[LinkState.Boomerang][DOWN][1] = -8; ShieldOffsetX[LinkState.Boomerang][DOWN][2] = -8; 
	ShieldOffsetY[LinkState.Boomerang][DOWN][0] = -4; ShieldOffsetY[LinkState.Boomerang][DOWN][1] = -7; ShieldOffsetY[LinkState.Boomerang][DOWN][2] = -7; 
	ShieldOffsetX[LinkState.Boomerang][LEFT][0] = 0; ShieldOffsetX[LinkState.Boomerang][LEFT][1] = 0; ShieldOffsetX[LinkState.Boomerang][LEFT][2] = 0; 
	ShieldOffsetY[LinkState.Boomerang][LEFT][0] = -6; ShieldOffsetY[LinkState.Boomerang][LEFT][1] = -6; ShieldOffsetY[LinkState.Boomerang][LEFT][2] = -6; 
	ShieldOffsetX[LinkState.Boomerang][RIGHT][0] = 0; ShieldOffsetX[LinkState.Boomerang][RIGHT][1] = 0; ShieldOffsetX[LinkState.Boomerang][RIGHT][2] = 0; 
	ShieldOffsetY[LinkState.Boomerang][RIGHT][0] = -6; ShieldOffsetY[LinkState.Boomerang][RIGHT][1] = -6; ShieldOffsetY[LinkState.Boomerang][RIGHT][2] = -6; 

	ShieldOffsetX[LinkState.Rod][UP] = array_create(5, 7); 
	ShieldOffsetY[LinkState.Rod][UP] = array_create(5, -7); 
	ShieldOffsetX[LinkState.Rod][DOWN] = array_create(5, -7);
	ShieldOffsetY[LinkState.Rod][DOWN] = array_create(5, -7);
	ShieldOffsetX[LinkState.Rod][LEFT] = array_create(5, 0);
	ShieldOffsetY[LinkState.Rod][LEFT] = array_create(5, -7); 
	ShieldOffsetX[LinkState.Rod][RIGHT] = array_create(5, 0);; 
	ShieldOffsetY[LinkState.Rod][RIGHT] = array_create(5, -7); 

}

function Shield_Draw(){
	
	if(global.Inventory.ItemData[ItemClass.Shield].Index < 0) exit;
	
	if(AghanimTakingItems) return false;
	
	if(Cape) exit;	
	
	switch(State){
		default: exit;
		//continue drawing the shield only if in these states
		case LinkState.Idle:
		case LinkState.Standing:
		case LinkState.Walking:
		case LinkState.Sword:
		case LinkState.SwordPoke:
		case LinkState.Hookshot:
		case LinkState.Boomerang:
		case LinkState.Rod:
		case LinkState.TreasureOpening:
		case LinkState.Inventory:
		case LinkState.Dialogue:
		case LinkState.AutoMove:
		
			break;
		
	}
	
	if(ItemHolding != noone && instance_exists(ItemHolding)) exit; //if holding an item don't draw shield
	
	if(oCamera.RoomTransition == NONE || oCamera.OpenTransition){ //you can spot the larger shields at Link's feet when he's waiting at a door for the camera to finish transitoning, so don't draw the shield during the transition
		var ImgInd = floor(image_index);
		switch(State){
			default: ShieldDir = Facing;
				break;
			
				//for these weapons he's holding the shield at a different orientation than his facing dir
			case LinkState.Boomerang:
				switch(Facing){
					case UP: 
						ShieldDir = (ImgInd == 0 ? UP : RIGHT); 
						break;						
					case DOWN: 
						ShieldDir = (ImgInd == 0 ? DOWN : LEFT); 
						break;
					case LEFT:
					case RIGHT: ShieldDir = UP; break;					
				}				
				break;
			
			case LinkState.Standing:
			case LinkState.Walking:
			case LinkState.AutoMove:
				if(SwordCharge == 0){
					ShieldDir = Facing;
					break;
				}
			case LinkState.Sword:
			case LinkState.SwordPoke:
			case LinkState.Hookshot:
			case LinkState.Rod:
				switch(Facing){
					case UP: ShieldDir = RIGHT; break;
					case DOWN: ShieldDir = LEFT; break;
					case LEFT:
					case RIGHT: ShieldDir = UP; break;					
				}
				break;
			
		}
		
		var _State = (State == LinkState.Idle || State == LinkState.TreasureOpening || State == LinkState.Inventory || State == LinkState.Dialogue ? LinkState.Standing : (State == LinkState.AutoMove ? LinkState.Walking : State)); 


			
		if(SwordCharge > 0){
			switch(State){
				case LinkState.Standing:
					var _PosX = x + ShieldOffsetX_SwordCharge_Stand[Facing][ImgInd];
					var _PosY = y + ShieldOffsetY_SwordCharge_Stand[Facing][ImgInd];
					break;
				default:
					var _PosX = x + ShieldOffsetX_SwordCharge_Walk[Facing][ImgInd];
					var _PosY = y + ShieldOffsetY_SwordCharge_Walk[Facing][ImgInd];
					break;
			}
				
		}else{
			var _PosX = x + ShieldOffsetX[_State][Facing][ImgInd];
			var _PosY = y + ShieldOffsetY[_State][Facing][ImgInd];			
		}
		
		draw_sprite(ShieldSprite[global.Inventory.ItemData[ItemClass.Shield].Index][ShieldDir], 0, _PosX, _PosY);
	}
			
}

function Shield_Hit(_Inst, _x, _y){
	
	if(global.Inventory.ItemData[ItemClass.Shield].Index == -1) return false
	
	if(State == LinkState.Hit || Invincible || Cape || ItemHolding != noone) return false;
	
	if(State != LinkState.Standing && State != LinkState.Walking && State != LinkState.AutoMove) return false


	switch(_Inst.object_index){
		case oBone:
		case oRock:
		case oRedBall:
			if(global.Inventory.ItemData[ItemClass.Shield].Index < 0) return false
			break;
			
		case oEnemy_Fireball:
			if(global.Inventory.ItemData[ItemClass.Shield].Index < 1) return false
			break;
			
		case oBeam:
		case oEnemy_Fireball2:
			if(global.Inventory.ItemData[ItemClass.Shield].Index < 2) return false
			break;
			
		case oEnemy_Beamos:
			if(global.Inventory.ItemData[ItemClass.Shield].Index < 3) return false
			break;
	}

	var _ShieldHit = false;
			
	var D = point_direction(x, y - 6, _x, _y);
	
	//Adjust shield when holding sword out since Link holds it to his side
	var _Facing = Facing;
	if(SwordCharge > 0){
		switch(Facing){
			case UP:
				_Facing = RIGHT;
				break;
			case DOWN:
				_Facing = LEFT; 
				break;
			case LEFT:
			case RIGHT:
				_Facing = UP;
				break;			
			
		}
		
	}
	
	switch(_Facing){
		case UP:
			if(D >= 20 && D <= 160) _ShieldHit = true; 
			break;
		case DOWN:
			if(D >= 200 && D <= 340) _ShieldHit = true; 
			break;
		case LEFT:
			if(D >= 110 && D <= 250) _ShieldHit = true; 
			break;
		case RIGHT:
			if( (D >= 0 && D <= 70) || (D >= 290 && D < 360) ) _ShieldHit = true; 
			break;
		
	}			
			
	return _ShieldHit
	
}