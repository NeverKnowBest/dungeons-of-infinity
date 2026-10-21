FloorLevel = GetFloorLevelID(x, y);
FloorLevelStr = GetFloorLevelString(FloorLevel);

X2 = x + W - 1;
Y2 = y + H - 1;
CenterX = x + (W / 2);

GemsInWater = array_create(GemCount);
WishStone = false;

switch(GID){
	
	case TemplateObjGID.GemPond:
		Palette = 0;
		break;
		
	case TemplateObjGID.WishPond:
		Palette = 1;
		break;
}