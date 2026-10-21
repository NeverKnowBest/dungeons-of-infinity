function GetTransformationStr(TransformationID){
	
	switch(TransformationID){
		case ObjTransformation.None:
			return "None";
		case ObjTransformation.FlipH:
			return "FlipH";
		case ObjTransformation.FlipV:
			return "FlipV";
		case ObjTransformation.FlipHV:
			return "FlipHV";
		case ObjTransformation.RotateCW:
			return "RotateCW";
		case ObjTransformation.RotateCCW:
			return "RotateCCW";		
	}
	
}