enum BlockGroupSize{
	_3x3,
	_4x4,
	_5x5	
}

function BlockPatterns_Init(){
	
	global.BlockPatternSizeID[3][3] = BlockGroupSize._3x3;
	global.BlockPatternSizeID[4][4] = BlockGroupSize._4x4;
	global.BlockPatternSizeID[5][5] = BlockGroupSize._5x5;

//. = blank space
//0 = blocks
//T = Treasure, but replace with block if no treasure added
//t = Treasure, but replace with space if no treasure added
//C = crystal
//c = Crystal or Treasure
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
									"000",
									"0G0",
									"000"];
									
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
									".00."];
	
	global.BlockPatterns[BlockGroupSize._4x4, i++] = [
									"....",
									"0G00",
									"00G0",
									"...."];
	
	global.BlockPatterns[BlockGroupSize._4x4, i++] = [
									"0000",
									".G0.",
									".0G.",
									"S000"];
	
	global.BlockPatterns[BlockGroupSize._4x4, i++] = [
									"G..S",
									"0G00",
									"00G0",
									"T..T"];
	
	global.BlockPatterns[BlockGroupSize._4x4, i++] = [
									"G..G",
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
									".00."];
	
	global.BlockPatterns[BlockGroupSize._4x4, i++] = [
									"0000",
									"0G00",
									"00G0",
									"0000"];
	
	global.BlockPatterns[BlockGroupSize._4x4, i++] = [
									"0G00",
									"....",
									"....",
									"S0G0"];
	
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
									".0C0.",
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
									"00g0S",
									"..t..",
									"....."];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									"00g00",
									"..t..",
									".....",
									".....",
									"S0g00"];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									"0...S",
									"0...0",
									"g.c.g",
									"0...0",
									"T...T"];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									".000.",
									".0G0.",
									".000.",
									".0G0.",
									".000."];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									".....",
									"00000",
									"0G0G0",
									"00000",
									"....."];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									"000..",
									"0G0c.",
									"00000",
									".t0G0",
									"..000"];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									"..000",
									".c0G0",
									"00000",
									"0G0t.",
									"000.."];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									"S...T",
									".....",
									"..c..",
									".....",
									"T...T"];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									".....",
									"S...0",
									"G.c.G",
									"T...T",
									"....."];
	
	global.BlockPatterns[BlockGroupSize._5x5, i++] = [
									".0g0.",
									".....",
									"..c..",
									".....",
									".S00."];
	
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
									".000.",
									"..0..",
									"..g..",
									"..S..",
									".000."];
	
	//global.BlockPatterns[BlockGroupSize._5x5, i++] = [
	//								".....",
	//								".....",
	//								".....",
	//								".....",
	//								"....."];
	
#endregion


}