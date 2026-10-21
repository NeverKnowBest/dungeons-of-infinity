event_inherited();


CamW = 200;
CamH = 150;

RoomW = CamW;
RoomH = CamH;


CamW_2 = CamW / 2;
CamH_2 = CamH / 2;
CamW_3 = CamW / 3;
CamH_3 = CamH / 3;
CamW_4 = CamW / 4;
CamH_4 = CamH / 4;

ReelPosX[0] = 12;
ReelPosX[1] = 72;
ReelPosX[2] = 132;

ReelPosX_Symbols[0] = ReelPosX[0] + 4;
ReelPosX_Symbols[1] = ReelPosX[1] + 4;
ReelPosX_Symbols[2] = ReelPosX[2] + 4;
ReelPosY_Symbols = 60;


ReelPos[0] = irandom(global.MothulaSlot_ReelIndexes) * 16;
ReelPos[1] = irandom(global.MothulaSlot_ReelIndexes) * 16;
ReelPos[2] = irandom(global.MothulaSlot_ReelIndexes) * 16;

ReelSpin[0] = false;
ReelSpin[1] = false;
ReelSpin[2] = false;

ReelSpinMaxSpeed = 8;
ReelSpinSpeed[0] = random_range(ReelSpinMaxSpeed - 1, ReelSpinMaxSpeed);
ReelSpinSpeed[1] = random_range(ReelSpinMaxSpeed - 1, ReelSpinMaxSpeed);
ReelSpinSpeed[2] = random_range(ReelSpinMaxSpeed - 1, ReelSpinMaxSpeed);



ReelSpinStopDelay = 45;

ReelSpinResult = 0;
ReelSpinResultSymbols[0] = 0;
ReelSpinResultSymbols[1] = 0;
ReelSpinResultSymbols[2] = 0;

ReelSpinResultSeek[0] = false;
ReelSpinResultSeek[1] = false;
ReelSpinResultSeek[2] = false;

ReelSpinIndexSeek[0] = -1;
ReelSpinIndexSeek[1] = -1;
ReelSpinIndexSeek[2] = -1;

MiniScreen_Sprite = sArcade_Screen_Mothula;

GameState = SlotState.Idle;
GameReady = true;
GameReadyDelay = 10;

Bet = 0;

WinMul = [0, 1, 2, 5, 10, 25, 100];
WinAmount = 0;
WinSound = noone;

StopSounds = [Sound_SlotStop1, Sound_SlotStop2, Sound_SlotStop3];
WinSounds = [noone, Sound_SlotWin1, Sound_SlotWin1, Sound_SlotWin1, Sound_SlotWin2, Sound_SlotWin3, Sound_SlotWin4];