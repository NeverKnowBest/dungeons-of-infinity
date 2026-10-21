
function PixelRender_Init() {
	
	//Lighting	
	global.uLighting_RoomStatus = shader_get_uniform(shdPixelRender,"RoomLightingStatus");
	global.uLighting_RoomBoundary = shader_get_uniform(shdPixelRender,"RoomLightingBoundary");
	global.uLightingStatus = shader_get_uniform(shdPixelRender,"LightingStatus");
	global.uLightingStatus_Lights = shader_get_uniform(shdPixelRender,"LightingStatus_Lights");
	global.uLighting_Count = shader_get_uniform(shdPixelRender,"LightCount");
	global.uLighting_Light = shader_get_uniform(shdPixelRender,"L");
	global.uLighting_LightParams1 = shader_get_uniform(shdPixelRender,"L_P1");
	global.uLighting_LightParams2 = shader_get_uniform(shdPixelRender,"L_P2");
	global.uLighting_Ambiance = shader_get_uniform(shdPixelRender,"AMB");
	global.uLighting_BaseLight = shader_get_uniform(shdPixelRender,"BaseLight");
	
	//Palette
  	global.uPaletteStatus = shader_get_uniform(shdPixelRender,"PaletteStatus");
	global.uPalette_PixelSize = shader_get_uniform(shdPixelRender, "u_pixelSize");
	global.uPalette_Uvs = shader_get_uniform(shdPixelRender, "u_Uvs");
	global.uPalette_Index = shader_get_uniform(shdPixelRender, "u_paletteId");
	global.uPalette_Texture = shader_get_sampler_index(shdPixelRender, "u_palTexture");

	global.uTransparencyMask_Status = shader_get_uniform(shdPixelRender,"TransparencyMask_Status");
	global.uTransparencyMask_BBox = shader_get_uniform(shdPixelRender,"TransparencyMask_BBox");
	
	global.uSilouetteMask_Status = shader_get_uniform(shdPixelRender,"SilouetteMask_Status");
	global.uSilouetteMask_BBox = shader_get_uniform(shdPixelRender,"SilouetteMask_BBox");
	
	global.uColor_Status = shader_get_uniform(shdPixelRender,"Color_Status");
	global.uColor = shader_get_uniform(shdPixelRender,"Color_Index");
	global.uColor_Tint = shader_get_uniform(shdPixelRender,"Color_Tint");
	global.uTimer = shader_get_uniform(shdPixelRender,"uni_timer");
	
	//when deleting a light, store the old index in this queue so it can be reused for new lights.
	//This is because if we delete the positions in LightingData arrays where the deleted light was, some of the indexes for other lights will be wrong.
	//So we don't delete any array entries, which resizes it, we just clear them and keep track of empty positions
	global.Lighting_UnusedIndexes = ds_queue_create();
		
}

function PixelRender_DataClear(){
	
	global.Lights = 0;
	global.LightingData_RoomStatus = 0;
	global.LightingData_RoomBoundary = 0;
	global.LightingData_Light = 0;
	global.LightingData_LightParams1 = 0;
	global.LightingData_LightParams2 = 0;

	ds_queue_clear(global.Lighting_UnusedIndexes);
	
	global.LightingData_RoomStatus = array_create(2);
	global.LightingData_RoomBoundary = array_create(8); //2 Rooms, 4 coordinates each
	global.LightingData_Light = array_create(0);
	global.LightingData_LightParams1 = array_create(0);
	global.LightingData_LightParams2 = array_create(0);

	Lighting_SetAmbiance(0, 0, 0);

}

function PixelRender_Dim(DoLighting, DoLighting_Lights, DoPalette, PaletteSpr, PaletteIndex, DoTransparency, Area, DoColor, Color){
	
	//Pass-thru function
	//Before rendering obj, Dim Link's lamp render on current obj calling this based on Link's LampDim, which is affected by floor level, jumping, and going up/down stairs 
	if(FloorLevel = UPPER){
		var LampDim = oLink.LampDim + (oLink.z * 0.01);
		Lighting_UpdateLightCol(oLink.LampLightID, oLink.LampLightR * LampDim, oLink.LampLightG * LampDim, oLink.LampLightB * LampDim);		
		PixelRender(DoLighting, DoLighting_Lights, DoPalette, PaletteSpr, PaletteIndex, DoTransparency, Area, DoColor, Color);	
		Lighting_UpdateLightCol(oLink.LampLightID, oLink.LampLightR, oLink.LampLightG, oLink.LampLightB);
	}else PixelRender(DoLighting, DoLighting_Lights, DoPalette, PaletteSpr, PaletteIndex, DoTransparency, Area, DoColor, Color);

}

function PixelRender(DoLighting, DoLighting_Lights, DoPalette, PaletteSpr, PaletteIndex, DoTransparency, Area, DoColor, Color){
	
	shader_set(shdPixelRender);
		
	//Lighting
	shader_set_uniform_f_array(global.uLighting_RoomStatus, global.LightingData_RoomStatus);
	shader_set_uniform_f_array(global.uLighting_RoomBoundary, global.LightingData_RoomBoundary);
	
	shader_set_uniform_f(global.uLightingStatus, global.Lighting && DoLighting ? 1.0 : 0.0);
	shader_set_uniform_f(global.uLightingStatus_Lights, DoLighting_Lights ? 1.0 : 0.0);
		
	shader_set_uniform_f(global.uLighting_Ambiance, global.Lighting_AmbianceR, global.Lighting_AmbianceG, global.Lighting_AmbianceB);
	shader_set_uniform_i(global.uLighting_Count, global.Lights);	
	if(global.Lights > 0){
		shader_set_uniform_f_array(global.uLighting_Light, global.LightingData_Light);
		shader_set_uniform_f_array(global.uLighting_LightParams1, global.LightingData_LightParams1);
		shader_set_uniform_f_array(global.uLighting_LightParams2, global.LightingData_LightParams2);
	}
	
	shader_set_uniform_f(global.uLighting_BaseLight, Pendant_Check(Pendant.Vision) && object_get_parent(object_index) == oEnemy ? 0.25 : 0.0185);
	
	//Palette
	shader_set_uniform_f(global.uPaletteStatus, DoPalette ? 1.0 : 0.0);
	if(DoPalette){
	
		var Texture = sprite_get_texture(PaletteSpr, 0), 
			UVs = sprite_get_uvs(PaletteSpr, 0);
    
		texture_set_stage(global.uPalette_Texture, Texture);
    
		var TexelX = texture_get_texel_width(Texture),
		    TexelY = texture_get_texel_height(Texture),
		    TexelHx = TexelX * 0.5,
		    TexelHy = TexelY * 0.5;
    
		shader_set_uniform_f(global.uPalette_PixelSize, TexelX, TexelY);
		shader_set_uniform_f(global.uPalette_Uvs, UVs[0] + TexelHx, UVs[1] + TexelHy, UVs[2], UVs[3]);
		shader_set_uniform_f(global.uPalette_Index, PaletteIndex);
	}
	
	//Transparency
	shader_set_uniform_f(global.uTransparencyMask_Status, DoTransparency ? 1.0 : 0.0);
	if(DoTransparency)// && Inst != noone)
		shader_set_uniform_f(global.uTransparencyMask_BBox, Area[0], Area[1], Area[2], Area[3]);
	
	//Silouette
	//shader_set_uniform_f(global.uSilouetteMask_Status, true ? 1.0 : 0.0);
	//if(DoTransparency)// && Inst != noone)
	//	shader_set_uniform_f(global.uSilouetteMask_BBox, Area[0], Area[1], Area[2], Area[3]);
		
	//Color
	shader_set_uniform_f(global.uColor_Status, DoColor ? 1.0 : 0.0);
	if(DoColor)	shader_set_uniform_f(global.uColor_Tint, Color[0], Color[1], Color[2], 1.0);

}

function Lighting_CreateLight(_x, _y, _r, _g, _b, _strength, _status) {
	
	var LightIndex = ds_queue_dequeue(global.Lighting_UnusedIndexes);
	if(LightIndex == undefined){
		
		global.Lights++;

		array_resize(global.LightingData_Light, global.Lights * 2);
		array_resize(global.LightingData_LightParams1, global.Lights * 3);
		array_resize(global.LightingData_LightParams2, global.Lights * 4);
	
		LightIndex = global.Lights - 1;
		
	}
	
	Lighting_UpdateLightPos(LightIndex, _x, _y);
	Lighting_UpdateLightCol(LightIndex, _r, _g, _b);
	Lighting_UpdateLightStrength(LightIndex, _strength);
	Lighting_UpdateLightStatus(LightIndex, _status);
	
	Lighting_UpdateInRoom(LightIndex);
	
	return LightIndex;

}

function Lighting_DestroyLight(LightIndex){
	
	//reminder to set the object's lightindex back to -1 after you destroy the light if the object doesn't also get destroyed
	if(LightIndex == -1) exit;
	
	Lighting_UpdateLightStatus(LightIndex, false);
	
	ds_queue_enqueue(global.Lighting_UnusedIndexes, LightIndex);
	
}

function Lighting_UpdateLightStatus(LightIndex, _status){
	
	if(LightIndex == -1) exit;
	
	var ShaderDataArrayPos = LightIndex * 4;
	global.LightingData_LightParams2[ShaderDataArrayPos + 3] = _status; 
	
}

function Lighting_UpdateLightPos(LightIndex, _x, _y){
	
	if(LightIndex == -1) exit;
	
	var ShaderDataArrayPos = LightIndex * 2;
	global.LightingData_Light[ShaderDataArrayPos] = _x; 
	global.LightingData_Light[ShaderDataArrayPos + 1] = _y; 
	
}
function Lighting_UpdateLightCol(LightIndex, _r, _g, _b){
	
	if(LightIndex == -1) exit;
	
	var ShaderDataArrayPos = LightIndex * 3;
	global.LightingData_LightParams1[ShaderDataArrayPos] = _r; 
	global.LightingData_LightParams1[ShaderDataArrayPos + 1] = _g;
	global.LightingData_LightParams1[ShaderDataArrayPos + 2] = _b; 
	
}

function Lighting_UpdateLightStrength(LightIndex, _strength){
	
	if(LightIndex == -1) exit;
	
	var ShaderDataArrayPos = LightIndex * 4;
	global.LightingData_LightParams2[ShaderDataArrayPos] = _strength; 
	
}

function Lighting_UpdateLightInRoomStatus(LightIndex, InRoom0, InRoom1){
	
	if(LightIndex == -1) exit;
	
	var ShaderDataArrayPos = LightIndex * 4;
	global.LightingData_LightParams2[ShaderDataArrayPos + 1] = InRoom0; 
	global.LightingData_LightParams2[ShaderDataArrayPos + 2] = InRoom1; 
	
}
function Lighting_UpdateInRoom(LightIndex){
	
	if(LightIndex == -1) exit;
	
	var Lx = global.LightingData_Light[LightIndex * 2];
	var Ly = global.LightingData_Light[(LightIndex * 2) + 1];
	var InRoom0 = (Lx >= global.LightingData_RoomBoundary[0] && Lx <= global.LightingData_RoomBoundary[2] && Ly >= global.LightingData_RoomBoundary[1] && Ly <= global.LightingData_RoomBoundary[3]);
	var InRoom1 = (Lx >= global.LightingData_RoomBoundary[4] && Lx <= global.LightingData_RoomBoundary[6] && Ly >= global.LightingData_RoomBoundary[5] && Ly <= global.LightingData_RoomBoundary[7]);
	
	if(global.Level.Index == DungeonLevel.Start)
		Lighting_UpdateLightInRoomStatus(LightIndex, true, true);
	else
		Lighting_UpdateLightInRoomStatus(LightIndex, InRoom0, InRoom1);
	
}
function Lighting_UpdateInRooms(){
	for(var LightIndex = 0; LightIndex < global.Lights; LightIndex++){
		Lighting_UpdateInRoom(LightIndex);
	}
}

function Lighting_SetRoomData(_RoomIndex, _InRoomID){


	global.LightingData_RoomStatus[_InRoomID] = Room.Lighting;
	var _IndexStart = (_InRoomID * 4);
	global.LightingData_RoomBoundary[_IndexStart] = DungeonRoom.x;
	global.LightingData_RoomBoundary[_IndexStart + 1] = DungeonRoom.y;
	global.LightingData_RoomBoundary[_IndexStart + 2] = DungeonRoom.x + DungeonRoom.width;
	global.LightingData_RoomBoundary[_IndexStart + 3] = DungeonRoom.y + DungeonRoom.height;
			
	Lighting_UpdateInRooms();
	
}

function Lighting_SetAmbiance(_r, _g, _b) {
	global.Lighting_AmbianceR = _r;
	global.Lighting_AmbianceG = _g;
	global.Lighting_AmbianceB = _b;
}


function PixelRender_Tiles_Ceiling(){
	if(event_type == ev_draw && event_number == 0){
		var OldAmbR = global.Lighting_AmbianceR;
		var OldAmbG = global.Lighting_AmbianceG;
		var OldAmbB = global.Lighting_AmbianceB;
		Lighting_SetAmbiance(0.2, 0.2, 0.2);
		PixelRender(true, false, false, noone, 0, false, noone, false, []);
		global.Lighting_AmbianceR = OldAmbR;
		global.Lighting_AmbianceG = OldAmbG;
		global.Lighting_AmbianceB = OldAmbB;
	}
}


function PixelRender_Tiles_Simple(){
	if(event_type == ev_draw && event_number == 0){
		with(oDoor) Lighting_UpdateLightStatus(FloorLight, false);
		PixelRender(true, true, false, noone, 0, false, noone, false, []);
		with(oDoor){ if(Status == DoorStatus.Open || Status == DoorStatus.ClosedHalf ||Status == DoorStatus.Secret_Open) Lighting_UpdateLightStatus(FloorLight, true); }
	}
}


function PixelRender_Tiles_Floor_Upper(){
	if(event_type == ev_draw && event_number == 0){
		with(oDoor){ if(Status == DoorStatus.Open || Status == DoorStatus.ClosedHalf || Status == DoorStatus.Secret_Open) Lighting_UpdateLightStatus(FloorLight, true); }
			
		Lighting_UpdateLightCol(oLink.LampLightID, oLink.LampLightR * oLink.LampDim, oLink.LampLightG * oLink.LampDim, oLink.LampLightB * oLink.LampDim);	
		with(oTorch){
			if(FloorLevel == LOWER && (Lit || Lighting)) Lighting_UpdateLightStatus(LightIndex, false);
		}
		PixelRender(true, true, false, noone, 0, false, noone, false, []);	
		Lighting_UpdateLightCol(oLink.LampLightID, oLink.LampLightR, oLink.LampLightG, oLink.LampLightB);
		with(oTorch){
			if(FloorLevel == LOWER && (Lit || Lighting)) Lighting_UpdateLightStatus(LightIndex, true);
		}
		with(oDoor) Lighting_UpdateLightStatus(FloorLight, false);
	}
}


function PixelRender_Tiles_Floor_Lower(){
	if(event_type == ev_draw && event_number == 0){
		with(oDoor){ if(Status == DoorStatus.Open || Status == DoorStatus.ClosedHalf || Status == DoorStatus.Secret_Open) Lighting_UpdateLightStatus(FloorLight, true); }
		PixelRender(true, true, false, noone, 0, false, noone, false, []);	
		with(oDoor) Lighting_UpdateLightStatus(FloorLight, false);
	}
}

function PixelRender_Tiles_End(){
	if(event_type == ev_draw && event_number == 0){
		shader_reset();
	}
}