instance_create_layer(CenterX + lengthdir_x(Radius, Angle), CenterY + lengthdir_y(Radius, Angle), "ObjsHigher_Upper", oFireTower);
Angle = Angle + (28.43 * Dir); //this exact angle makes it so it ends at 90 degrees
if(Angle >= 360) Angle -= 360;
if(Angle < 0) Angle+= 360;
Radius+=3;
Explosions--;
if(Explosions == 0)
	instance_destroy(self);
else
	alarm[0] = 6;