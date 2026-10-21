enum ObjTransformation{
	None,
	FlipH,
	FlipV,
	FlipHV,
	RotateCW,
	RotateCCW
}


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

function CheckRotation(Obj, Transformation){
	
	//return true if obj is rotated correctly based on the Room rotation/flip
	switch(Transformation){
		case ObjTransformation.None:
		case ObjTransformation.FlipH: 
			if(Obj[$ "rotation"] != 0) return false; 
			break;
		case ObjTransformation.FlipV: 
		case ObjTransformation.FlipHV:
			if(abs(Obj[$ "rotation"]) != 180) return false;
			break;
		case ObjTransformation.RotateCW:
			if(Obj[$ "rotation"] != -90) return false;
			break;
		case ObjTransformation.RotateCCW:
			if(Obj[$ "rotation"] != 90) return false;
			break;
	}
	
	return true;
}

function TransformObjArray (OldObjArray, NewObjArray, TransformType, RoomSizeIndex){

	var ObjCount = array_length(OldObjArray)
	
	for(var ObjIndex = 0; ObjIndex < ObjCount; ObjIndex++){
						
		var OldX = OldObjArray[ObjIndex].x;
		var OldY = OldObjArray[ObjIndex].y;
		var OldW = OldObjArray[ObjIndex].width;
		var OldH = OldObjArray[ObjIndex].height;

		var ObjHasGID = variable_struct_exists(OldObjArray[ObjIndex], "gid");
		if(ObjHasGID) var OldGID = OldObjArray[ObjIndex][$ "gid"];
		var Properties = OldObjArray[ObjIndex][$ "properties"];
		
		var NewX = OldX;
		var NewY = OldY;
		var NewW = OldW;
		var NewH = OldH;

		
		switch(TransformType){
			case ObjTransformation.FlipH:
								
				switch(RoomSizeIndex){
									
					case RoomSize._1x1: case RoomSize._1x2:
						var NewX = 256 - OldX - OldW;
						break;


					case RoomSize._2x1: case RoomSize._2x2:
						var NewX = 512 - OldX - OldW;
						break;

				}
				break;

			case ObjTransformation.FlipV:
				
				switch(RoomSizeIndex){
									
					case RoomSize._1x1: case RoomSize._2x1:
						var NewY = 256 - OldY - OldH;
						break;
									
					case RoomSize._1x2: case RoomSize._2x2:
						var NewY = 512 - OldY - OldH;
						break;
									
				}

				if(CheckRotation(OldObjArray[ObjIndex], TransformType)){
					NewX -= NewW;
					NewY += NewH;		
				}
				
				break;

			case ObjTransformation.FlipHV:
				
				switch(RoomSizeIndex){
					case RoomSize._1x1: 
						var NewX = 256 - OldX - OldW;
						var NewY = 256 - OldY - OldH;
						break;
									
					case RoomSize._1x2:
						var NewX = 256 - OldX - OldW;
						var NewY = 512 - OldY - OldH;										
						break;
										
					case RoomSize._2x1: 
						var NewX = 512 - OldX - OldW;
						var NewY = 256 - OldY - OldH;											
						break;
										
					case RoomSize._2x2:
						var NewX = 512 - OldX - OldW;
						var NewY = 512 - OldY - OldH;	
						break;
									
				}

				if(CheckRotation(OldObjArray[ObjIndex], TransformType)){
					NewX += NewW;
					NewY += NewH;		
				}
								
				break;

			case ObjTransformation.RotateCW:
								
				var NewW = OldH;
				var NewH = OldW;
				var NewY = OldX;

				
				switch(RoomSizeIndex){
					case RoomSize._1x1: case RoomSize._2x1: 
						var NewX = 256 - OldY - OldH;
						break;
									
					case RoomSize._1x2: case RoomSize._2x2:
						var NewX = 512 - OldY - OldH;
						break;
									
				}

				if(CheckRotation(OldObjArray[ObjIndex], TransformType)){
					NewX += NewW;
					var ObjW_Temp = NewW;
					NewW = NewH;
					NewH = ObjW_Temp;
				}

				break;
			
			case ObjTransformation.RotateCCW:

				var NewW = OldH;
				var NewH = OldW;
				var NewX = OldY;

				
				switch(RoomSizeIndex){
					case RoomSize._1x1:  case RoomSize._1x2: 
						var NewY = 256 - OldX - OldW;
						break;
										
					case RoomSize._2x1: case RoomSize._2x2:
						var NewY = 512 - OldX - OldW;
						break;
										
									
				}

				if(CheckRotation(OldObjArray[ObjIndex], TransformType)){
					NewY += NewH;
					var ObjW_Temp = NewW;
					NewW = NewH;
					NewH = ObjW_Temp;
				}
				
				break;
			
		}
						
		if(ObjHasGID) var NewGID = GetTransformedObjGID(OldGID, TransformType);
								

		//Switchboxes	
		var SBShiftCode = GetPropertyValue(Properties, "SB");
		if(SBShiftCode != -1){
			var NewShiftCode = GetTransformedSBShiftCode(SBShiftCode, TransformType);
			SetPropertyValue(NewObjArray[ObjIndex][$ "properties"], "SB", NewShiftCode);
		}

		//Carpet door codes
		for(var i = 1; i <= 2; i++){
			var DoorsCSV = GetPropertyValue(Properties, "Doors" + string(i));
			if(DoorsCSV != -1){
				var DoorList = CSVToList(DoorsCSV);
				var DoorCount = ds_list_size(DoorList);
				var NewDoorStr = ""
				for(var j = 0; j < DoorCount; j++){
					var DoorPosition = DoorList[| j];
					var NewDoorPos = GetTransformedDoorPosition(DoorPosition, TransformType)
					NewDoorStr += (string(NewDoorPos) + (j < DoorCount - 1 ? "," : ""));
				}
				SetPropertyValue(NewObjArray[ObjIndex][$ "properties"], "Doors" + string(i), NewDoorStr);
				ds_list_destroy(DoorList);
			}
		}
		
		NewObjArray[@ ObjIndex].x = NewX;
		NewObjArray[@ ObjIndex].y = NewY;
		NewObjArray[@ ObjIndex].width = NewW;
		NewObjArray[@ ObjIndex].height = NewH;						

		if(ObjHasGID) NewObjArray[@ ObjIndex][$ "gid"] = NewGID;
						
	}
	
}

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
				
				case TemplateObjGID.Carpet_TL: NewGID = TemplateObjGID.Carpet_TR; break;
				case TemplateObjGID.Carpet_TR: NewGID = TemplateObjGID.Carpet_TL; break;
				case TemplateObjGID.Carpet_BL: NewGID = TemplateObjGID.Carpet_BR; break;
				case TemplateObjGID.Carpet_BR: NewGID = TemplateObjGID.Carpet_BL; break;
				case TemplateObjGID.Carpet_TBL: NewGID = TemplateObjGID.Carpet_TBR; break;
				case TemplateObjGID.Carpet_TBR: NewGID = TemplateObjGID.Carpet_TBL; break;
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

				case TemplateObjGID.Carpet_TL: NewGID = TemplateObjGID.Carpet_BL; break;
				case TemplateObjGID.Carpet_TR: NewGID = TemplateObjGID.Carpet_BR; break;
				case TemplateObjGID.Carpet_BL: NewGID = TemplateObjGID.Carpet_TL; break;
				case TemplateObjGID.Carpet_BR: NewGID = TemplateObjGID.Carpet_TR; break;
				case TemplateObjGID.Carpet_TLR: NewGID = TemplateObjGID.Carpet_BLR; break;
				case TemplateObjGID.Carpet_BLR: NewGID = TemplateObjGID.Carpet_TLR; break;
				
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
				
				case TemplateObjGID.Carpet_TL: NewGID = TemplateObjGID.Carpet_BR; break;
				case TemplateObjGID.Carpet_TR: NewGID = TemplateObjGID.Carpet_BL; break;
				case TemplateObjGID.Carpet_BL: NewGID = TemplateObjGID.Carpet_TR; break;
				case TemplateObjGID.Carpet_BR: NewGID = TemplateObjGID.Carpet_TL; break;
				case TemplateObjGID.Carpet_TLR: NewGID = TemplateObjGID.Carpet_BLR; break;
				case TemplateObjGID.Carpet_BLR: NewGID = TemplateObjGID.Carpet_TLR; break;
				case TemplateObjGID.Carpet_TBL: NewGID = TemplateObjGID.Carpet_TBR; break;
				case TemplateObjGID.Carpet_TBR: NewGID = TemplateObjGID.Carpet_TBL; break;
				
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

				case TemplateObjGID.Carpet_H: NewGID = TemplateObjGID.Carpet_V; break;
				case TemplateObjGID.Carpet_V: NewGID = TemplateObjGID.Carpet_H; break;
				case TemplateObjGID.Carpet_TL: NewGID = TemplateObjGID.Carpet_TR; break;
				case TemplateObjGID.Carpet_TR: NewGID = TemplateObjGID.Carpet_BR; break;
				case TemplateObjGID.Carpet_BL: NewGID = TemplateObjGID.Carpet_TL; break;
				case TemplateObjGID.Carpet_BR: NewGID = TemplateObjGID.Carpet_BL; break;
				case TemplateObjGID.Carpet_TLR: NewGID = TemplateObjGID.Carpet_TBR; break;
				case TemplateObjGID.Carpet_BLR: NewGID = TemplateObjGID.Carpet_TBL; break;
				case TemplateObjGID.Carpet_TBL: NewGID = TemplateObjGID.Carpet_TLR; break;
				case TemplateObjGID.Carpet_TBR: NewGID = TemplateObjGID.Carpet_BLR; break;
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
				
				case TemplateObjGID.Carpet_H: NewGID = TemplateObjGID.Carpet_V; break;
				case TemplateObjGID.Carpet_V: NewGID = TemplateObjGID.Carpet_H; break;
				case TemplateObjGID.Carpet_TL: NewGID = TemplateObjGID.Carpet_BL; break;
				case TemplateObjGID.Carpet_TR: NewGID = TemplateObjGID.Carpet_TL; break;
				case TemplateObjGID.Carpet_BL: NewGID = TemplateObjGID.Carpet_BR; break;
				case TemplateObjGID.Carpet_BR: NewGID = TemplateObjGID.Carpet_TR; break;
				case TemplateObjGID.Carpet_TLR: NewGID = TemplateObjGID.Carpet_TBL; break;
				case TemplateObjGID.Carpet_BLR: NewGID = TemplateObjGID.Carpet_TBR; break;
				case TemplateObjGID.Carpet_TBL: NewGID = TemplateObjGID.Carpet_BLR; break;
				case TemplateObjGID.Carpet_TBR: NewGID = TemplateObjGID.Carpet_TLR; break;
				
			}		
			break;
		
	}

	return NewGID;
}

function GetTransformedDoorPosition(Position, TransformType){
	
	switch(TransformType){
		
		case ObjTransformation.None:
			return Position;
			break;
			
		case ObjTransformation.FlipH:
			
			switch(Position){
				case 1: return 11;	
				case 2: return 10;	
				case 3: return 9;	
				case 4: return 8;	
				case 5: return 7;	
				case 6: return 6;	
				case 7: return 5;	
				case 8: return 4;	
				case 9: return 3;	
				case 10: return 2;	
				case 11: return 1;	
				case 12: return 12;	
				case 13: return 23;	
				case 14: return 22;	
				case 15: return 21;	
				case 16: return 20;	
				case 17: return 19;	
				case 18: return 18;	
				case 19: return 17;	
				case 20: return 16;	
				case 21: return 15;	
				case 22: return 14;	
				case 23: return 13;	
				case 24: return 24;	
				
			}
			
			break;
			
		case ObjTransformation.FlipV:

			switch(Position){
				case 1: return 5;	
				case 2: return 4;	
				case 3: return 3;	
				case 4: return 2;	
				case 5: return 1;	
				case 6: return 12;	
				case 7: return 11;	
				case 8: return 10;	
				case 9: return 9;	
				case 10: return 8;	
				case 11: return 7;	
				case 12: return 6;	
				case 13: return 17;	
				case 14: return 16;	
				case 15: return 15;	
				case 16: return 14;	
				case 17: return 13;	
				case 18: return 24;	
				case 19: return 23;	
				case 20: return 22;	
				case 21: return 21;	
				case 22: return 20;	
				case 23: return 19;	
				case 24: return 18;	
				
			}
			break;
			
		case ObjTransformation.FlipHV:

			switch(Position){
				case 1: return 7;	
				case 2: return 8;	
				case 3: return 9;	
				case 4: return 10;	
				case 5: return 11;	
				case 6: return 12;	
				case 7: return 1;	
				case 8: return 2;	
				case 9: return 3;	
				case 10: return 4;	
				case 11: return 5;	
				case 12: return 6;	
				case 13: return 19;	
				case 14: return 20;	
				case 15: return 21;	
				case 16: return 22;	
				case 17: return 23;	
				case 18: return 24;	
				case 19: return 13;	
				case 20: return 14;	
				case 21: return 15;	
				case 22: return 16;	
				case 23: return 17;	
				case 24: return 18;	
				
			}
			
			break;
			
		case ObjTransformation.RotateCW:

			switch(Position){
				case 1: return 4;	
				case 2: return 5;	
				case 3: return 6;	
				case 4: return 7;	
				case 5: return 8;	
				case 6: return 9;	
				case 7: return 10;	
				case 8: return 11;	
				case 9: return 12;	
				case 10: return 1;	
				case 11: return 2;	
				case 12: return 3;	
				case 13: return 16;	
				case 14: return 17;	
				case 15: return 18;	
				case 16: return 19;	
				case 17: return 20;	
				case 18: return 21;	
				case 19: return 22;	
				case 20: return 23;	
				case 21: return 24;	
				case 22: return 13;	
				case 23: return 14;	
				case 24: return 15;	
				
			}
			
			break;
			
		case ObjTransformation.RotateCCW:

			switch(Position){
				case 1: return 10;	
				case 2: return 11;	
				case 3: return 12;	
				case 4: return 1;	
				case 5: return 2;	
				case 6: return 3;	
				case 7: return 4;	
				case 8: return 5;	
				case 9: return 6;	
				case 10: return 7;	
				case 11: return 8;	
				case 12: return 9;	
				case 13: return 22;	
				case 14: return 23;	
				case 15: return 24;	
				case 16: return 13;	
				case 17: return 14;	
				case 18: return 15;	
				case 19: return 16;	
				case 20: return 17;	
				case 21: return 18;	
				case 22: return 19;	
				case 23: return 20;	
				case 24: return 21;	
				
			}
			
			break;
		
	}
	
	return Position
	
}


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