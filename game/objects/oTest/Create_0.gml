// Test mode controller (see scripts/__Test). Created by Test_Init, lives through every room.
Step = 0;			// index in global.Test.Steps
StepFrames = 0;		// frames spent on the current step
Started = false;
ShotName = "";		// screenshot to save in the Post Draw of this frame
Sheet = undefined;	// contact sheet in progress (Test_SheetStart)
ActivateAll = false;	// set by steps that build a level: oTest's Step activates every instance, like oLink before the stairs

ExitVerb = "";		// verb the "exit" step holds to walk into the exit

LastLevel = undefined;
LastRoom = -1;
LastHealth = -1;
Dead = false;
