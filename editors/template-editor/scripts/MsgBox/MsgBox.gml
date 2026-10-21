enum MsgBox{
	Yes = 1,
	No = 2
}

function MsgBox_Create(_Msg, _Prompt_YesNo){
	
	var MsgBoxInst = instance_create_layer(0,0,"MsgBox",oMsgBox);
	if(_Prompt_YesNo){
		_Msg += " (Y/N)";
		MsgBoxInst.Prompt_YesNo = _Prompt_YesNo;
	}
	MsgBoxInst.Msg = _Msg;
	
	draw_set_font(fnt_header);
	MsgBoxInst.MsgWidth = string_width(_Msg);
	MsgBoxInst.BoxW = MsgBoxInst.MsgWidth + 80;
	MsgBoxInst.BoxH = 80;
	MsgBoxInst.BoxX = (1920 - MsgBoxInst.BoxW) / 2;
	MsgBoxInst.BoxY = (1080 - MsgBoxInst.BoxH) / 2;
	
	global.MsgBoxFlag = true;
	
	return MsgBoxInst;
}

function MsgBox_Check(MsgBoxInst){
	
	if(instance_exists(MsgBoxInst)){
		if(MsgBoxInst.Prompt_YesNo && MsgBoxInst.Choice != 0){
			instance_destroy(MsgBoxInst);
			return MsgBoxInst.Choice
		}
	}
	
	return 0;
	
}