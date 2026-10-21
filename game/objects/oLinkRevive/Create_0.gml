
image_speed = 0;
global.LinkDead = false;

RotDist = 16;
RotSpeed = 45;
RotDir = 1;
RotAngle = 0;

BeamPosX = array_create(4, 0);
BeamPosY = array_create(4, 0);

BeamColor = 0;
BeamSprites[0] = sSwordBeam_0;
BeamSprites[1] = sSwordBeam_1;
BeamSprite = BeamSprites[BeamColor];

BeamSoundDelay = 14;
alarm[0] = 1;
BeamColorDelay = 8;
alarm[1] = BeamColorDelay;



