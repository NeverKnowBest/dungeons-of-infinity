
if(State == ArcadeState.UnUsed) exit;


surface_set_target(GameSurface);
	
draw_set_color(#101025);
draw_rectangle(0, 0, CamW, CamH, false);

//var _Hx = floor(Hero.x);
//var _Hy = floor(Hero.y);

var _Spr;
for(var _WallX = 0; _WallX < 12; _WallX++){
	
	if(WallStatusX[_WallX] == 0) continue;
	
	var _CornerIndexX = _WallX mod 3;
	var _CornerIndexY = _WallX div 3;
	
	switch(WallStatusX[_WallX]){
		case 1: //normal walls
			_Spr = sZerberk_Level_Wall;
			break;
		case 2: //door
			_Spr = sZerberk_Level_DoorH;
			break;

	}
	
	if(State == ArcadeState.AttractScreen) _Spr = sZerberk_Level_Wall;
	
	draw_sprite_stretched(_Spr, 0, LevelCornersX[_CornerIndexX], LevelCornersY[_CornerIndexY], WallWidth[_CornerIndexX], 4);

}

for(var _WallY = 0; _WallY < 12; _WallY++){
	
	if(WallStatusY[_WallY] == 0) continue;
	
	var _CornerIndexX = _WallY mod 4;
	var _CornerIndexY = _WallY div 4;

	switch(WallStatusY[_WallY]){
		case 1: //normal walls
			_Spr = sZerberk_Level_Wall;
			break;
		case 2: //door
			_Spr = sZerberk_Level_DoorV;
			break;

	}
	
	if(State == ArcadeState.AttractScreen) _Spr = sZerberk_Level_Wall;
	
	draw_sprite_stretched(_Spr, 0, LevelCornersX[_CornerIndexX], LevelCornersY[_CornerIndexY], 4, WallHeight[_CornerIndexY]);

}

//redraw corners since doors can overlap
for(var _WallX = 0; _WallX < 12; _WallX++){
	
	if(WallStatusX[_WallX] == 0) continue;
	
	var _CornerIndexX = _WallX mod 3;
	var _CornerIndexY = _WallX div 3;
	
	draw_sprite(sZerberk_Level_Wall, 0, LevelCornersX[_CornerIndexX], LevelCornersY[_CornerIndexY]);
	
}

for(var _WallY = 0; _WallY < 12; _WallY++){
	
	if(WallStatusY[_WallY] == 0) continue;
	
	var _CornerIndexX = _WallY mod 4;
	var _CornerIndexY = _WallY div 4;

	draw_sprite(sZerberk_Level_Wall, 0, LevelCornersX[_CornerIndexX], LevelCornersY[_CornerIndexY]);
	
}

	
surface_reset_target();

