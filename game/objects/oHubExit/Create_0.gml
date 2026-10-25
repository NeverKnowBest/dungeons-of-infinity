// Front door of a hub room. Reaching it opens the Depart menu (bonus item and challenges);
// "Set out" fades the screen and starts a new run, "Stay" walks Link back inside.
// Created by Hub_CreateScenery at the bottom of the doorway; (x, y) is the trigger line.
State = HubExitState.Idle;
Started = false;
FadeAlpha = 0;
