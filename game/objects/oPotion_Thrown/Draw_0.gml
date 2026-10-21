var PickedUp = oLink.ItemHolding == id;

PixelRender_Dim(!PickedUp, !PickedUp, false, noone, 0, true, DoorPassage, false, 0);

if(!PickedUp) draw_sprite(sShadow_Large, 0, x, y);

draw_sprite(sprite_index, PotionType, x, y - z);	

shader_reset();	
