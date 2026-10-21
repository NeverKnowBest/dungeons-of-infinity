enum Input_Verb{
	Sword,
	Action,
	Item,
	Map,
	Strafe,	
	Inventory,
	Menu_Access,
	HUD
}
enum Input_Index{
	Gamepad,
	Keyboard	
}

//the verb indexes and order they appear on the menu for the different inputs
global.BindingVerbs[Input_Index.Gamepad] =  [Input_Verb.Sword, Input_Verb.Action, Input_Verb.Item, Input_Verb.Map, Input_Verb.Strafe, Input_Verb.Inventory, Input_Verb.Menu_Access, Input_Verb.HUD];
global.BindingVerbs[Input_Index.Keyboard] = [Input_Verb.Sword, Input_Verb.Action, Input_Verb.Item, Input_Verb.Map, Input_Verb.Strafe, Input_Verb.Inventory, Input_Verb.HUD];

global.BindingIconCount[Input_Index.Gamepad] = array_length(global.BindingVerbs[Input_Index.Gamepad]);
global.BindingIconCount[Input_Index.Keyboard] = array_length(global.BindingVerbs[Input_Index.Keyboard]);
global.BindingIcons[Input_Index.Gamepad] = array_create(global.BindingIconCount[Input_Index.Gamepad]);
global.BindingIcons[Input_Index.Keyboard] = array_create(global.BindingIconCount[Input_Index.Keyboard]);

global.BindingRemap_InputIndex = Input_Index.Gamepad;
global.BindingRemap_VerbIndex = 0;
global.BindingRemap_Next = false;

function GetInputIndexStr(_InputIndex){
	switch(_InputIndex){
		case Input_Index.Gamepad:	return "gamepad";
		case Input_Index.Keyboard:	return "keyboard";	
	}	
}
function GetInputID(_InputIndex){
	switch(_InputIndex){
		case Input_Index.Gamepad: return INPUT_GAMEPAD;
		case Input_Index.Keyboard: return INPUT_KEYBOARD;
	}
}
function GetInputVerbStr(_VerbIndex){
	switch(_VerbIndex){
		case Input_Verb.Sword: return "sword";
		case Input_Verb.Action: return "action";
		case Input_Verb.Item: return "item";
		case Input_Verb.Strafe: return "strafe";
		case Input_Verb.Map: return "map";
		case Input_Verb.Inventory: return "inventory";
		case Input_Verb.Menu_Access: return "menu_access";	
		case Input_Verb.HUD: return "hud";	
		
	}	
}

function Bindings_GetIcons(_InputIndex){
	var InputIndexStr = GetInputIndexStr(_InputIndex);
	for(var i = 0; i < global.BindingIconCount[_InputIndex]; i++){
		var VerbStr = input_binding_get_icon(input_binding_get(GetInputVerbStr(global.BindingVerbs[_InputIndex][i]),,, InputIndexStr));
		global.BindingIcons[_InputIndex][i] = VerbStr == "unknown" ? "" : VerbStr;
	}
}

function Bindings_Clear(_InputIndex){
	var InputIndexStr = GetInputIndexStr(_InputIndex);
	for(var i = 0; i < global.BindingIconCount[_InputIndex]; i++){
		input_binding_set(GetInputVerbStr(global.BindingVerbs[_InputIndex][i]), input_binding_empty(),,,InputIndexStr);
	}
}

function input_binding_scan_set_Success(_Binding){
	switch(_Binding.value){
		
		default:
			input_binding_set(GetInputVerbStr(global.BindingRemap_VerbIndex), _Binding,,,GetInputIndexStr(global.BindingRemap_InputIndex));
			BindingsRemap_CheckNext();
			break;
	}

}

function input_binding_scan_set_Failure(_ErrorCode){
	switch(_ErrorCode){
		case INPUT_BINDING_SCAN_EVENT.SOURCE_INVALID:
		case INPUT_BINDING_SCAN_EVENT.SOURCE_CHANGED:
		case INPUT_BINDING_SCAN_EVENT.LOST_FOCUS:
			global.BindingRemap_Next = true;
			break;
		
		case INPUT_BINDING_SCAN_EVENT.SCAN_TIMEOUT:
		case INPUT_BINDING_SCAN_EVENT.PLAYER_DISCONNECTED:
		case INPUT_BINDING_SCAN_EVENT.PLAYER_IS_GHOST:
			BindingsRemap_Exit();
			break;
			
		default:
			input_binding_set(GetInputVerbStr(global.BindingRemap_VerbIndex), input_binding_empty(),,,GetInputIndexStr(global.BindingRemap_InputIndex));
			BindingsRemap_CheckNext();
			break;
	}

}

function BindingsRemap_CheckNext(){
	if(global.BindingRemap_VerbIndex < global.BindingIconCount[global.BindingRemap_InputIndex] - 1) {
		global.BindingRemap_VerbIndex++; 
		global.BindingRemap_Next = true;
	}else{
		
		User_Save();
		
		BindingsRemap_Exit();
	}
	Bindings_GetIcons(global.BindingRemap_InputIndex);	
	
}

function BindingsRemap_Exit(){
	oMenu.Bindings_Remap = false;
	oMenu.Menu_Active = true;
	input_binding_scan_abort();
	input_binding_scan_clear_params();
	io_clear();
	input_clear_momentary(true);
	instance_destroy(oInputRemap);
}