


Template_InitData();
instance_create_layer(432, 16, "Template", oTemplate);

var ButtonBlockX = (view_xport[1] / 2);
var ButtonBlockY = 3;

btn_Template_EditDone = CreateButton(ButtonBlockX, ButtonBlockY, false, "Edit Done", fnt_button);

var ButtonBlockX = 5;
btn_Template_11 = CreateButton(ButtonBlockX, ButtonBlockY, false, "1x1", fnt_button); 
btn_Template_12 = CreateButton(ButtonBlockX, ButtonBlockY + 20, false, "1x2", fnt_button); 
btn_Template_21 = CreateButton(ButtonBlockX, ButtonBlockY + 40, false, "2x1", fnt_button); 
btn_Template_22 = CreateButton(ButtonBlockX, ButtonBlockY + 60, false, "2x2", fnt_button); 

var ButtonBlockX = (view_xport[1] / 2);
btn_Template_Prev = CreateButton(ButtonBlockX, ButtonBlockY, false, "<", fnt_button); 
btn_Template_Next = CreateButton(ButtonBlockX + 80, ButtonBlockY, false, ">", fnt_button); 

btn_Template_New = CreateButton(ButtonBlockX + 120, ButtonBlockY, false, "New", fnt_button); 
btn_Template_Del = CreateButton(ButtonBlockX + 172, ButtonBlockY, false, "Del", fnt_button); 

ButtonBlockX = (view_xport[1] / 2) + 230;
ButtonBlockY = 3;
btn_Template_Transf_None = CreateButton(ButtonBlockX, ButtonBlockY, false, "Main", fnt_button); 
chk_Template_Transf_H = CreateButton(ButtonBlockX, ButtonBlockY + 20, true, "H", fnt_button); 
chk_Template_Transf_V = CreateButton(ButtonBlockX, ButtonBlockY + 40, true, "V", fnt_button); 
chk_Template_Transf_HV = CreateButton(ButtonBlockX - 9, ButtonBlockY + 60, true, "HV", fnt_button); 
chk_Template_Transf_CW = CreateButton(ButtonBlockX - 9, ButtonBlockY + 80, true, "CW", fnt_button); 
chk_Template_Transf_CCW = CreateButton(ButtonBlockX - 18, ButtonBlockY + 100, true, "CCW", fnt_button); 

ButtonBlockX += 43;
btn_Template_Transf_H = CreateButton(ButtonBlockX, ButtonBlockY + 20, false, "->", fnt_button); 
btn_Template_Transf_V = CreateButton(ButtonBlockX, ButtonBlockY + 40, false, "->", fnt_button);
btn_Template_Transf_HV = CreateButton(ButtonBlockX, ButtonBlockY + 60, false, "->", fnt_button); 
btn_Template_Transf_CW = CreateButton(ButtonBlockX, ButtonBlockY + 80, false, "->", fnt_button); 
btn_Template_Transf_CCW = CreateButton(ButtonBlockX, ButtonBlockY + 100, false, "->", fnt_button); 

global.DoorCoordinates = json_parse(buffer_read(buffer_load("DoorCoordinates.json"), buffer_string));

global.SectionObjCoordinates = json_parse(buffer_read(buffer_load("SectionObjCoordinates.json"), buffer_string));

global.CurrentTemplate = 0;
global.CurrentTemplateTrans = Transformation.None;
global.CurrentTemplateSizeID = TemplateSize._1x1;

global.Data_RoomTemplates = array_create(4); //template sizes

for(var i = 0; i < 4; i++){ //for every template size, create tranformation arrays
	global.Data_RoomTemplates[i][Transformation.None] = array_create(0);
	global.Data_RoomTemplates[i][Transformation.H] = array_create(0);
	global.Data_RoomTemplates[i][Transformation.V] = array_create(0);
	global.Data_RoomTemplates[i][Transformation.HV] = array_create(0);
	global.Data_RoomTemplates[i][Transformation.CW] = array_create(0);
	global.Data_RoomTemplates[i][Transformation.CCW] = array_create(0);	
}


//var FileBuffer = buffer_load("C:\\Google Drive\\Omnitron Studios\\Zelda\\Code\\datafiles\\RoomTemplates.json")
//if(FileBuffer == -1){
	Template_New(TemplateSize._2x1);

//}else{
//	global.Data_RoomTemplates[global.CurrentTemplateSizeID][Transformation.None] = json_parse(buffer_read(FileBuffer, buffer_string));
//	Template_Load(Transformation.None, global.CurrentTemplate);
//}


global.MsgBoxFlag = false;

MsgBox_Template_Del = noone;

//NewValues = NewTransformPos([24,24,24,24], Transformation.H, TemplateSize._1x1);

var a = 0;
