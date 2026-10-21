#macro LOWER 0
#macro UPPER 1
#macro RoomBuffer 16



enum TemplateSize{
 _1x1,
 _1x2,
 _2x1,
 _2x2
}

function Template_InitData(){
	
	global.EditMode = true;
	
	global.WallLoop[LOWER][0] = array_create(0);
	global.WallLoop[LOWER][1] = array_create(0);
	global.WallLoop[UPPER][0] = array_create(0);
	global.WallLoop[UPPER][1] = array_create(0);
	
	global.TemplateObj_Sprites[TemplateObjID.Wall_Corner_TL] = sWall_Corner_TL;
	global.TemplateObj_Sprites[TemplateObjID.Wall_Corner_TR] = sWall_Corner_TR;
	global.TemplateObj_Sprites[TemplateObjID.Wall_Corner_BL] = sWall_Corner_BL;
	global.TemplateObj_Sprites[TemplateObjID.Wall_Corner_BR] = sWall_Corner_BR;
	global.TemplateObj_Sprites[TemplateObjID.Wall_InnerCorner_TL] = sWall_InnerCorner_TL;
	global.TemplateObj_Sprites[TemplateObjID.Wall_InnerCorner_TR] = sWall_InnerCorner_TR;
	global.TemplateObj_Sprites[TemplateObjID.Wall_InnerCorner_BL] = sWall_InnerCorner_BL;
	global.TemplateObj_Sprites[TemplateObjID.Wall_InnerCorner_BR] = sWall_InnerCorner_BR;
	global.TemplateObj_Sprites[TemplateObjID.Wall_Side_T] = sWall_Side_T;
	global.TemplateObj_Sprites[TemplateObjID.Wall_Side_B] = sWall_Side_B;
	global.TemplateObj_Sprites[TemplateObjID.Wall_Side_L] = sWall_Side_L;
	global.TemplateObj_Sprites[TemplateObjID.Wall_Side_R] = sWall_Side_R;

	global.TemplateObj_Sprites[TemplateObjID.Wall_Lower_Corner_TL] = sWall_Lower_Corner_TL;
	global.TemplateObj_Sprites[TemplateObjID.Wall_Lower_Corner_TR] = sWall_Lower_Corner_TR;
	global.TemplateObj_Sprites[TemplateObjID.Wall_Lower_Corner_BL] = sWall_Lower_Corner_BL;
	global.TemplateObj_Sprites[TemplateObjID.Wall_Lower_Corner_BR] = sWall_Lower_Corner_BR;
	global.TemplateObj_Sprites[TemplateObjID.Wall_Lower_InnerCorner_TL] = sWall_Lower_InnerCorner_TL;
	global.TemplateObj_Sprites[TemplateObjID.Wall_Lower_InnerCorner_TR] = sWall_Lower_InnerCorner_TR;
	global.TemplateObj_Sprites[TemplateObjID.Wall_Lower_InnerCorner_BL] = sWall_Lower_InnerCorner_BL;
	global.TemplateObj_Sprites[TemplateObjID.Wall_Lower_InnerCorner_BR] = sWall_Lower_InnerCorner_BR;
	global.TemplateObj_Sprites[TemplateObjID.Wall_Lower_Side_T] = sWall_Lower_Side_T;
	global.TemplateObj_Sprites[TemplateObjID.Wall_Lower_Side_B] = sWall_Lower_Side_B;
	global.TemplateObj_Sprites[TemplateObjID.Wall_Lower_Side_L] = sWall_Lower_Side_L;
	global.TemplateObj_Sprites[TemplateObjID.Wall_Lower_Side_R] = sWall_Lower_Side_R;
	
	global.TemplateObj_Level[LOWER][TemplateObjID.Wall_Corner_TL] = TemplateObjID.Wall_Lower_Corner_TL;
	global.TemplateObj_Level[LOWER][TemplateObjID.Wall_Corner_TR] = TemplateObjID.Wall_Lower_Corner_TR;
	global.TemplateObj_Level[LOWER][TemplateObjID.Wall_Corner_BL] = TemplateObjID.Wall_Lower_Corner_BL;
	global.TemplateObj_Level[LOWER][TemplateObjID.Wall_Corner_BR] = TemplateObjID.Wall_Lower_Corner_BR;
	global.TemplateObj_Level[LOWER][TemplateObjID.Wall_InnerCorner_TL] = TemplateObjID.Wall_Lower_InnerCorner_TL;
	global.TemplateObj_Level[LOWER][TemplateObjID.Wall_InnerCorner_TR] = TemplateObjID.Wall_Lower_InnerCorner_TR;
	global.TemplateObj_Level[LOWER][TemplateObjID.Wall_InnerCorner_BL] = TemplateObjID.Wall_Lower_InnerCorner_BL;
	global.TemplateObj_Level[LOWER][TemplateObjID.Wall_InnerCorner_BR] = TemplateObjID.Wall_Lower_InnerCorner_BR;
	global.TemplateObj_Level[LOWER][TemplateObjID.Wall_Side_T] = TemplateObjID.Wall_Lower_Side_T;
	global.TemplateObj_Level[LOWER][TemplateObjID.Wall_Side_B] = TemplateObjID.Wall_Lower_Side_B;
	global.TemplateObj_Level[LOWER][TemplateObjID.Wall_Side_L] = TemplateObjID.Wall_Lower_Side_L;
	global.TemplateObj_Level[LOWER][TemplateObjID.Wall_Side_R] = TemplateObjID.Wall_Lower_Side_R;

	global.TemplateObj_Level[UPPER][TemplateObjID.Wall_Corner_TL] = TemplateObjID.Wall_Corner_TL;
	global.TemplateObj_Level[UPPER][TemplateObjID.Wall_Corner_TR] = TemplateObjID.Wall_Corner_TR;
	global.TemplateObj_Level[UPPER][TemplateObjID.Wall_Corner_BL] = TemplateObjID.Wall_Corner_BL;
	global.TemplateObj_Level[UPPER][TemplateObjID.Wall_Corner_BR] = TemplateObjID.Wall_Corner_BR;
	global.TemplateObj_Level[UPPER][TemplateObjID.Wall_InnerCorner_TL] = TemplateObjID.Wall_InnerCorner_TL;
	global.TemplateObj_Level[UPPER][TemplateObjID.Wall_InnerCorner_TR] = TemplateObjID.Wall_InnerCorner_TR;
	global.TemplateObj_Level[UPPER][TemplateObjID.Wall_InnerCorner_BL] = TemplateObjID.Wall_InnerCorner_BL;
	global.TemplateObj_Level[UPPER][TemplateObjID.Wall_InnerCorner_BR] = TemplateObjID.Wall_InnerCorner_BR;
	global.TemplateObj_Level[UPPER][TemplateObjID.Wall_Side_T] = TemplateObjID.Wall_Side_T;
	global.TemplateObj_Level[UPPER][TemplateObjID.Wall_Side_B] = TemplateObjID.Wall_Side_B;
	global.TemplateObj_Level[UPPER][TemplateObjID.Wall_Side_L] = TemplateObjID.Wall_Side_L;
	global.TemplateObj_Level[UPPER][TemplateObjID.Wall_Side_R] = TemplateObjID.Wall_Side_R;
	
	global.TemplateSizeID[1][1] = TemplateSize._1x1;
	global.TemplateSizeID[1][2] = TemplateSize._1x2;
	global.TemplateSizeID[2][1] = TemplateSize._2x1;
	global.TemplateSizeID[2][2] = TemplateSize._2x2;
	global.TemplateSizeGridW[TemplateSize._1x1] = 1;
	global.TemplateSizeGridW[TemplateSize._1x2] = 1;
	global.TemplateSizeGridW[TemplateSize._2x1] = 2;
	global.TemplateSizeGridW[TemplateSize._2x2] = 2;
	global.TemplateSizeGridH[TemplateSize._1x1] = 1;
	global.TemplateSizeGridH[TemplateSize._1x2] = 2;
	global.TemplateSizeGridH[TemplateSize._2x1] = 1;
	global.TemplateSizeGridH[TemplateSize._2x2] = 2;
	
	global.DoorStatus = array_create(25, false);
	global.DoorObjID = array_create(25, 0);
	global.DoorObjID[11] = TemplateObjID.DoorT;
	global.DoorObjID[12] = TemplateObjID.DoorT;
	global.DoorObjID[1] = TemplateObjID.DoorT;
	global.DoorObjID[13] = TemplateObjID.DoorT;
	global.DoorObjID[23] = TemplateObjID.DoorT;
	global.DoorObjID[24] = TemplateObjID.DoorT;
	global.DoorObjID[2] = TemplateObjID.DoorR;
	global.DoorObjID[3] = TemplateObjID.DoorR;
	global.DoorObjID[4] = TemplateObjID.DoorR;
	global.DoorObjID[14] = TemplateObjID.DoorR;
	global.DoorObjID[15] = TemplateObjID.DoorR;
	global.DoorObjID[16] = TemplateObjID.DoorR;
	global.DoorObjID[5] = TemplateObjID.DoorB;
	global.DoorObjID[6] = TemplateObjID.DoorB;
	global.DoorObjID[7] = TemplateObjID.DoorB;
	global.DoorObjID[17] = TemplateObjID.DoorB;
	global.DoorObjID[18] = TemplateObjID.DoorB;
	global.DoorObjID[19] = TemplateObjID.DoorB;
	global.DoorObjID[8] = TemplateObjID.DoorL;
	global.DoorObjID[9] = TemplateObjID.DoorL;
	global.DoorObjID[10] = TemplateObjID.DoorL;
	global.DoorObjID[20] = TemplateObjID.DoorL;
	global.DoorObjID[21] = TemplateObjID.DoorL;
	global.DoorObjID[22] = TemplateObjID.DoorL;
	
}

function Template_New(_TemplateSizeID){
	
	var _W = global.TemplateSizeGridW[_TemplateSizeID];
	var _H = global.TemplateSizeGridH[_TemplateSizeID];
	
	with(oTemplateObj) instance_destroy(self);

	DeleteWallLoops();

	global.CurrentTemplateTrans = Transformation.None;
	global.CurrentTemplateSizeID = global.TemplateSizeID[_W][_H];
	
	var Templates = array_length(global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None]);
	array_insert(global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None], Templates, new struct_Template(_W, _H, true));
	
	//add a struct for each transformation type
	//To add: based on transformation type and room size, the _W and _H might be switched (1x2 room CW would be a 2x1 room)
	array_insert(global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.H], Templates, new struct_Template(_W, _H, false));
	array_insert(global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.V], Templates, new struct_Template(_W, _H, false));
	array_insert(global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.HV], Templates, new struct_Template(_W, _H, false));
	array_insert(global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.CW], Templates, new struct_Template(_W, _H, false));
	array_insert(global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.CCW], Templates, new struct_Template(_W, _H, false));
	
	global.CurrentTemplate = Templates;
	Template_SetSize(_W, _H);
	TemplateObj_CornerWall_Create(TemplateObjID.Wall_Corner_TL, global.Template_MinX, global.Template_MinY, UPPER, 0, 0);
	TemplateObj_CornerWall_Create(TemplateObjID.Wall_Corner_TR, global.Template_MaxX - CornerWallW, global.Template_MinY, UPPER, 0, 1);
	TemplateObj_CornerWall_Create(TemplateObjID.Wall_Corner_BR, global.Template_MaxX - CornerWallW, global.Template_MaxY - CornerWallW, UPPER, 0, 2);
	TemplateObj_CornerWall_Create(TemplateObjID.Wall_Corner_BL, global.Template_MinX, global.Template_MaxY - CornerWallW, UPPER, 0, 3);


	global.EditMode = true;

	
	UpdateButtons();

}

function Template_Load(_Transformation, _TemplateIndex){
	
	global.CurrentTemplateTrans = _Transformation;
	with(oTemplateObj) instance_destroy(self);
	var TemplateArray = global.Data_RoomTemplates[global.CurrentTemplateSizeID][global.CurrentTemplateTrans][_TemplateIndex];
	Template_SetSize(TemplateArray.GridW, TemplateArray.GridH);
	//for(var i = 0; i < array_length(global.Data_RoomTemplates[global.CurrentTemplateTrans][_TemplateIndex].WallLoop[UPPER][0]); i++){
	//	var _id = global.Data_RoomTemplates[global.CurrentTemplateTrans][_TemplateIndex].WallLoop[UPPER][0][i].ID;
	//	var _x = global.Data_RoomTemplates[global.CurrentTemplateTrans][_TemplateIndex].WallLoop[UPPER][0][i].x;
	//	var _y = global.Data_RoomTemplates[global.CurrentTemplateTrans][_TemplateIndex].WallLoop[UPPER][0][i].y;
	//	TemplateObj_CornerWall_Create(_id, _x, _y, UPPER, 0, i, true);
	//}
	
	//oMain.chk_Template_Edit.ChkStatus = global.EditMode;

	
	UpdateButtons();
}

function Template_SetSize(_W, _H){

	global.Template_GridW = _W;
	global.Template_GridH = _H;	
	global.Template_W = _W * 256;
	global.Template_H = _H * 256;
	global.Template_MinX = oTemplate.x + RoomBuffer;
	global.Template_MinY = oTemplate.y + RoomBuffer;
	global.Template_MaxX = oTemplate.x + global.Template_W - RoomBuffer;
	global.Template_MaxY = oTemplate.y + global.Template_H - RoomBuffer;
	oTemplate.image_index = global.TemplateSizeID[_W][_H];
}


function Template_DoorStatus(_Level, _Position, _WallStart, _WallEnd, _WallEdge){
	
	_Position = _Position + (_Level == LOWER ? 12 : 0);
	var _RoomBuffer = RoomBuffer + (_Level == LOWER ? 24 : 0);
	
	switch(_Position){
		case 11: case 12: case 1: 
		case 23: case 24: case 13: 
			var DoorX = global.DoorCoordinates[global.TemplateSizeID[global.Template_GridW][global.Template_GridH]][_Position].x;
			if(_WallEdge == oTemplate.y + _RoomBuffer && _WallStart <= oTemplate.x + DoorX && _WallEnd >= oTemplate.x + DoorX + 32){
				global.DoorStatus[_Position] = true;
				//draw_sprite(sDoor_Top, 0, oTemplate.x + DoorX, oTemplate.y + _RoomBuffer);
			}		
			break;

		case 2: case 3: case 4: 
		case 14: case 15: case 16: 
			var DoorY = global.DoorCoordinates[global.TemplateSizeID[global.Template_GridW][global.Template_GridH]][_Position].y;
			if(_WallEdge == oTemplate.x + global.Template_W - _RoomBuffer - 24 && _WallStart <= oTemplate.y + DoorY && _WallEnd >= oTemplate.y + DoorY + 32){
				global.DoorStatus[_Position] = true;
				//draw_sprite(sDoor_Right, 0, oTemplate.x + oTemplate.W - _RoomBuffer - 24, oTemplate.y + DoorY);
			}	
			break;	

		case 5: case 6: case 7: 
		case 17: case 18: case 19: 
			var DoorX = global.DoorCoordinates[global.TemplateSizeID[global.Template_GridW][global.Template_GridH]][_Position].x;
			if(_WallEdge == oTemplate.y + global.Template_H - _RoomBuffer - 24 && _WallStart <= oTemplate.x + DoorX && _WallEnd >= oTemplate.x + DoorX + 32){
				global.DoorStatus[_Position] = true;
				//draw_sprite(sDoor_Bottom, 0, oTemplate.x + DoorX, oTemplate.y + oTemplate.H - _RoomBuffer - 24);
			}		
			break;
			
		case 8: case 9: case 10: 
		case 20: case 21: case 22: 
			var DoorY = global.DoorCoordinates[global.TemplateSizeID[global.Template_GridW][global.Template_GridH]][_Position].y;
			if(_WallEdge == oTemplate.x + _RoomBuffer && _WallStart <= oTemplate.y + DoorY && _WallEnd >= oTemplate.y + DoorY + 32){
				global.DoorStatus[_Position] = true;
				//draw_sprite(sDoor_Left, 0, oTemplate.x + _RoomBuffer, oTemplate.y + DoorY);
			}	
			break;


			
	}

				
}

function Door_Draw(_Position){

	//_Position = _Position + (_Level == LOWER ? 12 : 0);
	var _RoomBuffer = RoomBuffer + (_Position > 12 ? 24 : 0);
	
	switch(_Position){
		case 11: case 12: case 1: 
		case 23: case 24: case 13: 
			var DoorX = global.DoorCoordinates[global.TemplateSizeID[global.Template_GridW][global.Template_GridH]][_Position].x;
			draw_sprite(sDoor_Top, 0, oTemplate.x + DoorX, oTemplate.y + _RoomBuffer);
			break;

		case 2: case 3: case 4: 
		case 14: case 15: case 16: 
			var DoorY = global.DoorCoordinates[global.TemplateSizeID[global.Template_GridW][global.Template_GridH]][_Position].y;
			draw_sprite(sDoor_Right, 0, oTemplate.x + global.Template_W - _RoomBuffer - 24, oTemplate.y + DoorY);
			break;	

		case 5: case 6: case 7: 
		case 17: case 18: case 19: 
			var DoorX = global.DoorCoordinates[global.TemplateSizeID[global.Template_GridW][global.Template_GridH]][_Position].x;
			draw_sprite(sDoor_Bottom, 0, oTemplate.x + DoorX, oTemplate.y + global.Template_H - _RoomBuffer - 24);	
			break;
			
		case 8: case 9: case 10: 
		case 20: case 21: case 22: 
			var DoorY = global.DoorCoordinates[global.TemplateSizeID[global.Template_GridW][global.Template_GridH]][_Position].y;
			draw_sprite(sDoor_Left, 0, oTemplate.x + _RoomBuffer, oTemplate.y + DoorY);
			break;


			
	}
	
}

function UpdateButtons(){
	
	btn_Template_EditDone.visible = global.EditMode;
	
	
	
	btn_Template_Next.visible = !global.EditMode;
	btn_Template_Prev.visible = !global.EditMode;
	btn_Template_New.visible = !global.EditMode;
	btn_Template_Del.visible = !global.EditMode;
	btn_Template_11.visible = !global.EditMode;
	btn_Template_12.visible = !global.EditMode;
	btn_Template_21.visible = !global.EditMode;
	btn_Template_22.visible = !global.EditMode;
	
	btn_Template_Transf_None.visible = !global.EditMode;
	chk_Template_Transf_H.visible = !global.EditMode;
	chk_Template_Transf_V.visible = !global.EditMode;
	chk_Template_Transf_HV.visible = !global.EditMode;
	chk_Template_Transf_CW.visible = !global.EditMode;
	chk_Template_Transf_CCW.visible = !global.EditMode;
	
	btn_Template_Transf_V.visible = !global.EditMode;
	btn_Template_Transf_HV.visible = !global.EditMode;
	btn_Template_Transf_CW.visible = !global.EditMode;
	btn_Template_Transf_CCW.visible = !global.EditMode;
	
	
	btn_Template_Transf_H.visible = !global.EditMode && global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None][global.CurrentTemplate].RoomTransformations[Transformation.H];
	btn_Template_Transf_V.visible = !global.EditMode && global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None][global.CurrentTemplate].RoomTransformations[Transformation.V];
	btn_Template_Transf_HV.visible = !global.EditMode && global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None][global.CurrentTemplate].RoomTransformations[Transformation.HV];
	btn_Template_Transf_CW.visible = !global.EditMode && global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None][global.CurrentTemplate].RoomTransformations[Transformation.CW];
	btn_Template_Transf_CCW.visible = !global.EditMode && global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None][global.CurrentTemplate].RoomTransformations[Transformation.CCW];

	chk_Template_Transf_H.ChkStatus = global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None][global.CurrentTemplate].RoomTransformations[Transformation.H];
	chk_Template_Transf_V.ChkStatus = global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None][global.CurrentTemplate].RoomTransformations[Transformation.V];
	chk_Template_Transf_HV.ChkStatus = global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None][global.CurrentTemplate].RoomTransformations[Transformation.HV];
	chk_Template_Transf_CW.ChkStatus = global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None][global.CurrentTemplate].RoomTransformations[Transformation.CW];
	chk_Template_Transf_CCW.ChkStatus = global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None][global.CurrentTemplate].RoomTransformations[Transformation.CCW];
}

function DeleteWallLoops(){
	
	for(var WallLoopLevel = 0; WallLoopLevel < 2; WallLoopLevel++){
		for(var WallLoopID = 0; WallLoopID < 2; WallLoopID++){
		
			//go through each list item
		
			var Array = global.WallLoop[WallLoopLevel][WallLoopID];
			var ArraySize = array_length(Array);
		
			repeat(ArraySize){
				delete Array[0];
			}
		}
	}

	global.WallLoop[LOWER][0] = array_create(0);
	global.WallLoop[LOWER][1] = array_create(0);
	global.WallLoop[UPPER][0] = array_create(0);
	global.WallLoop[UPPER][1] = array_create(0);
	
}


function GetWallLoopLinkedInsts(_Inst, _Array){
	//returns an array with 2 indexes holding the L(0) and R(1) instances in the wall loop
		var ArraySize = array_length(_Array);
		for(var i = 0; i < ArraySize; i++){
			if(_Array[i].Inst == _Inst)
				break	
		}
		//var CornerWallInstPos = array_find_index(_Array, _Inst);
		//array
		Inst[0] = _Array[i == 0 ? ArraySize - 1 : i - 1];
		Inst[1] = _Array[i == ArraySize - 1 ? 0 : i + 1];
		
		return Inst;
}
