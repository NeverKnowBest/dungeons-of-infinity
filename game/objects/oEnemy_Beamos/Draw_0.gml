if(EyeA < 180){
	if(Shooting) Beamos_Laser_Draw();
	Enemy_PixelRender(true, sEnemy_Beamos_Palette, Index);
	draw_sprite(sEnemy_Beamos_Eye, EyeImgIndex, EyeX, EyeY);
	shader_reset();
	
}

if(StopWatch || Stoned){
	Enemy_PixelRender();
}else{
	if(State == EnemyState.KnockBack)
		PixelRender_Dim(true, true, true, sEnemy_Beamos_Palette, Index, true, global.KnockBackColors[KnockBackColorFrame]);	
	else
		PixelRender_Dim(!Flashing, !Flashing, true, sEnemy_Beamos_Palette, Index, Flashing, FlashColors[FlashColorIndex]);
}
draw_self();
shader_reset();

if(EyeA >= 180){
	Enemy_PixelRender(true, sEnemy_Beamos_Palette, Index);
	draw_sprite(sEnemy_Beamos_Eye, EyeImgIndex, EyeX, EyeY);
	shader_reset();
	if(Shooting && !StopWatch) Beamos_Laser_Draw();
}


//draw_text(x + 16, y, string(floor(point_direction(oLink.x, oLink.y - 6, EyeX, EyeY))));
//var _Dir = point_direction(EyeX, EyeY, ClosestWallPosX, ClosestWallPosY);
//draw_line_width(EyeX, EyeY, EyeX + lengthdir_x(ClosestWall, _Dir), EyeY + lengthdir_y(ClosestWall, _Dir), 2)