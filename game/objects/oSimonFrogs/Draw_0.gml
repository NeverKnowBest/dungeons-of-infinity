
var _y = y + 8;

for(var i = 0; i < 4; i++){	
	
	var _x = x + (i * 18) + 8;
	
	PixelRender(true, true, true, sSimonFrogs_Pal, i, false, []);
	
	draw_sprite(sSimonFrogPad, 0, _x, _y);
	draw_sprite(sFrog, Index == i ? NoteFrames[NoteFrame] : 0, _x, _y);
	
	shader_reset();
	
}
