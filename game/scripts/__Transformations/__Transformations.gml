enum ObjTransformation{
	None,
	FlipH,
	FlipV,
	FlipHV,
	RotateCW,
	RotateCCW,
	FlipHRotateCW,
	FlipHRotateCCW
}

#macro TransformTypes 8

function TransformObjArray (ObjArray, TransformType, ObjType, RoomW, RoomH){
	
	gml_pragma("forceinline");
	
	var ObjCount = array_length(ObjArray)
	if(ObjCount == 0) return ObjArray;
	
	var NewArray = array_create(0);//array_length(ObjArray));
	
	for(var ObjIndex = 0; ObjIndex < ObjCount; ObjIndex++){
		
		array_push(NewArray, StructCopy(ObjArray[ObjIndex]));
		//array_copy(NewArray, ObjIndex, ObjArray, ObjIndex, 1);
		
		
		var OldObj = ObjArray[ObjIndex];
		var OldX = OldObj.x;
		var OldY = OldObj.y;
		var OldW = OldObj.width;
		var OldH = OldObj.height;
		
		var NewX = OldX;
		var NewY = OldY;
		var NewW = OldW;
		var NewH = OldH;
		
		switch(TransformType){
			case ObjTransformation.FlipH:
				var NewX = RoomW - OldX - OldW;
				
				break;

			case ObjTransformation.FlipV:
				
				var NewY = RoomH - OldY - OldH;

				break;

			case ObjTransformation.FlipHV:
				
				var NewX = RoomW - OldX - OldW;
				var NewY = RoomH - OldY - OldH;
		
				break;

			case ObjTransformation.RotateCW:
								
				var NewW = OldH;
				var NewH = OldW;
				var NewY = OldX;
				var NewX = RoomH - OldY - OldH;

				break;
			
			case ObjTransformation.RotateCCW:

				var NewW = OldH;
				var NewH = OldW;
				var NewX = OldY;
				var NewY = RoomW - OldX - OldW;

				break;
			
			case ObjTransformation.FlipHRotateCW:
			
				var NewW = OldH;
				var NewH = OldW;				
				var NewX = RoomH - OldY - OldH;
				var NewY = RoomW - OldX - OldW;

				break;
			
			case ObjTransformation.FlipHRotateCCW:
				var NewW = OldH;
				var NewH = OldW;
				var NewX = OldY;
				var NewY = OldX;

				break;
			
		}
		
		var Properties = OldObj[$ "properties"];	
		
		//Pots
		var PotSpawnDir = GetPropertyValue(Properties, "SpawnDir");
		if(PotSpawnDir != -1){
			var NewPotSpawnDir = GetTransformedPotStartingCorner(PotSpawnDir, TransformType)
			SetPropertyValue(NewArray[ObjIndex][$ "properties"], "SpawnDir", NewPotSpawnDir);
		}
		
		
		//Switchboxes	
		var SBShiftCode = GetPropertyValue(Properties, "SB");
		if(SBShiftCode != -1){
			var NewShiftCode = GetTransformedSBShiftCode(SBShiftCode, TransformType);
			SetPropertyValue(NewArray[ObjIndex][$ "properties"], "SB", NewShiftCode);
		}

		var SBShiftCode = GetPropertyValue(Properties, "SBShift");
		if(SBShiftCode != -1){
			var NewShiftCode = GetTransformedSBShiftCode(SBShiftCode, TransformType);
			SetPropertyValue(NewArray[ObjIndex][$ "properties"], "SBShift", NewShiftCode);
		}

		//Carpet door codes
		for(var i = 1; i <= 2; i++){
			var _DoorStr = (i == 1 ? "DoorsFrom" : "DoorsTo");
			var DoorsCSV = GetPropertyValue(Properties, _DoorStr);
			if(DoorsCSV != -1 && DoorsCSV != ""){
				var DoorList = CSVToList(DoorsCSV);
				var DoorCount = ds_list_size(DoorList);
				var NewDoorStr = ""
				for(var j = 0; j < DoorCount; j++){
					var DoorPosition = DoorList[| j];
					var NewDoorPos = GetTransformedDoorPosition(DoorPosition, TransformType)
					NewDoorStr += (string(NewDoorPos) + (j < DoorCount - 1 ? "," : ""));
				}
				SetPropertyValue(NewArray[ObjIndex][$ "properties"], _DoorStr, NewDoorStr);
				ds_list_destroy(DoorList);
			}
		}
		
		NewArray[ObjIndex].x = NewX;
		NewArray[ObjIndex].y = NewY;
		NewArray[ObjIndex].width = NewW;
		NewArray[ObjIndex].height = NewH;						

		var ObjCanRotate = ds_list_find_index(global.TemplateObjsThatCanRotate, ObjType);
		if(ObjCanRotate != -1) NewArray[ObjIndex][$ "rotation"] = GetTransformedObjRotation(OldObj[$ "rotation"], TransformType);
		
		var OldGID = variable_struct_exists(OldObj, "gid") ? OldObj.gid : -1;		
		if(OldGID != -1) NewArray[ObjIndex][$ "gid"] = GetTransformedObjGID(OldGID, TransformType);
						
	}
	
	return NewArray
	
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
				case TemplateObjGID.WallPitCornerBL: NewGID = TemplateObjGID.WallPitCornerBR; break;
				case TemplateObjGID.WallPitCornerBR: NewGID = TemplateObjGID.WallPitCornerBL; break;
				case TemplateObjGID.WallPitCornerTL: NewGID = TemplateObjGID.WallPitCornerTR; break;
				case TemplateObjGID.WallPitCornerTR: NewGID = TemplateObjGID.WallPitCornerTL; break;
				
				case TemplateObjGID.WallInnerBL: NewGID = TemplateObjGID.WallInnerBR; break;
				case TemplateObjGID.WallInnerBR: NewGID = TemplateObjGID.WallInnerBL; break;
				case TemplateObjGID.WallInnerTL: NewGID = TemplateObjGID.WallInnerTR; break;
				case TemplateObjGID.WallInnerTR: NewGID = TemplateObjGID.WallInnerTL; break;
				case TemplateObjGID.WallLowerInnerBL: NewGID = TemplateObjGID.WallLowerInnerBR; break;
				case TemplateObjGID.WallLowerInnerBR: NewGID = TemplateObjGID.WallLowerInnerBL; break;
				case TemplateObjGID.WallLowerInnerTL: NewGID = TemplateObjGID.WallLowerInnerTR; break;
				case TemplateObjGID.WallLowerInnerTR: NewGID = TemplateObjGID.WallLowerInnerTL; break;
				case TemplateObjGID.WallPitInnerBL: NewGID = TemplateObjGID.WallPitInnerBR; break;
				case TemplateObjGID.WallPitInnerBR: NewGID = TemplateObjGID.WallPitInnerBL; break;
				case TemplateObjGID.WallPitInnerTL: NewGID = TemplateObjGID.WallPitInnerTR; break;
				case TemplateObjGID.WallPitInnerTR: NewGID = TemplateObjGID.WallPitInnerTL; break;
				
				case TemplateObjGID.WallSideL: NewGID = TemplateObjGID.WallSideR; break;				
				case TemplateObjGID.WallSideR: NewGID = TemplateObjGID.WallSideL; break;
				case TemplateObjGID.WallLowerSideL: NewGID = TemplateObjGID.WallLowerSideR; break;				
				case TemplateObjGID.WallLowerSideR: NewGID = TemplateObjGID.WallLowerSideL; break;	
				case TemplateObjGID.WallPitSideL: NewGID = TemplateObjGID.WallPitSideR; break;				
				case TemplateObjGID.WallPitSideR: NewGID = TemplateObjGID.WallPitSideL; break;	
				
				case TemplateObjGID.Carpet_TL: NewGID = TemplateObjGID.Carpet_TR; break;
				case TemplateObjGID.Carpet_TR: NewGID = TemplateObjGID.Carpet_TL; break;
				case TemplateObjGID.Carpet_BL: NewGID = TemplateObjGID.Carpet_BR; break;
				case TemplateObjGID.Carpet_BR: NewGID = TemplateObjGID.Carpet_BL; break;
				case TemplateObjGID.Carpet_TBL: NewGID = TemplateObjGID.Carpet_TBR; break;
				case TemplateObjGID.Carpet_TBR: NewGID = TemplateObjGID.Carpet_TBL; break;
				
				case TemplateObjGID.MovingFloorLeft: NewGID = TemplateObjGID.MovingFloorRight; break;
				case TemplateObjGID.MovingFloorRight: NewGID = TemplateObjGID.MovingFloorLeft; break;
				
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
				case TemplateObjGID.WallPitCornerBL: NewGID = TemplateObjGID.WallPitCornerTL; break;
				case TemplateObjGID.WallPitCornerTL: NewGID = TemplateObjGID.WallPitCornerBL; break;
				case TemplateObjGID.WallPitCornerBR: NewGID = TemplateObjGID.WallPitCornerTR; break;
				case TemplateObjGID.WallPitCornerTR: NewGID = TemplateObjGID.WallPitCornerBR; break;
				
				case TemplateObjGID.WallInnerBL: NewGID = TemplateObjGID.WallInnerTL; break;
				case TemplateObjGID.WallInnerTL: NewGID = TemplateObjGID.WallInnerBL; break;
				case TemplateObjGID.WallInnerBR: NewGID = TemplateObjGID.WallInnerTR; break;
				case TemplateObjGID.WallInnerTR: NewGID = TemplateObjGID.WallInnerBR; break;
				case TemplateObjGID.WallLowerInnerBL: NewGID = TemplateObjGID.WallLowerInnerTL; break;
				case TemplateObjGID.WallLowerInnerTL: NewGID = TemplateObjGID.WallLowerInnerBL; break;
				case TemplateObjGID.WallLowerInnerBR: NewGID = TemplateObjGID.WallLowerInnerTR; break;
				case TemplateObjGID.WallLowerInnerTR: NewGID = TemplateObjGID.WallLowerInnerBR; break;
				case TemplateObjGID.WallPitInnerBL: NewGID = TemplateObjGID.WallPitInnerTL; break;
				case TemplateObjGID.WallPitInnerTL: NewGID = TemplateObjGID.WallPitInnerBL; break;
				case TemplateObjGID.WallPitInnerBR: NewGID = TemplateObjGID.WallPitInnerTR; break;
				case TemplateObjGID.WallPitInnerTR: NewGID = TemplateObjGID.WallPitInnerBR; break;
				
				case TemplateObjGID.WallSideT: NewGID = TemplateObjGID.WallSideB; break;
				case TemplateObjGID.WallSideB: NewGID = TemplateObjGID.WallSideT; break;
				case TemplateObjGID.WallLowerSideT: NewGID = TemplateObjGID.WallLowerSideB; break;
				case TemplateObjGID.WallLowerSideB: NewGID = TemplateObjGID.WallLowerSideT; break;
				case TemplateObjGID.WallPitSideT: NewGID = TemplateObjGID.WallPitSideB; break;
				case TemplateObjGID.WallPitSideB: NewGID = TemplateObjGID.WallPitSideT; break;
				
				case TemplateObjGID.StairsT: NewGID = TemplateObjGID.StairsB; break;
				case TemplateObjGID.StairsB: NewGID = TemplateObjGID.StairsT; break;

				case TemplateObjGID.Carpet_TL: NewGID = TemplateObjGID.Carpet_BL; break;
				case TemplateObjGID.Carpet_TR: NewGID = TemplateObjGID.Carpet_BR; break;
				case TemplateObjGID.Carpet_BL: NewGID = TemplateObjGID.Carpet_TL; break;
				case TemplateObjGID.Carpet_BR: NewGID = TemplateObjGID.Carpet_TR; break;
				case TemplateObjGID.Carpet_TLR: NewGID = TemplateObjGID.Carpet_BLR; break;
				case TemplateObjGID.Carpet_BLR: NewGID = TemplateObjGID.Carpet_TLR; break;

				case TemplateObjGID.MovingFloorUp: NewGID = TemplateObjGID.MovingFloorDown; break;
				case TemplateObjGID.MovingFloorDown: NewGID = TemplateObjGID.MovingFloorUp; break;
				
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
				case TemplateObjGID.WallPitCornerBL: NewGID = TemplateObjGID.WallPitCornerTR; break;
				case TemplateObjGID.WallPitCornerTR: NewGID = TemplateObjGID.WallPitCornerBL; break;
				case TemplateObjGID.WallPitCornerBR: NewGID = TemplateObjGID.WallPitCornerTL; break;
				case TemplateObjGID.WallPitCornerTL: NewGID = TemplateObjGID.WallPitCornerBR; break;
				
				case TemplateObjGID.WallInnerBL: NewGID = TemplateObjGID.WallInnerTR; break;
				case TemplateObjGID.WallInnerTR: NewGID = TemplateObjGID.WallInnerBL; break;
				case TemplateObjGID.WallInnerBR: NewGID = TemplateObjGID.WallInnerTL; break;
				case TemplateObjGID.WallInnerTL: NewGID = TemplateObjGID.WallInnerBR; break;
				case TemplateObjGID.WallLowerInnerBL: NewGID = TemplateObjGID.WallLowerInnerTR; break;
				case TemplateObjGID.WallLowerInnerTR: NewGID = TemplateObjGID.WallLowerInnerBL; break;
				case TemplateObjGID.WallLowerInnerBR: NewGID = TemplateObjGID.WallLowerInnerTL; break;
				case TemplateObjGID.WallLowerInnerTL: NewGID = TemplateObjGID.WallLowerInnerBR; break;
				case TemplateObjGID.WallPitInnerBL: NewGID = TemplateObjGID.WallPitInnerTR; break;
				case TemplateObjGID.WallPitInnerTR: NewGID = TemplateObjGID.WallPitInnerBL; break;
				case TemplateObjGID.WallPitInnerBR: NewGID = TemplateObjGID.WallPitInnerTL; break;
				case TemplateObjGID.WallPitInnerTL: NewGID = TemplateObjGID.WallPitInnerBR; break;
				
				case TemplateObjGID.WallSideL: NewGID = TemplateObjGID.WallSideR; break;				
				case TemplateObjGID.WallSideR: NewGID = TemplateObjGID.WallSideL; break;										
				case TemplateObjGID.WallSideT: NewGID = TemplateObjGID.WallSideB; break;
				case TemplateObjGID.WallSideB: NewGID = TemplateObjGID.WallSideT; break;
				case TemplateObjGID.WallLowerSideL: NewGID = TemplateObjGID.WallLowerSideR; break;				
				case TemplateObjGID.WallLowerSideR: NewGID = TemplateObjGID.WallLowerSideL; break;										
				case TemplateObjGID.WallLowerSideT: NewGID = TemplateObjGID.WallLowerSideB; break;
				case TemplateObjGID.WallLowerSideB: NewGID = TemplateObjGID.WallLowerSideT; break;
				case TemplateObjGID.WallPitSideL: NewGID = TemplateObjGID.WallPitSideR; break;				
				case TemplateObjGID.WallPitSideR: NewGID = TemplateObjGID.WallPitSideL; break;										
				case TemplateObjGID.WallPitSideT: NewGID = TemplateObjGID.WallPitSideB; break;
				case TemplateObjGID.WallPitSideB: NewGID = TemplateObjGID.WallPitSideT; break;
				
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

				case TemplateObjGID.MovingFloorLeft: NewGID = TemplateObjGID.MovingFloorRight; break;
				case TemplateObjGID.MovingFloorRight: NewGID = TemplateObjGID.MovingFloorLeft; break;
				case TemplateObjGID.MovingFloorUp: NewGID = TemplateObjGID.MovingFloorDown; break;
				case TemplateObjGID.MovingFloorDown: NewGID = TemplateObjGID.MovingFloorUp; break;
				
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
				case TemplateObjGID.WallPitCornerBL: NewGID = TemplateObjGID.WallPitCornerTL; break;
				case TemplateObjGID.WallPitCornerTR: NewGID = TemplateObjGID.WallPitCornerBR; break;
				case TemplateObjGID.WallPitCornerBR: NewGID = TemplateObjGID.WallPitCornerBL; break;
				case TemplateObjGID.WallPitCornerTL: NewGID = TemplateObjGID.WallPitCornerTR; break;
				
				case TemplateObjGID.WallInnerBL: NewGID = TemplateObjGID.WallInnerTL; break;
				case TemplateObjGID.WallInnerTR: NewGID = TemplateObjGID.WallInnerBR; break;
				case TemplateObjGID.WallInnerBR: NewGID = TemplateObjGID.WallInnerBL; break;
				case TemplateObjGID.WallInnerTL: NewGID = TemplateObjGID.WallInnerTR; break;
				case TemplateObjGID.WallLowerInnerBL: NewGID = TemplateObjGID.WallLowerInnerTL; break;
				case TemplateObjGID.WallLowerInnerTR: NewGID = TemplateObjGID.WallLowerInnerBR; break;
				case TemplateObjGID.WallLowerInnerBR: NewGID = TemplateObjGID.WallLowerInnerBL; break;
				case TemplateObjGID.WallLowerInnerTL: NewGID = TemplateObjGID.WallLowerInnerTR; break;
				case TemplateObjGID.WallPitInnerBL: NewGID = TemplateObjGID.WallPitInnerTL; break;
				case TemplateObjGID.WallPitInnerTR: NewGID = TemplateObjGID.WallPitInnerBR; break;
				case TemplateObjGID.WallPitInnerBR: NewGID = TemplateObjGID.WallPitInnerBL; break;
				case TemplateObjGID.WallPitInnerTL: NewGID = TemplateObjGID.WallPitInnerTR; break;
				
				case TemplateObjGID.WallSideL: NewGID = TemplateObjGID.WallSideT; break;				
				case TemplateObjGID.WallSideR: NewGID = TemplateObjGID.WallSideB; break;										
				case TemplateObjGID.WallSideT: NewGID = TemplateObjGID.WallSideR; break;
				case TemplateObjGID.WallSideB: NewGID = TemplateObjGID.WallSideL; break;
				case TemplateObjGID.WallLowerSideL: NewGID = TemplateObjGID.WallLowerSideT; break;				
				case TemplateObjGID.WallLowerSideR: NewGID = TemplateObjGID.WallLowerSideB; break;										
				case TemplateObjGID.WallLowerSideT: NewGID = TemplateObjGID.WallLowerSideR; break;
				case TemplateObjGID.WallLowerSideB: NewGID = TemplateObjGID.WallLowerSideL; break;
				case TemplateObjGID.WallPitSideL: NewGID = TemplateObjGID.WallPitSideT; break;				
				case TemplateObjGID.WallPitSideR: NewGID = TemplateObjGID.WallPitSideB; break;										
				case TemplateObjGID.WallPitSideT: NewGID = TemplateObjGID.WallPitSideR; break;
				case TemplateObjGID.WallPitSideB: NewGID = TemplateObjGID.WallPitSideL; break;
				
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

				case TemplateObjGID.MovingFloorLeft: NewGID = TemplateObjGID.MovingFloorUp; break;
				case TemplateObjGID.MovingFloorRight: NewGID = TemplateObjGID.MovingFloorDown; break;
				case TemplateObjGID.MovingFloorUp: NewGID = TemplateObjGID.MovingFloorRight; break;
				case TemplateObjGID.MovingFloorDown: NewGID = TemplateObjGID.MovingFloorLeft; break;
				
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
				case TemplateObjGID.WallPitCornerBL: NewGID = TemplateObjGID.WallPitCornerBR; break;
				case TemplateObjGID.WallPitCornerTR: NewGID = TemplateObjGID.WallPitCornerTL; break;
				case TemplateObjGID.WallPitCornerBR: NewGID = TemplateObjGID.WallPitCornerTR; break;
				case TemplateObjGID.WallPitCornerTL: NewGID = TemplateObjGID.WallPitCornerBL; break;
				
				case TemplateObjGID.WallInnerBL: NewGID = TemplateObjGID.WallInnerBR; break;
				case TemplateObjGID.WallInnerTR: NewGID = TemplateObjGID.WallInnerTL; break;
				case TemplateObjGID.WallInnerBR: NewGID = TemplateObjGID.WallInnerTR; break;
				case TemplateObjGID.WallInnerTL: NewGID = TemplateObjGID.WallInnerBL; break;
				case TemplateObjGID.WallLowerInnerBL: NewGID = TemplateObjGID.WallLowerInnerBR; break;
				case TemplateObjGID.WallLowerInnerTR: NewGID = TemplateObjGID.WallLowerInnerTL; break;
				case TemplateObjGID.WallLowerInnerBR: NewGID = TemplateObjGID.WallLowerInnerTR; break;
				case TemplateObjGID.WallLowerInnerTL: NewGID = TemplateObjGID.WallLowerInnerBL; break;
				case TemplateObjGID.WallPitInnerBL: NewGID = TemplateObjGID.WallPitInnerBR; break;
				case TemplateObjGID.WallPitInnerTR: NewGID = TemplateObjGID.WallPitInnerTL; break;
				case TemplateObjGID.WallPitInnerBR: NewGID = TemplateObjGID.WallPitInnerTR; break;
				case TemplateObjGID.WallPitInnerTL: NewGID = TemplateObjGID.WallPitInnerBL; break;
				
				case TemplateObjGID.WallSideL: NewGID = TemplateObjGID.WallSideB; break;				
				case TemplateObjGID.WallSideR: NewGID = TemplateObjGID.WallSideT; break;										
				case TemplateObjGID.WallSideT: NewGID = TemplateObjGID.WallSideL; break;
				case TemplateObjGID.WallSideB: NewGID = TemplateObjGID.WallSideR; break;
				case TemplateObjGID.WallLowerSideL: NewGID = TemplateObjGID.WallLowerSideB; break;				
				case TemplateObjGID.WallLowerSideR: NewGID = TemplateObjGID.WallLowerSideT; break;										
				case TemplateObjGID.WallLowerSideT: NewGID = TemplateObjGID.WallLowerSideL; break;
				case TemplateObjGID.WallLowerSideB: NewGID = TemplateObjGID.WallLowerSideR; break;
				case TemplateObjGID.WallPitSideL: NewGID = TemplateObjGID.WallPitSideB; break;				
				case TemplateObjGID.WallPitSideR: NewGID = TemplateObjGID.WallPitSideT; break;										
				case TemplateObjGID.WallPitSideT: NewGID = TemplateObjGID.WallPitSideL; break;
				case TemplateObjGID.WallPitSideB: NewGID = TemplateObjGID.WallPitSideR; break;
				
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

				case TemplateObjGID.MovingFloorLeft: NewGID = TemplateObjGID.MovingFloorDown; break;
				case TemplateObjGID.MovingFloorRight: NewGID = TemplateObjGID.MovingFloorUp; break;
				case TemplateObjGID.MovingFloorUp: NewGID = TemplateObjGID.MovingFloorLeft; break;
				case TemplateObjGID.MovingFloorDown: NewGID = TemplateObjGID.MovingFloorRight; break;
				
			}		
			break;

		case ObjTransformation.FlipHRotateCW:

			switch(GID){
				case TemplateObjGID.DoorL: NewGID = TemplateObjGID.DoorB; break;
				case TemplateObjGID.DoorR: NewGID = TemplateObjGID.DoorT; break;
				case TemplateObjGID.DoorT: NewGID = TemplateObjGID.DoorR; break;
				case TemplateObjGID.DoorB: NewGID = TemplateObjGID.DoorL; break;
				
				case TemplateObjGID.WallCornerBR: NewGID = TemplateObjGID.WallCornerTL; break;
				case TemplateObjGID.WallCornerTL: NewGID = TemplateObjGID.WallCornerBR; break;
				case TemplateObjGID.WallLowerCornerBR: NewGID = TemplateObjGID.WallLowerCornerTL; break;
				case TemplateObjGID.WallLowerCornerTL: NewGID = TemplateObjGID.WallLowerCornerBR; break;
				case TemplateObjGID.WallPitCornerBR: NewGID = TemplateObjGID.WallPitCornerTL; break;
				case TemplateObjGID.WallPitCornerTL: NewGID = TemplateObjGID.WallPitCornerBR; break;
				
				case TemplateObjGID.WallInnerBR: NewGID = TemplateObjGID.WallInnerTL; break;
				case TemplateObjGID.WallInnerTL: NewGID = TemplateObjGID.WallInnerBR; break;
				case TemplateObjGID.WallLowerInnerBR: NewGID = TemplateObjGID.WallLowerInnerTL; break;
				case TemplateObjGID.WallLowerInnerTL: NewGID = TemplateObjGID.WallLowerInnerBR; break;
				case TemplateObjGID.WallPitInnerBR: NewGID = TemplateObjGID.WallPitInnerTL; break;
				case TemplateObjGID.WallPitInnerTL: NewGID = TemplateObjGID.WallPitInnerBR; break;
				
				case TemplateObjGID.WallSideL: NewGID = TemplateObjGID.WallSideB; break;				
				case TemplateObjGID.WallSideR: NewGID = TemplateObjGID.WallSideT; break;										
				case TemplateObjGID.WallSideT: NewGID = TemplateObjGID.WallSideR; break;
				case TemplateObjGID.WallSideB: NewGID = TemplateObjGID.WallSideL; break;
				case TemplateObjGID.WallLowerSideL: NewGID = TemplateObjGID.WallLowerSideB; break;				
				case TemplateObjGID.WallLowerSideR: NewGID = TemplateObjGID.WallLowerSideT; break;										
				case TemplateObjGID.WallLowerSideT: NewGID = TemplateObjGID.WallLowerSideR; break;
				case TemplateObjGID.WallLowerSideB: NewGID = TemplateObjGID.WallLowerSideL; break;
				case TemplateObjGID.WallPitSideL: NewGID = TemplateObjGID.WallPitSideB; break;				
				case TemplateObjGID.WallPitSideR: NewGID = TemplateObjGID.WallPitSideT; break;										
				case TemplateObjGID.WallPitSideT: NewGID = TemplateObjGID.WallPitSideR; break;
				case TemplateObjGID.WallPitSideB: NewGID = TemplateObjGID.WallPitSideL; break;
				
				case TemplateObjGID.RollingSpikesH:  NewGID = TemplateObjGID.RollingSpikesV; break;
				case TemplateObjGID.RollingSpikesV:  NewGID = TemplateObjGID.RollingSpikesH; break;

				case TemplateObjGID.Carpet_H: NewGID = TemplateObjGID.Carpet_V; break;
				case TemplateObjGID.Carpet_V: NewGID = TemplateObjGID.Carpet_H; break;
				case TemplateObjGID.Carpet_TL: NewGID = TemplateObjGID.Carpet_BR; break;
				case TemplateObjGID.Carpet_BR: NewGID = TemplateObjGID.Carpet_TL; break;
				case TemplateObjGID.Carpet_TLR: NewGID = TemplateObjGID.Carpet_TBR; break;
				case TemplateObjGID.Carpet_BLR: NewGID = TemplateObjGID.Carpet_TBL; break;
				case TemplateObjGID.Carpet_TBL: NewGID = TemplateObjGID.Carpet_BLR; break;
				case TemplateObjGID.Carpet_TBR: NewGID = TemplateObjGID.Carpet_TLR; break;

				case TemplateObjGID.MovingFloorLeft: NewGID = TemplateObjGID.MovingFloorDown; break;
				case TemplateObjGID.MovingFloorRight: NewGID = TemplateObjGID.MovingFloorUp; break;
				case TemplateObjGID.MovingFloorUp: NewGID = TemplateObjGID.MovingFloorRight; break;
				case TemplateObjGID.MovingFloorDown: NewGID = TemplateObjGID.MovingFloorLeft; break;
				
			}
			
			break;

		case ObjTransformation.FlipHRotateCCW:
			switch(GID){
				case TemplateObjGID.DoorL: NewGID = TemplateObjGID.DoorT; break;
				case TemplateObjGID.DoorR: NewGID = TemplateObjGID.DoorB; break;
				case TemplateObjGID.DoorT: NewGID = TemplateObjGID.DoorL; break;
				case TemplateObjGID.DoorB: NewGID = TemplateObjGID.DoorR; break;
				
				case TemplateObjGID.WallCornerBL: NewGID = TemplateObjGID.WallCornerTR; break;
				case TemplateObjGID.WallCornerTR: NewGID = TemplateObjGID.WallCornerBL; break;
				case TemplateObjGID.WallLowerCornerTR: NewGID = TemplateObjGID.WallLowerCornerBL; break;
				case TemplateObjGID.WallLowerCornerBL: NewGID = TemplateObjGID.WallLowerCornerTR; break;
				case TemplateObjGID.WallPitCornerBL: NewGID = TemplateObjGID.WallPitCornerTR; break;
				case TemplateObjGID.WallPitCornerTR: NewGID = TemplateObjGID.WallPitCornerBL; break;
				
				case TemplateObjGID.WallInnerBL: NewGID = TemplateObjGID.WallInnerTR; break;
				case TemplateObjGID.WallInnerTR: NewGID = TemplateObjGID.WallInnerBL; break;
				case TemplateObjGID.WallLowerInnerBL: NewGID = TemplateObjGID.WallLowerInnerTR; break;
				case TemplateObjGID.WallLowerInnerTR: NewGID = TemplateObjGID.WallLowerInnerBL; break;
				case TemplateObjGID.WallPitInnerBL: NewGID = TemplateObjGID.WallPitInnerTR; break;
				case TemplateObjGID.WallPitInnerTR: NewGID = TemplateObjGID.WallPitInnerBL; break;
				
				case TemplateObjGID.WallSideL: NewGID = TemplateObjGID.WallSideT; break;				
				case TemplateObjGID.WallSideR: NewGID = TemplateObjGID.WallSideB; break;										
				case TemplateObjGID.WallSideT: NewGID = TemplateObjGID.WallSideL; break;
				case TemplateObjGID.WallSideB: NewGID = TemplateObjGID.WallSideR; break;
				case TemplateObjGID.WallLowerSideL: NewGID = TemplateObjGID.WallLowerSideT; break;				
				case TemplateObjGID.WallLowerSideR: NewGID = TemplateObjGID.WallLowerSideB; break;										
				case TemplateObjGID.WallLowerSideT: NewGID = TemplateObjGID.WallLowerSideL; break;
				case TemplateObjGID.WallLowerSideB: NewGID = TemplateObjGID.WallLowerSideR; break;
				case TemplateObjGID.WallPitSideL: NewGID = TemplateObjGID.WallPitSideT; break;				
				case TemplateObjGID.WallPitSideR: NewGID = TemplateObjGID.WallPitSideB; break;										
				case TemplateObjGID.WallPitSideT: NewGID = TemplateObjGID.WallPitSideL; break;
				case TemplateObjGID.WallPitSideB: NewGID = TemplateObjGID.WallPitSideR; break;
				
				case TemplateObjGID.RollingSpikesH:  NewGID = TemplateObjGID.RollingSpikesV; break;
				case TemplateObjGID.RollingSpikesV:  NewGID = TemplateObjGID.RollingSpikesH; break;
				
				case TemplateObjGID.Carpet_H: NewGID = TemplateObjGID.Carpet_V; break;
				case TemplateObjGID.Carpet_V: NewGID = TemplateObjGID.Carpet_H; break;
				case TemplateObjGID.Carpet_TR: NewGID = TemplateObjGID.Carpet_BL; break;
				case TemplateObjGID.Carpet_BL: NewGID = TemplateObjGID.Carpet_TR; break;
				case TemplateObjGID.Carpet_TLR: NewGID = TemplateObjGID.Carpet_TBL; break;
				case TemplateObjGID.Carpet_BLR: NewGID = TemplateObjGID.Carpet_TBR; break;
				case TemplateObjGID.Carpet_TBL: NewGID = TemplateObjGID.Carpet_TLR; break;
				case TemplateObjGID.Carpet_TBR: NewGID = TemplateObjGID.Carpet_BLR; break;

				case TemplateObjGID.MovingFloorLeft: NewGID = TemplateObjGID.MovingFloorUp; break;
				case TemplateObjGID.MovingFloorRight: NewGID = TemplateObjGID.MovingFloorDown; break;
				case TemplateObjGID.MovingFloorUp: NewGID = TemplateObjGID.MovingFloorLeft; break;
				case TemplateObjGID.MovingFloorDown: NewGID = TemplateObjGID.MovingFloorRight; break;
				
			}		
			break;
			
	}

	return NewGID;
}

function GetTransformedDungeonGrid(_OldGridX, _OldGridY, _OldGridW, _OldGridH, _TransformType){
	
	var _NewGridX = _OldGridX;
	var _NewGridY = _OldGridY;
	var _NewGridW = _OldGridW;
	var _NewGridH = _OldGridH;
			
	switch(_TransformType){
		
		case ObjTransformation.FlipH:
			_NewGridX = DungeonGridW - _OldGridX - _OldGridW;
			
			break;
			
		case ObjTransformation.FlipV:
			_NewGridY = DungeonGridW - _OldGridY - _OldGridH;			
			break;
			
		case ObjTransformation.FlipHV:
			_NewGridX = DungeonGridW - _OldGridX - _OldGridW;
			_NewGridY = DungeonGridW - _OldGridY - _OldGridH;
			break;
			
		case ObjTransformation.RotateCW:
			_NewGridW = _OldGridH;
			_NewGridH = _OldGridW;
			_NewGridY = _OldGridX;
			_NewGridX = DungeonGridW - _OldGridY - _OldGridH;
			break;
			
		case ObjTransformation.RotateCCW:
			_NewGridW = _OldGridH;
			_NewGridH = _OldGridW;
			_NewGridX = _OldGridY;
			_NewGridY = DungeonGridW - _OldGridX - _OldGridW;
			break;
		
		case ObjTransformation.FlipHRotateCW:
			_NewGridW = _OldGridH;
			_NewGridH = _OldGridW;
			_NewGridX = DungeonGridW - _OldGridY - _OldGridH;
			_NewGridY = DungeonGridW - _OldGridX - _OldGridW;
			break;

		case ObjTransformation.FlipHRotateCCW:
			_NewGridW = _OldGridH;
			_NewGridH = _OldGridW;
			_NewGridX = _OldGridY;
			_NewGridY = _OldGridX;
			break;
			
	}	
			
	return [_NewGridX, _NewGridY, _NewGridW, _NewGridH]
	
}

function GetTransformedDoorPosition(Position, TransformType){
	
	if(Position == -1) return -1;
	
	var NewPosition = Position;
	
	switch(TransformType){
			
		case ObjTransformation.FlipH:
			
			switch(Position){
				case 1: case 13: NewPosition = 11; break;	
				case 2: case 14: NewPosition = 10; break;	
				case 3: case 15: NewPosition = 9; break;	
				case 4: case 16: NewPosition = 8; break;	
				case 5: case 17: NewPosition = 7; break;	
				case 6: case 18: NewPosition = 6; break;	
				case 7: case 19: NewPosition = 5; break;	
				case 8: case 20: NewPosition = 4; break;	
				case 9: case 21: NewPosition = 3; break;	
				case 10: case 22: NewPosition = 2; break;
				case 11: case 23: NewPosition = 1; break;	
				case 12: case 24: NewPosition = 12; break;	
				
			}
			
			break;
			
		case ObjTransformation.FlipV:

			switch(Position){
				case 1: case 13: NewPosition = 5; break;	
				case 2: case 14: NewPosition = 4; break;	
				case 3: case 15: NewPosition = 3; break;	
				case 4: case 16: NewPosition = 2; break;	
				case 5: case 17: NewPosition = 1; break;	
				case 6: case 18: NewPosition = 12; break;	
				case 7: case 19: NewPosition = 11; break;	
				case 8: case 20: NewPosition = 10; break;	
				case 9: case 21: NewPosition = 9; break;	
				case 10: case 22: NewPosition = 8; break;
				case 11: case 23: NewPosition = 7; break;	
				case 12: case 24: NewPosition = 6; break;	
				
			}
			break;
			
		case ObjTransformation.FlipHV:

			switch(Position){

				case 1: case 13: NewPosition = 7; break;	
				case 2: case 14: NewPosition = 8; break;	
				case 3: case 15: NewPosition = 9; break;	
				case 4: case 16: NewPosition = 10; break;	
				case 5: case 17: NewPosition = 11; break;	
				case 6: case 18: NewPosition = 12; break;	
				case 7: case 19: NewPosition = 1; break;	
				case 8: case 20: NewPosition = 2; break;	
				case 9: case 21: NewPosition = 3; break;	
				case 10: case 22: NewPosition = 4; break;
				case 11: case 23: NewPosition = 5; break;	
				case 12: case 24: NewPosition = 6; break;
				
			}
			
			break;
			
		case ObjTransformation.RotateCW:

			switch(Position){

				case 1: case 13: NewPosition = 4; break;	
				case 2: case 14: NewPosition = 5; break;	
				case 3: case 15: NewPosition = 6; break;	
				case 4: case 16: NewPosition = 7; break;	
				case 5: case 17: NewPosition = 8; break;	
				case 6: case 18: NewPosition = 9; break;	
				case 7: case 19: NewPosition = 10; break;	
				case 8: case 20: NewPosition = 11; break;	
				case 9: case 21: NewPosition = 12; break;	
				case 10: case 22: NewPosition = 1; break;
				case 11: case 23: NewPosition = 2; break;	
				case 12: case 24: NewPosition = 3; break;
				
			}
			
			break;
			
		case ObjTransformation.RotateCCW:

			switch(Position){

				case 1: case 13: NewPosition = 10; break;	
				case 2: case 14: NewPosition = 11; break;	
				case 3: case 15: NewPosition = 12; break;	
				case 4: case 16: NewPosition = 1; break;	
				case 5: case 17: NewPosition = 2; break;	
				case 6: case 18: NewPosition = 3; break;	
				case 7: case 19: NewPosition = 4; break;	
				case 8: case 20: NewPosition = 5; break;	
				case 9: case 21: NewPosition = 6; break;	
				case 10: case 22: NewPosition = 7; break;
				case 11: case 23: NewPosition = 8; break;	
				case 12: case 24: NewPosition = 9; break;

			}
			
			break;

		case ObjTransformation.FlipHRotateCW:

			switch(Position){

				case 1: case 13: NewPosition = 2; break;	
				case 2: case 14: NewPosition = 1; break;	
				case 3: case 15: NewPosition = 12; break;	
				case 4: case 16: NewPosition = 11; break;	
				case 5: case 17: NewPosition = 10; break;	
				case 6: case 18: NewPosition = 9; break;	
				case 7: case 19: NewPosition = 8; break;	
				case 8: case 20: NewPosition = 7; break;	
				case 9: case 21: NewPosition = 6; break;	
				case 10: case 22: NewPosition = 5; break;
				case 11: case 23: NewPosition = 4; break;	
				case 12: case 24: NewPosition = 3; break;
				
			}
			
			break;

		case ObjTransformation.FlipHRotateCCW:

			switch(Position){

				case 1: case 13: NewPosition = 8; break;	
				case 2: case 14: NewPosition = 7; break;	
				case 3: case 15: NewPosition = 6; break;	
				case 4: case 16: NewPosition = 5; break;	
				case 5: case 17: NewPosition = 4; break;	
				case 6: case 18: NewPosition = 3; break;	
				case 7: case 19: NewPosition = 2; break;	
				case 8: case 20: NewPosition = 1; break;	
				case 9: case 21: NewPosition = 12; break;	
				case 10: case 22: NewPosition = 11; break;
				case 11: case 23: NewPosition = 10; break;	
				case 12: case 24: NewPosition = 9; break;
				
			}
			
			break;
			
	}
	
	if(TransformType != ObjTransformation.None) NewPosition += (Position > 12 ? 12 : 0);
	
	return NewPosition
	
}

function GetTransformedDoorLocation(Location, TransformType){
	
	switch(TransformType){
		
		case ObjTransformation.FlipH:
			
			switch(Location){
				case "Left": return "Right"
				case "Right": return "Left"
			}
			
			break;
			
		case ObjTransformation.FlipV:

			switch(Location){
				case "Bottom": return "Top"
				case "Top": return "Bottom"
			}
			
			break;
			
		case ObjTransformation.FlipHV:

			switch(Location){
				case "Left": return "Right"
				case "Right": return "Left"
				case "Bottom": return "Top"
				case "Top": return "Bottom"
			}
			
			break;
			
		case ObjTransformation.RotateCW:

			switch(Location){
				case "Left": return "Top"
				case "Right": return "Bottom"
				case "Bottom": return "Left"
				case "Top": return "Right"
			}
			
			break;
			
		case ObjTransformation.RotateCCW:
			switch(Location){
				case "Left": return "Bottom"
				case "Right": return "Top"
				case "Bottom": return "Right"
				case "Top": return "Left"			
			}		
			break;
		
		case ObjTransformation.FlipHRotateCW:
			switch(Location){
				case "Left": return "Bottom"
				case "Right": return "Top"
				case "Bottom": return "Left"
				case "Top": return "Right"				
			}					
			break;

		case ObjTransformation.FlipHRotateCCW:
			switch(Location){
				case "Left": return "Top"
				case "Right": return "Bottom"
				case "Bottom": return "Right"
				case "Top": return "Left"		
			}		
			break;
			
	}

	return Location;	
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

			case ObjTransformation.FlipHRotateCW:

				switch(Chr){
					case "L": NewChr = "D";	break;
					case "R": NewChr = "U";	break;
					case "U": NewChr = "R";	break;
					case "D": NewChr = "L";	break;	
				}
				break;
				
			case ObjTransformation.FlipHRotateCCW:

				switch(Chr){
					case "L": NewChr = "U";	break;
					case "R": NewChr = "D";	break;
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
				case 19: NewSectionID = 20; break; case 20: NewSectionID = 19; break;	
				case 21: NewSectionID = 22; break; case 22: NewSectionID = 21; break;
				case 23: NewSectionID = 24; break; case 24: NewSectionID = 23; break;
				case 27: NewSectionID = 28; break; case 28: NewSectionID = 27; break;
				case 29: NewSectionID = 30; break; case 30: NewSectionID = 29; break;
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
				case 17: NewSectionID = 18; break; case 18: NewSectionID = 17; break;	
				case 21: NewSectionID = 23; break; case 23: NewSectionID = 21; break;	
				case 22: NewSectionID = 24; break; case 24: NewSectionID = 22; break;
				case 27: NewSectionID = 29; break; case 29: NewSectionID = 27; break;
				case 28: NewSectionID = 30; break; case 30: NewSectionID = 28; break;
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
				case 17: NewSectionID = 18; break; case 18: NewSectionID = 17; break;	
				case 19: NewSectionID = 20; break; case 20: NewSectionID = 19; break;	
				case 21: NewSectionID = 24; break; case 24: NewSectionID = 21; break;	
				case 22: NewSectionID = 23; break; case 23: NewSectionID = 22; break;
				case 27: NewSectionID = 30; break; case 30: NewSectionID = 27; break;
				case 28: NewSectionID = 29; break; case 29: NewSectionID = 28; break;
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
				case 17: NewSectionID = 20; break;
				case 18: NewSectionID = 19; break;
				case 19: NewSectionID = 17; break;
				case 20: NewSectionID = 18; break;
				case 21: NewSectionID = 22; break;
				case 22: NewSectionID = 24; break;
				case 23: NewSectionID = 21; break;
				case 24: NewSectionID = 23; break;
				case 25: NewSectionID = 26; break;
				case 26: NewSectionID = 25; break;
				case 27: NewSectionID = 28; break;
				case 28: NewSectionID = 30; break;
				case 29: NewSectionID = 27; break;
				case 30: NewSectionID = 29; break;
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
				case 18: NewSectionID = 20; break;
				case 19: NewSectionID = 18; break;
				case 20: NewSectionID = 17; break;
				case 21: NewSectionID = 23; break;
				case 22: NewSectionID = 21; break;
				case 23: NewSectionID = 24; break;
				case 24: NewSectionID = 22; break;
				case 25: NewSectionID = 26; break;
				case 26: NewSectionID = 25; break;
				case 27: NewSectionID = 29; break;
				case 28: NewSectionID = 27; break;
				case 29: NewSectionID = 30; break;
				case 30: NewSectionID = 28; break;
			}		
			break;

		case ObjTransformation.FlipHRotateCW:

			switch(SectionID){
				case 1: NewSectionID = 8; break;
				case 2: NewSectionID = 5; break;
				case 4: NewSectionID = 7; break;	
				case 5: NewSectionID = 2; break;
				case 7: NewSectionID = 4; break;
				case 8: NewSectionID = 1; break;
				case 9: NewSectionID = 16; break;
				case 10: NewSectionID = 14; break;
				case 11: NewSectionID = 15; break;
				case 12: NewSectionID = 13; break;
				case 13: NewSectionID = 12; break;
				case 14: NewSectionID = 10; break;
				case 15: NewSectionID = 11; break;
				case 16: NewSectionID = 9; break;
				case 17: NewSectionID = 20; break;
				case 18: NewSectionID = 19; break;
				case 19: NewSectionID = 18; break;
				case 20: NewSectionID = 17; break;
				case 21: NewSectionID = 24; break;
				case 24: NewSectionID = 21; break;
				case 25: NewSectionID = 26; break;
				case 26: NewSectionID = 25; break;
				case 27: NewSectionID = 30; break;
				case 30: NewSectionID = 27; break;
			}
			
			break;

		case ObjTransformation.FlipHRotateCCW:
			switch(SectionID){
				case 2: NewSectionID = 4; break;
				case 3: NewSectionID = 6; break;	
				case 4: NewSectionID = 2; break;	
				case 5: NewSectionID = 7; break;	
				case 6: NewSectionID = 3; break;
				case 7: NewSectionID = 5; break;
				case 9: NewSectionID = 13; break;
				case 10: NewSectionID = 15; break;
				case 11: NewSectionID = 14; break;
				case 12: NewSectionID = 16; break;
				case 13: NewSectionID = 9; break;
				case 14: NewSectionID = 11; break;
				case 15: NewSectionID = 10; break;
				case 16: NewSectionID = 12; break;
				case 17: NewSectionID = 19; break;
				case 18: NewSectionID = 20; break;
				case 19: NewSectionID = 17; break;
				case 20: NewSectionID = 18; break;
				case 22: NewSectionID = 23; break;
				case 23: NewSectionID = 22; break;
				case 25: NewSectionID = 26; break;
				case 26: NewSectionID = 25; break;
				case 28: NewSectionID = 29; break;
				case 29: NewSectionID = 28; break;
			}		
			break;
			
	}

	return NewSectionID;
}

function GetTransformedSectionIDReversed(SectionID_Template, SectionID_Needed, _2x1Room){
	
	//Given the template section ID, return the transformation required to get the section ID needed. _2x1 is boolean if room is a 2x1 room since that requires different transformations needed
	//If return -1, then needed section is not possible to get from the Template section given.
	//The code that called this function would then try the next main section ID in the template until this function returns the correct transformation
	
	//if(SectionID_Template == SectionID_Needed) return ObjTransformation.None
	
	switch(SectionID_Template){
		case 1:
			if(_2x1Room){
				switch(SectionID_Needed){
					case 1: return ObjTransformation.FlipHRotateCCW
					case 3: return ObjTransformation.RotateCW
					case 6: return ObjTransformation.RotateCCW
					case 8: return ObjTransformation.FlipHRotateCW
				}				
			}else{
				switch(SectionID_Needed){
					case 3: return ObjTransformation.FlipH
					case 6: return ObjTransformation.FlipV
					case 8: return ObjTransformation.FlipHV
				}
			}
			break;
			
		case 2:
			if(_2x1Room){
				switch(SectionID_Needed){
					case 4: return ObjTransformation.RotateCCW
					case 5: return ObjTransformation.RotateCW
				}				
			}else{
				switch(SectionID_Needed){
					case 4: return ObjTransformation.RotateCCW
					case 5: return ObjTransformation.RotateCW
					case 7: return ObjTransformation.FlipV
				}
			}
			break;
			
		case 3:
			if(_2x1Room){
				switch(SectionID_Needed){
					case 1: return ObjTransformation.RotateCCW
					case 3: return ObjTransformation.FlipHRotateCW
					case 6: return ObjTransformation.FlipHRotateCCW
					case 8: return ObjTransformation.RotateCW
				}
			}else{
				switch(SectionID_Needed){
					case 1: return ObjTransformation.FlipH
					case 6: return ObjTransformation.FlipHV
					case 8: return ObjTransformation.FlipV
				}
			}
			break;
			
		case 4:
			switch(SectionID_Needed){
				case 2: return ObjTransformation.RotateCW
				case 5: return ObjTransformation.FlipH
				case 7: return ObjTransformation.RotateCCW
			}
			break;
			
		case 5:
			switch(SectionID_Needed){
				case 2: return ObjTransformation.RotateCCW
				case 4: return ObjTransformation.FlipH
				case 7: return ObjTransformation.RotateCW
			}
			break;
			
		case 6:
			if(_2x1Room){
				switch(SectionID_Needed){
					case 1: return ObjTransformation.RotateCW
					case 3: return ObjTransformation.FlipHRotateCCW
					case 6: return ObjTransformation.FlipHRotateCW
					case 8: return ObjTransformation.RotateCCW
				}				
			}else{
				switch(SectionID_Needed){
					case 1: return ObjTransformation.FlipV
					case 3: return ObjTransformation.FlipHV
					case 8: return ObjTransformation.FlipH
				}
			}
			break;
			
		case 7:
			if(_2x1Room){
				switch(SectionID_Needed){
					case 4: return ObjTransformation.RotateCW
					case 5: return ObjTransformation.RotateCCW
				}				
			}else{
				switch(SectionID_Needed){
					case 2: return ObjTransformation.FlipV
					case 4: return ObjTransformation.RotateCW
					case 5: return ObjTransformation.RotateCCW
				}
			}
			break;
			
		case 8:
			if(_2x1Room){
				switch(SectionID_Needed){
					case 1: return ObjTransformation.FlipHRotateCW
					case 3: return ObjTransformation.RotateCCW
					case 6: return ObjTransformation.RotateCW
					case 8: return ObjTransformation.FlipHRotateCCW
				}				
			}else{
				switch(SectionID_Needed){
					case 1: return ObjTransformation.FlipHV
					case 3: return ObjTransformation.FlipV
					case 6: return ObjTransformation.FlipH
				}
			}
			break;
			
		case 9:
			if(_2x1Room){
				switch(SectionID_Needed){
					case 13: return ObjTransformation.FlipHRotateCCW
					case 14: return ObjTransformation.RotateCW
					case 15: return ObjTransformation.RotateCCW
					case 16: return ObjTransformation.FlipHRotateCW
				}				
			}else{
				switch(SectionID_Needed){
					case 10: return ObjTransformation.FlipH
					case 11: return ObjTransformation.FlipV
					case 12: return ObjTransformation.FlipHV
					case 13: return ObjTransformation.FlipHRotateCCW
					case 14: return ObjTransformation.RotateCW
					case 15: return ObjTransformation.RotateCCW
					case 16: return ObjTransformation.FlipHRotateCW
				}
			}
			break;
			
		case 10:
			if(_2x1Room){
				switch(SectionID_Needed){
					case 13: return ObjTransformation.RotateCCW
					case 14: return ObjTransformation.FlipHRotateCW
					case 15: return ObjTransformation.FlipHRotateCCW
					case 16: return ObjTransformation.RotateCW
				}				
			}else{
				switch(SectionID_Needed){
					case 9: return ObjTransformation.FlipH
					case 11: return ObjTransformation.FlipHV
					case 12: return ObjTransformation.FlipV
					case 13: return ObjTransformation.RotateCCW
					case 14: return ObjTransformation.FlipHRotateCW
					case 15: return ObjTransformation.FlipHRotateCCW
					case 16: return ObjTransformation.RotateCW
				}
			}
			break;
			
		case 11:
			if(_2x1Room){
				switch(SectionID_Needed){
					case 13: return ObjTransformation.RotateCW
					case 14: return ObjTransformation.FlipHRotateCCW
					case 15: return ObjTransformation.FlipHRotateCW
					case 16: return ObjTransformation.RotateCCW
				}				
			}else{
				switch(SectionID_Needed){
					case 9: return ObjTransformation.FlipV
					case 10: return ObjTransformation.FlipHV
					case 12: return ObjTransformation.FlipH
					case 13: return ObjTransformation.RotateCW
					case 14: return ObjTransformation.FlipHRotateCCW
					case 15: return ObjTransformation.FlipHRotateCW
					case 16: return ObjTransformation.RotateCCW
				}
			}
			break;
			
		case 12:
			if(_2x1Room){
				switch(SectionID_Needed){
					case 13: return ObjTransformation.FlipHRotateCW
					case 14: return ObjTransformation.RotateCCW
					case 15: return ObjTransformation.RotateCW
					case 16: return ObjTransformation.FlipHRotateCCW
				}				
			}else{
				switch(SectionID_Needed){
					case 9: return ObjTransformation.FlipHV
					case 10: return ObjTransformation.FlipV
					case 11: return ObjTransformation.FlipH
					case 13: return ObjTransformation.FlipHRotateCW
					case 14: return ObjTransformation.RotateCCW
					case 15: return ObjTransformation.RotateCW
					case 16: return ObjTransformation.FlipHRotateCCW
				}
			}
			break;
			
		case 13:
			switch(SectionID_Needed){
				case 9: return ObjTransformation.FlipHRotateCCW
				case 10: return ObjTransformation.RotateCW
				case 11: return ObjTransformation.RotateCCW
				case 12: return ObjTransformation.FlipHRotateCW
				case 14: return ObjTransformation.FlipH
				case 15: return ObjTransformation.FlipV
				case 16: return ObjTransformation.FlipHV
			}
			break;
			
		case 14:
			switch(SectionID_Needed){
				case 9: return ObjTransformation.RotateCCW
				case 10: return ObjTransformation.FlipHRotateCW
				case 11: return ObjTransformation.FlipHRotateCCW
				case 12: return ObjTransformation.RotateCW
				case 13: return ObjTransformation.FlipH
				case 15: return ObjTransformation.FlipHV
				case 16: return ObjTransformation.FlipV
			}
			break;
			
		case 15:
			switch(SectionID_Needed){
				case 9: return ObjTransformation.RotateCW
				case 10: return ObjTransformation.FlipHRotateCCW
				case 11: return ObjTransformation.FlipHRotateCW
				case 12: return ObjTransformation.RotateCCW
				case 13: return ObjTransformation.FlipV
				case 14: return ObjTransformation.FlipHV
				case 16: return ObjTransformation.FlipH
			}
			break;
			
		case 16:
			switch(SectionID_Needed){
				case 9: return ObjTransformation.FlipHRotateCW
				case 10: return ObjTransformation.RotateCCW
				case 11: return ObjTransformation.RotateCW
				case 12: return ObjTransformation.FlipHRotateCCW
				case 13: return ObjTransformation.FlipHV
				case 14: return ObjTransformation.FlipV
				case 15: return ObjTransformation.FlipH
			}
			break;
			
		case 17:
			if(_2x1Room){
				switch(SectionID_Needed){
					case 19: return ObjTransformation.RotateCCW
					case 20: return ObjTransformation.RotateCW
				}				
			}else{
				switch(SectionID_Needed){
					case 18: return ObjTransformation.FlipV
					case 19: return ObjTransformation.RotateCCW
					case 20: return ObjTransformation.RotateCW
				}
			}
			break;
			
		case 18:
			if(_2x1Room){
				switch(SectionID_Needed){
					case 19: return ObjTransformation.RotateCW
					case 20: return ObjTransformation.RotateCCW
				}				
			}else{
				switch(SectionID_Needed){
					case 17: return ObjTransformation.FlipV
					case 19: return ObjTransformation.RotateCW
					case 20: return ObjTransformation.RotateCCW
				}
			}
			break;
			
		case 19:
			switch(SectionID_Needed){
				case 17: return ObjTransformation.RotateCW
				case 18: return ObjTransformation.RotateCCW
				case 20: return ObjTransformation.FlipH
			}
			break;
			
		case 20:
			switch(SectionID_Needed){
				case 17: return ObjTransformation.RotateCCW
				case 18: return ObjTransformation.RotateCW
				case 19: return ObjTransformation.FlipH
			}
			break;
			
		case 21:
			switch(SectionID_Needed){
				case 22: return ObjTransformation.FlipH
				case 23: return ObjTransformation.FlipV
				case 24: return ObjTransformation.FlipHV
			}
			break;
			
		case 22:
			switch(SectionID_Needed){
				case 21: return ObjTransformation.FlipH
				case 23: return ObjTransformation.FlipHV
				case 24: return ObjTransformation.FlipV
			}
			break;
			
		case 23:
			switch(SectionID_Needed){
				case 21: return ObjTransformation.FlipV
				case 22: return ObjTransformation.FlipHV
				case 24: return ObjTransformation.FlipH
			}
			break;
			
		case 24:
			switch(SectionID_Needed){
				case 21: return ObjTransformation.FlipHV
				case 22: return ObjTransformation.FlipV
				case 23: return ObjTransformation.FlipH
			}
			break;
			
		case 25:
			switch(SectionID_Needed){
				case 26: return ObjTransformation.RotateCW
			}
			break;
			
		case 26:
			switch(SectionID_Needed){
				case 25: return ObjTransformation.RotateCW
			}
			break;

		case 27:
			switch(SectionID_Needed){
				case 28: return ObjTransformation.FlipH
				case 29: return ObjTransformation.FlipV
				case 30: return ObjTransformation.FlipHV
			}
			break;
			
		case 28:
			switch(SectionID_Needed){
				case 27: return ObjTransformation.FlipH
				case 29: return ObjTransformation.FlipHV
				case 30: return ObjTransformation.FlipV
			}
			break;
			
		case 29:
			switch(SectionID_Needed){
				case 27: return ObjTransformation.FlipV
				case 28: return ObjTransformation.FlipHV
				case 30: return ObjTransformation.FlipH
			}
			break;
			
		case 30:
			switch(SectionID_Needed){
				case 27: return ObjTransformation.FlipHV
				case 28: return ObjTransformation.FlipV
				case 29: return ObjTransformation.FlipH
			}
			break;
			
	}
	
	return -1
	
}

function SectionFamilyCheck(_Section1, _Section2){
	
	//checks if both sections are part of the same section family, ex: 1,3,6,8 are the same family, so is 9-16, etc
	
	if( (_Section1 == 1 || _Section1 == 3 || _Section1 == 6 || _Section1 == 8) && (_Section2 == 1 || _Section2 == 3 || _Section2 == 6 || _Section2 == 8)) return true
	if( (_Section1 == 2 || _Section1 == 4 || _Section1 == 5 || _Section1 == 7) && (_Section2 == 2 || _Section2 == 4 || _Section2 == 5 || _Section2 == 7)) return true
	if(_Section1 >= 9 &&  _Section1 <= 16 && _Section2 >= 9 &&  _Section2 <= 16) return true
	if(_Section1 >= 17 && _Section1 <= 20 && _Section2 >= 17 && _Section2 <= 20) return true
	if(_Section1 >= 21 && _Section1 <= 24 && _Section2 >= 21 && _Section2 <= 24) return true
	if(_Section1 >= 25 && _Section1 <= 26 && _Section2 >= 25 && _Section2 <= 26) return true
	if(_Section1 >= 27 && _Section1 <= 30 && _Section2 >= 27 && _Section2 <= 30) return true
	
	return false
	
}

function GetTransformedObjRotation(Rotation, TransformType){
	
	var NewRotation = Rotation;
	
	switch(TransformType){
		
		case ObjTransformation.FlipH:
			
			switch(Rotation){
				case 90: return -90
				case -90: return 90
			}
			
			break;
			
		case ObjTransformation.FlipV:

			switch(Rotation){
				case 0: return 180
				case 180: return 0
			}
			
			break;
			
		case ObjTransformation.FlipHV:

			switch(Rotation){
				case 0: return 180
				case 90: return -90
				case -90: return 90
				case 180: return 0
			}
			
			break;
			
		case ObjTransformation.RotateCW:

			switch(Rotation){
				case 0: return 90
				case 90: return 180
				case -90: return 0
				case 180: return -90				
			}
			
			break;
			
		case ObjTransformation.RotateCCW:
			switch(Rotation){
				case 0: return -90
				case 90: return 0
				case -90: return 180
				case 180: return 90
				
			}		
			break;
		
		case ObjTransformation.FlipHRotateCW:
			switch(Rotation){
				case 0: return 90
				case 90: return 0
				case -90: return 180
				case 180: return -90				
			}					
			break;

		case ObjTransformation.FlipHRotateCCW:
			switch(Rotation){
				case 0: return -90
				case 90: return 180
				case -90: return 0
				case 180: return 90			
			}		
			break;
			
	}

	return NewRotation;
}

function GetTransformedPotStartingCorner(PotSpawnDir, TransformType){

	switch(TransformType){
		
		case ObjTransformation.FlipH:
			
			switch(PotSpawnDir){
				case "L": return "R"
				case "R": return "L"
			}
			
			break;
			
		case ObjTransformation.FlipV:

			switch(PotSpawnDir){
				case "D": return "U"
				case "U": return "D"
			}
			
			break;
			
		case ObjTransformation.FlipHV:

			switch(PotSpawnDir){
				case "L": return "R"
				case "R": return "L"
				case "D": return "U"
				case "U": return "D"
			}
			
			break;
			
		case ObjTransformation.RotateCW:

			switch(PotSpawnDir){
				case "L": return "U"
				case "R": return "D"
				case "D": return "L"
				case "U": return "R"
			}
			
			break;
			
		case ObjTransformation.RotateCCW:
			switch(PotSpawnDir){
				case "L": return "D"
				case "R": return "U"
				case "D": return "R"
				case "U": return "L"			
			}		
			break;
		
		case ObjTransformation.FlipHRotateCW:
			switch(PotSpawnDir){
				case "L": return "D"
				case "R": return "U"
				case "D": return "L"
				case "U": return "R"				
			}					
			break;

		case ObjTransformation.FlipHRotateCCW:
			switch(PotSpawnDir){
				case "L": return "U"
				case "R": return "D"
				case "D": return "R"
				case "U": return "L"		
			}		
			break;
			
	}

	return PotSpawnDir;
	
}

function TransformationStr(_Trans){
	
	switch(_Trans){
		
		case ObjTransformation.None: return "None"
		case ObjTransformation.FlipH: return "FlipH"
		case ObjTransformation.FlipV: return "FlipV"
		case ObjTransformation.FlipHV: return "FlipHV"
		case ObjTransformation.RotateCW: return "RotateCW"
		case ObjTransformation.RotateCCW: return "RotateCCW"
		case ObjTransformation.FlipHRotateCW: return "FlipHRotateCW"
		case ObjTransformation.FlipHRotateCCW: return "FlipHRotateCCW"
		
		
	}
	
}