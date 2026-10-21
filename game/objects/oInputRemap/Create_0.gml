global.BindingRemap_InputIndex = InputIndex;
global.BindingRemap_VerbIndex = 0;

InputID = GetInputID(global.BindingRemap_InputIndex);
Bindings_Clear(InputIndex);
Bindings_GetIcons(InputIndex);

switch(global.BindingRemap_InputIndex){
	case Input_Index.Gamepad:
		input_binding_scan_params_set([gp_axislh, gp_axislv, gp_axisrh, gp_axisrv, gp_padl, gp_padr, gp_padu, gp_padd],[gp_face1, gp_face2, gp_face3, gp_face4, gp_select, gp_start, gp_shoulderl, gp_shoulderr, gp_shoulderlb, gp_shoulderrb, gp_stickl, gp_stickr]);
		break;
		
	case Input_Index.Keyboard:
		input_binding_scan_params_set([vk_backspace],
		[vk_left, vk_right, vk_up, vk_down, vk_lcontrol, vk_rcontrol, vk_lalt, vk_ralt, vk_space, vk_shift, vk_enter, vk_escape, vk_home, vk_end, vk_pageup, vk_pagedown, vk_insert, vk_delete, 
		 vk_comma, vk_period, vk_fslash, vk_bslash, vk_apostrophe, vk_hyphen, vk_equals, vk_semicolon, vk_apostrophe, vk_lbracket, vk_rbracket,
		 vk_f1, vk_f2, vk_f3, vk_f4, vk_f5, vk_f6, vk_f7, vk_f8, vk_f9, vk_f10, vk_f11, vk_f12,
		 vk_numpad0,vk_numpad1,vk_numpad2,vk_numpad3,vk_numpad4,vk_numpad5,vk_numpad6,vk_numpad7,vk_numpad8,vk_numpad9,vk_decimal,vk_divide,vk_multiply,vk_subtract,vk_add,
		 "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","1","2","3","4","5","6","7","8","9","0"]);
		break;
}

oMenu.Bindings_Remap = true;
oMenu.Menu_Active = false;
						
global.BindingRemap_Next = true;
