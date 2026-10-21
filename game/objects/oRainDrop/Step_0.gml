x += vx;
y += vy;

vx += random_range(-0.025, 0.025);

if(y > oCamera.Y2 + 20) instance_destroy(self);