
if(global.Arcade_ActiveInst.Harry.Killed && global.Arcade_ActiveInst.State != ArcadeState.GameOver) exit;

x += vx;
y += vy;

if(x < global.Arcade_ActiveInst.CamX - 20) instance_destroy(id);

if(global.Arcade_ActiveInst.State == ArcadeState.GameOver) exit;

if(x < global.Arcade_ActiveInst.Harry.x - 10 && !AddedPoints){
	global.Arcade_ActiveInst.Score += Points;
	AddedPoints = true;
}