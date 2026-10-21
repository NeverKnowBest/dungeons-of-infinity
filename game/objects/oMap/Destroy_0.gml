sprite_delete(MapSprite);
sprite_delete(LinkSprite);
global.MapInst = noone;
global.Paused = false;
with(oLink) UpdateState(LinkState.Standing);