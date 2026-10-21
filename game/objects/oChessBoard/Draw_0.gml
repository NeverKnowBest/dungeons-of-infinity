draw_set_alpha(0.5);
draw_set_color(c_black)
draw_rectangle(oCamera.X, oCamera.Y, oCamera.X + CAM_W - 1, oCamera.Y + CAM_H - 1, false);
draw_set_alpha(1);
draw_set_color(c_white);

draw_self();


var PieceStartX = x + 5;
var PieceStartY = y + 117;

//draw board
for(var j = 0; j < 8; j++){
	for(var i = 0; i < 8; i++){

		var PieceX = PieceStartX + (i * 16);
		var PieceY = PieceStartY + (j * -16);
		
		if(FromSquare[0] == i && FromSquare[1] == j){
			draw_sprite(sChessMoveSquare, 0, PieceX - 1, PieceY - 1);
		}
		if(ToSquare[0] == i && ToSquare[1] == j){
			draw_sprite(sChessMoveSquare, 0, PieceX - 1, PieceY - 1);
		}
		
		if(global.Board[i][j] != 0){
			draw_sprite(sChessPiece, 6 + global.Board[i][j], PieceX, PieceY);
		}

	}
}

if(Status == ChessStatus.Playing && global.Chess_Player == Player.Human){
	draw_set_color(c_white);
	draw_sprite_stretched(sChess_Selection, 0, x + 4 + (SelectionX * 16), y + 4 + (SelectionY * 16), 16, 16);	
	
	if(array_length(piece_selected) > 0){
		draw_sprite_stretched(sChess_Selected, 0, x + 4 + (piece_selected[0] * 16), y + 4 + ((7 - piece_selected[1]) * 16), 16, 16);		
	}
	
}

		
draw_sprite_stretched(sHUD_Window_DialogueBox, 0, AIWindowX, AIWindowY, AIWindowW, 32);	
draw_sprite(sChess_AI_Icon, 0, AIWindowX + 8, AIWindowY + 8);
draw_set_font(global.Font_Blue);
draw_set_halign(fa_left);
draw_text(AIWindowX + 28, AIWindowY + 10, StockfishStr);





