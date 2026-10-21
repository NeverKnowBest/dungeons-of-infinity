surface_free(GameSurface);
with(oZerberk_MiniArcade_Alien) instance_destroy(id);
with(oZerberk_MiniArcade_Ship) instance_destroy(id);
with(oZerberk_MiniArcade_Laser) instance_destroy(id);
with(oZerberk_MiniArcade_Explosion) instance_destroy(id);
audio_stop_sound(sndZerberk_MiniArcade_Death);