draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, c_white, 0.8);

//Draw grid
draw_set_alpha(0.35);
draw_set_color(c_grey);
//vertical lines
var y_end = y + (global.Template_GridH * 256);
var Lines = 32 * global.Template_GridW;
for(var _x = 0; _x < Lines; _x++){
	var xpos = x + (_x * 8);
	draw_line(xpos, y, xpos, y_end);
}
//horizontal lines
var x_end = x + (global.Template_GridW * 256);
var Lines = 32 * global.Template_GridH;
for(var _y = 0; _y < Lines; _y++){
	var ypos = y + (_y * 8);
	draw_line(x, ypos, x_end, ypos);
}
draw_set_alpha(1);
draw_set_color(c_white);

for(var i = 1; i <= 24; i++){
	global.DoorStatus[i] = false;	
}


if(global.EditMode){ //if in edit mode, draw the walls from WallLoop
	
	//Draw side walls for each wall loop
	for(var WallLoopLevel = 0; WallLoopLevel < 2; WallLoopLevel++){
		for(var WallLoopID = 0; WallLoopID < 2; WallLoopID++){
		
			//go through each list item
		
			var Array = global.WallLoop[WallLoopLevel][WallLoopID];
			var ArraySize = array_length(Array);
		
			for(var WallLoopIndex = 0; WallLoopIndex < ArraySize; WallLoopIndex++){
			
				var Inst = Array[WallLoopIndex].Inst;
				//find positions for linked insts in the list
				LinkedInsts = GetWallLoopLinkedInsts(Inst, Array); //returns array: [0] = L, [1] = R	
				var InstR = LinkedInsts[1].Inst; //we only need to always check the R inst in the list
			
				with(Inst){
					switch(ID){
						case TemplateObjID.Wall_Corner_TL:
						case TemplateObjID.Wall_InnerCorner_TR:
						case TemplateObjID.Wall_Lower_Corner_TL:
						case TemplateObjID.Wall_Lower_InnerCorner_TR:
							//Horizontal wall
							var WallStartX = x + W;
							var WallW = InstR.x - WallStartX;
							var WallEndX = WallStartX + WallW;
							var WallSegments = WallW / 8;
				
							for(var i = 0; i < WallSegments; i++){
								draw_sprite(WallLoopLevel == UPPER ? sWall_Side_T : sWall_Lower_Side_T, 0, WallStartX + (i * 8), y);
							}

							//doors
							Template_DoorStatus(WallLoopLevel, 11, WallStartX, WallEndX, y);
							Template_DoorStatus(WallLoopLevel, 12, WallStartX, WallEndX, y);
							Template_DoorStatus(WallLoopLevel, 1,  WallStartX, WallEndX, y);
						
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
							for(var i = 0; i < WallSegments; i++){
								draw_sprite(WallLoopLevel == UPPER ? sWall_Side_R : sWall_Lower_Side_R, 0, x, WallStartY + (i * 8));
							}
							//doors
							Template_DoorStatus(WallLoopLevel, 2, WallStartY, WallEndY, x);
							Template_DoorStatus(WallLoopLevel, 3, WallStartY, WallEndY, x);
							Template_DoorStatus(WallLoopLevel, 4,  WallStartY, WallEndY, x);
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

							for(var i = 0; i < WallSegments; i++){
								draw_sprite(WallLoopLevel == UPPER ? sWall_Side_B : sWall_Lower_Side_B, 0, WallStartX + (i * 8), y);
							}
							//doors
							Template_DoorStatus(WallLoopLevel, 5, WallStartX, WallEndX, y);
							Template_DoorStatus(WallLoopLevel, 6, WallStartX, WallEndX, y);
							Template_DoorStatus(WallLoopLevel, 7,  WallStartX, WallEndX, y);
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
				
							for(var i = 0; i < WallSegments; i++){
								draw_sprite(WallLoopLevel == UPPER ? sWall_Side_L : sWall_Lower_Side_L, 0, x, WallStartY + (i * 8));
							}
							//doors
							Template_DoorStatus(WallLoopLevel, 8, WallStartY, WallEndY, x);
							Template_DoorStatus(WallLoopLevel, 9, WallStartY, WallEndY, x);
							Template_DoorStatus(WallLoopLevel, 10,  WallStartY, WallEndY, x);
							break;

						
					}	
				}
			
			}
		
		}
	}

	for(var i = 1; i <= 24; i++){
		if(global.DoorStatus[i]) Door_Draw(i);	
	}
	
}else{
	//not in edit mode, draw walls from Data_Templates	
	
}



//if(Mouse_Inst_Move){
//	draw_text(5,20,string(Mouse_Inst.x - oTemplate.x) + "," + string(Mouse_Inst.y - oTemplate.y));	
//}
