// Fade to black, move Link to another hub room, fade back in. Created by oHubDoor (outside every room, so moving
// between rooms does not deactivate it).
State = 0;		// 0 fading out, 1 black, 2 fading in
Alpha = 0;
Hold = 0;
with(oLink) UpdateState(LinkState.Inventory);
