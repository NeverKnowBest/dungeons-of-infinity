if(global.Paused) exit;

if(SoldierInst.State == EnemyState.OnFire || SoldierInst.State == EnemyState.Frozen || SoldierInst.State == EnemyState.Stone || SoldierInst.StopWatch){
	CanHurtLinkWhenSoldierHurt = false;
	exit;
}

if(SpinContract){
	SpinDist -= SpinExtendSpeed;
	if(SpinDist <= 0){
		SpinDist = 0;
		SpinContract = false;
		with(SoldierInst){
			alarm[3] = IdleDelay;
		}
	}	
}

if(SpinExtend){
	SpinDist += SpinExtendSpeed;
	if(SpinDist >= SpinDistEnd){
		SpinDist = SpinDistEnd;
		SpinExtend = false;
		SpinContract = true;
	}	
}

Spin = SpinDist != 0;
SpinAngle = (SpinAngle + SpinSpeed) mod 360;

layer = (Spin ? global.LayerID_ObjsHighest : IdleLayer);