

LightIndex = Lighting_CreateLight(RoomIndex, x, y - 8, 1.0, [0.8, 0.8, 0.8]);
Lighting_UpdateLight_RGB(RoomIndex, LightIndex, [0.0, 0.0, 0.0]);
image_alpha = 0;
global.Paused = true;
alarm[0] = 40;

MoveCamera1 = false;
MoveCamera2 = false;
MoveCamera3 = false;
CameraStartY = oCamera.Y;

Start = false;
Spawning = false;
SpawnItems = false;

ItemInst1 = noone;
ItemInst2 = noone;