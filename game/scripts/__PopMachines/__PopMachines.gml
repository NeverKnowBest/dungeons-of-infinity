#macro PopMachineCost 15
#macro ClawMachineCost 10

enum ClawMachineState{
	Reset,
	Idle,
	MoveClaw,
	Drop,
	Grab,
	RaiseClaw,
	DropPrize,
	ClaimPrize,
	GameOver
}