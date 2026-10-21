LightIndex = Lighting_CreateLight(RoomIndex, x, y, LightStrength, [R, G, B]);

LightFlickerDist = 0;
LightFlickerDir = 1;
LightFlickerLenMax = 0.25;
LightFlickerLenTarget = random_range(0.01, LightFlickerLenMax);