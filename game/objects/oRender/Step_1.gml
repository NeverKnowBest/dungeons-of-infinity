

if(global.ArcadeVP_Show){
	if(!surface_exists(global.ArcadeVP_Surface)) Arcade_SetVP();	
}

/// Cheat Watermark Movement
// Handle X
if (CheatWatermarkX + CheatWatermarkHsp >= ScreenBoundaryRight) {
	CheatWatermarkX = ScreenBoundaryRight;
	CheatWatermarkHsp *= -1;
} else if (CheatWatermarkX + CheatWatermarkHsp <= ScreenBoundaryLeft) {
	CheatWatermarkX = ScreenBoundaryLeft;
	CheatWatermarkHsp *= -1;
}

// Handle Y
if (CheatWatermarkY + CheatWatermarkVsp >= ScreenBoundaryBottom) {
	CheatWatermarkY = ScreenBoundaryBottom;
	CheatWatermarkVsp *= -1;
} else if (CheatWatermarkY + CheatWatermarkVsp <= ScreenBoundaryTop) {
	CheatWatermarkY = ScreenBoundaryTop;
	CheatWatermarkVsp *= -1;
}

CheatWatermarkX += CheatWatermarkHsp;
CheatWatermarkY += CheatWatermarkVsp;

