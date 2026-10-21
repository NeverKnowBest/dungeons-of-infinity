enum KinstoneState{Idle, DBStarted, Fuse, FuseMerge, TreasureDrop, TreasurePoof, FuseDone, TreasureLight}

enum KinstoneColor{Green, Blue, Red, Gold};
global.KinstoneColorNames[KinstoneColor.Green] = "Green";
global.KinstoneColorNames[KinstoneColor.Blue] = "Blue";
global.KinstoneColorNames[KinstoneColor.Red] = "Red";
global.KinstoneColorNames[KinstoneColor.Gold] = "Gold";

global.KinstoneSignText = "Bring me the other half of this kinstone piece and I shall grant you a reward.";

function KinstoneMain_SetIndex(_Index){

	Item_SetIndex(_Index);

	var r = 0; var g = 0; var b = 0;
	switch(image_index){
		case KinstoneColor.Green:	g = 0.5; r = 0.15; b = 0.15; break;
		case KinstoneColor.Blue:	b = 0.6; r = 0.2; g = 0.2; break;
		case KinstoneColor.Red:		r = 0.65; g = 0.25; b = 0.25; break;
		case KinstoneColor.Gold:	r = 0.6; g = 0.5; b = 0.1; break;
	}
	
	Lighting_UpdateLight_RGB(RoomIndex, LightIndex, [r, g, b]);
}

function Kinstone_PickIndex(){
	
	return choose(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,2,2,2,3,3);
	
}

function Kinstone_Update(){
	
	SpriteY = BaseY - (4 * dsin(t)) - 4;
	t = (t + 5) mod 360;

	Lighting_UpdateLight_Radius(RoomIndex, LightIndex, 1.0 + ((BaseY - SpriteY) / 30.0));		
}
