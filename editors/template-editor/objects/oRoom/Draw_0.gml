draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, c_white, 0.8);

//Draw grid
draw_set_alpha(0.35);
draw_set_color(c_grey);
//vertical lines
var y_end = y + (GridH * 256);
var Lines = 32 * GridW;
for(var _x = 0; _x < Lines; _x++){
	var xpos = x + (_x * 8);
	draw_line(xpos, y, xpos, y_end);
}
//horizontal lines
var x_end = x + (GridW * 256);
var Lines = 32 * GridH;
for(var _y = 0; _y < Lines; _y++){
	var ypos = y + (_y * 8);
	draw_line(x, ypos, x_end, ypos);
}
draw_set_alpha(1);
draw_set_color(c_white);


//Draw side walls for each wall loop
for(var WallLoopLevel = 0; WallLoopLevel < 2; WallLoopLevel++){
	for(var WallLoopID = 0; WallLoopID < 2; WallLoopID++){
		
		//go through each list item
		
		var List = WallLoopList[WallLoopLevel][WallLoopID];
		var ListSize = ds_list_size(List);
		
		for(var WallLoopListIndex = 0; WallLoopListIndex < ListSize; WallLoopListIndex++){
			
			var Inst = List[| WallLoopListIndex];
			//find positions for linked insts in the list
			LinkedInsts = GetWallLoopLinkedInsts(Inst, List); //returns array: [0] = L, [1] = R	
			var InstR = LinkedInsts[1]; //we only need to always check the R inst in the list
			
			with(Inst){
				switch(Type){
					case RoomObj.Wall_Corner_TL:
					case RoomObj.Wall_InnerCorner_TR:
					case RoomObj.Wall_Lower_Corner_TL:
					case RoomObj.Wall_Lower_InnerCorner_TR:
						//Horizontal wall
						var WallStartX = x + W;
						var WallW = InstR.x - WallStartX;
						var WallEndX = WallStartX + WallW;
						var WallSegments = WallW / 8;
				
						for(var i = 0; i < WallSegments; i++){
							draw_sprite(WallLoopLevel == UPPER ? sWall_Side_T : sWall_Lower_Side_T, 0, WallStartX + (i * 8), y);
						}

						//doors
						Room_DrawDoor(WallLoopLevel, 11, WallStartX, WallEndX, y);
						Room_DrawDoor(WallLoopLevel, 12, WallStartX, WallEndX, y);
						Room_DrawDoor(WallLoopLevel, 1,  WallStartX, WallEndX, y);
						
						break;

					case RoomObj.Wall_Corner_TR:
					case RoomObj.Wall_InnerCorner_BR:
					case RoomObj.Wall_Lower_Corner_TR:
					case RoomObj.Wall_Lower_InnerCorner_BR:				
						//Vertical wall
						var WallStartY = y + H;
						var WallH = InstR.y - WallStartY;
						var WallEndY = WallStartY + WallH;
						var WallSegments = WallH / 8;
						for(var i = 0; i < WallSegments; i++){
							draw_sprite(WallLoopLevel == UPPER ? sWall_Side_R : sWall_Lower_Side_R, 0, x, WallStartY + (i * 8));
						}
						//doors
						Room_DrawDoor(WallLoopLevel, 2, WallStartY, WallEndY, x);
						Room_DrawDoor(WallLoopLevel, 3, WallStartY, WallEndY, x);
						Room_DrawDoor(WallLoopLevel, 4,  WallStartY, WallEndY, x);
						break;
			
					case RoomObj.Wall_Corner_BR:
					case RoomObj.Wall_InnerCorner_BL:
					case RoomObj.Wall_Lower_Corner_BR:
					case RoomObj.Wall_Lower_InnerCorner_BL:
						//Horizontal wall
						var WallStartX = InstR.x + W;
						var WallW = x - WallStartX;
						var WallEndX = WallStartX + WallW;
						var WallSegments = WallW / 8;

						for(var i = 0; i < WallSegments; i++){
							draw_sprite(WallLoopLevel == UPPER ? sWall_Side_B : sWall_Lower_Side_B, 0, WallStartX + (i * 8), y);
						}
						//doors
						Room_DrawDoor(WallLoopLevel, 5, WallStartX, WallEndX, y);
						Room_DrawDoor(WallLoopLevel, 6, WallStartX, WallEndX, y);
						Room_DrawDoor(WallLoopLevel, 7,  WallStartX, WallEndX, y);
						break;

					case RoomObj.Wall_Corner_BL:
					case RoomObj.Wall_InnerCorner_TL:
					case RoomObj.Wall_Lower_Corner_BL:
					case RoomObj.Wall_Lower_InnerCorner_TL:
					
						//Vertical wall
						var WallStartY = InstR.y + H;
						var WallH = y - WallStartY;
						var WallEndY = WallStartY + WallH;
						var WallSegments = WallH / 8;
				
						for(var i = 0; i < WallSegments; i++){
							draw_sprite(WallLoopLevel == UPPER ? sWall_Side_L : sWall_Lower_Side_L, 0, x, WallStartY + (i * 8));
						}
						//doors
						Room_DrawDoor(WallLoopLevel, 8, WallStartY, WallEndY, x);
						Room_DrawDoor(WallLoopLevel, 9, WallStartY, WallEndY, x);
						Room_DrawDoor(WallLoopLevel, 10,  WallStartY, WallEndY, x);
						break;
						break;
						
				}	
			}
			
		}
		
	}
}
	




if(Mouse_Inst_Move){
	draw_text(5,20,string(Mouse_Inst.x - oRoom.x) + "," + string(Mouse_Inst.y - oRoom.y));	
}
