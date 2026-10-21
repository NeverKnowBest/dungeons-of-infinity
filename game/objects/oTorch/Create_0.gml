event_inherited();

WallInst = WallObj_Create("Objs_" + FloorLevelStr, x, y, 2, 2);

LightMaxRGB = 0.5;
LightMaxR = LightMaxRGB;
LightMaxG = LightMaxRGB;
LightMaxB = LightMaxRGB;

LightR = Lit ? LightMaxR : 0;
LightG = Lit ? LightMaxG : 0;
LightB = Lit ? LightMaxB : 0;

LightStrengthMax = 1.8;
LightStrength = (Lit ? LightStrengthMax : 0)
LightIndex = Lighting_CreateLight(RoomIndex, x + 8, y + 8, LightStrength, [LightMaxR, LightMaxG, LightMaxB], Lit);

LightFlickerDist = 0;
LightFlickerDir = 1;
LightFlickerLenMax = 0.15;
LightFlickerLenTarget = random_range(0.01, LightFlickerLenMax);

Lighting = false;

IsSwitch = false;
GroupIndex = 0;

LastImageSpeed = image_speed;

sprite_index = (Lit ? sTorch_Lit: sTorch);
