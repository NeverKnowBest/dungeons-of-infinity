for(var _ClassIndex = 0; _ClassIndex < RoomTemplateClasses; _ClassIndex++){
			
	global.Templates_Room[_ClassIndex] = Array_Create2D(0, RoomTemplateClassData[_ClassIndex].SubClasses);		//all templates are held in here
	global.Templates_Room_Count[_ClassIndex] = array_create(RoomTemplateClassData[_ClassIndex].SubClasses);			//count for each subclass
	global.RoomTemplateSectionLayerIndex[_ClassIndex] = array_length(global.RoomTemplateObjTypes[_ClassIndex]) + 1  //layer index where the section layer is
			
	var _Filename = "C:\\Omnitron\\Zelda\\Room Templates\\Room Templates " + RoomTemplateClassData[_ClassIndex].File + ".json";
	var _Buffer = buffer_load(_Filename);
	RoomTemplates_Parse(_ClassIndex, _Buffer);
	buffer_delete(_Buffer);
	_Buffer = -1;
			
}
		

JSON_Save("C:\\Omnitron\\Zelda\\Project Files\\datafiles\\Data\\data_r", global.Templates_Room);

game_end();