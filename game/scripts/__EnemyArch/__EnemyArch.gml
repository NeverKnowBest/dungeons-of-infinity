// Enemy archetypes and per-level variants (roadmap F7).
//
// ARCHETYPES: a simple enemy is data. Its object has oEnemy_Archetype as parent and no events of its own; what it does
// is its entry in global.EnemyArch (EnemyArch_Init below, one EnemyArch(object, {...}) call). The events of
// oEnemy_Archetype and the hooks in Enemy_UpdateState / Enemy_UpdateSprite run the entry. Bosses and enemies with a
// mechanic of their own keep their own code. Recipe: docs/dev/receitas.md ("Inimigo novo por arquétipo").
//
// Entry fields (all optional except States):
//   Vars		instance variables set in Create, after oEnemy's: {Size: EnemySize.Tiny, WalkSpeed: 1.5, CheckForWater: true}.
//				A list is picked from with choose; a function is called on the instance (function(){ return sprite_width - 4; })
//   StartDir	"Random": a random Dir before the first state
//   Start		states it may start in, one picked with choose (default: the first state of States)
//   States		[[EnemyState.X, {state fields}], ...] what each state does (below). A state not listed is oEnemy's
//   Recover	state it goes to when a knockback or a stun ends (undefined: none, like the Hover)
//   Sprites	[[EnemyState.X, "sEnemy_Rat_Walk"], ...] sprite of a state; when sEnemy_Rat_Walk_Left/_Right/_Up/_Down exist,
//				one per Dir. A state not listed keeps the sprite it has
//   Palette	palette sprite (*_Pal) for the palette shader, picked by ColorIndex (set ColorIndex in a variant, below)
//   Shadow		shadow sprite drawn under it (default noone)
//   Flip		true: FacingDir is -1 or 1 (random at first) and the sprite is drawn mirrored when it is -1
//   InWaterW	width of the water ripple by Dir: [left and right, up and down] (a single width goes in Vars, InWaterSprW)
//   StayOnWater	never leaves the water tiles; the room generator only places it on water
//   Trap		can be used in trap rooms (default true; false for small weak enemies)
//   Flies, Jumps, Hides	what Enemy_CanFly, Enemy_CanJump and Enemy_CanBeHidden answer (default false)
//
// State fields:
//   Time		[min, max] frames until alarm 0 ends the state (irandom_range); TimeChoose [a, b, ...] picks one instead
//   Next		states alarm 0 picks from (choose) when Time is up. Without Next the state goes on with a new move
//   Move		how it moves in the state (none: it stands still)
//		"Dir"		straight in one of the 4 directions at WalkSpeed (RunSpeed when Running): a random one on entering,
//					a new one at each wall (Enemy_WallCollisionNewDir) and each Time (rat, rope)
//		"Toward"	like "Dir", but the direction on entering and at each Time faces Link (a chaser)
//		"Scuttle"	sideways like a crab: a random direction, Side times Speed on the horizontal, Speed on the vertical,
//					either way along it, animation at SideImageSpeed or UpDownImageSpeed. Bounces off walls when
//					Vars has WallCollide_Bounce
//		"Dash"		a dash at Speed_Initial towards Link (anywhere with the Cape), slowing down by one of Slowdown each
//					frame; when it stops, the state goes to Next (hover)
//   ImageSpeed	animation speed set when the move starts
//
// Variables the moves use: WalkSpeed, RunSpeed, Speed (Scuttle), Speed_Initial and SlowdownSpeed (Dash), FacingDir
// (Flip), TMID (StayOnWater). Create sets only what the entry asks for, so a converted enemy has the same variables
// as before.
//
// VARIANTS: what an enemy changes from level to level (colour, energy, attack, sprites, soldier head and weapon).
// EnemyVariant(object, default, [[level, {...}], ...]) in EnemyVariants_Init. An enemy takes the variant of its level
// in this order: the level sheet's own (LevelDef.EnemyVariants, {oEnemy_X: {...}}), the one listed for the level
// LevelDef.EnemyStats points at, and the default. So any level can have any enemy with a variant.
// Variant fields are instance variables (ColorIndex, Attack, HeadIndex...), except:
//   Energy		energy index (Enemy_SetEnergy)
//   Sprites	archetypes only: replaces the entry's Sprites (same form)
// A list is picked from with choose (HeadIndex: [SoldierHead.Pig, SoldierHead.Demon]). Fields are set in name order.
// An archetype applies its variant in Create, after Vars; other enemies call Enemy_ApplyVariant() themselves.

#macro Arch global.EnemyArch[object_index]

/// The archetype entry of an object, or undefined
function EnemyArch_Get(_Obj){
	if(_Obj < 0 || _Obj >= array_length(global.EnemyArch)) return undefined;
	var _A = global.EnemyArch[_Obj];
	return is_struct(_A) ? _A : undefined;
}

/// choose() over a list, with the same random draws as writing choose(a, b, c) (a list of one draws nothing)
function EnemyArch_Choose(_List){
	var _N = array_length(_List);
	switch(_N){
		case 1: return _List[0];
		case 2: return choose(_List[0], _List[1]);
		case 3: return choose(_List[0], _List[1], _List[2]);
		case 4: return choose(_List[0], _List[1], _List[2], _List[3]);
		case 5: return choose(_List[0], _List[1], _List[2], _List[3], _List[4]);
		case 6: return choose(_List[0], _List[1], _List[2], _List[3], _List[4], _List[5]);
		case 7: return choose(_List[0], _List[1], _List[2], _List[3], _List[4], _List[5], _List[6]);
		case 8: return choose(_List[0], _List[1], _List[2], _List[3], _List[4], _List[5], _List[6], _List[7]);
	}
	return _List[irandom(_N - 1)];
}

/// A data value for the calling instance: a list is picked from, a function is called on the instance
function EnemyArch_Value(_V){
	if(is_array(_V)) return EnemyArch_Choose(_V);
	if(is_method(_V)) return method(id, _V)();
	return _V;
}

/// [[state, "sprite base"], ...] to an array by state of a sprite, or of [_, up, down, left, right] by Dir
function EnemyArch_ResolveSprites(_List, _Where){
	var _Out = array_create(EnemyState.Killed + 1, undefined);	// holes would be 0, which is a sprite
	for(var i = 0; i < array_length(_List); i++){
		var _Name = _List[i][1];
		var _Dirs = [-1, asset_get_index(_Name + "_Up"), asset_get_index(_Name + "_Down"), asset_get_index(_Name + "_Left"), asset_get_index(_Name + "_Right")];
		if(sprite_exists(_Dirs[UP]) && sprite_exists(_Dirs[DOWN]) && sprite_exists(_Dirs[LEFT]) && sprite_exists(_Dirs[RIGHT])) _Out[_List[i][0]] = _Dirs;
		else{
			var _Spr = asset_get_index(_Name);
			if(!sprite_exists(_Spr)) Error(_Where + ": no sprite " + _Name + " (nor its _Left/_Right/_Up/_Down)");
			_Out[_List[i][0]] = _Spr;
		}
	}
	return _Out;
}

/// Registers an archetype enemy (fields at the top of this file)
function EnemyArch(_Obj, _Def){
	var _Name = object_get_name(_Obj);
	if(object_get_parent(_Obj) != oEnemy_Archetype) Error(_Name + ": an archetype enemy needs oEnemy_Archetype as its parent");
	var _States = [];
	for(var i = 0; i < array_length(_Def.States); i++){
		var _S = _Def.States[i][1];
		var _Fields = ["Move", "Next", "Time", "TimeChoose", "ImageSpeed"];
		for(var j = 0; j < array_length(_Fields); j++){
			if(!variable_struct_exists(_S, _Fields[j])) _S[$ _Fields[j]] = (_Fields[j] == "Move" ? "" : undefined);
		}
		_States[_Def.States[i][0]] = _S;
	}
	var _A = {
		Name: _Name,
		Vars: _Def[$ "Vars"] ?? {},
		StartDir: _Def[$ "StartDir"] ?? "",
		Start: _Def[$ "Start"] ?? [_Def.States[0][0]],
		States: _States,
		Recover: _Def[$ "Recover"] ?? undefined,
		Sprites: EnemyArch_ResolveSprites(_Def[$ "Sprites"] ?? [], _Name),
		Palette: _Def[$ "Palette"] ?? noone,
		Shadow: _Def[$ "Shadow"] ?? noone,
		Flip: _Def[$ "Flip"] ?? false,
		InWaterW: _Def[$ "InWaterW"] ?? undefined,
		StayOnWater: _Def[$ "StayOnWater"] ?? false,
		Trap: _Def[$ "Trap"] ?? true,
		Flies: _Def[$ "Flies"] ?? false,
		Jumps: _Def[$ "Jumps"] ?? false,
		Hides: _Def[$ "Hides"] ?? false,
		Dash: false
	};
	for(var i = 0; i < array_length(_States); i++){
		if(is_struct(_States[i]) && _States[i].Move == "Dash") _A.Dash = true;
	}
	global.EnemyArch[_Obj] = _A;
}

/// The archetype's state struct for a state, or undefined
function EnemyArch_State(_A, _State){
	if(_State >= array_length(_A.States)) return undefined;
	var _S = _A.States[_State];
	return is_struct(_S) ? _S : undefined;
}

#region Instance side (oEnemy_Archetype and the hooks in __Enemies)

/// oEnemy_Archetype Create, after oEnemy's
function EnemyArch_Create(){
	var _A = Arch;
	var _Names = variable_struct_get_names(_A.Vars);
	array_sort(_Names, true);
	for(var i = 0; i < array_length(_Names); i++){
		variable_instance_set(id, _Names[i], EnemyArch_Value(_A.Vars[$ _Names[i]]));
	}
	Enemy_ApplyVariant();
	if(_A.StartDir == "Random") Dir = RandomDir();
	if(_A.Flip) FacingDir = choose(-1, 1);
	if(_A.Dash) SlowdownSpeed = 0;
	if(_A.StayOnWater) TMID = FloorLevel == UPPER ? global.TMID_Water_Upper : global.TMID_Water_Lower;
	Enemy_UpdateState(EnemyArch_Choose(_A.Start));
}

/// Hook at the start of Enemy_UpdateState: runs a state the archetype lists; returns false for oEnemy's states
function EnemyArch_UpdateState(){
	var _A = EnemyArch_Get(object_index);
	if(_A == undefined) return false;
	var _S = EnemyArch_State(_A, State);
	if(_S == undefined) return false;
	if(_S.Move == ""){
		vx = 0;
		vy = 0;
	}
	EnemyArch_Move(_S);
	return true;
}

/// Starts the move of a state (on entering it, and when its Time is up without Next)
function EnemyArch_Move(_S){
	switch(_S.Move){
		case "Dir":
			EnemyArch_SetDir(_S, RandomDir());
			break;
		case "Toward":
			EnemyArch_SetDir(_S, DirFaceLink());
			break;
		case "Scuttle":
			Dir = RandomDir();
			if(Dir == LEFT || Dir == RIGHT){
				vx = choose(-1, 1) * Speed * _S.Side;
				vy = 0;
				ObjSetImageSpeed(_S.SideImageSpeed);
			}else{
				vx = 0;
				vy = choose(-1, 1) * Speed;
				ObjSetImageSpeed(_S.UpDownImageSpeed);
			}
			EnemyArch_SetTime(_S);
			break;
		case "Dash":
			Dir = (oLink.Cape ? irandom(359) : point_direction(x, y, oLink.x, oLink.y));
			Speed = Speed_Initial;
			vx = lengthdir_x(Speed, Dir);
			vy = lengthdir_y(Speed, Dir);
			FacingDir = vx < 0 ? -1 : 1;
			SlowdownSpeed = EnemyArch_Choose(_S.Slowdown);
			EnemyArch_SetTime(_S);
			break;
		default:
			EnemyArch_SetTime(_S);
			break;
	}
	if(_S.ImageSpeed != undefined) ObjSetImageSpeed(_S.ImageSpeed);
}

/// "Dir" and "Toward": a new direction, its sprite and speed, and a new Time
function EnemyArch_SetDir(_S, _Dir){
	Dir = _Dir;
	Enemy_UpdateSprite(State);
	Enemy_UpdateV(State == EnemyState.Running ? RunSpeed : WalkSpeed);
	EnemyArch_SetTime(_S);
}

function EnemyArch_SetTime(_S){
	if(_S.Time != undefined) alarm[0] = irandom_range(_S.Time[0], _S.Time[1]);
	else if(_S.TimeChoose != undefined) alarm[0] = EnemyArch_Choose(_S.TimeChoose);
}

/// oEnemy_Archetype Alarm 0: the state's Time is up
function EnemyArch_Alarm(){
	var _S = EnemyArch_State(Arch, State);
	if(_S == undefined) exit;
	if(_S.Next == undefined) EnemyArch_Move(_S);
	else Enemy_UpdateState(EnemyArch_Choose(_S.Next));
}

/// oEnemy_Archetype Step, before oEnemy's
function EnemyArch_StepBegin(){
	if(Arch.StayOnWater){
		if(!OnWaterTile(TMID, x + vx, y)) vx = 0;
		if(!OnWaterTile(TMID, x, y + vy)) vy = 0;
	}
}

/// oEnemy_Archetype Step, after oEnemy's and PauseCheck
function EnemyArch_Step(){
	var _A = Arch;
	var _S = EnemyArch_State(_A, State);
	if(_S != undefined){
		switch(_S.Move){
			case "Dir":
			case "Toward":
				if(WallCollide_X) EnemyArch_SetDir(_S, Enemy_WallCollisionNewDir(HORIZONTAL));
				if(WallCollide_Y) EnemyArch_SetDir(_S, Enemy_WallCollisionNewDir(VERTICAL));
				break;
			case "Dash":
				Speed -= SlowdownSpeed;
				if(Speed <= 0){
					Speed = 0;
					Enemy_UpdateState(EnemyArch_Choose(_S.Next));
				}else{
					vx = lengthdir_x(Speed, Dir);
					vy = lengthdir_y(Speed, Dir);
				}
				break;
		}
	}
	if(_A.InWaterW != undefined){
		switch(Dir){
			case LEFT:
			case RIGHT:
				InWaterSprW = _A.InWaterW[0];
				break;
			case UP:
			case DOWN:
				InWaterSprW = _A.InWaterW[1];
				break;
		}
	}
}

/// Hook at the start of Enemy_UpdateSprite: sets the sprite of a state the archetype has one for
function EnemyArch_UpdateSprite(_State){
	var _A = EnemyArch_Get(object_index);
	if(_A == undefined) return false;
	var _Sprites = _A.Sprites;
	var _V = Enemy_Variant();
	if(_V != undefined && variable_struct_exists(_V, "Sprites")){
		if(!variable_struct_exists(_V, "SpriteIds")) _V.SpriteIds = EnemyArch_ResolveSprites(_V.Sprites, _A.Name + " variant");
		_Sprites = _V.SpriteIds;
	}
	var _Spr = _Sprites[_State];
	if(_Spr == undefined) return false;
	if(is_array(_Spr)){
		if(Dir >= UP && Dir <= RIGHT) sprite_index = _Spr[Dir];
		return true;
	}
	sprite_index = _Spr;
	return true;
}

/// oEnemy_Archetype Draw
function EnemyArch_Draw(){
	var _A = Arch;
	if(_A.Shadow != noone) Enemy_DrawShadow(_A.Shadow);
	Enemy_PixelRender(_A.Palette != noone, _A.Palette, ColorIndex);
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * (_A.Flip ? FacingDir : 1), image_yscale, image_angle, image_blend, image_alpha);
	shader_reset();
	Obj_DrawInWater();
}

#endregion

#region Variants

/// Registers what an enemy changes per level: the default, and [[DungeonLevel.X, {...}], ...]
function EnemyVariant(_Obj, _Default, _Levels){
	var _ByLevel = [];
	for(var i = 0; i < array_length(_Levels); i++) _ByLevel[_Levels[i][0]] = _Levels[i][1];
	global.EnemyVariants[_Obj] = {Default: _Default, Levels: _ByLevel};
}

/// The variant the calling enemy takes in the current level, or undefined
function Enemy_Variant(){
	var _Own = LevelDef.EnemyVariants[$ object_get_name(object_index)];
	if(is_struct(_Own)) return _Own;
	if(object_index >= array_length(global.EnemyVariants)) return undefined;
	var _V = global.EnemyVariants[object_index];
	if(!is_struct(_V)) return undefined;
	var _L = LevelDef.EnemyStats;
	if(_L < array_length(_V.Levels) && is_struct(_V.Levels[_L])) return _V.Levels[_L];
	return _V.Default;
}

/// Sets the calling enemy's variables from its variant
function Enemy_ApplyVariant(){
	var _V = Enemy_Variant();
	if(_V == undefined) exit;
	var _Names = variable_struct_get_names(_V);
	array_sort(_Names, true);
	for(var i = 0; i < array_length(_Names); i++){
		switch(_Names[i]){
			case "Sprites":
			case "SpriteIds":
				break;
			case "Energy":
				Enemy_SetEnergy(EnemyArch_Value(_V.Energy));
				break;
			default:
				variable_instance_set(id, _Names[i], EnemyArch_Value(_V[$ _Names[i]]));
				break;
		}
	}
}

#endregion

#region Data

function EnemyArch_Init(){

	global.EnemyArch = [];
	global.EnemyVariants = [];

	EnemyArch(oEnemy_Rat, {
		Vars: {Size: EnemySize.Tiny, WalkSpeed: 1.5, CheckForWater: true, InWaterSprYOffset: 2},
		StartDir: "Random",
		Start: [EnemyState.Standing, EnemyState.Walking, EnemyState.Walking],
		Recover: EnemyState.Walking,
		States: [
			[EnemyState.Standing,	{Time: [30, 160], Next: [EnemyState.Walking]}],
			[EnemyState.Walking,	{Move: "Dir", Time: [30, 120], Next: [EnemyState.Standing]}]
		],
		Sprites: [[EnemyState.Standing, "sEnemy_Rat_Stand"], [EnemyState.Walking, "sEnemy_Rat_Walk"]],
		InWaterW: [16, 14],
		Trap: false
	});

	EnemyArch(oEnemy_Rope, {
		Vars: {Size: EnemySize.Tiny, WalkSpeed: 0.75, RunSpeed: 1.25, CheckForWater: true},
		Start: [EnemyState.Walking, EnemyState.Running],
		Recover: EnemyState.Running,
		States: [
			[EnemyState.Walking,	{Move: "Dir", Time: [30, 120], Next: [EnemyState.Walking, EnemyState.Running], ImageSpeed: 0.5}],
			[EnemyState.Running,	{Move: "Dir", Time: [30, 120], Next: [EnemyState.Walking, EnemyState.Running], ImageSpeed: 1}]
		],
		Sprites: [[EnemyState.Walking, "sEnemy_Rope"], [EnemyState.Running, "sEnemy_Rope"]],
		InWaterW: [18, 16],
		Trap: false
	});

	EnemyArch(oEnemy_Crab, {
		Vars: {Size: EnemySize.Medium, Speed: 0.5, WallCollide_Bounce: true, CheckForWater: true, InWaterSprW: function(){ return sprite_width - 4; }},
		Recover: EnemyState.Walking,
		States: [
			[EnemyState.Walking,	{Move: "Scuttle", Side: 3, SideImageSpeed: 1, UpDownImageSpeed: 0.5, Time: [30, 120]}]
		],
		Shadow: sShadow_Large
	});

	EnemyArch(oEnemy_Hover, {
		Vars: {Size: EnemySize.Tiny, Speed_Initial: 2},
		Flip: true,
		StayOnWater: true,
		States: [
			[EnemyState.Standing,	{TimeChoose: [45, 60, 75, 90], Next: [EnemyState.Walking]}],
			[EnemyState.Walking,	{Move: "Dash", Slowdown: [0.05, 0.1, 0.2], Next: [EnemyState.Standing]}]
		],
		Sprites: [[EnemyState.Standing, "sEnemy_Hover_Standing"], [EnemyState.Walking, "sEnemy_Hover_Walking"]],
		Trap: false
	});

	EnemyVariants_Init();
}

function EnemyVariants_Init(){

	EnemyVariant(oEnemy_Rope, {}, [
		[DungeonLevel.Catacombs,	{Sprites: [[EnemyState.Walking, "sEnemy_Rope2"], [EnemyState.Running, "sEnemy_Rope2"]]}]
	]);

	// Soldiers: colour (sEnemy_Soldier_Palette), head, weapon, energy index and attack. The default is the first level's,
	// so a soldier placed in a level not listed here still works.
	var _Simple = {HeadIndex: SoldierHead.Normal, ColorIndex: SoldierColor.Green, Energy: 1, Attack: 0.5};
	EnemyVariant(oEnemy_Soldier_Simple, _Simple, [
		[DungeonLevel.Castle,			_Simple],
		[DungeonLevel.CastleBasement,	{HeadIndex: SoldierHead.Normal, ColorIndex: SoldierColor.Blue, Energy: 1, Attack: 0.5}],
		[DungeonLevel.CastleJails,		{HeadIndex: SoldierHead.Normal, ColorIndex: SoldierColor.Grey, Energy: 2, Attack: 0.5}]
	]);

	var _Advanced = {Size: EnemySize.Medium, ColorIndex: SoldierColor.Green, HeadIndex: SoldierHead.Normal, Weapon: SoldierWeapon.Sword, Energy: 2, Attack: 0.5};
	EnemyVariant(oEnemy_Soldier_Advanced, _Advanced, [
		[DungeonLevel.Castle,			_Advanced],
		[DungeonLevel.CastleBasement,	{Size: EnemySize.Medium, ColorIndex: SoldierColor.Blue, HeadIndex: SoldierHead.Normal, Weapon: SoldierWeapon.Sword, Energy: 2, Attack: 0.5}],
		[DungeonLevel.CastleJails,		{Size: EnemySize.Large, ColorIndex: SoldierColor.Grey, HeadIndex: SoldierHead.Knight, Weapon: SoldierWeapon.Spear, Energy: 3, Attack: 0.75}],
		[DungeonLevel.Catacombs,		{Size: EnemySize.Large, ColorIndex: SoldierColor.Grey, HeadIndex: SoldierHead.Skull, Weapon: SoldierWeapon.Stick, Energy: 3, Attack: 0.75}],
		[DungeonLevel.WaterTemple,		{Size: EnemySize.Large, ColorIndex: SoldierColor.Blue, HeadIndex: SoldierHead.Dragon, Weapon: SoldierWeapon.Fork, Energy: 6, Attack: 1.75}],
		// energy and attack come from the head, in Step_1
		[DungeonLevel.Aghanim1,			{Size: EnemySize.Large, ColorIndex: SoldierColor.Red, Weapon: SoldierWeapon.Sword, HeadIndex: [SoldierHead.Pig, SoldierHead.Pig2, SoldierHead.Demon]}]
	]);

	var _Mace = {ColorIndex: SoldierColor.Grey, HeadIndex: SoldierHead.Knight, Energy: 4, Attack: 1};
	EnemyVariant(oEnemy_Soldier_Mace, _Mace, [
		[DungeonLevel.CastleJails,		_Mace],
		[DungeonLevel.Aghanim1,			{ColorIndex: SoldierColor.Gold, HeadIndex: SoldierHead.Warrior, Energy: 9, Attack: 3.25}]
	]);
}

#endregion
