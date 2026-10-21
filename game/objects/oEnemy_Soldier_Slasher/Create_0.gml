event_inherited();


ColorIndex = irandom(4);
HeadIndex = irandom(3);
Weapon = SoldierWeapon.Sword;

Size = EnemySize.Large;

Dir = RandomDir();

RunSpeed = 1.1;

HeadDir = Dir;
HeadSpr = noone;

WeaponInst = instance_create_layer(x, y, layer, oSoldierWeapon);
WeaponInst.SoldierInst = self;
WeaponInst.FloorLevel = FloorLevel;

Strafe = false;
StrafeDir = LEFT;
StrafeTime = 60;


LinkHitSword = false;

PlayRunSound = true;

SaveVariables = ["ColorIndex", "HeadIndex"];

Enemy_UpdateState(EnemyState.Running);
//image_index = 0;
//image_speed = 0.05;//0.5;