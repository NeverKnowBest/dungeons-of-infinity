if(Prompt_YesNo){
	
	if(keyboard_check_pressed(ord("Y"))) Choice = MsgBox.Yes;
	if(keyboard_check_pressed(ord("N"))) Choice = MsgBox.No;

}
if(!Prompt_YesNo && keyboard_check_pressed(vk_enter)) instance_destroy(self);