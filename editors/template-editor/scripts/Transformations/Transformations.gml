enum Transformation{
	None,
	H,
	V,
	HV,
	CW,
	CCW
}

function NewTransformPos (Values, TransformType, TemplateSizeID){
	
	var OldX = Values[0];
	var OldY = Values[1];
	var OldW = Values[2];
	var OldH = Values[3];
	
	var NewX = OldX;
	var NewY = OldY;
	var NewW = OldW;
	var NewH = OldH;

	switch(TransformType){
		case Transformation.H:
								
			switch(TemplateSizeID){
									
				case TemplateSize._1x1: case TemplateSize._1x2:
					var NewX = 256 - OldX - OldW;
					break;


				case TemplateSize._2x1: case TemplateSize._2x2:
					var NewX = 512 - OldX - OldW;
					break;

			}
			break;

		case Transformation.V:
				
			switch(TemplateSizeID){
									
				case TemplateSize._1x1: case TemplateSize._2x1:
					var NewY = 256 - OldY - OldH;
					break;
									
				case TemplateSize._1x2: case TemplateSize._2x2:
					var NewY = 512 - OldY - OldH;
					break;
									
			}

				
			break;

		case Transformation.HV:
				
			switch(TemplateSizeID){
				case TemplateSize._1x1: 
					var NewX = 256 - OldX - OldW;
					var NewY = 256 - OldY - OldH;
					break;
									
				case TemplateSize._1x2:
					var NewX = 256 - OldX - OldW;
					var NewY = 512 - OldY - OldH;										
					break;
										
				case TemplateSize._2x1: 
					var NewX = 512 - OldX - OldW;
					var NewY = 256 - OldY - OldH;											
					break;
										
				case TemplateSize._2x2:
					var NewX = 512 - OldX - OldW;
					var NewY = 512 - OldY - OldH;	
					break;
									
			}

								
			break;

		case Transformation.CW:
								
			var NewW = OldH;
			var NewH = OldW;
			var NewY = OldX;

				
			switch(TemplateSizeID){
				case TemplateSize._1x1: case TemplateSize._2x1: 
					var NewX = 256 - OldY - OldH;
					break;
									
				case TemplateSize._1x2: case TemplateSize._2x2:
					var NewX = 512 - OldY - OldH;
					break;
									
			}


			break;
			
		case Transformation.CCW:

			var NewW = OldH;
			var NewH = OldW;
			var NewX = OldY;

				
			switch(TemplateSizeID){
				case TemplateSize._1x1:  case TemplateSize._1x2: 
					var NewY = 256 - OldX - OldW;
					break;
										
				case TemplateSize._2x1: case TemplateSize._2x2:
					var NewY = 512 - OldX - OldW;
					break;
										
									
			}

			break;
			
	}
	
	
	return [NewX, NewY, NewW, NewH]
	
}

function GetTransformedObjID(ID, TransformType){
	
	var NewID = ID;
	
	switch(TransformType){
		
		case Transformation.H:
			
			switch(ID){
				case TemplateObjID.DoorL: NewID = TemplateObjID.DoorR; break;
				case TemplateObjID.DoorR: NewID = TemplateObjID.DoorL; break;
				
				case TemplateObjID.Wall_Corner_BL: NewID = TemplateObjID.Wall_Corner_BR; break;
				case TemplateObjID.Wall_Corner_BR: NewID = TemplateObjID.Wall_Corner_BL; break;
				case TemplateObjID.Wall_Corner_TL: NewID = TemplateObjID.Wall_Corner_TR; break;
				case TemplateObjID.Wall_Corner_TR: NewID = TemplateObjID.Wall_Corner_TL; break;
				case TemplateObjID.Wall_Lower_Corner_BL: NewID = TemplateObjID.Wall_Lower_Corner_BR; break;
				case TemplateObjID.Wall_Lower_Corner_BR: NewID = TemplateObjID.Wall_Lower_Corner_BL; break;
				case TemplateObjID.Wall_Lower_Corner_TL: NewID = TemplateObjID.Wall_Lower_Corner_TR; break;
				case TemplateObjID.Wall_Lower_Corner_TR: NewID = TemplateObjID.Wall_Lower_Corner_TL; break;
				//case TemplateObjID.WallPitCornerBL: NewID = TemplateObjID.WallPitCornerBR; break;
				//case TemplateObjID.WallPitCornerBR: NewID = TemplateObjID.WallPitCornerBL; break;
				//case TemplateObjID.WallPitCornerTL: NewID = TemplateObjID.WallPitCornerTR; break;
				//case TemplateObjID.WallPitCornerTR: NewID = TemplateObjID.WallPitCornerTL; break;
				
				case TemplateObjID.Wall_InnerCorner_BL: NewID = TemplateObjID.Wall_InnerCorner_BR; break;
				case TemplateObjID.Wall_InnerCorner_BR: NewID = TemplateObjID.Wall_InnerCorner_BL; break;
				case TemplateObjID.Wall_InnerCorner_TL: NewID = TemplateObjID.Wall_InnerCorner_TR; break;
				case TemplateObjID.Wall_InnerCorner_TR: NewID = TemplateObjID.Wall_InnerCorner_TL; break;
				case TemplateObjID.Wall_Lower_InnerCorner_BL: NewID = TemplateObjID.Wall_Lower_InnerCorner_BR; break;
				case TemplateObjID.Wall_Lower_InnerCorner_BR: NewID = TemplateObjID.Wall_Lower_InnerCorner_BL; break;
				case TemplateObjID.Wall_Lower_InnerCorner_TL: NewID = TemplateObjID.Wall_Lower_InnerCorner_TR; break;
				case TemplateObjID.Wall_Lower_InnerCorner_TR: NewID = TemplateObjID.Wall_Lower_InnerCorner_TL; break;
				//case TemplateObjID.WallPitInnerBL: NewID = TemplateObjID.WallPitInnerBR; break;
				//case TemplateObjID.WallPitInnerBR: NewID = TemplateObjID.WallPitInnerBL; break;
				//case TemplateObjID.WallPitInnerTL: NewID = TemplateObjID.WallPitInnerTR; break;
				//case TemplateObjID.WallPitInnerTR: NewID = TemplateObjID.WallPitInnerTL; break;
				
				case TemplateObjID.Wall_Side_L: NewID = TemplateObjID.Wall_Side_R; break;				
				case TemplateObjID.Wall_Side_R: NewID = TemplateObjID.Wall_Side_L; break;
				case TemplateObjID.Wall_Lower_Side_L: NewID = TemplateObjID.Wall_Lower_Side_R; break;				
				case TemplateObjID.Wall_Lower_Side_R: NewID = TemplateObjID.Wall_Lower_Side_L; break;	
				//case TemplateObjID.WallPitSideL: NewID = TemplateObjID.WallPitSideR; break;				
				//case TemplateObjID.WallPitSideR: NewID = TemplateObjID.WallPitSideL; break;	
			}
			
			break;
			
		case Transformation.V:

			switch(NewID){
				case TemplateObjID.DoorT: NewID = TemplateObjID.DoorB; break;
				case TemplateObjID.DoorB: NewID = TemplateObjID.DoorT; break;
				
				case TemplateObjID.Wall_Corner_BL: NewID = TemplateObjID.Wall_Corner_TL; break;
				case TemplateObjID.Wall_Corner_TL: NewID = TemplateObjID.Wall_Corner_BL; break;
				case TemplateObjID.Wall_Corner_BR: NewID = TemplateObjID.Wall_Corner_TR; break;
				case TemplateObjID.Wall_Corner_TR: NewID = TemplateObjID.Wall_Corner_BR; break;
				case TemplateObjID.Wall_Lower_Corner_BL: NewID = TemplateObjID.Wall_Lower_Corner_TL; break;
				case TemplateObjID.Wall_Lower_Corner_TL: NewID = TemplateObjID.Wall_Lower_Corner_BL; break;
				case TemplateObjID.Wall_Lower_Corner_BR: NewID = TemplateObjID.Wall_Lower_Corner_TR; break;
				case TemplateObjID.Wall_Lower_Corner_TR: NewID = TemplateObjID.Wall_Lower_Corner_BR; break;
				//case TemplateObjID.WallPitCornerBL: NewID = TemplateObjID.WallPitCornerTL; break;
				//case TemplateObjID.WallPitCornerTL: NewID = TemplateObjID.WallPitCornerBL; break;
				//case TemplateObjID.WallPitCornerBR: NewID = TemplateObjID.WallPitCornerTR; break;
				//case TemplateObjID.WallPitCornerTR: NewID = TemplateObjID.WallPitCornerBR; break;
				
				case TemplateObjID.Wall_InnerCorner_BL: NewID = TemplateObjID.Wall_InnerCorner_TL; break;
				case TemplateObjID.Wall_InnerCorner_TL: NewID = TemplateObjID.Wall_InnerCorner_BL; break;
				case TemplateObjID.Wall_InnerCorner_BR: NewID = TemplateObjID.Wall_InnerCorner_TR; break;
				case TemplateObjID.Wall_InnerCorner_TR: NewID = TemplateObjID.Wall_InnerCorner_BR; break;
				case TemplateObjID.Wall_Lower_InnerCorner_BL: NewID = TemplateObjID.Wall_Lower_InnerCorner_TL; break;
				case TemplateObjID.Wall_Lower_InnerCorner_TL: NewID = TemplateObjID.Wall_Lower_InnerCorner_BL; break;
				case TemplateObjID.Wall_Lower_InnerCorner_BR: NewID = TemplateObjID.Wall_Lower_InnerCorner_TR; break;
				case TemplateObjID.Wall_Lower_InnerCorner_TR: NewID = TemplateObjID.Wall_Lower_InnerCorner_BR; break;
				//case TemplateObjID.WallPitInnerBL: NewID = TemplateObjID.WallPitInnerTL; break;
				//case TemplateObjID.WallPitInnerTL: NewID = TemplateObjID.WallPitInnerBL; break;
				//case TemplateObjID.WallPitInnerBR: NewID = TemplateObjID.WallPitInnerTR; break;
				//case TemplateObjID.WallPitInnerTR: NewID = TemplateObjID.WallPitInnerBR; break;
				
				case TemplateObjID.Wall_Side_T: NewID = TemplateObjID.Wall_Side_B; break;
				case TemplateObjID.Wall_Side_B: NewID = TemplateObjID.Wall_Side_T; break;
				case TemplateObjID.Wall_Lower_Side_T: NewID = TemplateObjID.Wall_Lower_Side_B; break;
				case TemplateObjID.Wall_Lower_Side_B: NewID = TemplateObjID.Wall_Lower_Side_T; break;
				//case TemplateObjID.WallPitSideT: NewID = TemplateObjID.WallPitSideB; break;
				//case TemplateObjID.WallPitSideB: NewID = TemplateObjID.WallPitSideT; break;
				
				//case TemplateObjID.StairsT: NewID = TemplateObjID.StairsB; break;
				//case TemplateObjID.StairsB: NewID = TemplateObjID.StairsT; break;
			}
			
			break;
			
		case Transformation.HV:

			switch(NewID){
				case TemplateObjID.DoorL: NewID = TemplateObjID.DoorR; break;
				case TemplateObjID.DoorR: NewID = TemplateObjID.DoorL; break;										
				case TemplateObjID.DoorT: NewID = TemplateObjID.DoorB; break;
				case TemplateObjID.DoorB: NewID = TemplateObjID.DoorT; break;
				
				case TemplateObjID.Wall_Corner_BL: NewID = TemplateObjID.Wall_Corner_TR; break;
				case TemplateObjID.Wall_Corner_TR: NewID = TemplateObjID.Wall_Corner_BL; break;
				case TemplateObjID.Wall_Corner_BR: NewID = TemplateObjID.Wall_Corner_TL; break;
				case TemplateObjID.Wall_Corner_TL: NewID = TemplateObjID.Wall_Corner_BR; break;
				case TemplateObjID.Wall_Lower_Corner_BL: NewID = TemplateObjID.Wall_Lower_Corner_TR; break;
				case TemplateObjID.Wall_Lower_Corner_TR: NewID = TemplateObjID.Wall_Lower_Corner_BL; break;
				case TemplateObjID.Wall_Lower_Corner_BR: NewID = TemplateObjID.Wall_Lower_Corner_TL; break;
				case TemplateObjID.Wall_Lower_Corner_TL: NewID = TemplateObjID.Wall_Lower_Corner_BR; break;
				//case TemplateObjID.WallPitCornerBL: NewID = TemplateObjID.WallPitCornerTR; break;
				//case TemplateObjID.WallPitCornerTR: NewID = TemplateObjID.WallPitCornerBL; break;
				//case TemplateObjID.WallPitCornerBR: NewID = TemplateObjID.WallPitCornerTL; break;
				//case TemplateObjID.WallPitCornerTL: NewID = TemplateObjID.WallPitCornerBR; break;
				
				case TemplateObjID.Wall_InnerCorner_BL: NewID = TemplateObjID.Wall_InnerCorner_TR; break;
				case TemplateObjID.Wall_InnerCorner_TR: NewID = TemplateObjID.Wall_InnerCorner_BL; break;
				case TemplateObjID.Wall_InnerCorner_BR: NewID = TemplateObjID.Wall_InnerCorner_TL; break;
				case TemplateObjID.Wall_InnerCorner_TL: NewID = TemplateObjID.Wall_InnerCorner_BR; break;
				case TemplateObjID.Wall_Lower_InnerCorner_BL: NewID = TemplateObjID.Wall_Lower_InnerCorner_TR; break;
				case TemplateObjID.Wall_Lower_InnerCorner_TR: NewID = TemplateObjID.Wall_Lower_InnerCorner_BL; break;
				case TemplateObjID.Wall_Lower_InnerCorner_BR: NewID = TemplateObjID.Wall_Lower_InnerCorner_TL; break;
				case TemplateObjID.Wall_Lower_InnerCorner_TL: NewID = TemplateObjID.Wall_Lower_InnerCorner_BR; break;
				//case TemplateObjID.WallPitInnerBL: NewID = TemplateObjID.WallPitInnerTR; break;
				//case TemplateObjID.WallPitInnerTR: NewID = TemplateObjID.WallPitInnerBL; break;
				//case TemplateObjID.WallPitInnerBR: NewID = TemplateObjID.WallPitInnerTL; break;
				//case TemplateObjID.WallPitInnerTL: NewID = TemplateObjID.WallPitInnerBR; break;
				
				case TemplateObjID.Wall_Side_L: NewID = TemplateObjID.Wall_Side_R; break;				
				case TemplateObjID.Wall_Side_R: NewID = TemplateObjID.Wall_Side_L; break;										
				case TemplateObjID.Wall_Side_T: NewID = TemplateObjID.Wall_Side_B; break;
				case TemplateObjID.Wall_Side_B: NewID = TemplateObjID.Wall_Side_T; break;
				case TemplateObjID.Wall_Lower_Side_L: NewID = TemplateObjID.Wall_Lower_Side_R; break;				
				case TemplateObjID.Wall_Lower_Side_R: NewID = TemplateObjID.Wall_Lower_Side_L; break;										
				case TemplateObjID.Wall_Lower_Side_T: NewID = TemplateObjID.Wall_Lower_Side_B; break;
				case TemplateObjID.Wall_Lower_Side_B: NewID = TemplateObjID.Wall_Lower_Side_T; break;
				//case TemplateObjID.WallPitSideL: NewID = TemplateObjID.WallPitSideR; break;				
				//case TemplateObjID.WallPitSideR: NewID = TemplateObjID.WallPitSideL; break;										
				//case TemplateObjID.WallPitSideT: NewID = TemplateObjID.WallPitSideB; break;
				//case TemplateObjID.WallPitSideB: NewID = TemplateObjID.WallPitSideT; break;
				
				//case TemplateObjID.StairsT: NewID = TemplateObjID.StairsB; break;
				//case TemplateObjID.StairsB: NewID = TemplateObjID.StairsT; break;			
			}
			
			break;
			
		case Transformation.CW:

			switch(NewID){
				case TemplateObjID.DoorL: NewID = TemplateObjID.DoorT; break;
				case TemplateObjID.DoorR: NewID = TemplateObjID.DoorB; break;
				case TemplateObjID.DoorT: NewID = TemplateObjID.DoorR; break;
				case TemplateObjID.DoorB: NewID = TemplateObjID.DoorL; break;
				
				case TemplateObjID.Wall_Corner_BL: NewID = TemplateObjID.Wall_Corner_TL; break;
				case TemplateObjID.Wall_Corner_TR: NewID = TemplateObjID.Wall_Corner_BR; break;
				case TemplateObjID.Wall_Corner_BR: NewID = TemplateObjID.Wall_Corner_BL; break;
				case TemplateObjID.Wall_Corner_TL: NewID = TemplateObjID.Wall_Corner_TR; break;
				case TemplateObjID.Wall_Lower_Corner_BL: NewID = TemplateObjID.Wall_Lower_Corner_TL; break;
				case TemplateObjID.Wall_Lower_Corner_TR: NewID = TemplateObjID.Wall_Lower_Corner_BR; break;
				case TemplateObjID.Wall_Lower_Corner_BR: NewID = TemplateObjID.Wall_Lower_Corner_BL; break;
				case TemplateObjID.Wall_Lower_Corner_TL: NewID = TemplateObjID.Wall_Lower_Corner_TR; break;
				//case TemplateObjID.WallPitCornerBL: NewID = TemplateObjID.WallPitCornerTL; break;
				//case TemplateObjID.WallPitCornerTR: NewID = TemplateObjID.WallPitCornerBR; break;
				//case TemplateObjID.WallPitCornerBR: NewID = TemplateObjID.WallPitCornerBL; break;
				//case TemplateObjID.WallPitCornerTL: NewID = TemplateObjID.WallPitCornerTR; break;
				
				case TemplateObjID.Wall_InnerCorner_BL: NewID = TemplateObjID.Wall_InnerCorner_TL; break;
				case TemplateObjID.Wall_InnerCorner_TR: NewID = TemplateObjID.Wall_InnerCorner_BR; break;
				case TemplateObjID.Wall_InnerCorner_BR: NewID = TemplateObjID.Wall_InnerCorner_BL; break;
				case TemplateObjID.Wall_InnerCorner_TL: NewID = TemplateObjID.Wall_InnerCorner_TR; break;
				case TemplateObjID.Wall_Lower_InnerCorner_BL: NewID = TemplateObjID.Wall_Lower_InnerCorner_TL; break;
				case TemplateObjID.Wall_Lower_InnerCorner_TR: NewID = TemplateObjID.Wall_Lower_InnerCorner_BR; break;
				case TemplateObjID.Wall_Lower_InnerCorner_BR: NewID = TemplateObjID.Wall_Lower_InnerCorner_BL; break;
				case TemplateObjID.Wall_Lower_InnerCorner_TL: NewID = TemplateObjID.Wall_Lower_InnerCorner_TR; break;
				//case TemplateObjID.WallPitInnerBL: NewID = TemplateObjID.WallPitInnerTL; break;
				//case TemplateObjID.WallPitInnerTR: NewID = TemplateObjID.WallPitInnerBR; break;
				//case TemplateObjID.WallPitInnerBR: NewID = TemplateObjID.WallPitInnerBL; break;
				//case TemplateObjID.WallPitInnerTL: NewID = TemplateObjID.WallPitInnerTR; break;
				
				case TemplateObjID.Wall_Side_L: NewID = TemplateObjID.Wall_Side_T; break;				
				case TemplateObjID.Wall_Side_R: NewID = TemplateObjID.Wall_Side_B; break;										
				case TemplateObjID.Wall_Side_T: NewID = TemplateObjID.Wall_Side_R; break;
				case TemplateObjID.Wall_Side_B: NewID = TemplateObjID.Wall_Side_L; break;
				case TemplateObjID.Wall_Lower_Side_L: NewID = TemplateObjID.Wall_Lower_Side_T; break;				
				case TemplateObjID.Wall_Lower_Side_R: NewID = TemplateObjID.Wall_Lower_Side_B; break;										
				case TemplateObjID.Wall_Lower_Side_T: NewID = TemplateObjID.Wall_Lower_Side_R; break;
				case TemplateObjID.Wall_Lower_Side_B: NewID = TemplateObjID.Wall_Lower_Side_L; break;
				//case TemplateObjID.WallPitSideL: NewID = TemplateObjID.WallPitSideT; break;				
				//case TemplateObjID.WallPitSideR: NewID = TemplateObjID.WallPitSideB; break;										
				//case TemplateObjID.WallPitSideT: NewID = TemplateObjID.WallPitSideR; break;
				//case TemplateObjID.WallPitSideB: NewID = TemplateObjID.WallPitSideL; break;
				
			}
			
			break;
			
		case Transformation.CCW:
			switch(NewID){
				case TemplateObjID.DoorL: NewID = TemplateObjID.DoorB; break;
				case TemplateObjID.DoorR: NewID = TemplateObjID.DoorT; break;
				case TemplateObjID.DoorT: NewID = TemplateObjID.DoorL; break;
				case TemplateObjID.DoorB: NewID = TemplateObjID.DoorR; break;
				
				case TemplateObjID.Wall_Corner_BL: NewID = TemplateObjID.Wall_Corner_BR; break;
				case TemplateObjID.Wall_Corner_TR: NewID = TemplateObjID.Wall_Corner_TL; break;
				case TemplateObjID.Wall_Corner_BR: NewID = TemplateObjID.Wall_Corner_TR; break;
				case TemplateObjID.Wall_Corner_TL: NewID = TemplateObjID.Wall_Corner_BL; break;
				case TemplateObjID.Wall_Lower_Corner_BL: NewID = TemplateObjID.Wall_Lower_Corner_BR; break;
				case TemplateObjID.Wall_Lower_Corner_TR: NewID = TemplateObjID.Wall_Lower_Corner_TL; break;
				case TemplateObjID.Wall_Lower_Corner_BR: NewID = TemplateObjID.Wall_Lower_Corner_TR; break;
				case TemplateObjID.Wall_Lower_Corner_TL: NewID = TemplateObjID.Wall_Lower_Corner_BL; break;
				//case TemplateObjID.WallPitCornerBL: NewID = TemplateObjID.WallPitCornerBR; break;
				//case TemplateObjID.WallPitCornerTR: NewID = TemplateObjID.WallPitCornerTL; break;
				//case TemplateObjID.WallPitCornerBR: NewID = TemplateObjID.WallPitCornerTR; break;
				//case TemplateObjID.WallPitCornerTL: NewID = TemplateObjID.WallPitCornerBL; break;
				
				case TemplateObjID.Wall_InnerCorner_BL: NewID = TemplateObjID.Wall_InnerCorner_BR; break;
				case TemplateObjID.Wall_InnerCorner_TR: NewID = TemplateObjID.Wall_InnerCorner_TL; break;
				case TemplateObjID.Wall_InnerCorner_BR: NewID = TemplateObjID.Wall_InnerCorner_TR; break;
				case TemplateObjID.Wall_InnerCorner_TL: NewID = TemplateObjID.Wall_InnerCorner_BL; break;
				case TemplateObjID.Wall_Lower_InnerCorner_BL: NewID = TemplateObjID.Wall_Lower_InnerCorner_BR; break;
				case TemplateObjID.Wall_Lower_InnerCorner_TR: NewID = TemplateObjID.Wall_Lower_InnerCorner_TL; break;
				case TemplateObjID.Wall_Lower_InnerCorner_BR: NewID = TemplateObjID.Wall_Lower_InnerCorner_TR; break;
				case TemplateObjID.Wall_Lower_InnerCorner_TL: NewID = TemplateObjID.Wall_Lower_InnerCorner_BL; break;
				//case TemplateObjID.WallPitInnerBL: NewID = TemplateObjID.WallPitInnerBR; break;
				//case TemplateObjID.WallPitInnerTR: NewID = TemplateObjID.WallPitInnerTL; break;
				//case TemplateObjID.WallPitInnerBR: NewID = TemplateObjID.WallPitInnerTR; break;
				//case TemplateObjID.WallPitInnerTL: NewID = TemplateObjID.WallPitInnerBL; break;
				
				case TemplateObjID.Wall_Side_L: NewID = TemplateObjID.Wall_Side_B; break;				
				case TemplateObjID.Wall_Side_R: NewID = TemplateObjID.Wall_Side_T; break;										
				case TemplateObjID.Wall_Side_T: NewID = TemplateObjID.Wall_Side_L; break;
				case TemplateObjID.Wall_Side_B: NewID = TemplateObjID.Wall_Side_R; break;
				case TemplateObjID.Wall_Lower_Side_L: NewID = TemplateObjID.Wall_Lower_Side_B; break;				
				case TemplateObjID.Wall_Lower_Side_R: NewID = TemplateObjID.Wall_Lower_Side_T; break;										
				case TemplateObjID.Wall_Lower_Side_T: NewID = TemplateObjID.Wall_Lower_Side_L; break;
				case TemplateObjID.Wall_Lower_Side_B: NewID = TemplateObjID.Wall_Lower_Side_R; break;
				//case TemplateObjID.WallPitSideL: NewID = TemplateObjID.WallPitSideB; break;				
				//case TemplateObjID.WallPitSideR: NewID = TemplateObjID.WallPitSideT; break;										
				//case TemplateObjID.WallPitSideT: NewID = TemplateObjID.WallPitSideL; break;
				//case TemplateObjID.WallPitSideB: NewID = TemplateObjID.WallPitSideR; break;

			}		
			break;
		
	}

	return NewID;
}
