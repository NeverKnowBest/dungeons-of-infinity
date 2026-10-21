
Mouse_LB = mouse_check_button(mb_left);
Mouse_RB_Pressed = mouse_check_button_pressed(mb_right);
Mouse_MB_Pressed = mouse_check_button_pressed(mb_middle);

var MouseInst = instance_position(mouse_x, mouse_y, oTemplateObj);

if(MouseInst != noone) MouseInst.MouseOver = true;

if(Mouse_LB){
	
	if(MouseInst == noone && !Mouse_OffClickL) Mouse_OffClickL = true;
	
	if(MouseInst != noone && !Mouse_Inst_Move && !Mouse_OffClickL){

		Mouse_Inst = MouseInst;
		Mouse_Inst_OffsetX = mouse_x - Mouse_Inst.x;
		Mouse_Inst_OffsetY = mouse_y - Mouse_Inst.y;


		if(Mouse_Inst.IsCornerWall && global.EditMode){
			
			var WallLoopArray = global.WallLoop[Mouse_Inst.WallLoopLevel][Mouse_Inst.WallLoopID];
			//find positions for linked insts in the list
			LinkedInsts = GetWallLoopLinkedInsts(Mouse_Inst, WallLoopArray); //returns array: [0] = L, [1] = R		
		
			//depending on what type of corner Mouse_Inst is, adjust the mins and maxes accordingly
			switch(Mouse_Inst.ID){
				case TemplateObjID.Wall_Corner_TL: case TemplateObjID.Wall_Lower_Corner_TL:
					Mouse_Inst.MaxX = LinkedInsts[1].Inst.x - LinkedInsts[1].Inst.W;
					Mouse_Inst.MaxY = LinkedInsts[0].Inst.y - LinkedInsts[0].Inst.H;
					break;
					
				case TemplateObjID.Wall_Corner_TR: case TemplateObjID.Wall_Lower_Corner_TR: 
					Mouse_Inst.MinX = LinkedInsts[0].Inst.x + LinkedInsts[0].Inst.W;
					Mouse_Inst.MaxY = LinkedInsts[1].Inst.y - LinkedInsts[1].Inst.H;
					break;

				case TemplateObjID.Wall_Corner_BL: case TemplateObjID.Wall_Lower_Corner_BL:
					Mouse_Inst.MaxX = LinkedInsts[0].Inst.x - LinkedInsts[0].Inst.W;
					Mouse_Inst.MinY = LinkedInsts[1].Inst.y + LinkedInsts[1].Inst.H;
					break;

				case TemplateObjID.Wall_Corner_BR: case TemplateObjID.Wall_Lower_Corner_BR:
					Mouse_Inst.MinX = LinkedInsts[1].Inst.x + LinkedInsts[1].Inst.W;
					Mouse_Inst.MinY = LinkedInsts[0].Inst.y + LinkedInsts[0].Inst.H;
					break;
				
				case TemplateObjID.Wall_InnerCorner_TL: case TemplateObjID.Wall_Lower_InnerCorner_TL:
					Mouse_Inst.MinX = LinkedInsts[0].Inst.x + LinkedInsts[0].Inst.W;
					Mouse_Inst.MinY = LinkedInsts[1].Inst.y + LinkedInsts[1].Inst.H;
					break;

				case TemplateObjID.Wall_InnerCorner_TR: case TemplateObjID.Wall_Lower_InnerCorner_TR:
					Mouse_Inst.MaxX = LinkedInsts[1].Inst.x - LinkedInsts[1].Inst.W;
					Mouse_Inst.MinY = LinkedInsts[0].Inst.y + LinkedInsts[0].Inst.H;
					break;
					
				case TemplateObjID.Wall_InnerCorner_BL: case TemplateObjID.Wall_Lower_InnerCorner_BL:
					Mouse_Inst.MinX = LinkedInsts[1].Inst.x + LinkedInsts[1].Inst.W;
					Mouse_Inst.MaxY = LinkedInsts[0].Inst.y - LinkedInsts[0].Inst.H;
					break;
					
				case TemplateObjID.Wall_InnerCorner_BR: case TemplateObjID.Wall_Lower_InnerCorner_BR:
					Mouse_Inst.MaxX = LinkedInsts[0].Inst.x - LinkedInsts[0].Inst.W;
					Mouse_Inst.MaxY = LinkedInsts[1].Inst.y - LinkedInsts[1].Inst.H;
					break;
					
			}
			
			Mouse_Inst_Move = true;
			
		}

		

	}
	
}else{
	Mouse_Inst_Move = false;	
	Mouse_OffClickL = false;
}

if(Mouse_Inst_Move){
	
	Mouse_Inst.x = clamp(floor((mouse_x - Mouse_Inst_OffsetX) / 8) * 8, Mouse_Inst.MinX, Mouse_Inst.MaxX);
	Mouse_Inst.y = clamp(floor((mouse_y - Mouse_Inst_OffsetY) / 8) * 8, Mouse_Inst.MinY, Mouse_Inst.MaxY);
	
	//if inst that was moved is a corner wall, then also update the instances in the loop that are next to it(linked to it)
	if(Mouse_Inst.IsCornerWall){
		
		var WallLoopArray = global.WallLoop[Mouse_Inst.WallLoopLevel][Mouse_Inst.WallLoopID];
		
		//find positions for linked insts in the list
		LinkedInsts = GetWallLoopLinkedInsts(Mouse_Inst, WallLoopArray); //returns array: [0] = L, [1] = R	
		
		//depending on what type of corner Mouse_Inst is, adjust the linked ones accordingly
		switch(Mouse_Inst.ID){
			
			case TemplateObjID.Wall_Corner_TL: case TemplateObjID.Wall_Lower_Corner_TL:
			case TemplateObjID.Wall_Corner_BR: case TemplateObjID.Wall_Lower_Corner_BR:
			case TemplateObjID.Wall_InnerCorner_TR: case TemplateObjID.Wall_Lower_InnerCorner_TR:
			case TemplateObjID.Wall_InnerCorner_BL: case TemplateObjID.Wall_Lower_InnerCorner_BL:
				LinkedInsts[0].Inst.x = Mouse_Inst.x;
				LinkedInsts[1].Inst.y = Mouse_Inst.y;
				break;
				
			case TemplateObjID.Wall_Corner_TR: case TemplateObjID.Wall_Lower_Corner_TR:
			case TemplateObjID.Wall_Corner_BL: case TemplateObjID.Wall_Lower_Corner_BL:
			case TemplateObjID.Wall_InnerCorner_TL: case TemplateObjID.Wall_Lower_InnerCorner_TL:
			case TemplateObjID.Wall_InnerCorner_BR: case TemplateObjID.Wall_Lower_InnerCorner_BR:
				LinkedInsts[0].Inst.y = Mouse_Inst.y;
				LinkedInsts[1].Inst.x = Mouse_Inst.x;
				break;
			
		}
		
		//Template_UpdateWallLoopsInDataTemplates();

		
	}
	
	Mouse_Inst.MouseOver = true;
	
}

if(Mouse_RB_Pressed){
	
	if(MouseInst == noone && !Mouse_OffClickR) Mouse_OffClickR = true;
	
	if(MouseInst != noone && !Mouse_OffClickR){

		Mouse_Inst = MouseInst;

		if(Mouse_Inst.IsCornerWall && global.EditMode){
			
			var Level = Mouse_Inst.WallLoopLevel;
			var WallLoopArray = global.WallLoop[Level][Mouse_Inst.WallLoopID];
			for(var CornerWallInstPos = 0; CornerWallInstPos < array_length(WallLoopArray); CornerWallInstPos++){
				if(WallLoopArray[CornerWallInstPos].Inst == Mouse_Inst) break;
			}						
		
			switch(Mouse_Inst.ID){
				case TemplateObjID.Wall_Corner_TL: case TemplateObjID.Wall_Lower_Corner_TL:
					Mouse_Inst.y += CornerWallW;
					TemplateObj_CornerWall_Create(Mouse_Inst.ID, Mouse_Inst.x + CornerWallW, Mouse_Inst.y - CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
					TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_TL], Mouse_Inst.x + CornerWallW, Mouse_Inst.y, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R1
					break;
					
				case TemplateObjID.Wall_Corner_TR: case TemplateObjID.Wall_Lower_Corner_TR:
					Mouse_Inst.x -= CornerWallW;
					TemplateObj_CornerWall_Create(Mouse_Inst.ID, Mouse_Inst.x + CornerWallW, Mouse_Inst.y + CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
					TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_TR], Mouse_Inst.x, Mouse_Inst.y + CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R1
					break;

				case TemplateObjID.Wall_Corner_BL: case TemplateObjID.Wall_Lower_Corner_BL:
					Mouse_Inst.x += CornerWallW;
					TemplateObj_CornerWall_Create(Mouse_Inst.ID, Mouse_Inst.x - CornerWallW, Mouse_Inst.y - CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
					TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_BL], Mouse_Inst.x, Mouse_Inst.y - CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R1
					break;

				case TemplateObjID.Wall_Corner_BR: case TemplateObjID.Wall_Lower_Corner_BR:
					Mouse_Inst.y -= CornerWallW;
					TemplateObj_CornerWall_Create(Mouse_Inst.ID, Mouse_Inst.x - CornerWallW, Mouse_Inst.y + CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
					TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_BR], Mouse_Inst.x - CornerWallW, Mouse_Inst.y, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R1
					break;

				case TemplateObjID.Wall_InnerCorner_TL: case TemplateObjID.Wall_Lower_InnerCorner_TL:
					Mouse_Inst.x -= CornerWallW;
					TemplateObj_CornerWall_Create(Mouse_Inst.ID, Mouse_Inst.x + CornerWallW, Mouse_Inst.y - CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
					TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_TL], Mouse_Inst.x, Mouse_Inst.y - CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R1
					break;

				case TemplateObjID.Wall_InnerCorner_TR: case TemplateObjID.Wall_Lower_InnerCorner_TR:
					Mouse_Inst.y -= CornerWallW;
					TemplateObj_CornerWall_Create(Mouse_Inst.ID, Mouse_Inst.x + CornerWallW, Mouse_Inst.y + CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
					TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_TR], Mouse_Inst.x + CornerWallW, Mouse_Inst.y, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R1
					break;

				case TemplateObjID.Wall_InnerCorner_BR: case TemplateObjID.Wall_Lower_InnerCorner_BR:
					Mouse_Inst.x += CornerWallW;
					TemplateObj_CornerWall_Create(Mouse_Inst.ID, Mouse_Inst.x - CornerWallW, Mouse_Inst.y + CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
					TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_BR], Mouse_Inst.x, Mouse_Inst.y + CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R1
					break;

				case TemplateObjID.Wall_InnerCorner_BL: case TemplateObjID.Wall_Lower_InnerCorner_BL:
					Mouse_Inst.y += CornerWallW;
					TemplateObj_CornerWall_Create(Mouse_Inst.ID, Mouse_Inst.x - CornerWallW, Mouse_Inst.y - CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
					TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_BL], Mouse_Inst.x - CornerWallW, Mouse_Inst.y, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R1
					break;
					
			}
			
			
			//Template_UpdateWallLoopsInDataTemplates();
		
		}



	}
	
}else{	
	Mouse_OffClickR = false;
}

if(Mouse_MB_Pressed){
	
	if(MouseInst == noone && !Mouse_OffClickM) Mouse_OffClickM = true;
	
	if(MouseInst != noone && !Mouse_OffClickM){

		Mouse_Inst = MouseInst;
		
		if(Mouse_Inst.IsCornerWall && global.EditMode){
			
			var Level = Mouse_Inst.WallLoopLevel;
			var WallLoopArray = global.WallLoop[Mouse_Inst.WallLoopLevel][Mouse_Inst.WallLoopID];
			var ArraySize = array_length(WallLoopArray);
			for(var CornerWallInstPos = 0; CornerWallInstPos < ArraySize; CornerWallInstPos++){
				if(WallLoopArray[CornerWallInstPos].Inst == Mouse_Inst) break;
			}		
			var CornerWallNextInst = WallLoopArray[(CornerWallInstPos + 1) mod ArraySize].Inst;
			
			if(keyboard_check(vk_control)){
				
				switch(Mouse_Inst.ID){
					case TemplateObjID.Wall_Corner_TL: case TemplateObjID.Wall_Lower_Corner_TL:
					case TemplateObjID.Wall_InnerCorner_TR: case TemplateObjID.Wall_Lower_InnerCorner_TR:
						var MidPoint = floor(((CornerWallNextInst.x - Mouse_Inst.x + CornerWallW) / 2) / 8) * 8;
						var LeftSide = Mouse_Inst.x + MidPoint - CornerWallW;
						var RightSide = Mouse_Inst.x + MidPoint;
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_TR], RightSide, Mouse_Inst.y, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_TR], RightSide, Mouse_Inst.y - CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_TL], LeftSide, Mouse_Inst.y - CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_TL], LeftSide, Mouse_Inst.y, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2			
						break;
					
					case TemplateObjID.Wall_Corner_TR: case TemplateObjID.Wall_Lower_Corner_TR:
					case TemplateObjID.Wall_InnerCorner_BR: case TemplateObjID.Wall_Lower_InnerCorner_BR:
						var MidPoint = floor(((CornerWallNextInst.y - Mouse_Inst.y + CornerWallW) / 2) / 8) * 8;
						var TopSide = Mouse_Inst.y + MidPoint - CornerWallW;
						var BottomSide = Mouse_Inst.y + MidPoint;
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_BR], Mouse_Inst.x, BottomSide, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_BR], Mouse_Inst.x + CornerWallW, BottomSide, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_TR], Mouse_Inst.x + CornerWallW, TopSide, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_TR], Mouse_Inst.x, TopSide, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						break;

					case TemplateObjID.Wall_Corner_BR: case TemplateObjID.Wall_Lower_Corner_BR:
					case TemplateObjID.Wall_InnerCorner_BL: case TemplateObjID.Wall_Lower_InnerCorner_BL:
						var MidPoint = floor(((Mouse_Inst.x - CornerWallNextInst.x + CornerWallW) / 2) / 8) * 8;
						var LeftSide = CornerWallNextInst.x + MidPoint - CornerWallW;
						var RightSide = CornerWallNextInst.x + MidPoint;
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_BL], LeftSide, Mouse_Inst.y, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_BL], LeftSide, Mouse_Inst.y + CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_BR], RightSide, Mouse_Inst.y + CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_BR], RightSide, Mouse_Inst.y, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2			
						break;

					case TemplateObjID.Wall_Corner_BL: case TemplateObjID.Wall_Lower_Corner_BL:
					case TemplateObjID.Wall_InnerCorner_TL: case TemplateObjID.Wall_Lower_InnerCorner_TL:
						var MidPoint = floor(((Mouse_Inst.y - CornerWallNextInst.y + CornerWallW) / 2) / 8) * 8;
						var TopSide = CornerWallNextInst.y + MidPoint - CornerWallW;
						var BottomSide = CornerWallNextInst.y + MidPoint;
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_TL], Mouse_Inst.x, TopSide, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_TL], Mouse_Inst.x - CornerWallW, TopSide, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_BL], Mouse_Inst.x - CornerWallW, BottomSide, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_BL], Mouse_Inst.x, BottomSide, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						break;
					
				}				
				
			}else{
				switch(Mouse_Inst.ID){
					case TemplateObjID.Wall_Corner_TL: case TemplateObjID.Wall_Lower_Corner_TL:
					case TemplateObjID.Wall_InnerCorner_TR: case TemplateObjID.Wall_Lower_InnerCorner_TR:
						var MidPoint = floor(((CornerWallNextInst.x - Mouse_Inst.x + CornerWallW) / 2) / 8) * 8;
						var LeftSide = Mouse_Inst.x + MidPoint - CornerWallW;
						var RightSide = Mouse_Inst.x + MidPoint;
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_TL], RightSide, Mouse_Inst.y, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_TL], RightSide, Mouse_Inst.y + CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_TR], LeftSide, Mouse_Inst.y + CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_TR], LeftSide, Mouse_Inst.y, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2			
						break;
					
					case TemplateObjID.Wall_Corner_TR: case TemplateObjID.Wall_Lower_Corner_TR:
					case TemplateObjID.Wall_InnerCorner_BR: case TemplateObjID.Wall_Lower_InnerCorner_BR:
						var MidPoint = floor(((CornerWallNextInst.y - Mouse_Inst.y + CornerWallW) / 2) / 8) * 8;
						var TopSide = Mouse_Inst.y + MidPoint - CornerWallW;
						var BottomSide = Mouse_Inst.y + MidPoint;
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_TR], Mouse_Inst.x, BottomSide, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_TR], Mouse_Inst.x - CornerWallW, BottomSide, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_BR], Mouse_Inst.x - CornerWallW, TopSide, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_BR], Mouse_Inst.x, TopSide, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						break;

					case TemplateObjID.Wall_Corner_BR: case TemplateObjID.Wall_Lower_Corner_BR:
					case TemplateObjID.Wall_InnerCorner_BL: case TemplateObjID.Wall_Lower_InnerCorner_BL:
						var MidPoint = floor(((Mouse_Inst.x - CornerWallNextInst.x + CornerWallW) / 2) / 8) * 8;
						var LeftSide = CornerWallNextInst.x + MidPoint - CornerWallW;
						var RightSide = CornerWallNextInst.x + MidPoint;
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_BR], LeftSide, Mouse_Inst.y, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_BR], LeftSide, Mouse_Inst.y - CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_BL], RightSide, Mouse_Inst.y - CornerWallW, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_BL], RightSide, Mouse_Inst.y, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2			
						break;

					case TemplateObjID.Wall_Corner_BL: case TemplateObjID.Wall_Lower_Corner_BL:
					case TemplateObjID.Wall_InnerCorner_TL: case TemplateObjID.Wall_Lower_InnerCorner_TL:
						var MidPoint = floor(((Mouse_Inst.y - CornerWallNextInst.y + CornerWallW) / 2) / 8) * 8;
						var TopSide = CornerWallNextInst.y + MidPoint - CornerWallW;
						var BottomSide = CornerWallNextInst.y + MidPoint;
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_BL], Mouse_Inst.x, TopSide, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_BL], Mouse_Inst.x + CornerWallW, TopSide, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_InnerCorner_TL], Mouse_Inst.x + CornerWallW, BottomSide, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						TemplateObj_CornerWall_Create(global.TemplateObj_Level[Level][TemplateObjID.Wall_Corner_TL], Mouse_Inst.x, BottomSide, Mouse_Inst.WallLoopLevel, Mouse_Inst.WallLoopID, CornerWallInstPos + 1); //R2
						break;
					
				}
			}
			
			//Template_UpdateWallLoopsInDataTemplates();
			
		}


	}
	
}else{	
	Mouse_OffClickM = false;
}
