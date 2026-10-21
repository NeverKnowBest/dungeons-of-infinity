event_inherited();

S[0] = 0.7; S[1] = 0.9; S[2] = 1.1; S[3] = 1.3; S[4] = 1.1; S[5] = 0.9; S[6] = 0.7; S[7] = 0.5;
R[0] = 1.5; R[1] = 1.75; R[2] = 2.0; R[3] = 1.25; R[4] = 1; R[5] = 0.8; R[6] = 0.6; R[7] = 0.4;
G[0] = 1.2; G[1] = 1.2; G[2] = 1.2; G[3] = 0.75; G[4] = 0.5; G[5] = 0.3; G[6] = 0.2; G[7] = 0.1;
B[0] = 0.5; B[1] = 0.5; B[2] = 0.5; B[3] = 0.3; B[4] = 0.2; B[5] = 0.1; B[6] = 0.05; B[7] = 0.025;

LightIndex = Lighting_CreateLight(RoomIndex, x, y, S[0], [R[0], G[0], B[0]]);

LightFrame = 0;
LightFrames = 8;
LightDelay = 4;

LightUpdate = true;

AnimationEndDestroy = false;
