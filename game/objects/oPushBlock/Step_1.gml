if(Moved) exit;



if(MoveX != 0 && Move_Start && !Moved){
	x += MoveX;
	Move_Dist += abs(MoveX);
	if(Move_Dist >= 16){
		x += (-sign(MoveX) * (Move_Dist - 16)); //subtract any remainder
		Moved = true;
	}
}

if(MoveY != 0 && Move_Start && !Moved){
	y += MoveY
	Move_Dist += abs(MoveY);
	if(Move_Dist >= 16){
		y += (-sign(MoveY) * (Move_Dist - 16)); //subtract any remainder
		
		Moved = true;
	}
}

if(Moved){
	
	Switch_Activate(Action, HiddenObjInst);
	
	//DrawTileBlock(TMID, x, y, 1, 0, 2, 2);
	
	//WallObj_Create(TMID, x, y, 2, 2);
	
	//instance_destroy(id);
	
}
