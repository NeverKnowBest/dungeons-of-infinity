// End Step, like oLink's level changes: room activation needs the Step events to be over
if(global.Test.Finished) exit;

global.TestFrame++;
if(global.TestFrame > global.Test.MaxFrames){
	Test_Fail("max_frames reached at step " + string(Step));
	Test_Finish("timeout");
	exit;
}

if(room != Room_Dungeon || !instance_exists(oLink) || !variable_global_exists("Level")) exit;

if(Sheet != undefined){
	Test_SheetStep();
	exit;
}

Test_Watch();

if(!Started){
	Started = true;
	for(var i = 0; i < array_length(global.Test.Items); i++){
		var _Item = global.Test.Items[i];
		if(!is_real(_Item[$ "item"])) Test_Fail("bad item " + string(_Item[$ "item"]));
		else Test_GiveItem(_Item.item, _Item[$ "index"] ?? 0, _Item[$ "amount"] ?? 1);
	}
	Test_LogState();
}

if(Step >= array_length(global.Test.Steps)){
	Test_Finish("ok");
	exit;
}

var _S = global.Test.Steps[Step];
if(StepFrames == 0) Test_Log("step " + string(Step) + " " + json_stringify(_S));
StepFrames++;
if(Test_DoStep(_S)){
	Step++;
	StepFrames = 0;
}
