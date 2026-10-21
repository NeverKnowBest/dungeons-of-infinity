event_inherited();

CollisionList = ds_list_create();

if(RoomIndex == -1){
	instance_destroy(id); //fail-safe, sometimes effect would be located out of room index map and return -1, which would cause the game to crash
	exit;
}

FloorLevel = GetFloorLevelID(x, y);

S[0] = 0.3; S[1] = 0.4; S[2] = 0.5; S[3] = 0.6; S[4] = 0.7; S[5] = 0.7; S[6] = 0.6; S[7] = 0.5; S[8] = 0.4; S[9] = 0.3; S[10] = 0.2; S[11] = 0.1; S[12] = 0.1; S[13] = 0.1;

R[0] = 0.8; R[1] = 0.8; R[2] = 0.7; R[3] = 0.6; R[4] = 0.4; R[5] = 0.2; R[6] = 0.1; R[7] = 0.05; R[8] = 0.025; R[9] = 0.025; R[10] = 0.025; R[11] = 0.025; R[12] = 0.025; R[13] = 0.025;
G[0] = 0.8; G[1] = 1.0; G[2] = 1.0; G[3] = 1.0; G[4] = 1.0; G[5] = 0.8; G[6] = 0.6; G[7] = 0.5; G[8] = 0.4; G[9] = 0.4; G[10] = 0.2; G[11] = 0.1; G[12] = 0.0; G[13] = 0.0;
B[0] = 1.0; B[1] = 1.25; B[2] = 1.5; B[3] = 1.75; B[4] = 2.0; B[5] = 1.75; B[6] = 1.5; B[7] = 1.25; B[8] = 1.0; B[9] = 0.8; B[10] = 0.6; B[11] = 0.4; B[12] = 0.4; B[13] = 0.4;

LightIndex = Lighting_CreateLight(RoomIndex, x, y, S[0], [R[0], G[0], B[0]]);

