
Speed = random_range(2.5, 4.25);
Angle = random_range(75, 105);
vx = lengthdir_x(Speed, Angle);
vy = lengthdir_y(Speed, Angle);
vz = random(2);
z = random(10);
ObjSetY(y);

FlipX = choose(-1, 1);
FlipY = choose(-1, 1);
Rot = choose(0, 90, 180, 270);

AlwaysRotate = false;
AlwaysRotateDir = choose(-1, 1);
if(Prob(0.5)) alarm[0] = irandom_range(15, 30);

Stop = false;