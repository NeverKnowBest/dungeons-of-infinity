event_inherited();

Enemy = true;
Speed = 2.5;
z = 8;
var D = point_direction(x, y, oLink.x, oLink.y - 6);
vx = lengthdir_x(Speed, D);
vy = lengthdir_y(Speed, D);
Destroyed = false;