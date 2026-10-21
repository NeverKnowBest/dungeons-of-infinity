//function GetDoorPosition(_RoomSizeIndex, _x, _y){
	
//	//Returns door position based on x/y of door
//	//door coordinates x/y should be template coordinate values(not accounting room position)
	
//	for(var DoorPosIndex = 1; DoorPosIndex <= 24; DoorPosIndex++){
//		var DoorPosX = global.DoorCoordinates[_RoomSizeIndex][DoorPosIndex].x;
//		var DoorPosY = global.DoorCoordinates[_RoomSizeIndex][DoorPosIndex].y;
//		if(_x == DoorPosX && _y == DoorPosY) return DoorPosIndex;
		
//	}
	
//	return -1;
	
//}

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

function GetConnectedDoorPos(ARGridX, ARGridY, ARSize, CRGridX, CRGridY, CRSize, ARDoorPos){
	
	//AR = Active Room
	//CR = Connected Room
	
	var A = (ARDoorPos > 12 ? 12 : 0); //A stands for 'Add 12'
	
	switch(ARSize){
		case RoomSize._1x1:
			
			switch(CRSize){
				case RoomSize._1x1:
						
					switch(ARDoorPos){
						case 1: case 13: return 5 + A;
						case 2: case 14: return 10 + A;
						case 3: case 15: return 9 + A;
						case 4: case 16: return 8 + A;
						case 5: case 17: return 1 + A;
						case 6: case 18: return 12 + A;
						case 7: case 19: return 11 + A;
						case 8: case 20: return 4 + A;
						case 9: case 21: return 3 + A;
						case 10: case 22: return 2 + A;
						case 11: case 23: return 7 + A;
						case 12: case 24: return 6 + A;
						default: return -1;
								
					}
					break;
						
				case RoomSize._1x2:
				
					switch(ARDoorPos){
						case 1: case 13: return 5 + A;
						case 3: case 15: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 5: case 17: return 1 + A;;
						case 6: case 18: return 12 + A;
						case 7: case 19: return 11 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 11: case 23: return 7 + A;
						case 12: case 24: return 6 + A;
						default: return -1;
								
					}
					break;
					
				case RoomSize._2x1:

					switch(ARDoorPos){
						case 2: case 14: return 10 + A;
						case 3: case 15: return 9 + A;
						case 4: case 16: return 8 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 8: case 20: return 4 + A;
						case 9: case 21: return 3 + A;
						case 10: case 22: return 2 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						default: return -1;
								
					}
					break;
						
				case RoomSize._2x2:
				
					switch(ARDoorPos){
						case 3: case 15: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						default: return -1;
								
					}
					break;
			}
				
			break;
		
		case RoomSize._1x2:

			switch(CRSize){
				case RoomSize._1x1:
						
					switch(ARDoorPos){
						case 1: case 13: return 5 + A;
						case 2: case 14: return 9 + A;
						case 4: case 16: return 9 + A;
						case 5: case 17: return 1 + A;
						case 6: case 18: return 12 + A;
						case 7: case 19: return 11 + A;
						case 8: case 20: return 3 + A;
						case 10: case 22: return 3 + A;
						case 11: case 23: return 7 + A;
						case 12: case 24: return 6 + A;
						default: return -1;
								
					}
					break;
						
				case RoomSize._1x2:
				
					switch(ARDoorPos){
						case 1: case 13: return 5 + A;
						case 2: case 14: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 3: case 15: if(ARGridY == CRGridY) return 9 + A; else return -1;
						case 4: case 16: if(ARGridY == CRGridY) return 8 + A; else return 10 + A;
						case 5: case 17: return 1 + A;;
						case 6: case 18: return 12 + A;
						case 7: case 19: return 11 + A;
						case 8: case 20: if(ARGridY == CRGridY) return 4 + A; else return 2 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 3 + A; else return -1;
						case 10: case 22: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 11: case 23: return 7 + A;
						case 12: case 24: return 6 + A;
						default: return -1;
								
					}
					break;
					
				case RoomSize._2x1:

					switch(ARDoorPos){
						case 2: case 14: return 9 + A;
						case 4: case 16: return 9 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 8: case 20: return 3 + A;
						case 10: case 22: return 3 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						default: return -1;
								
					}
					break;
						
				case RoomSize._2x2:
				
					switch(ARDoorPos){
						case 2: case 14: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 3: case 15: if(ARGridY == CRGridY) return 9 + A; else return -1;
						case 4: case 16: if(ARGridY == CRGridY) return 8 + A; else return 10 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 8: case 20: if(ARGridY == CRGridY) return 4 + A; else return 2 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 3 + A; else return -1;
						case 10: case 22: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						default: return -1;
								
					}
					break;
			}
			
			break;
			
			
		case RoomSize._2x1:

			switch(CRSize){
				case RoomSize._1x1:
						
					switch(ARDoorPos){
						case 1: case 13: return 6 + A;
						case 2: case 14: return 10 + A;
						case 3: case 15: return 9 + A;
						case 4: case 16: return 8 + A;
						case 5: case 17: return 12 + A;
						case 7: case 19: return 12 + A;
						case 8: case 20: return 4 + A;
						case 9: case 21: return 3 + A;
						case 10: case 22: return 2 + A;
						case 11: case 23: return 6 + A;
						default: return -1;
								
					}
					break;
						
				case RoomSize._1x2:
				
					switch(ARDoorPos){
						case 1: case 13: return 6 + A;
						case 3: case 15: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 5: case 17: return 12 + A;;
						case 7: case 19: return 12 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 11: case 23: return 6 + A;
						default: return -1;
								
					}
					break;
					
				case RoomSize._2x1:

					switch(ARDoorPos){
						case 1: case 13: if(ARGridX == CRGridX) return 5 + A; else return 7 + A;
						case 2: case 14: return 10 + A;
						case 3: case 15: return 9 + A;
						case 4: case 16: return 8 + A;
						case 5: case 17: if(ARGridX == CRGridX) return 1 + A; else return 11 + A;
						case 6: case 18: return 12 + A;
						case 7: case 19: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 8: case 20: return 4 + A;
						case 9: case 21: return 3 + A;
						case 10: case 22: return 2 + A;
						case 11: case 23: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						case 12: case 24: return 6 + A;
						default: return -1;
								
					}
					break;
						
				case RoomSize._2x2:
				
					switch(ARDoorPos){
						case 1: case 13: if(ARGridX == CRGridX) return 5 + A; else return 7 + A;
						case 3: case 15: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 5: case 17: if(ARGridX == CRGridX) return 1 + A; else return 11 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 12 + A; else return -1;
						case 7: case 19: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 11: case 23: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 6 + A; else return -1;
						default: return -1;
								
					}
					break;
			}
			
			break;
			
		case RoomSize._2x2:

			switch(CRSize){
				case RoomSize._1x1:
						
					switch(ARDoorPos){
						case 1: case 13: return 6 + A;
						case 2: case 14: return 9 + A;
						case 4: case 16: return 9 + A;
						case 5: case 17: return 12 + A;
						case 7: case 19: return 12 + A;
						case 8: case 20: return 3 + A;
						case 10: case 22: return 3 + A;
						case 11: case 23: return 6 + A;
						default: return -1;
								
					}
					break;
						
				case RoomSize._1x2:
				
					switch(ARDoorPos){
						case 1: case 13: return 6 + A;
						case 2: case 14: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 3: case 15:  if(ARGridY == CRGridY) return 9 + A; else return -1;
						case 4: case 16: if(ARGridY == CRGridY) return 8 + A; else return 10 + A;
						case 5: case 17: return 12 + A;
						case 7: case 19: return 12 + A;
						case 8: case 20: if(ARGridY == CRGridY) return 4 + A; else return 2 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 3 + A; else return -1;
						case 10: case 22: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 11: case 23: return 6 + A;
						default: return -1;
								
					}
					break;
					
				case RoomSize._2x1:

					switch(ARDoorPos){
						case 1: case 13: if(ARGridX == CRGridX) return 5 + A; else return 7 + A;
						case 2: case 14: return 9 + A;
						case 4: case 16: return 9 + A;
						case 5: case 17: if(ARGridX == CRGridX) return 1 + A; else return 11 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 12 + A; else return -1;
						case 7: case 19: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 8: case 20: return 3 + A;
						case 10: case 22: return 3 + A;
						case 11: case 23: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 6 + A; else return -1;
						default: return -1;
								
					}
					break;
						
				case RoomSize._2x2:
				
					switch(ARDoorPos){
						case 1: case 13: if(ARGridX == CRGridX) return 5 + A; else return 7 + A;
						case 2: case 14: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 3: case 15: if(ARGridY == CRGridY) return 9 + A; else return -1;
						case 4: case 16: if(ARGridY == CRGridY) return 8 + A; else return 10 + A;
						case 5: case 17: if(ARGridX == CRGridX) return 1 + A; else return 11 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 12 + A; else return -1;
						case 7: case 19: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 8: case 20: if(ARGridY == CRGridY) return 4 + A; else return 2 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 3 + A; else return -1;
						case 10: case 22: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 11: case 23: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 6 + A; else return -1;
						default: return -1;
								
					}
					break;
			}
			
			break;
			
	}
		
	
}