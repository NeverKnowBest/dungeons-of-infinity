// The Flute Boy at the Sanctuary counter. Talking to him opens the wardrobe (skins).
event_inherited();

// he only has a front-facing sprite
SprUp = SprDown;
SprLeft = SprDown;
SprRight = SprDown;

// taller collision mask so Link can talk to him across the counter
mask_index = sHub_TalkMask;

OpenWardrobe = false;
