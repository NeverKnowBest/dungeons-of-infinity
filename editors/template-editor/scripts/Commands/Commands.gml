
function Save(){

	exit;
	
	var Template = global.Data_RoomTemplates[global.CurrentTemplateSizeID][global.CurrentTemplateTrans][global.CurrentTemplate];
	Template.WallsUpper = array_create(0); //clear array before adding objects
	Template.WallsLower = array_create(0); //clear array before adding objects
	
	//Add UpperWalls
	for(var WallLoopLevel = 0; WallLoopLevel < 2; WallLoopLevel++){
		for(var WallLoopID = 0; WallLoopID < 2; WallLoopID++){
		
			var WallsArray = WallLoopLevel == UPPER ? Template.WallsUpper : Template.WallsLower;	

			
			var WallLoopArray = global.WallLoop[WallLoopLevel][WallLoopID];
			var WallLoopArraySize = array_length(WallLoopArray);
		
			for(var WallLoopIndex = 0; WallLoopIndex < WallLoopArraySize; WallLoopIndex++){
				
				//add corner walls from list
				var Inst = WallLoopArray[WallLoopIndex].Inst;
				var InstX = Inst.x - oTemplate.x;
				var InstY = Inst.y - oTemplate.y;
				
				array_insert(WallsArray, WallLoopIndex, new struct_TemplateObj(Inst.ID, Inst, InstX, InstY, CornerWallW, CornerWallW));
				
				//For each corner wall, add the appropriate side walls.
				LinkedInsts = GetWallLoopLinkedInsts(Inst, WallLoopArray); //returns array: [0] = L, [1] = R	
				var InstR = LinkedInsts[1].Inst; //we only need to always check the R inst in the list
				var InstRX = InstR.x - oTemplate.x;
				var InstRY = InstR.y - oTemplate.y;			
				
				switch(Inst.ID){
					case TemplateObjID.Wall_Corner_TL:
					case TemplateObjID.Wall_InnerCorner_TR:
					case TemplateObjID.Wall_Lower_Corner_TL:
					case TemplateObjID.Wall_Lower_InnerCorner_TR:
						//Horizontal wall
						var WallStartX = InstX + Inst.W;
						var WallW = InstRX - WallStartX;
						
						//Only add if the distance between Inst and InstR is larger than CornerWallW
						if(WallW > 0){
							var ObjID = global.TemplateObj_Level[WallLoopLevel][TemplateObjID.Wall_Side_T]
							array_insert(WallsArray, WallLoopIndex, new struct_TemplateObj(ObjID, Inst, WallStartX, InstY, WallW, CornerWallW));
						}
						
						break;

					case TemplateObjID.Wall_Corner_TR:
					case TemplateObjID.Wall_InnerCorner_BR:
					case TemplateObjID.Wall_Lower_Corner_TR:
					case TemplateObjID.Wall_Lower_InnerCorner_BR:				
						//Vertical wall
						var WallStartY = InstY + Inst.H;
						var WallH = InstRY - WallStartY;

						//Only add if the distance between Inst and InstR is larger than CornerWallW
						if(WallH > 0){
							var ObjID = global.TemplateObj_Level[WallLoopLevel][TemplateObjID.Wall_Side_R]
							array_insert(WallsArray, WallLoopIndex, new struct_TemplateObj(ObjID, Inst, InstX, WallStartY, CornerWallW, WallH));
						}
						
						break;
			
					case TemplateObjID.Wall_Corner_BR:
					case TemplateObjID.Wall_InnerCorner_BL:
					case TemplateObjID.Wall_Lower_Corner_BR:
					case TemplateObjID.Wall_Lower_InnerCorner_BL:
						//Horizontal wall
						var WallStartX = InstRX + Inst.W;
						var WallW = InstX - WallStartX;

						//Only add if the distance between Inst and InstR is larger than CornerWallW
						if(WallW > 0){
							var ObjID = global.TemplateObj_Level[WallLoopLevel][TemplateObjID.Wall_Side_B]
							array_insert(WallsArray, WallLoopIndex, new struct_TemplateObj(ObjID, Inst, WallStartX, InstY, WallW, CornerWallW));
						}
						
						break;

					case TemplateObjID.Wall_Corner_BL:
					case TemplateObjID.Wall_InnerCorner_TL:
					case TemplateObjID.Wall_Lower_Corner_BL:
					case TemplateObjID.Wall_Lower_InnerCorner_TL:
					
						//Vertical wall
						var WallStartY = InstRY + Inst.H;
						var WallH = InstY - WallStartY;

						//Only add if the distance between Inst and InstR is larger than CornerWallW
						if(WallH > 0){
							var ObjID = global.TemplateObj_Level[WallLoopLevel][TemplateObjID.Wall_Side_L]
							array_insert(WallsArray, WallLoopIndex, new struct_TemplateObj(ObjID, Inst, InstX, WallStartY, CornerWallW, WallH));
						}
						
						break;
						
				}	
			
			}
		
		}
	}


	//add doors
	var DoorArray = Template.Doors
	DoorArray = array_create(0); //clear array
	
	for(var i = 1; i <= 24; i++){
		if(global.DoorStatus[i]){
			var DoorIndex = array_length(DoorArray);
			array_insert(DoorArray, DoorIndex, new struct_Door(global.TemplateSizeID[global.Template_GridW][global.Template_GridH], i));			
		}	
	}

	var file = file_text_open_write("C:\\Google Drive\\Omnitron Studios\\Zelda\\Code\\datafiles\\RoomTemplates.json");
	file_text_write_string(file, Convert_To_JSON(global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None], true));
	file_text_close(file);

	//var file = file_text_open_write("C:\\Google Drive\\Omnitron Studios\\Zelda\\Template Editor\\RoomTemplates.json");
	//file_text_write_string(file, Convert_To_JSON(global.Data_Dungeons, true));
	//file_text_close(file);


}

