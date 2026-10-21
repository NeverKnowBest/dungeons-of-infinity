enum MoldormSection{
	BodyL1,
	BodyL2,
	BodyS,
	Tail		
}

function Moldorm_CheckLinkHit(){
	
	if(oBoss_Moldorm.State == EnemyState.Killed) exit;
	
	var _LinkInst = instance_place(x, y, oLink);
	if(_LinkInst != noone){
		with(oLink){
			LinkHit(point_direction(other.x, other.y, x, y), 2, 12, 2.75);
		}
	}
	
}

function Moldorm_PixelRender(){

	if(oBoss_Moldorm.State == EnemyState.Hit || oBoss_Moldorm.State == EnemyState.Killed){
		PixelRender_Dim(true, true, false, noone, 0, true, global.KnockBackColors[oBoss_Moldorm.KnockBackColorFrame]);
	}else if(oBoss_Moldorm.Energy <= oBoss_Moldorm.LowEnergy){
		PixelRender_Dim(true, true, false, noone, 0, true, KB_R);
	}else{
		PixelRender_Dim(true, true, false, noone, 0, false, 0);
	}

}