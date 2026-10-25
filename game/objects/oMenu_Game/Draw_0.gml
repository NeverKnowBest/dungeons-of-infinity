
draw_set_alpha(Alpha / 2.2);
draw_set_color(#000000);
draw_rectangle(oCamera.X, oCamera.Y, oCamera.X + CAM_W - 1, oCamera.Y + CAM_H - 1, false);

draw_set_alpha(Alpha);
draw_set_color(#FFFFFF);

draw_sprite_stretched(sprite_index, 0, FrameX, FrameY, FrameW, FrameH);

var _Page = Menu_ActiveIndex;
var _Config = Menu_Config[_Page];
var _Centered = _Config[$ "Centered"] ?? false;
var _Changed = Menu_HasChanges(_Page);
// The frame's border is 15px on every side (nine-slice), so values and scroll arrows stay a few pixels inside it
var _ValueRight = FrameX + FrameW - 20;

// Pages can use the title menu's small row font (the Sanctuary challenges page), with labels at LabelX
var _RowFont = Menu_Font[_Page];
var _SmallRows = _RowFont != global.MenuFont;
var _LabelX = _Config[$ "LabelX"] ?? 20;
var _TextOffY = Menu_TextOffsetY[_Page];

// Page title (the quit prompt, "Options", "Cheats"...), flagged while there are unsaved changes.
// A selected row with a Title function replaces it (e.g. "3 hearts" on the challenges page)
var _Title = Menu_Title[_Page];
var _SelRow = Menu_Count[_Page] > 0 ? Menu[_Page][SelectorPos] : undefined;
if(_SelRow != undefined && _SelRow.Title != undefined) _Title = _SelRow.Title(_SelRow);
if(_Title != ""){
	draw_set_font(global.MenuFont);
	draw_set_halign(fa_center);
	draw_text(FrameCentre, FrameY + (_Config[$ "TitleY"] ?? 8), _Changed ? _Title + " (unsaved)" : _Title);
}

// Extra drawing for the whole page (e.g. a statue's tier and progress)
if(variable_struct_exists(_Config, "OnDrawPage")) _Config.OnDrawPage();

var _LastRowY = FrameY;
for(var i = 0; i < Menu_Count[_Page]; i++){

	if(!Menu_IsRowVisible(_Page, i)) continue;

	var _Row = Menu[_Page][i];
	var _Text = Menu_RowLabel(_Row, _Changed);
	// Sanctuary menu rows can compute their label (e.g. "???" while locked) and gray themselves out
	if(variable_struct_exists(_Row, "LabelFn")) _Text = _Row.LabelFn(_Row);
	var _Locked = variable_struct_exists(_Row, "LockedFn") && _Row.LockedFn(_Row);
	var _TextY = FrameY + Menu_RowY(_Page, i);
	_LastRowY = _TextY;

	draw_set_font(_SmallRows ? _RowFont : global.MenuFont_Innactive);
	var _TextW = string_width(_Text);
	var _TextH = string_height(_Text);

	var _TextX, _SelectorX;
	if(_Centered){
		draw_set_halign(fa_center);
		_TextX = FrameCentre;
		_SelectorX = FrameCentre - (_TextW / 2) - 2;
	}else{
		draw_set_halign(fa_left);
		_TextX = FrameX + _LabelX;
		_SelectorX = FrameX + _LabelX - 2;
	}

	if(i == SelectorPos){
		draw_set_color(#284028);
		if(!_SmallRows) draw_set_font(global.MenuFont);
		draw_rectangle(_SelectorX, _TextY + _TextOffY - 2, _SelectorX + _TextW + 3, _TextY + _TextOffY + _TextH - (_SmallRows ? 2 : 0), false);
	}

	draw_set_color(_Locked ? #707070 : #FFFFFF);
	draw_text(_TextX, _TextY + _TextOffY, _Text);
	draw_set_font(global.MenuFont);
	draw_set_halign(fa_left);
	draw_set_color(#FFFFFF);
	
	// Value text on the right edge (e.g. a challenge level), and any extra drawing of the row (icons, previews)
	if(variable_struct_exists(_Row, "ValueFn")){
		draw_set_halign(fa_right);
		draw_text(_ValueRight, _TextY, _Row.ValueFn(_Row));
		draw_set_halign(fa_left);
	}
	if(_Row.OnDraw != undefined) _Row.OnDraw(_Row, FrameX, _TextY, _ValueRight);

	// Toggles and sliders: value on the right edge, greyed out when off
	if(Menu_RowHasValue(_Row)){
		if(!_Row.Slider && !_Row.Get(_Row)){
			draw_set_font(global.MenuFont_Innactive);
			draw_set_color(#404040);
		}
		Menu_DrawRowValue(_Row, _TextX + _TextW, _ValueRight, _TextY);
	}

	draw_set_color(#FFFFFF);

}

Menu_DrawScrollArrows(_Page, _ValueRight - 4, FrameY + Menu_RowY(_Page, Menu_Scroll[_Page]), _LastRowY + 18);

draw_set_font(global.Font_Small);
draw_set_halign(fa_center);
draw_set_color(#AAAAAA);
if(Mode == "Pause"){
	if(!global.HubLevel){
		draw_text(FrameCentre, PlayTimeY, "PLAYING TIME");
		draw_text(FrameCentre, PlayTimeY + 8, TimePlayed);
	}
}else{
	// Sanctuary menus: a hint about the selected row (what unlocks it, what it does)
	var _Sel = Menu[_Page][SelectorPos];
	if(variable_struct_exists(_Sel, "HintFn")) draw_text_ext(FrameCentre, PlayTimeY - 4, string_upper(_Sel.HintFn(_Sel)), 9, FrameW - 32);
}
draw_set_halign(fa_left);

draw_set_color(#FFFFFF);

draw_set_alpha(1);
