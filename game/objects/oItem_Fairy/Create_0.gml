event_inherited();

FloorLevel = UPPERLOWER;

layer = global.LayerID_ObjsHighest;
//visible = true;

Get_Sound = Sound_ItemGet;

z = 8;
z_min = 2;
z_max = 16;

ObjSetY(y_base);

Speed = 0.25;
alarm[0] = 30;
ZSpeed = 0.2;

LastImageSpeed = image_speed;

Setup = true;

Fairy_NewDir();
