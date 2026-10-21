
function GetTransformedObjGID(GID, TransformType){
	
	var NewGID = GID;
	
	switch(TransformType){
		
		case ObjTransformation.FlipH:
			
			switch(GID){
				case TemplateObjGID.DoorL: NewGID = TemplateObjGID.DoorR; break;
				case TemplateObjGID.DoorR: NewGID = TemplateObjGID.DoorL; break;
				
				case TemplateObjGID.WallCornerBL: NewGID = TemplateObjGID.WallCornerBR; break;
				case TemplateObjGID.WallCornerBR: NewGID = TemplateObjGID.WallCornerBL; break;
				case TemplateObjGID.WallCornerTL: NewGID = TemplateObjGID.WallCornerTR; break;
				case TemplateObjGID.WallCornerTR: NewGID = TemplateObjGID.WallCornerTL; break;
				case TemplateObjGID.WallLowerCornerBL: NewGID = TemplateObjGID.WallLowerCornerBR; break;
				case TemplateObjGID.WallLowerCornerBR: NewGID = TemplateObjGID.WallLowerCornerBL; break;
				case TemplateObjGID.WallLowerCornerTL: NewGID = TemplateObjGID.WallLowerCornerTR; break;
				case TemplateObjGID.WallLowerCornerTR: NewGID = TemplateObjGID.WallLowerCornerTL; break;
				
				case TemplateObjGID.WallInnerBL: NewGID = TemplateObjGID.WallInnerBR; break;
				case TemplateObjGID.WallInnerBR: NewGID = TemplateObjGID.WallInnerBL; break;
				case TemplateObjGID.WallInnerTL: NewGID = TemplateObjGID.WallInnerTR; break;
				case TemplateObjGID.WallInnerTR: NewGID = TemplateObjGID.WallInnerTL; break;
				case TemplateObjGID.WallLowerInnerBL: NewGID = TemplateObjGID.WallLowerInnerBR; break;
				case TemplateObjGID.WallLowerInnerBR: NewGID = TemplateObjGID.WallLowerInnerBL; break;
				case TemplateObjGID.WallLowerInnerTL: NewGID = TemplateObjGID.WallLowerInnerTR; break;
				case TemplateObjGID.WallLowerInnerTR: NewGID = TemplateObjGID.WallLowerInnerTL; break;
				
				case TemplateObjGID.WallSideL: NewGID = TemplateObjGID.WallSideR; break;				
				case TemplateObjGID.WallSideR: NewGID = TemplateObjGID.WallSideL; break;
				case TemplateObjGID.WallLowerSideL: NewGID = TemplateObjGID.WallLowerSideR; break;				
				case TemplateObjGID.WallLowerSideR: NewGID = TemplateObjGID.WallLowerSideL; break;	

			}
			
			break;
			
		case ObjTransformation.FlipV:

			switch(GID){
				case TemplateObjGID.DoorT: NewGID = TemplateObjGID.DoorB; break;
				case TemplateObjGID.DoorB: NewGID = TemplateObjGID.DoorT; break;
				
				case TemplateObjGID.WallCornerBL: NewGID = TemplateObjGID.WallCornerTL; break;
				case TemplateObjGID.WallCornerTL: NewGID = TemplateObjGID.WallCornerBL; break;
				case TemplateObjGID.WallCornerBR: NewGID = TemplateObjGID.WallCornerTR; break;
				case TemplateObjGID.WallCornerTR: NewGID = TemplateObjGID.WallCornerBR; break;
				case TemplateObjGID.WallLowerCornerBL: NewGID = TemplateObjGID.WallLowerCornerTL; break;
				case TemplateObjGID.WallLowerCornerTL: NewGID = TemplateObjGID.WallLowerCornerBL; break;
				case TemplateObjGID.WallLowerCornerBR: NewGID = TemplateObjGID.WallLowerCornerTR; break;
				case TemplateObjGID.WallLowerCornerTR: NewGID = TemplateObjGID.WallLowerCornerBR; break;
				
				case TemplateObjGID.WallInnerBL: NewGID = TemplateObjGID.WallInnerTL; break;
				case TemplateObjGID.WallInnerTL: NewGID = TemplateObjGID.WallInnerBL; break;
				case TemplateObjGID.WallInnerBR: NewGID = TemplateObjGID.WallInnerTR; break;
				case TemplateObjGID.WallInnerTR: NewGID = TemplateObjGID.WallInnerBR; break;
				case TemplateObjGID.WallLowerInnerBL: NewGID = TemplateObjGID.WallLowerInnerTL; break;
				case TemplateObjGID.WallLowerInnerTL: NewGID = TemplateObjGID.WallLowerInnerBL; break;
				case TemplateObjGID.WallLowerInnerBR: NewGID = TemplateObjGID.WallLowerInnerTR; break;
				case TemplateObjGID.WallLowerInnerTR: NewGID = TemplateObjGID.WallLowerInnerBR; break;
				
				case TemplateObjGID.WallSideT: NewGID = TemplateObjGID.WallSideB; break;
				case TemplateObjGID.WallSideB: NewGID = TemplateObjGID.WallSideT; break;
				case TemplateObjGID.WallLowerSideT: NewGID = TemplateObjGID.WallLowerSideB; break;
				case TemplateObjGID.WallLowerSideB: NewGID = TemplateObjGID.WallLowerSideT; break;
				
				case TemplateObjGID.StairsT: NewGID = TemplateObjGID.StairsB; break;
				case TemplateObjGID.StairsB: NewGID = TemplateObjGID.StairsT; break;

				
			}
			
			break;
			
		case ObjTransformation.FlipHV:

			switch(GID){
				case TemplateObjGID.DoorL: NewGID = TemplateObjGID.DoorR; break;
				case TemplateObjGID.DoorR: NewGID = TemplateObjGID.DoorL; break;										
				case TemplateObjGID.DoorT: NewGID = TemplateObjGID.DoorB; break;
				case TemplateObjGID.DoorB: NewGID = TemplateObjGID.DoorT; break;
				
				case TemplateObjGID.WallCornerBL: NewGID = TemplateObjGID.WallCornerTR; break;
				case TemplateObjGID.WallCornerTR: NewGID = TemplateObjGID.WallCornerBL; break;
				case TemplateObjGID.WallCornerBR: NewGID = TemplateObjGID.WallCornerTL; break;
				case TemplateObjGID.WallCornerTL: NewGID = TemplateObjGID.WallCornerBR; break;
				case TemplateObjGID.WallLowerCornerBL: NewGID = TemplateObjGID.WallLowerCornerTR; break;
				case TemplateObjGID.WallLowerCornerTR: NewGID = TemplateObjGID.WallLowerCornerBL; break;
				case TemplateObjGID.WallLowerCornerBR: NewGID = TemplateObjGID.WallLowerCornerTL; break;
				case TemplateObjGID.WallLowerCornerTL: NewGID = TemplateObjGID.WallLowerCornerBR; break;
				
				case TemplateObjGID.WallInnerBL: NewGID = TemplateObjGID.WallInnerTR; break;
				case TemplateObjGID.WallInnerTR: NewGID = TemplateObjGID.WallInnerBL; break;
				case TemplateObjGID.WallInnerBR: NewGID = TemplateObjGID.WallInnerTL; break;
				case TemplateObjGID.WallInnerTL: NewGID = TemplateObjGID.WallInnerBR; break;
				case TemplateObjGID.WallLowerInnerBL: NewGID = TemplateObjGID.WallLowerInnerTR; break;
				case TemplateObjGID.WallLowerInnerTR: NewGID = TemplateObjGID.WallLowerInnerBL; break;
				case TemplateObjGID.WallLowerInnerBR: NewGID = TemplateObjGID.WallLowerInnerTL; break;
				case TemplateObjGID.WallLowerInnerTL: NewGID = TemplateObjGID.WallLowerInnerBR; break;
				
				case TemplateObjGID.WallSideL: NewGID = TemplateObjGID.WallSideR; break;				
				case TemplateObjGID.WallSideR: NewGID = TemplateObjGID.WallSideL; break;										
				case TemplateObjGID.WallSideT: NewGID = TemplateObjGID.WallSideB; break;
				case TemplateObjGID.WallSideB: NewGID = TemplateObjGID.WallSideT; break;
				case TemplateObjGID.WallLowerSideL: NewGID = TemplateObjGID.WallLowerSideR; break;				
				case TemplateObjGID.WallLowerSideR: NewGID = TemplateObjGID.WallLowerSideL; break;										
				case TemplateObjGID.WallLowerSideT: NewGID = TemplateObjGID.WallLowerSideB; break;
				case TemplateObjGID.WallLowerSideB: NewGID = TemplateObjGID.WallLowerSideT; break;
				
				case TemplateObjGID.StairsT: NewGID = TemplateObjGID.StairsB; break;
				case TemplateObjGID.StairsB: NewGID = TemplateObjGID.StairsT; break;

				
			}
			
			break;
			
		case ObjTransformation.RotateCW:

			switch(GID){
				case TemplateObjGID.DoorL: NewGID = TemplateObjGID.DoorT; break;
				case TemplateObjGID.DoorR: NewGID = TemplateObjGID.DoorB; break;
				case TemplateObjGID.DoorT: NewGID = TemplateObjGID.DoorR; break;
				case TemplateObjGID.DoorB: NewGID = TemplateObjGID.DoorL; break;
				
				case TemplateObjGID.WallCornerBL: NewGID = TemplateObjGID.WallCornerTL; break;
				case TemplateObjGID.WallCornerTR: NewGID = TemplateObjGID.WallCornerBR; break;
				case TemplateObjGID.WallCornerBR: NewGID = TemplateObjGID.WallCornerBL; break;
				case TemplateObjGID.WallCornerTL: NewGID = TemplateObjGID.WallCornerTR; break;
				case TemplateObjGID.WallLowerCornerBL: NewGID = TemplateObjGID.WallLowerCornerTL; break;
				case TemplateObjGID.WallLowerCornerTR: NewGID = TemplateObjGID.WallLowerCornerBR; break;
				case TemplateObjGID.WallLowerCornerBR: NewGID = TemplateObjGID.WallLowerCornerBL; break;
				case TemplateObjGID.WallLowerCornerTL: NewGID = TemplateObjGID.WallLowerCornerTR; break;
				
				case TemplateObjGID.WallInnerBL: NewGID = TemplateObjGID.WallInnerTL; break;
				case TemplateObjGID.WallInnerTR: NewGID = TemplateObjGID.WallInnerBR; break;
				case TemplateObjGID.WallInnerBR: NewGID = TemplateObjGID.WallInnerBL; break;
				case TemplateObjGID.WallInnerTL: NewGID = TemplateObjGID.WallInnerTR; break;
				case TemplateObjGID.WallLowerInnerBL: NewGID = TemplateObjGID.WallLowerInnerTL; break;
				case TemplateObjGID.WallLowerInnerTR: NewGID = TemplateObjGID.WallLowerInnerBR; break;
				case TemplateObjGID.WallLowerInnerBR: NewGID = TemplateObjGID.WallLowerInnerBL; break;
				case TemplateObjGID.WallLowerInnerTL: NewGID = TemplateObjGID.WallLowerInnerTR; break;
				
				case TemplateObjGID.WallSideL: NewGID = TemplateObjGID.WallSideT; break;				
				case TemplateObjGID.WallSideR: NewGID = TemplateObjGID.WallSideB; break;										
				case TemplateObjGID.WallSideT: NewGID = TemplateObjGID.WallSideR; break;
				case TemplateObjGID.WallSideB: NewGID = TemplateObjGID.WallSideL; break;
				case TemplateObjGID.WallLowerSideL: NewGID = TemplateObjGID.WallLowerSideT; break;				
				case TemplateObjGID.WallLowerSideR: NewGID = TemplateObjGID.WallLowerSideB; break;										
				case TemplateObjGID.WallLowerSideT: NewGID = TemplateObjGID.WallLowerSideR; break;
				case TemplateObjGID.WallLowerSideB: NewGID = TemplateObjGID.WallLowerSideL; break;
				
				case TemplateObjGID.RollingSpikesH:  NewGID = TemplateObjGID.RollingSpikesV; break;
				case TemplateObjGID.RollingSpikesV:  NewGID = TemplateObjGID.RollingSpikesH; break;

				
			}
			
			break;
			
		case ObjTransformation.RotateCCW:
			switch(GID){
				case TemplateObjGID.DoorL: NewGID = TemplateObjGID.DoorB; break;
				case TemplateObjGID.DoorR: NewGID = TemplateObjGID.DoorT; break;
				case TemplateObjGID.DoorT: NewGID = TemplateObjGID.DoorL; break;
				case TemplateObjGID.DoorB: NewGID = TemplateObjGID.DoorR; break;
				
				case TemplateObjGID.WallCornerBL: NewGID = TemplateObjGID.WallCornerBR; break;
				case TemplateObjGID.WallCornerTR: NewGID = TemplateObjGID.WallCornerTL; break;
				case TemplateObjGID.WallCornerBR: NewGID = TemplateObjGID.WallCornerTR; break;
				case TemplateObjGID.WallCornerTL: NewGID = TemplateObjGID.WallCornerBL; break;
				case TemplateObjGID.WallLowerCornerBL: NewGID = TemplateObjGID.WallLowerCornerBR; break;
				case TemplateObjGID.WallLowerCornerTR: NewGID = TemplateObjGID.WallLowerCornerTL; break;
				case TemplateObjGID.WallLowerCornerBR: NewGID = TemplateObjGID.WallLowerCornerTR; break;
				case TemplateObjGID.WallLowerCornerTL: NewGID = TemplateObjGID.WallLowerCornerBL; break;
				
				case TemplateObjGID.WallInnerBL: NewGID = TemplateObjGID.WallInnerBR; break;
				case TemplateObjGID.WallInnerTR: NewGID = TemplateObjGID.WallInnerTL; break;
				case TemplateObjGID.WallInnerBR: NewGID = TemplateObjGID.WallInnerTR; break;
				case TemplateObjGID.WallInnerTL: NewGID = TemplateObjGID.WallInnerBL; break;
				case TemplateObjGID.WallLowerInnerBL: NewGID = TemplateObjGID.WallLowerInnerBR; break;
				case TemplateObjGID.WallLowerInnerTR: NewGID = TemplateObjGID.WallLowerInnerTL; break;
				case TemplateObjGID.WallLowerInnerBR: NewGID = TemplateObjGID.WallLowerInnerTR; break;
				case TemplateObjGID.WallLowerInnerTL: NewGID = TemplateObjGID.WallLowerInnerBL; break;
				
				case TemplateObjGID.WallSideL: NewGID = TemplateObjGID.WallSideB; break;				
				case TemplateObjGID.WallSideR: NewGID = TemplateObjGID.WallSideT; break;										
				case TemplateObjGID.WallSideT: NewGID = TemplateObjGID.WallSideL; break;
				case TemplateObjGID.WallSideB: NewGID = TemplateObjGID.WallSideR; break;
				case TemplateObjGID.WallLowerSideL: NewGID = TemplateObjGID.WallLowerSideB; break;				
				case TemplateObjGID.WallLowerSideR: NewGID = TemplateObjGID.WallLowerSideT; break;										
				case TemplateObjGID.WallLowerSideT: NewGID = TemplateObjGID.WallLowerSideL; break;
				case TemplateObjGID.WallLowerSideB: NewGID = TemplateObjGID.WallLowerSideR; break;

				case TemplateObjGID.RollingSpikesH:  NewGID = TemplateObjGID.RollingSpikesV; break;
				case TemplateObjGID.RollingSpikesV:  NewGID = TemplateObjGID.RollingSpikesH; break;

			}		
			break;
		
	}

	return NewGID;
}
