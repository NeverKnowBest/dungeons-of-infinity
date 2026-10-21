
function GetTransformedSectionID(SectionID, TransformType){
	
	var NewSectionID = SectionID;
	
	switch(TransformType){
		
		case ObjTransformation.FlipH:
			
			switch(SectionID){
				case 1: NewSectionID = 3; break; case 3: NewSectionID = 1; break;	
				case 4: NewSectionID = 5; break; case 5: NewSectionID = 4; break;	
				case 6: NewSectionID = 8; break; case 8: NewSectionID = 6; break;	
				case 9: NewSectionID = 10; break; case 10: NewSectionID = 9; break;	
				case 11: NewSectionID = 12; break; case 12: NewSectionID = 11; break;	
				case 13: NewSectionID = 14; break; case 14: NewSectionID = 13; break;	
				case 15: NewSectionID = 16; break; case 16: NewSectionID = 15; break;	
				case 17: NewSectionID = 18; break; case 18: NewSectionID = 17; break;	
				case 19: NewSectionID = 20; break; case 20: NewSectionID = 19; break;	
				case 21: NewSectionID = 22; break; case 22: NewSectionID = 21; break;
				case 27: NewSectionID = 30; break; case 30: NewSectionID = 27; break;
				case 28: NewSectionID = 29; break; case 29: NewSectionID = 28; break;
			}
			
			break;
			
		case ObjTransformation.FlipV:

			switch(SectionID){
				case 1: NewSectionID = 6; break; case 6: NewSectionID = 1; break;	
				case 2: NewSectionID = 7; break; case 7: NewSectionID = 2; break;	
				case 3: NewSectionID = 8; break; case 8: NewSectionID = 3; break;	
				case 9: NewSectionID = 11; break; case 11: NewSectionID = 9; break;	
				case 10: NewSectionID = 12; break; case 12: NewSectionID = 10; break;	
				case 13: NewSectionID = 15; break; case 15: NewSectionID = 13; break;	
				case 14: NewSectionID = 16; break; case 16: NewSectionID = 14; break;	
				case 17: NewSectionID = 19; break; case 19: NewSectionID = 17; break;	
				case 18: NewSectionID = 20; break; case 20: NewSectionID = 18; break;	
				case 23: NewSectionID = 24; break; case 24: NewSectionID = 23; break;
				case 27: NewSectionID = 28; break; case 28: NewSectionID = 27; break;
				case 29: NewSectionID = 30; break; case 30: NewSectionID = 29; break;
			}
			
			break;
			
		case ObjTransformation.FlipHV:

			switch(SectionID){
				case 1: NewSectionID = 8; break; case 8: NewSectionID = 1; break;	
				case 2: NewSectionID = 7; break; case 7: NewSectionID = 2; break;	
				case 3: NewSectionID = 6; break; case 6: NewSectionID = 3; break;	
				case 4: NewSectionID = 5; break; case 5: NewSectionID = 4; break;	
				case 9: NewSectionID = 12; break; case 12: NewSectionID = 9; break;	
				case 10: NewSectionID = 11; break; case 11: NewSectionID = 10; break;	
				case 13: NewSectionID = 16; break; case 16: NewSectionID = 13; break;	
				case 14: NewSectionID = 15; break; case 15: NewSectionID = 14; break;	
				case 17: NewSectionID = 20; break; case 20: NewSectionID = 17; break;	
				case 18: NewSectionID = 19; break; case 19: NewSectionID = 18; break;	
				case 21: NewSectionID = 22; break; case 22: NewSectionID = 21; break;	
				case 23: NewSectionID = 24; break; case 24: NewSectionID = 23; break;
				case 27: NewSectionID = 29; break; case 29: NewSectionID = 27; break;
				case 28: NewSectionID = 30; break; case 30: NewSectionID = 28; break;
			}
			
			break;
			
		case ObjTransformation.RotateCW:

			switch(SectionID){
				case 1: NewSectionID = 3; break;
				case 2: NewSectionID = 5; break;
				case 3: NewSectionID = 8; break;	
				case 4: NewSectionID = 2; break;	
				case 5: NewSectionID = 7; break;	
				case 6: NewSectionID = 1; break;
				case 7: NewSectionID = 4; break;
				case 8: NewSectionID = 6; break;
				case 9: NewSectionID = 14; break;
				case 10: NewSectionID = 16; break;
				case 11: NewSectionID = 13; break;
				case 12: NewSectionID = 15; break;
				case 13: NewSectionID = 10; break;
				case 14: NewSectionID = 12; break;
				case 15: NewSectionID = 9; break;
				case 16: NewSectionID = 11; break;
				case 17: NewSectionID = 18; break;
				case 18: NewSectionID = 20; break;
				case 19: NewSectionID = 17; break;
				case 20: NewSectionID = 19; break;
				case 21: NewSectionID = 23; break;
				case 22: NewSectionID = 24; break;
				case 23: NewSectionID = 22; break;
				case 24: NewSectionID = 21; break;
				case 25: NewSectionID = 26; break;
				case 26: NewSectionID = 25; break;
				case 27: NewSectionID = 28; break;
				case 28: NewSectionID = 29; break;
				case 29: NewSectionID = 30; break;
				case 30: NewSectionID = 27; break;
			}
			
			break;
			
		case ObjTransformation.RotateCCW:
			switch(SectionID){
				case 1: NewSectionID = 6; break;
				case 2: NewSectionID = 4; break;
				case 3: NewSectionID = 1; break;	
				case 4: NewSectionID = 7; break;	
				case 5: NewSectionID = 2; break;	
				case 6: NewSectionID = 8; break;
				case 7: NewSectionID = 5; break;
				case 8: NewSectionID = 3; break;
				case 9: NewSectionID = 15; break;
				case 10: NewSectionID = 13; break;
				case 11: NewSectionID = 16; break;
				case 12: NewSectionID = 14; break;
				case 13: NewSectionID = 11; break;
				case 14: NewSectionID = 9; break;
				case 15: NewSectionID = 12; break;
				case 16: NewSectionID = 10; break;
				case 17: NewSectionID = 19; break;
				case 18: NewSectionID = 17; break;
				case 19: NewSectionID = 20; break;
				case 20: NewSectionID = 18; break;
				case 21: NewSectionID = 24; break;
				case 22: NewSectionID = 23; break;
				case 23: NewSectionID = 21; break;
				case 24: NewSectionID = 22; break;
				case 25: NewSectionID = 26; break;
				case 26: NewSectionID = 25; break;
				case 27: NewSectionID = 30; break;
				case 28: NewSectionID = 27; break;
				case 29: NewSectionID = 28; break;
				case 30: NewSectionID = 29; break;
			}		
			break;
		
	}

	return NewSectionID;
}