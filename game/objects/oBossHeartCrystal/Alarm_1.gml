ItemSpawn(ItemClass.Crystal, -100, -100, ItemFrom.Enemy, ItemSpawnType.DropSky, UPPER);
audio_play_sound(Sound_ItemFallingSky, 1, false);
instance_destroy(id);