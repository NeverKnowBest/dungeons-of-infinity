// Feather disable GM2064
var _LightStr = (W >= H ? W / 20 : H / 20);
instance_create_layer(x + (W / 2), y + (H / 2), layer, oCoalLight, {RoomIndex : RoomIndex, R : 1.0, G : 0.2, B : 0.0, LightStrength : _LightStr});
LastImageSpeed = image_speed;