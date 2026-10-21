
global.CatacombGraveHeadings =	[	"My body below, rests cold and still, and some day too, yours surely will.",
									"Death is a debt to nature due,\\which I have paid...\\and now must you!",
									"Weep not for me, for soon I will be back for thee.",
									"If this stone you stop to read, the corpse below on you will feed.",
									"As you are, I once was. As I am, you will be.",
									"^I'm watching you.",
									"^I see dead people.",
									"^I know what you did."
									//dont' add any more until you can test if adding more dialogue won't upset the save file
									//"^Stinks down here.",
									//"^I've got a bone to pick with you!",
									//"^It's dark down here.",
									//"^Expired meat"
								]

								
function SignCreate(_x, _y, _Text, _Hidden = false){
	
	var _SignInst = instance_create_layer(_x, _y, "Objs_" + GetFloorLevelString(_x, _y), oSign);
	_SignInst.Dialogue = _Text;
	_SignInst.DB_Script[# 1, 0] = _SignInst.Dialogue;
	_SignInst.Hidden = _Hidden;
	if(_Hidden){
		instance_destroy(_SignInst.WallObj);
		_SignInst.WallObj = noone;
	}
}
	