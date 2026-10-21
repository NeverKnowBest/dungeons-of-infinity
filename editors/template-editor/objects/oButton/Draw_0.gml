
if(!visible) exit;

draw_set_font(Font);

var Highlight = 0;
if(MouseOver){
	Highlight++;
	if(mouse_check_button(mb_left)) Highlight++;
}

var R = color_get_red(Color); var G = color_get_green(Color); var B = color_get_blue(Color);
draw_set_color(make_color_rgb(R + (R * .25 * Highlight), G + (G * 0.25 * Highlight), B + (B * 0.25 * Highlight)));
draw_set_alpha(0.9);
draw_rectangle(x, y, x + W - 1, y + H - 1, false);
if(Checkbox){
	draw_set_color(Color);
	var X1 = x + W + 2;
	var X2 = x + W + H;
	draw_rectangle(X1, y, X2, y + H - 1, false);
	draw_set_color(c_white);
	if(ChkStatus) draw_rectangle(X1 + 4, y + 4, X2 - 4, y + H - 5, false);
}
draw_set_alpha(1);
	
if(Text != ""){
	draw_set_color(Active ? TextColor_Active : TextColor_Default);
	draw_text(x + 4, y + 2, Text);
}

if(Sprite != noone){
	SetBrightness(Highlight * 0.1);
	draw_sprite(Sprite, SpriteIndex, x + 3, y + 2);
	shader_reset();
}

