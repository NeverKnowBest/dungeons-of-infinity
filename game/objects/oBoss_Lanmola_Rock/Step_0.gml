if(global.Paused) exit;

x += vx;
ObjSetY(y_base + vy);

event_inherited();

if(WallCollided){
	instance_destroy(id);
}