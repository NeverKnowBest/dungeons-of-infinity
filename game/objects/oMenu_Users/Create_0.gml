Users[0] = "Ophelius"
Users[1] = "Link"
Users[2] = "Riley"
Users[3] = "Ganon"
Users[4] = ""
UserCount = array_length(Users);
UserIndex = 0;

var i = 0;
for(var i = 0; i < UserCount; i++){
	Menu[MenuID.NameSelect][i] = Users[i];
}
Menu[MenuID.NameSelect][i] = "Exit";
MenuCount[MenuID.NameSelect] = array_length(Menu[MenuID.NameSelect]);


var i = 0;
Menu[MenuID.NewGame][i++] = "New Game"
Menu[MenuID.NewGame][i++] = "Continue"
Menu[MenuID.NewGame][i++] = "Options"
Menu[MenuID.NewGame][i++] = "Stats"
Menu[MenuID.NewGame][i++] = "Back"
MenuCount[MenuID.NewGame] = array_length(Menu[MenuID.NewGame]);


Menu_Index = MenuID.NameSelect;

Selector_X = x + 12;
Selector_Y = y + 16;
Selector_Index = 0;