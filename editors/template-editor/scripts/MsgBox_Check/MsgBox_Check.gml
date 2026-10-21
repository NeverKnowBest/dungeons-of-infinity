function MsgBox_Check(MsgBoxInst){
	
	if(instance_exists(MsgBoxInst)){
		if(MsgBoxInst.Prompt_YesNo && MsgBoxInst.Choice != 0){
			instance_destroy(MsgBoxInst);
			return MsgBoxInst.Choice
		}
	}
	
	return 0;
	
}