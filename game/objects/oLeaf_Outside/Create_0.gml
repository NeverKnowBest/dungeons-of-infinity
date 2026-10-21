
MinAngle = 220;
MaxAngle = 260;
Speed = random_range(3, 5);
Angle = random_range(MinAngle, MaxAngle);
vx = lengthdir_x(Speed, Angle);
vy = lengthdir_y(Speed, Angle);

FlipX = choose(-1, 1);
FlipY = choose(-1, 1);
Rot = choose(0, 90, 180, 270);

AlwaysRotate = false;
AlwaysRotateDir = choose(-1, 1);
AlwaysRotateDegrees = irandom_range(340, 380);
alarm[0] = irandom_range(30, 180);
