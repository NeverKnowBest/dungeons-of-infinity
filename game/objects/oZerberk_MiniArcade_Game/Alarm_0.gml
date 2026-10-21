/// @description Create alien

if(!GenerateAliens) exit

instance_create_depth(irandom_range(8, GameW - 8), -8, depth, choose(oZerberk_MiniArcade_Alien1, oZerberk_MiniArcade_Alien2, oZerberk_MiniArcade_Alien3, oZerberk_MiniArcade_Alien4))
var Difficulty = 25 - (Level * 5);
if(Difficulty < 5) Difficulty = 5;
alarm[0] = irandom_range(Difficulty, Difficulty + 25 - clamp(floor(Level / 2), 0, 5));