x += vx;

if(x < camera_get_view_x(view_camera[ArcadeScreen_View]) - 32) instance_destroy(self);

if(x < oArcade_Pitfall.Harry.x - 10 && !AddedPoints){
	oArcade_Pitfall.Score += 50;
	AddedPoints = true;
}