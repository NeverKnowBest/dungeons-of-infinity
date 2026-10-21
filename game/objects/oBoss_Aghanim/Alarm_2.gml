if(BombIndex >= BombsTotal){
	ScriptNext = true;
	exit;
}

image_index = 2 + (BombIndex mod 2);

switch(image_index){
	case 2: //Left
		var _HandPosX = x + global.AghanimHandPos[Dir][0];
		var _HandPosY = y + global.AghanimHandPos[Dir][1];	
		break;
	case 3: //Righty
		var _HandPosX = x + global.AghanimHandPos[Dir][2];
		var _HandPosY = y + global.AghanimHandPos[Dir][3];	
}

instance_create_layer(_HandPosX, _HandPosY, EffectLayer(UPPER), oSwordBeamHit);

var _BombX = MovePosX[BombPosIndex[BombIndex] mod 3];
var _BombY = MovePosY[BombPosIndex[BombIndex] div 3];

Aghanim_DropBomb(_BombX + irandom_range(-16, 16), _BombY + irandom_range(-16, 16));
	
BombIndex++;

alarm[2] = BombDelay;

