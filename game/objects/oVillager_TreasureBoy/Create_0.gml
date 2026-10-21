event_inherited();

//we need to know the king's door inst to detect if it was open. If so use response dialogue
DoorInst = collision_rectangle(x - 64, y - 48, x, y, oDoor, false, true);