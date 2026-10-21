FloorLevel = GetFloorLevelID(x, y);

DwarfSprite = sMineCart_Dwarf_Right;
RockSprite = sMineRocks_H;
RockDirX = 1;

RockIndex = irandom(8);

vx = 0;
vy = 0;
Speed = 0.5;

DirSwitchInst = noone;
DirSwitch = false;
DirSwitchNextDir = 0;

LastImageSpeed = image_speed;