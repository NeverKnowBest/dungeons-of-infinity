
if(!variable_instance_exists(id, "Y")) Y = 144;
if(!variable_instance_exists(id, "CenterText")) CenterText = false;

//TextX = 0;
//TextY = 0;
TextColor = c_white;

Surface = -1;
SurfaceW = DialogueBoxW - 14;
SurfaceH = 0;
SurfaceMaxH = 48;
SurfaceY = 0;
SurfaceShiftDelay = 0;
SurfaceShiftDelayLastState = 0;


BoxCenter = SurfaceW / 2;

ShowBox = true;

Script = -1;
ScriptPos = 0;
ScriptCode = 0;
ScriptNext = true;
InputChoice = 0;
InputChoices = 0;
DialogueArray = "";
LinesLeft = 0;

Status = -1;
GotoFlag = false;


depth = -2000;

if(variable_instance_exists(id, "Method")){
	if(Method != undefined){
		Method();
	}
}

CameraExists = instance_exists(oCamera);
if(!CameraExists) exit;

if(oCamera.RoomTransition == NONE && oLink.State != LinkState.AutoMove){
	with(oLink) UpdateState(LinkState.Dialogue);
	global.Paused = true;
}