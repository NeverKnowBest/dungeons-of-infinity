//visible = false; //visible set to false so DepthDrawObjs can sort and draw everything manually
				 
sprite_index = asset_get_index("sSword" + string(global.Inventory.ItemData[ItemClass.Sword].Index));

image_speed = 0;

DepthBehindLink = oLink.depth + 5;
DepthInFrontOfLink = oLink.depth - 5;

SparkleDelay = 5;
if(SwordLevel(Swords.Long)) alarm[0] = SparkleDelay;
CreateSparkle = false;


FloorLevel = oLink.FloorLevel;

CollidedObjList = ds_list_create();

HitPosX = 0;
HitPosY = 0;

StarCollisionRadius = 22 + global.Inventory.ItemData[ItemClass.Sword].Index;
StarCollisionX = 0;
StarCollisionY = 0;

ReadySpark = true;

oLink.SwordChargeAllowed = true;

SwordSpinSparkle_Delay = 1;
SwordSpinSparkle_Speed = 22;

switch(oLink.Facing){
	case DOWN: SwordSpinSparkle_Dir = 240; break;	
	case UP: SwordSpinSparkle_Dir = 60; break;	
	case RIGHT: SwordSpinSparkle_Dir = 330; break;	
	case LEFT: SwordSpinSparkle_Dir = 150; break;	
	
}