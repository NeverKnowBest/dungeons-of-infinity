
function GetTransformedSBShiftCode(ShiftCode, TransformType){
	
	//Shift code can contain multiple letters, go through each and combine new letters into 1 code
	
	ShiftCode = string_upper(ShiftCode);
	
	var StrLen = string_length(ShiftCode);
	var NewShiftCode = "";
	
	for(var StrChr = 1; StrChr <= StrLen; StrChr++){
		
		var Chr = string_copy(ShiftCode, StrChr, 1);
		var NewChr = Chr;
		
		switch(TransformType){
		
			case ObjTransformation.FlipH:
			
				switch(Chr){
					case "L": NewChr = "R";	break;
					case "R": NewChr = "L";	break;
				}
			
				break;
			
			case ObjTransformation.FlipV:

				switch(Chr){
					case "U": NewChr = "D";	break;
					case "D": NewChr = "U";	break;
				}
			
				break;
			
			case ObjTransformation.FlipHV:

				switch(Chr){
					case "L": NewChr = "R";	break;
					case "R": NewChr = "L";	break;
					case "U": NewChr = "D";	break;
					case "D": NewChr = "U";	break;	
				}
			
				break;
			
			case ObjTransformation.RotateCW:

				switch(Chr){
					case "L": NewChr = "U";	break;
					case "R": NewChr = "D";	break;
					case "U": NewChr = "R";	break;
					case "D": NewChr = "L";	break;	
				}
			
				break;
			
			case ObjTransformation.RotateCCW:
				switch(Chr){
					case "L": NewChr = "D";	break;
					case "R": NewChr = "U";	break;
					case "U": NewChr = "L";	break;
					case "D": NewChr = "R";	break;	
				}		
				break;
		
		}
		
		NewShiftCode = NewShiftCode + NewChr;
		
	}

	return NewShiftCode;
}
