FloorLevel = GetFloorLevelID(x, y);
FloorLevelStr = GetFloorLevelString(FloorLevel);
Spark = false;
Pause = false;

if(Flip) x += 24;

image_index = random(image_number - 1);

LastImageSpeed = image_speed;