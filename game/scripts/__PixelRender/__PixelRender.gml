
#macro MAXROOMLIGHTS 48

enum MosaicType{
	Warp,
	Shock,
	Sick	
}

function PixelRender_Init() {
	
	//Lighting	
	
	global.uLighting_Status =				shader_get_uniform(shd_PixelRender,"Lighting_Status");	//x=main, y = lights
	global.uLighting_RoomStatus =			shader_get_uniform(shd_PixelRender,"Lighting_RoomStatus");	
	global.uLighting_RoomBoundary[0] =		shader_get_uniform(shd_PixelRender,"Lighting_RoomBoundary0");
	global.uLighting_RoomBoundary[1] =		shader_get_uniform(shd_PixelRender,"Lighting_RoomBoundary1");
	global.uLighting_RoomRGB[0] =			shader_get_uniform(shd_PixelRender,"Lighting_RoomRGB0");	
	global.uLighting_RoomRGB[1] =			shader_get_uniform(shd_PixelRender,"Lighting_RoomRGB1");	
	
	global.uLighting_LightArray_Pos[0] =	shader_get_uniform(shd_PixelRender,"Lighting_LightArray_Pos0");		//x, y, radius
	global.uLighting_LightArray_Pos[1] =	shader_get_uniform(shd_PixelRender,"Lighting_LightArray_Pos1");		//x, y, radius
	global.uLighting_LightArray_RGB[0] =	shader_get_uniform(shd_PixelRender,"Lighting_LightArray_RGB0");
	global.uLighting_LightArray_RGB[1] =	shader_get_uniform(shd_PixelRender,"Lighting_LightArray_RGB1");

	global.uLighting_Link_Pos =	shader_get_uniform(shd_PixelRender,"Lighting_Link_Pos");	
	global.uLighting_Link_RGB =	shader_get_uniform(shd_PixelRender,"Lighting_Link_RGB");
	
	global.LinkLight_Pos = array_create(3);
	global.LinkLight_RGB = array_create(3);
	
	global.uAlpha = shader_get_uniform(shd_PixelRender,"Alpha");
	
	//Palette
  	global.uPaletteStatus = shader_get_uniform(shd_PixelRender,"PaletteStatus");
	global.uPalette_PixelSize = shader_get_uniform(shd_PixelRender, "u_pixelSize");
	global.uPalette_Uvs = shader_get_uniform(shd_PixelRender, "u_Uvs");
	global.uPalette_Index = shader_get_uniform(shd_PixelRender, "u_paletteId");
	global.uPalette_Texture = shader_get_sampler_index(shd_PixelRender, "u_palTexture");

	global.uColor_Status = shader_get_uniform(shd_PixelRender,"Color_Status");
	global.uColor = shader_get_uniform(shd_PixelRender,"Color_Index");
	global.uColor_Tint = shader_get_uniform(shd_PixelRender,"Color_Tint");
	global.uTimer = shader_get_uniform(shd_PixelRender,"uni_timer");
	
	global.uAlpha_Status = shader_get_uniform(shd_PixelRender,"Alpha_Status");
	global.uAlpha_Val = shader_get_uniform(shd_PixelRender,"Alpha_Val");
		
}

function Lighting_CreateLight(_RoomIndex, _x, _y, _Radius, _RGB, _Visible = true) {
	
	if(_RoomIndex == -1) return -1;
	
	var _LightIndex = array_pop(Room.Lights_UnusedIndexes);
	
	if(_LightIndex == undefined){
		
		if(Room.Lights_LastIndex >= MAXROOMLIGHTS - 1) return -1; //no more space for another lights
		
		_LightIndex = ++Room.Lights_LastIndex;
		
	}	
	
	Lighting_UpdateLight_Pos(_RoomIndex, _LightIndex, _x, _y);
	Lighting_UpdateLight_Radius(_RoomIndex, _LightIndex, _Radius);
	Lighting_UpdateLight_RGB(_RoomIndex, _LightIndex, _RGB);
	if(!_Visible) Lighting_UpdateLight_Visible(_RoomIndex, _LightIndex, false);
	
	return _LightIndex;

}

function Lighting_DestroyLight(_RoomIndex, _LightIndex){
	
	//reminder to set the object's lightindex back to -1 after you destroy the light if the object doesn't also get destroyed
	
	if(_LightIndex == -1) return -1;
	
	//_Light.Status
	Lighting_UpdateLight_RGB(_RoomIndex, _LightIndex, [0.0, 0.0, 0.0]);
	
	if(_LightIndex == Room.Lights_LastIndex){
		Room.Lights_LastIndex--;
	}else{
		array_push(Room.Lights_UnusedIndexes, _LightIndex);
	}
	
	return -1 //so we can use LightIndex = DestroyLight(), which would reset the object's LightIndex back to -1 if the object doesn't get destroyed after and still needs the LightIndex variable
	
}

function PixelRender_Dim(_DoLighting, _DoLighting_Lights, _DoPalette, _PaletteSpr, _PaletteIndex, _DoColor, _Color, _BaseRGB = [0.0, 0.0, 0.0], _Alpha = 1.0){
	
	//Pass-thru function
	//Before rendering obj, Dim Link's lamp render on current obj calling this based on Link's LampDim, which is affected by floor level, jumping, and going up/down stairs 
	if(FloorLevel = UPPER){
		var _LinkExists = instance_exists(oLink); //Link may not exist for some rare cases which crashes the game in these pixel render functions that update Link's light
		if(_LinkExists){
			Lighting_UpdateLinkLight(,,[oLink.LampLightR * oLink.LampDim, oLink.LampLightG * oLink.LampDim, oLink.LampLightB * oLink.LampDim]);
		}
		PixelRender(_DoLighting, _DoLighting_Lights, _DoPalette, _PaletteSpr, _PaletteIndex, _DoColor, _Color, _BaseRGB, _Alpha);	
		if(_LinkExists) Lighting_UpdateLinkLight(,,[oLink.LampLightR, oLink.LampLightG, oLink.LampLightB]);	
	}else PixelRender(_DoLighting, _DoLighting_Lights, _DoPalette, _PaletteSpr, _PaletteIndex, _DoColor, _Color, _BaseRGB, _Alpha);

}

function PixelRender(_DoLighting, _DoLighting_Lights, _DoPalette, _PaletteSpr, _PaletteIndex, _DoColor, _Color, _BaseRGB = [0.0, 0.0, 0.0], _Alpha = 1.0){

	
	shader_set(shd_PixelRender);
	
	shader_set_uniform_f(global.uAlpha, _Alpha);
	
	//Lighting
	shader_set_uniform_i(global.uLighting_Status, global.GlobalLighting && _DoLighting, _DoLighting_Lights);

	shader_set_uniform_f(global.uLighting_Link_Pos, global.LinkLight_Pos[0], global.LinkLight_Pos[1], global.LinkLight_Pos[2]);
	shader_set_uniform_f(global.uLighting_Link_RGB, global.LinkLight_RGB[0], global.LinkLight_RGB[1], global.LinkLight_RGB[2]);
	
	var _Room0 = global.Level.Rooms[global.CurrentRoomIndex];
	
	shader_set_uniform_f(global.uLighting_RoomBoundary[0], _Room0.x, _Room0.y, _Room0.x2, _Room0.y2);
	shader_set_uniform_f(global.uLighting_RoomRGB[0], _BaseRGB[0], _BaseRGB[1], _BaseRGB[2], 1.0);
	
	shader_set_uniform_f_array(global.uLighting_LightArray_Pos[0], _Room0.Lights_Pos);
	shader_set_uniform_f_array(global.uLighting_LightArray_RGB[0], _Room0.Lights_RGB);	
	
	var _DoRoom1Lights = false;
	if(global.TransitionRoomIndex != -1){
		_DoRoom1Lights = global.Level.Rooms[global.TransitionRoomIndex].Lighting;
	}
	
	shader_set_uniform_i(global.uLighting_RoomStatus, _Room0.Lighting, _DoRoom1Lights);
	
	if(_DoRoom1Lights){ 		
		
		var _Room1 = global.Level.Rooms[global.TransitionRoomIndex];
		shader_set_uniform_f(global.uLighting_RoomBoundary[1], _Room1.x, _Room1.y, _Room1.x2, _Room1.y2);
		shader_set_uniform_f(global.uLighting_RoomRGB[1], _BaseRGB[0], _BaseRGB[1], _BaseRGB[2], 1.0);

		shader_set_uniform_f_array(global.uLighting_LightArray_Pos[1], _Room1.Lights_Pos);
		shader_set_uniform_f_array(global.uLighting_LightArray_RGB[1], _Room1.Lights_RGB);	
	
	}	
	
	//Palette
	
	//to do, looks like a lot of this can be pre-calculated
	
	shader_set_uniform_i(global.uPaletteStatus, _DoPalette);
	if(_DoPalette){
	
		var Texture = sprite_get_texture(_PaletteSpr, 0), 
			UVs = sprite_get_uvs(_PaletteSpr, 0);
    
		texture_set_stage(global.uPalette_Texture, Texture);
    
		var TexelW = texture_get_texel_width(Texture),
		    TexelH = texture_get_texel_height(Texture),
		    TexelWx = TexelW * 0.5,
		    TexelHy = TexelH * 0.5;
    
		shader_set_uniform_f(global.uPalette_PixelSize, TexelW, TexelH);
		shader_set_uniform_f(global.uPalette_Uvs, UVs[0] + TexelWx, UVs[1] + TexelHy, UVs[2], UVs[3]);
		shader_set_uniform_f(global.uPalette_Index, _PaletteIndex);
	}

	//Color
	shader_set_uniform_i(global.uColor_Status, _DoColor);
	if(_DoColor) shader_set_uniform_f(global.uColor_Tint, _Color[0], _Color[1], _Color[2], 1.0);

			
}

function Lighting_UpdateLinkLight(_Pos = -1, _Radius = -1, _RGB = -1){

	if(_Pos != -1){
		global.LinkLight_Pos[0] = _Pos[0];
		global.LinkLight_Pos[1] = _Pos[1];
	}
	
	if(_Radius != -1){
		global.LinkLight_Pos[2] = _Radius;
	}

	if(_RGB != -1){
		global.LinkLight_RGB[0] = _RGB[0];
		global.LinkLight_RGB[1] = _RGB[1];
		global.LinkLight_RGB[2] = _RGB[2];
	}
	
}

function Lighting_UpdateLight_Pos(_RoomIndex, _LightIndex, _x, _y){
	
	if(_LightIndex == -1) exit;
	
	var _ArrayPos = _LightIndex * 3;
	
	Room.Lights_Pos[_ArrayPos] = _x;
	Room.Lights_Pos[_ArrayPos + 1] = _y;
	
}

function Lighting_UpdateLight_RGB(_RoomIndex, _LightIndex, _RGB){
	
	if(_LightIndex == -1) exit;
	
	var _ArrayPos = _LightIndex * 3;
	
	Room.Lights_RGB[_ArrayPos] = _RGB[0];
	Room.Lights_RGB[_ArrayPos + 1] = _RGB[1];
	Room.Lights_RGB[_ArrayPos + 2] = _RGB[2];
	
	Room.Lights_RGBOld[_ArrayPos] = _RGB[0];
	Room.Lights_RGBOld[_ArrayPos + 1] = _RGB[1];
	Room.Lights_RGBOld[_ArrayPos + 2] = _RGB[2];
	
}

function Lighting_UpdateLight_Radius(_RoomIndex, _LightIndex, _Radius){
	
	if(_LightIndex == -1) exit;
	
	var _ArrayPos = _LightIndex * 3;
	Room.Lights_Pos[_ArrayPos + 2] = _Radius;
	
}

function Lighting_UpdateLight_Visible(_RoomIndex, _LightIndex, _Status){
	
	if(_LightIndex == -1) exit;
	
	var _ArrayPos = _LightIndex * 3;
	
	if(_Status){
		Room.Lights_RGB[_ArrayPos] = Room.Lights_RGBOld[_ArrayPos];
		Room.Lights_RGB[_ArrayPos + 1] = Room.Lights_RGBOld[_ArrayPos + 1];
		Room.Lights_RGB[_ArrayPos + 2] = Room.Lights_RGBOld[_ArrayPos + 2];	
	}else{
		Room.Lights_RGB[_ArrayPos] = 0.0;
		Room.Lights_RGB[_ArrayPos + 1] = 0.0;
		Room.Lights_RGB[_ArrayPos + 2] = 0.0;	
	}
	
}

function PixelRender_Tiles_Ceiling(){
	if(event_type == ev_draw && event_number == 0){
		PixelRender(true, false, false, noone, 0, false, 0, [0.15, 0.15, 0.15]);
	}
}

function PixelRender_Tiles_Simple(){
	
	if(event_type == ev_draw && event_number == 0){
		
		with(oDoor){
			if(FloorLight == -1) continue;
			Lighting_UpdateLight_Visible(RoomIndex, FloorLight, false);
		}
		
		PixelRender(true, true, false, noone, 0, false, []);
		
		with(oDoor){
			if(FloorLight == -1) continue;
			if(Status == DoorStatus.Open || Status == DoorStatus.ClosedHalf || Status == DoorStatus.Secret_Open) 
				Lighting_UpdateLight_Visible(RoomIndex, FloorLight, true);
		}
		
	}
}

function PixelRender_Tiles_Floor_Upper(){
	
	if(event_type == ev_draw && event_number == 0){
		
		with(oDoor){
			if(FloorLight == -1) continue;
			if(Status == DoorStatus.Open || Status == DoorStatus.ClosedHalf || Status == DoorStatus.Secret_Open) 
				Lighting_UpdateLight_Visible(RoomIndex, FloorLight, true);	
		}
		
		var _LinkExists = instance_exists(oLink);
		if(_LinkExists) Lighting_UpdateLinkLight(,, [oLink.LampLightR * oLink.LampDim, oLink.LampLightG * oLink.LampDim, oLink.LampLightB * oLink.LampDim]);

		with(oTorch){
			if(FloorLevel == LOWER && (Lit || Lighting)){
				Lighting_UpdateLight_Visible(RoomIndex, LightIndex, false);	
			}
		}
		
		with(oProjectile){
			if(LightIndex == -1) continue;
			if(FloorLevel == LOWER){
				Lighting_UpdateLight_Visible(RoomIndex, LightIndex, false);	
			}			
		}
		
		with(oEffects){
			if(LightIndex == -1) continue;
			if(FloorLevel == LOWER){
				Lighting_UpdateLight_Visible(RoomIndex, LightIndex, false);	
			}			
		}
		
		PixelRender(true, true, false, noone, 0, false, []);
		
		if(_LinkExists) Lighting_UpdateLinkLight(,, [oLink.LampLightR, oLink.LampLightG, oLink.LampLightB]);

		with(oEffects){
			if(LightIndex == -1) continue;
			if(FloorLevel == LOWER){
				Lighting_UpdateLight_Visible(RoomIndex, LightIndex, true);	
			}			
		}
		
		with(oProjectile){
			if(LightIndex == -1) continue;
			if(FloorLevel == LOWER){
				Lighting_UpdateLight_Visible(RoomIndex, LightIndex, true);	
			}			
		}
		
		with(oTorch){
			if(FloorLevel == LOWER && (Lit || Lighting)){
				Lighting_UpdateLight_Visible(RoomIndex, LightIndex, true);	
			}
		}
		
		with(oDoor){
			if(FloorLight == -1) continue;
			Lighting_UpdateLight_Visible(RoomIndex, FloorLight, false);
		}
	}
}

function PixelRender_Tiles_Floor_Lower(){
	if(event_type == ev_draw && event_number == 0){
		
		with(oDoor){
			if(FloorLight == -1) continue;
			if(Status == DoorStatus.Open || Status == DoorStatus.ClosedHalf || Status == DoorStatus.Secret_Open) 
				Lighting_UpdateLight_Visible(RoomIndex, FloorLight, true);	
		}
		
		PixelRender(true, true, false, noone, 0, false, []);	
		
		with(oDoor){
			if(FloorLight == -1) continue;
			Lighting_UpdateLight_Visible(RoomIndex, FloorLight, false);
		}
		
	}
}

function PixelRender_Tiles_End(){
	if(event_type == ev_draw && event_number == 0){
		shader_reset();
	}
}

function PixelRender_Normal(){
	
	PixelRender_Dim(true, true, false, noone, 0, false, []);

	draw_self();

	shader_reset();	
	
}

function Mosaic(_MosaicType){

	global.MosaicDo = true;
	global.Paused = true;
	oRender.Mosaic_Type = _MosaicType;
	oRender.Mosaic_SizeIndex = 0;
	
	switch(_MosaicType){
		case MosaicType.Warp:
			oRender.Mosaic_Speed = 0.125;
			oRender.Mosaic_Warp = true;
			
			break;
			
		case MosaicType.Shock:
			oRender.Mosaic_Speed = 0.65;
			
			break;
		
	}	
	
}