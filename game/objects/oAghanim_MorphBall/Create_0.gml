Speed = 4;
vx = 0;
vy = 0;

Move = false;
			
var Angle = point_direction(x, y, MoveX, MoveY);
vx = lengthdir_x(Speed, Angle);
vy = lengthdir_y(Speed, Angle);

MorphTo = true;
MorphFrom = false;
MorphAniDelay = 5;
alarm[0] = MorphAniDelay;

LastImageSpeed = 1;