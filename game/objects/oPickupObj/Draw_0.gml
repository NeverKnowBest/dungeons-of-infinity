
//if(Hidden) exit;

var _PickedUp = (State == PickupObjState.PickedUp);
var _Lighting = (Lighting && (!_PickedUp || global.Inventory.ItemData[ItemClass.Lamp].Index == -1));

PixelRender_Dim(_Lighting, _Lighting, false, noone, 0, false, []);

if(DrawShadow) draw_sprite(sShadow_Large, 0, x, y_base);

draw_sprite(sprite_index, Index, x, y);	

if(!_PickedUp) Obj_DrawInWater(false);

shader_reset();

//if(ContentsObj != -1) draw_sprite(object_get_sprite(ObjIndexFromItemClass(ContentsObj)), 0, x, y);


//if(ContentsObj == ItemClass.Key) draw_sprite(sItem_Key, 0, x, y);


//var _y = y;
//draw_text(x, _y, "vx: " + string(vx)); _y+=10;
//draw_text(x, _y, "vy: " + string(vy)); _y+=10;
//draw_text(x, _y, string(z)); _y+=10;
//draw_text(x, _y, string(Hidden)); _y+=10;
//draw_text(x, _y, string(sEmptyMask)); _y+=10;
//draw_text(x, _y, "St:" + string(State)); _y+=10;
//draw_text(x, _y, "OI:" + string(object_index)); _y+=10;
//draw_text(x, _y, "Ly:" + string(layer)); _y+=10;
//draw_text(x, _y, "Ly:" + string(FloorLevel)); _y+=10;



