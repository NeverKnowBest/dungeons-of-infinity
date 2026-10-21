
State = RodChargerState.Idle;
RodIndex = 3;
RodInserted = false;

MagicCost = 4;
ChargeDelay = 13;
FillError = false;
CanAddShot = true;

ChargeColor = 0;
ChargeColors = [KB_In, KB_Br, KB_Gr];

BaseLightRadius = 0.75;
LightRadius = BaseLightRadius;
LightIndex = Lighting_CreateLight(RoomIndex, x, y + 1, LightRadius, [0.4, 0.4, 1.1]);
LightFrame = 0;
