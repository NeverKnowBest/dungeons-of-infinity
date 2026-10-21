PauseObj

x += vx;
y += vy;

ObjSetY(y);

event_inherited();

if(WallCollided) instance_destroy(id);
