//the night tint and the lightning are drawn by oWeather, under this fade from black
draw_set_color(#000000);
draw_set_alpha(DarkScreenAlpha);
if(DrawDarkScreen) draw_rectangle(oCamera.X, oCamera.Y, oCamera.X2, oCamera.Y2, false);
draw_set_alpha(1);
draw_set_color(#FFFFFF);

