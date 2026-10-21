if(!visible) exit;

if(Reset){
	Counts = 0;
	Counts = array_create(ItemClasses, 0);
	Total = 0;
	Reset = false;	
}


var _ItemClass = Probs_RandomItemClass(From);
TreasureLimiter_Update(_ItemClass);
Counts[_ItemClass]++;
Total++;


DrawX = oCamera.X + 4;
DrawY = oCamera.Y + 4;