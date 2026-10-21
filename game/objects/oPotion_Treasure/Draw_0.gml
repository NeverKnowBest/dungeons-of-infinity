var PickedUp = oLink.ItemHolding == id;
PixelRender_Dim(!PickedUp, !PickedUp, false, noone, 0, false, noone, false, 0);

if(!PickedUp) draw_sprite(sShadow_Large, 0, x, y);

draw_self();

shader_reset();


