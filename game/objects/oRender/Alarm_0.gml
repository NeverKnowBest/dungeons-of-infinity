/// @description mosaic

MosaicAmountIndex += MosaicAmountDir;

MosaicAmount = MosaicAmounts[MosaicAmountIndex];

if(MosaicAmountDir == 1 && MosaicAmountIndex == array_length(MosaicAmounts) - 1) MosaicAmountDir = -1;
if(MosaicAmountDir == -1 && MosaicAmountIndex == 0){
	MosaicAmountDir = 1;
	global.MosaicDo = false;
	exit;
}

alarm[0] = MosaicSpeed;