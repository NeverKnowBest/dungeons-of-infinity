
function CreateButton(_x, _y, _Checkbox){
	
	var ObjInst = instance_create_layer(_x, _y, "UI", oButton);
	ObjInst.Checkbox = _Checkbox;
	
	var ButtonW = 16;
	var ButtonH = 16;
	if(argument_count == 4){ 
		if(sprite_exists(argument[3])){
			//sprite
			ObjInst.Sprite = argument[3];
			var ButtonW = sprite_get_width(ObjInst.Sprite) + 6;
			var ButtonH = sprite_get_height(ObjInst.Sprite) + 4;
		}
	}
	
    if(argument_count == 5){ 
		
		if(is_string(argument[3])){
			//text
			ObjInst.Text = argument[3];
			ObjInst.Font = argument[4];
			draw_set_font(ObjInst.Font);
			var ButtonW  = string_width(ObjInst.Text) + 4;
			var ButtonH  = string_height(ObjInst.Text) + 3;
			
		
		}else{
			var ButtonW = argument[3];
			var ButtonH = argument[4];
		}
		
	}
	
	
	ObjInst.W = ButtonW;
	ObjInst.H = ButtonH;
	

	return ObjInst;
}