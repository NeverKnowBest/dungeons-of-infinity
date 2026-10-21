event_inherited();

IgnoreWalls = true;
ContainInRoom = true;
Speed = 0.75;
//KnockBackIgnoreZRule = true;

zs = 16;
z = zs;
Zt = 0;
ObjSetY(y_base);

layer = global.LayerID_ObjsHighest;

Enemy_UpdateState(EnemyState.Walking);