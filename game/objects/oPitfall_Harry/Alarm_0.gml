/// @description Flash
if(!global.ArcadeVP_Show) exit;

visible = !visible;
KilledFlashCounter--;
if(KilledFlashCounter == 0){
	KilledDone = true;
	visible = true;
}else alarm[0] = 10;
