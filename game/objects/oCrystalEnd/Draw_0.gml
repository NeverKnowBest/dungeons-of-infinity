if(!Start) exit;

for(var i = 0; i < 3; i++){
	if(CVisible[i]){
		draw_sprite(sShadow_Large, 0, Cx[i], Cy[i]);
		draw_sprite(sItem_Crystal, 0, Cx[i], Cy[i] - Cz[i]);
	}
}

if(AttackScreenFadeDir != 0){
	draw_set_color(c_white);
	draw_set_alpha(AttackScreenFade);
	draw_rectangle(oCamera.X - 2, oCamera.Y - 2, oCamera.X + CAM_W + 3, oCamera.Y + CAM_H + 3, false);
	draw_set_alpha(1);
}