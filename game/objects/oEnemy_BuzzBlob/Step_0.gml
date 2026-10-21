event_inherited();

if(KnockBackDone || StunDone || ShockDone){
	Enemy_UpdateState(EnemyState.Walking);
	Lighting_UpdateLight_Visible(RoomIndex, LightIndex, false);
	BuzzBlob_UpdateDir();
}

PauseCheck

switch(State){
	
	case EnemyState.Standing:
	case EnemyState.Walking:
		break;
		
	case EnemyState.Shock:

		ShockFrame = (ShockFrame + 0.15);
		ShockPal = floor(ShockFrame) mod 3;
		Lighting_UpdateLight_Radius(RoomIndex, LightIndex, random_range(0.6, 0.7));
		Lighting_UpdateLight_RGB(RoomIndex, LightIndex, [ShockPal == 1 ? 0.6 : 0.3, ShockPal > 0 ? 0.6 : 0.3, ShockPal == 0 ? 0.6 : 0.3]);
		break;
		
}