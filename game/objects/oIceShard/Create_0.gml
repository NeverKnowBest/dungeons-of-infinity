ObjSetY(y);

FloorLevelStr = GetFloorLevelString(FloorLevel);

vz = 3.5;
g = -0.2;
var Angle = irandom(45) * 8;
var Speed = random_range(0.2, 0.7);
vx = lengthdir_x(Speed, Angle);
vy = lengthdir_y(Speed, Angle);
sprite_index = choose(sIceShardS,sIceShardS,sIceShardS,sIceShardM,sIceShardM,sIceShardL);
