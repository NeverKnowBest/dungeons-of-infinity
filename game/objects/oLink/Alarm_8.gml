/// @description Star stop
StopStar();

with(oLink) UpdateState(LinkState.Standing);

if(UncurseAfterStar){
	UncurseAfterStar = false;
	MsgBox("Task completed!\\You are now uncursed.",,, Curse_Done);
}