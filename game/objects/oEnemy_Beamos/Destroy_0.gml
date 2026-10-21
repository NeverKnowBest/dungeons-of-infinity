event_inherited();

Beamos_DestroyLaserLights();
Lighting_DestroyLight(RoomIndex, EyeLight);

if(instance_exists(WallInst)) instance_destroy(WallInst);