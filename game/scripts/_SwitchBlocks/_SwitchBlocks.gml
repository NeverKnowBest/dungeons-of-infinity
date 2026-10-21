enum SwitchBlockColor{
	Red,
	Blue,
	Green	
}

function SwitchBlock_SetWalls(SBInst){
	
	if(SBInst.Segment_L_Wall != noone){
		SBInst.Segment_L_Wall.BlockLink = SBInst.Raised;
		SBInst.Segment_L_Wall.BlockLinkCarry = SBInst.Raised;
		SBInst.Segment_L_Wall.BlockEnemies = SBInst.Raised;
	}
	if(SBInst.Segment_R_Wall != noone){
		SBInst.Segment_R_Wall.BlockLink = SBInst.Raised;
		SBInst.Segment_R_Wall.BlockLinkCarry = SBInst.Raised;
		SBInst.Segment_R_Wall.BlockEnemies = SBInst.Raised;
	}
	if(SBInst.Segment_T_Wall != noone){
		SBInst.Segment_T_Wall.BlockLink = SBInst.Raised;
		SBInst.Segment_T_Wall.BlockLinkCarry = SBInst.Raised;
		SBInst.Segment_T_Wall.BlockEnemies = SBInst.Raised;
	}
	if(SBInst.Segment_B_Wall != noone){
		SBInst.Segment_B_Wall.BlockLink = SBInst.Raised;
		SBInst.Segment_B_Wall.BlockLinkCarry = SBInst.Raised;
		SBInst.Segment_B_Wall.BlockEnemies = SBInst.Raised;
	}
}