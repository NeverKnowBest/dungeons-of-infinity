enum BlockObj{
	None,
	Switch,
	Treasure,
	Crystal,
	Guru	
}

enum BlockGroupSize{
	_3x3,
	_4x4,
	_5x5	
}


function Block_Draw(_X, _Y, _Spike = false){
	
	var Layer = (global.SpawnedBlocks_TMID == global.TMID_Walls_Upper ? "Objs_Upper" : "Objs_Lower");
	if(_Spike)
		instance_create_layer(_X, _Y, Layer, oSpikeBlock);
	else
		DrawTileBlock(global.SpawnedBlocks_TMID, _X, _Y, 1, 0, 2, 2);
		
	var BlockInst = WallObj_Create(Layer, _X, _Y, 2, 2);
	BlockInst.BlockProjectiles = false;
	AddUsedSpace(_X, _Y, 16, 16, false, false);
	
}

function BlockPattern_DrawItem(_RoomIndex, _BlockObj, _TreasureItem = noone){
	
	
	var Pattern = global.BlockPatterns[global.SpawnedBlocks_PatternSize, global.SpawnedBlocks_PatternIndex];
	
	//check to see if the block pattern that was spawn can even spawn the BlockObj, if not return false
	if(!BlockPattern_HasObj(global.SpawnedBlocks_PatternSize, global.SpawnedBlocks_PatternIndex, _BlockObj)) return false;
	
	//get a random possible position within the pattern that can spawn the BlockObj
	BlockObjPosition = 0; BlockObjPosition = array_create(2, -1);
	BlockObjPosition = BlockPattern_PossibleObjPosition(Pattern, _BlockObj);
	
	if(BlockObjPosition[0] == -1) return false;
	
	var ObjChr = string_char_at(Pattern[BlockObjPosition[1]], BlockObjPosition[0] + 1);
	
	var BlockObjX = global.SpawnedBlocks_GroupX + (BlockObjPosition[0] * 16);
	var BlockObjY = global.SpawnedBlocks_GroupY + (BlockObjPosition[1] * 16);
	
	//clear any block that was created here
	ClearTileBlock(global.SpawnedBlocks_TMID, BlockObjX, BlockObjY, 2, 2);
	instance_destroy(instance_position(BlockObjX, BlockObjY, oWall));
	
	var FloorLevel = GetFloorLevelID(BlockObjX, BlockObjY)
	var FloorLevelStr = GetFloorLevelString(FloorLevel);
	
	//spawn BlockObj
	switch(_BlockObj){
		
		case BlockObj.Switch:
			global.Switch_Inst = instance_create_layer(BlockObjX, BlockObjY, "Objs_" + FloorLevelStr, oPushBlock, {Action : global.Switch_Action});
			AddUsedSpace(BlockObjX, BlockObjY, 16, 16, false, false);
			global.Switch_Add = false;
			break;
			
		case BlockObj.Treasure:
		
			var TreasureInst = Treasure_Create(BlockObjX, BlockObjY, _TreasureItem, true);
			
			if(TreasureInst != noone){
				
				if(ObjChr == "T" && Prob(0.5)){
					//sometimes make the hidden treasure a block in disguise, though only if the chr from the pattern was a "T", a "t" would have to stay invisible
					TreasureInst.sprite_index = sItem_TreasureBlock;	
					TreasureInst.visible = true;
					TreasureInst.WallInst.BlockLink = true;
				}
				
				AddUsedSpace(BlockObjX, BlockObjY, 16, 16, false, false);	
				
			}else return false;
			
			break;
			
		case BlockObj.Crystal:
			Crystal_Create(_RoomIndex, BlockObjX, BlockObjY);
			AddUsedSpace(BlockObjX, BlockObjY, 16, 16, false, false);		
			break;
			
		case BlockObj.Guru:
			var VarStruct = {FloorLevel : FloorLevel, ItemHolding : noone, RoomTemplate: Room.TemplateIndex, SectionID: Room.Section_ID, RoomX : Room.x, RoomY : Room.y};
			instance_create_layer(BlockObjX, BlockObjY, "Objs_" + FloorLevelStr, oEnemy_Guru_Bar, VarStruct);	
			break;
		
	}
	return true;


}

function BlockPattern_HasObj(_Size, _Index, _BlockObj){
	
	//returns true if the pattern can provide a specific obj.
	//Otherwise returns -1
	
	var Pattern = global.BlockPatterns[_Size, _Index];
	var PatternH = array_length(Pattern);
	
	for(var i = 0; i < PatternH; i++){
		
		var PatternLine = Pattern[i];
		
		switch(_BlockObj){
			case BlockObj.Switch:
				if(string_pos("S", PatternLine) > 0) return true;
				break;
			
			case BlockObj.Treasure:
				if(string_pos("T", PatternLine) > 0) return true;
				if(string_pos("t", PatternLine) > 0) return true;
				if(string_pos("c", PatternLine) > 0) return true;
				break;
			
			case BlockObj.Crystal:
				if(string_pos("C", PatternLine) > 0) return true;
				if(string_pos("c", PatternLine) > 0) return true;
				if(string_pos("g", PatternLine) > 0) return true;
				if(string_pos("T", PatternLine) > 0) return true;
				if(string_pos("t", PatternLine) > 0) return true;
				break;
			
			case BlockObj.Guru:
				if(string_pos("G", PatternLine) > 0) return true;
				if(string_pos("g", PatternLine) > 0) return true;
				break;
			
		}
		
		
	}
	
	return false;
	
}

function BlockPattern_ChrIsObj(_Chr, _BlockObj){
	
	switch(_BlockObj){
		case BlockObj.Switch:
			if(_Chr == "S") return true;
			break;
			
		case BlockObj.Treasure:
			if(_Chr == "T") return true;
			if(_Chr == "t") return true;
			if(_Chr == "c") return true;
			break;
			
		case BlockObj.Crystal:
			if(_Chr == "C") return true;
			if(_Chr == "c") return true;
			if(_Chr == "g") return true;
			if(_Chr == "T") return true;
			if(_Chr == "t") return true;
			break;
			
		case BlockObj.Guru:
			if(_Chr == "G") return true;
			if(_Chr == "g") return true;
			break;
	}
	
	return false;
	
}



function BlockPattern_PossibleObjPosition(_Pattern, _BlockObj){
	
	//returns a [x,y] array indicating a random position in the pattern that can allow the block obj.
	//If it can't find a valid position, the array will have -1 in both elements
	
	var BlockObjPositionsGrid = ds_grid_create(2, 0);
	
	var PatternW = string_length(_Pattern[0]);
	var PatternH = array_length(_Pattern);
	
	var GridY = 0;
	
	for(var _y = 0; _y < PatternH; _y++){
		for(var _x = 0; _x < PatternW; _x++){
			var _Chr = string_char_at(_Pattern[_y], _x + 1);
			if(BlockPattern_ChrIsObj(_Chr, _BlockObj)){
				ds_grid_resize(BlockObjPositionsGrid, 2, GridY + 1)
				ds_grid_add(BlockObjPositionsGrid, 0, GridY, _x)
				ds_grid_add(BlockObjPositionsGrid, 1, GridY, _y);
				GridY++;
			}
		}
	}
	
	if(GridY > 0){
		var RandomPos = irandom(GridY - 1);
		ValidPosition[0] = BlockObjPositionsGrid[# 0, RandomPos];
		ValidPosition[1] = BlockObjPositionsGrid[# 1, RandomPos];		
	}else{
		ValidPosition[0] = -1;
		ValidPosition[1] = -1;
	}
	
	ds_grid_destroy(BlockObjPositionsGrid);
	
	return ValidPosition

}


function BlockPatterns_Init(){
	
	global.BlockPatternSizeID[3][3] = BlockGroupSize._3x3;
	global.BlockPatternSizeID[4][4] = BlockGroupSize._4x4;
	global.BlockPatternSizeID[5][5] = BlockGroupSize._5x5;

//. = blank space
//0 = blocks
//S = Switch
//T = Treasure, but replace with block if no treasure added
//t = Treasure or crystal, but replace with space if no item added
//C = crystal
//G = Guru bar
//g = Guru bar or crystal
//Treasures can also be spots for crystals

	var i = 0;
	
#region 3x3

	global.BlockPatterns[BlockGroupSize._3x3, i++] = [
									".S.",
									"0g0",
									".T."];

									
	global.BlockPatterns[BlockGroupSize._3x3, i++] = [
									"S.0",
									".g.",
									"T.T"];
									

#endregion


#region 4x4
	
	i = 0;
	
	global.BlockPatterns[BlockGroupSize._4x4, i++] = [
									"....",
									".00.",
									".TT.",
									"...."];
	
	global.BlockPatterns[BlockGroupSize._4x4, i++] = [
									".00.",
									".G0.",
									".0G.",
									".TT."];
	
	global.BlockPatterns[BlockGroupSize._4x4, i++] = [
									"....",
									"0G00",
									"T0G0",
									"...."];
	
	global.BlockPatterns[BlockGroupSize._4x4, i++] = [
									"T00T",
									".G0.",
									".0G.",
									"S00T"];
	
	global.BlockPatterns[BlockGroupSize._4x4, i++] = [
									"G..S",
									"0G00",
									"00G0",
									"T..T"];
	
	global.BlockPatterns[BlockGroupSize._4x4, i++] = [
									"T..G",
									"....",
									"....",
									"G..S"];
	
	global.BlockPatterns[BlockGroupSize._4x4, i++] = [
									"G..G",
									".00.",
									".00.",
									"S..T"];
	
	global.BlockPatterns[BlockGroupSize._4x4, i++] = [
									".00.",
									"0GG0",
									"0GG0",
									"tTTt"];
	
	global.BlockPatterns[BlockGroupSize._4x4, i++] = [
									"0000",
									"0G00",
									"00G0",
									"T00T"];
	
	global.BlockPatterns[BlockGroupSize._4x4, i++] = [
									"TG0T",
									"....",
									"....",
									"S0GT"];
	
	global.BlockPatterns[BlockGroupSize._4x4, i++] = [
									"0..0",
									"G..G",
									"0..0",
									"T..S"];

	//global.BlockPatterns[BlockGroupSize._4x4, i++] = [
	//								"....",
	//								"....",
	//								"....",
	//								"...."];


#endregion


#region 5x5
	
	i = 0;
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									".....",
									".000.",
									".0G0.",
									".TCT.",
									"....."];
	
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									".....",
									"..S..",
									".0g0.",
									"..T..",
									"....."];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									"..S..",
									"..0..",
									"..g..",
									"..0..",
									"..T.."];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									".....",
									".....",
									"T0g0S",
									"..t..",
									"....."];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									"T0g0T",
									"..t..",
									".....",
									".....",
									"S0g0T"];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									"0...S",
									"0...0",
									"g.t.g",
									"0...0",
									"T...T"];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									".000.",
									".0G0.",
									".000.",
									".0G0.",
									".0T0."];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									".....",
									"00000",
									"0G0G0",
									"00T00",
									"....."];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									"000..",
									"0G0..",
									"00000",
									".t0G0",
									"..0T0"];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									"..000",
									"..0G0",
									"00000",
									"0G0t.",
									"0T0.."];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									"S...T",
									".....",
									"..t..",
									".....",
									"T...T"];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									".....",
									"S...0",
									"G.t.G",
									"T...T",
									"....."];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									".TgT.",
									".....",
									"..t..",
									".....",
									".S0T."];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									"S...0",
									".0.0.",
									"..g..",
									".0t0.",
									"T...T"];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									"..0..",
									"..S..",
									".0g0.",
									"..0..",
									"..T.."];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									".....",
									"..S..",
									"T0g0T",
									"..T..",
									"....."];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									".....",
									"0...S",
									"00g00",
									"T.t.T",
									"....."];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									".T0T.",
									"..0..",
									"..g..",
									"..S..",
									".TTT."];
	
	//global.BlockPatterns[BlockGroupSize._5x5, i++] = [
	//								".....",
	//								".....",
	//								".....",
	//								".....",
	//								"....."];
	
#endregion


}