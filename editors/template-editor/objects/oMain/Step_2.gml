if(keyboard_check_pressed(ord("R"))) game_restart();

if(keyboard_check(vk_escape)) game_end();

if(keyboard_check(vk_control) && keyboard_check_pressed(ord("S"))){
	Save();
}

if(btn_Template_11.ClickedL){
	global.CurrentTemplateSizeID = TemplateSize._1x1;
}
if(btn_Template_12.ClickedL){
	global.CurrentTemplateSizeID = TemplateSize._1x2;
}
if(btn_Template_21.ClickedL){
	global.CurrentTemplateSizeID = TemplateSize._2x1;
	
}
if(btn_Template_22.ClickedL){
	global.CurrentTemplateSizeID = TemplateSize._2x2;
	
}

if(btn_Template_New.ClickedL) Template_New(global.CurrentTemplateSizeID);

if(btn_Template_Del.ClickedL) MsgBox_Template_Del = MsgBox_Create("Are you sure you want to delete this template?", true);

if(MsgBox_Check(MsgBox_Template_Del) == MsgBox.Yes){
	//array_delete(global.Data_Dungeons, global.DungeonMap, 1);
	//var Dungeons = array_length(global.Data_Dungeons);
	//if(Dungeons == 0){

	//	NewDungeon();
		
	//}else{
	//	if(global.DungeonMap == Dungeons) global.DungeonMap--;
	//	RoomButtons_LoadFromDungeon(global.DungeonMap);	
	//	if(global.Data_Dungeons[global.DungeonMap].EntranceRoomIndex != -1)
	//		global.ActiveRoom = global.Data_Dungeons[global.DungeonMap].EntranceRoomIndex;
	//	else
	//		global.ActiveRoom = 0;
	//}
}

if(btn_Template_Prev.ClickedL){
	global.CurrentTemplate--;
	if(global.CurrentTemplate < 0) global.CurrentTemplate = 0;
	Template_Load(Transformation.None, global.CurrentTemplate);
}
if(btn_Template_Next.ClickedL){
	var Templates = array_length(global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None]);
	if(global.CurrentTemplate + 1 < Templates){
		global.CurrentTemplate++;
	}
	Template_Load(Transformation.None, global.CurrentTemplate);
}

if(btn_Template_EditDone.ClickedL){ ;
	
	//add transformed versions to other transformed template array

	for(var WallLoopLevel = 0; WallLoopLevel < 2; WallLoopLevel++){
		for(var WallLoopID = 0; WallLoopID < 2; WallLoopID++){
		
			//go through each Wall loop item from main template and add the transformed version to transformed templates
			var Template = global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None][global.CurrentTemplate];
			var TemplateArray = WallLoopLevel == UPPER ? Template.WallsUpper : Template.WallsLower;
			
			var WallLoopArray = global.WallLoop[WallLoopLevel][WallLoopID];
			var ArraySize = array_length(WallLoopArray);
		
			for(var WallLoopIndex = 0; WallLoopIndex < ArraySize; WallLoopIndex++){
			
				var Inst = WallLoopArray[WallLoopIndex].Inst;
				LinkedInsts = GetWallLoopLinkedInsts(Inst, WallLoopArray); //returns array: [0] = L, [1] = R	
				var InstR = LinkedInsts[1].Inst; //we only need to always check the R inst in the list
				
				//we need template-relative coordinates, the inst coordinates are relative to the screen
				var _x = Inst.x - oTemplate.x;
				var _y = Inst.y - oTemplate.y;
				var _InstR_x = InstR.x - oTemplate.x;
				var _InstR_y = InstR.y - oTemplate.y;
				//var NewPosValues = array_create(4);
				//NewPosValues = NewTransformPos([_x, _y, Inst.W, Inst.H], Transformation.H, global.CurrentTemplateSizeID);
				//var NewObjID = GetTransformedObjID(Inst.ID, Transformation.H);




				//add side walls
				with(Inst){
					switch(ID){
						case TemplateObjID.Wall_Corner_TL:
						case TemplateObjID.Wall_InnerCorner_TR:
						case TemplateObjID.Wall_Lower_Corner_TL:
						case TemplateObjID.Wall_Lower_InnerCorner_TR:
							//Horizontal wall
							var WallStartX = _x + W;
							var WallW = _InstR_x - WallStartX;
							var WallEndX = WallStartX + WallW;
							var WallSegments = WallW / 8;
							
							array_insert(TemplateArray, 0, new struct_TemplateObj(WallLoopLevel == UPPER ? TemplateObjID.Wall_Side_T : TemplateObjID.Wall_Lower_Side_T, noone, WallStartX, _y, WallW, CornerWallW));
							
							for(var i = 0; i < WallSegments; i++){
								draw_sprite(WallLoopLevel == UPPER ? sWall_Side_T : sWall_Lower_Side_T, 0, WallStartX + (i * 8), y);
							}

							//doors
							//Template_DoorStatus(WallLoopLevel, 11, WallStartX, WallEndX, y);
							//Template_DoorStatus(WallLoopLevel, 12, WallStartX, WallEndX, y);
							//Template_DoorStatus(WallLoopLevel, 1,  WallStartX, WallEndX, y);
						
							break;

						case TemplateObjID.Wall_Corner_TR:
						case TemplateObjID.Wall_InnerCorner_BR:
						case TemplateObjID.Wall_Lower_Corner_TR:
						case TemplateObjID.Wall_Lower_InnerCorner_BR:				
							//Vertical wall
							var WallStartY = y + H;
							var WallH = InstR.y - WallStartY;
							var WallEndY = WallStartY + WallH;
							var WallSegments = WallH / 8;
							//for(var i = 0; i < WallSegments; i++){
							//	draw_sprite(WallLoopLevel == UPPER ? sWall_Side_R : sWall_Lower_Side_R, 0, x, WallStartY + (i * 8));
							//}
							//doors
							//Template_DoorStatus(WallLoopLevel, 2, WallStartY, WallEndY, x);
							//Template_DoorStatus(WallLoopLevel, 3, WallStartY, WallEndY, x);
							//Template_DoorStatus(WallLoopLevel, 4,  WallStartY, WallEndY, x);
							break;
			
						case TemplateObjID.Wall_Corner_BR:
						case TemplateObjID.Wall_InnerCorner_BL:
						case TemplateObjID.Wall_Lower_Corner_BR:
						case TemplateObjID.Wall_Lower_InnerCorner_BL:
							//Horizontal wall
							var WallStartX = InstR.x + W;
							var WallW = x - WallStartX;
							var WallEndX = WallStartX + WallW;
							var WallSegments = WallW / 8;

							//for(var i = 0; i < WallSegments; i++){
							//	draw_sprite(WallLoopLevel == UPPER ? sWall_Side_B : sWall_Lower_Side_B, 0, WallStartX + (i * 8), y);
							//}
							//doors
							//Template_DoorStatus(WallLoopLevel, 5, WallStartX, WallEndX, y);
							//Template_DoorStatus(WallLoopLevel, 6, WallStartX, WallEndX, y);
							//Template_DoorStatus(WallLoopLevel, 7,  WallStartX, WallEndX, y);
							break;

						case TemplateObjID.Wall_Corner_BL:
						case TemplateObjID.Wall_InnerCorner_TL:
						case TemplateObjID.Wall_Lower_Corner_BL:
						case TemplateObjID.Wall_Lower_InnerCorner_TL:
					
							//Vertical wall
							var WallStartY = InstR.y + H;
							var WallH = y - WallStartY;
							var WallEndY = WallStartY + WallH;
							var WallSegments = WallH / 8;
				
							//for(var i = 0; i < WallSegments; i++){
							//	draw_sprite(WallLoopLevel == UPPER ? sWall_Side_L : sWall_Lower_Side_L, 0, x, WallStartY + (i * 8));
							//}
							//doors
							//Template_DoorStatus(WallLoopLevel, 8, WallStartY, WallEndY, x);
							//Template_DoorStatus(WallLoopLevel, 9, WallStartY, WallEndY, x);
							//Template_DoorStatus(WallLoopLevel, 10,  WallStartY, WallEndY, x);
							break;

						
					}	
				}



				array_insert(TemplateArray, 0, new struct_TemplateObj(Inst.ID, noone, _x, _y, CornerWallW, CornerWallW));
				//array_insert(global.Data_RoomTemplates[Transformation.H][global.CurrentTemplate].WallsUpper, WallLoopIndex, new struct_TemplateObj(NewObjID, noone, _x, _y, CornerWallW, CornerWallW));

			
			}
		
		}
	}
	
	with(oTemplateObj) instance_destroy(self);
	
	DeleteWallLoops();
	
	global.EditMode = false;
	
	UpdateButtons();		
		

}


if(chk_Template_Transf_H.ClickedL){
	global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None][global.CurrentTemplate].RoomTransformations[Transformation.H] = chk_Template_Transf_H.ChkStatus;
	UpdateButtons();
}
if(chk_Template_Transf_V.ClickedL){
	global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None][global.CurrentTemplate].RoomTransformations[Transformation.V] = chk_Template_Transf_V.ChkStatus;
	UpdateButtons();
}
if(chk_Template_Transf_HV.ClickedL){
	global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None][global.CurrentTemplate].RoomTransformations[Transformation.HV] = chk_Template_Transf_HV.ChkStatus;
	UpdateButtons();
}
if(chk_Template_Transf_CW.ClickedL){
	global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None][global.CurrentTemplate].RoomTransformations[Transformation.CW] = chk_Template_Transf_CW.ChkStatus;
	UpdateButtons();
}
if(chk_Template_Transf_CCW.ClickedL){
	global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None][global.CurrentTemplate].RoomTransformations[Transformation.CCW] = chk_Template_Transf_CCW.ChkStatus;
	UpdateButtons();
}

if(btn_Template_Transf_H.ClickedL){
	Template_Load(Transformation.H, global.CurrentTemplate);
}
