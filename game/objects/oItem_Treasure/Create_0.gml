event_inherited();

if(!variable_instance_exists(id, "From")) From = ItemFrom.Treasure;
if(!variable_instance_exists(id, "ContentsFrom")) ContentsFrom = ItemFrom.Treasure;

ContentsObj = RandomItem;


InSection = false;

IsSwitchTreasure = false;

visible = true;

Get_WhenLinkCollides = false;
Get_Sound = noone;

WallInst = noone;

ShadowSpr = sEmptyMask;