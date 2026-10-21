FloorLevel = UPPER;//don't use GetFloorLevelID(x, y) here, see WallObj_Create();

Position = NONE;

ShopInst = noone;

BlockLink = true;
BlockLinkCarry = true;
BlockEnemies = true;
BlockProjectiles = true;
BlockItems = true;

GID = 0;

PrisonerInst = noone; //for walls below prisons, some may have a prisoner, this keeps the inst id fo when Link collides with prison and wants to talk

Moved = false;
MoveX = 0;
MoveY = 0;
Move_Start = false;
Move_Dist = 0;

IsHiddenObj = false;

IsSwitchBlock = false;
SwitchBlockInst = noone;

IsEnemy = false;
IsDoorEntrance = false;
IsStairs = false;
IsHole = false;

AllowedDir = ALLDIR;
