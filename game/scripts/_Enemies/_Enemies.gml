enum EnemyState{
	Idle,
	Wake,
	Standing,
	Walking,
	Running,
	Jumping,
	Shooting,
	Sleep,
	Alerted,
	KnockBack,
	PushBack,
	Hit,
	Stunned,
	Shock,
	Frozen,
	OnFire,
	StopWatch,
	Killed
}


enum EnemyHitEffect{
	Function = -9,
	Magic,
	Freeze,	
	Fire,
	ShockLink,
	StunDamage,
	Stun,
	PushBack,
	NoDamage,
	Ignore,
	Damage 
}

#macro PauseCheck  if(global.Paused || State == EnemyState.KnockBack || State == EnemyState.PushBack || State == EnemyState.Stunned || State == EnemyState.Frozen || State == EnemyState.OnFire || State == EnemyState.StopWatch) { ObjPause();	exit; } else image_speed = LastImageSpeed

//knockback colors
#macro KB_R [1.0,0.0,0.0]
#macro KB_G [0.0,1.0,0.0]
#macro KB_B [0.0,0.0,1.0]
#macro KB_Br [-1,-1,-1] //bright
#macro KB_Gr [-2,-2,-2] //Greyscale
#macro KB_In [-3,-3,-3] //invert

//H = Hit Effect IDs. Using small names to make entering data in the table easier
#macro H_FF -9 //Function (value determined by some condition)
#macro H_Mg -8 //Magic
#macro H_Fr -7 //Freeze
#macro H_Fi -6 //Fire
#macro H_Sh -5 //Shock Link
#macro H_SD -4 //Stun Damage
#macro H_St -3 //Stun
#macro H_PB -2 //Push Back
#macro H_ND -1 //No Damage (wall hit effect)
// 0 //Ignore
//>0 = Damage amount


function Enemies_InitData(){

	//Table that says how many hits we want to kill an enemy with n energy for each sword:
	
	//					Enemy Energy index	 0	1	2	3	4	5	6	7	8	9	10	11	12  13		<- 10,11,12 are reserved for the bosses, 13 is for the chicken, 0 not used
	global.EnemyHitsToKill[Swords.Basic] =	[1,	1,	2,	3,	4,	5,	6,	7,	8,	9,	10,	12,	16,	999];
	global.EnemyHitsToKill[Swords.Steel] =	[1,	1,	1,	2,	3,	4,	5,	6,	7,	8,	 8,	10,	14,	999];
	global.EnemyHitsToKill[Swords.Long] =	[1,	1,	1,	1,	2,	3,	3,	4,	6,	7,	 6,	 7,	10,	999];
	global.EnemyHitsToKill[Swords.Blood] =	[1,	1,	1,	1,	1,	2,	2,	3,	4,	6,	 4,	 5,	 8,	999];
	global.EnemyHitsToKill[Swords.Dragon] =	[1,	1,	1,	1,	1,	1,	1,	2,	3,	4,	 3,	 4,	 6,	999];
	global.EnemyHitsToKill[Swords.Master] =	[1,	1,	1,	1,	1,	1,	1,	1,	2,	2,	 2,	 3,	 4,	999];
	
	//then create a table that holds the damage needed for each sword type to kill the enemy in n hits from the table above.
	//Link will then use this table to determine how much damage his sword inflicts.
	//Example: AN enemy with a max energy og 6, if we want to kill it in 3 hits with the long sword, we need to inflict 6 / 3 = 2 damage to do that
	for(var _SwordIndex = 0; _SwordIndex < 6; _SwordIndex++){
		global.LinkSwordDamage[_SwordIndex] = array_create(14);
		for(var _EnergyIndex = 0; _EnergyIndex < 14; _EnergyIndex++){
			global.LinkSwordDamage[_SwordIndex][_EnergyIndex] = global.EnemyHitsToKill[Swords.Basic][_EnergyIndex] / global.EnemyHitsToKill[_SwordIndex][_EnergyIndex];
		}
	}
	
									     //					Pack	Hit effects for link weapons. Values in brackets are the true/false values after testing a condition												Levels		   
									     //Ene Atk SItm	Itm	Pts	Trp	[   SWORD   ,   POT     ,   ARROW   , BOOMERANG ,  HOOKSHOT ,   BOMB    ,   FIRE    ,     ICE   ,SWORD BEAM ,    MAGIC  ]	[St,Cas,Bsm,Jai,Cat,Sew,Vil,Lan,Rn1,Rn2,Rn3,Mol,Ag1,Ag2,Ag3]
	EnemyDataInit(oBoss_Armos,			   10,	1,	0,	0,	0,	0,	[[H_FF,H_ND],	H_ND	,[2,H_ND]	,	H_ND	,	H_ND	,	0		,	H_ND	,	H_ND	,[H_FF,H_ND],	0		],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oBoss_Lanmola,		   11,1.5,	0,	0,	0,	0,	[	H_FF	,	H_ND	,	2		,	H_ND	,	H_ND	,	0		,	H_ND	,	H_ND	,	H_FF	,	0		],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oBoss_Moldorm,		   12,2.25,	0,	0,	0,	0,	[	H_FF	,	H_ND	,	H_ND	,	H_ND	,	H_ND	,	0		,	H_ND	,	H_ND	,	H_FF	,	0		],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Armos,				8,2.5,	1,	1, 	3,	1,	[[H_FF,H_ND],	[2,H_ND],[2,H_ND]	,	H_ND	,	H_ND	,[5,0]		,[H_Fi,H_ND],[H_Fr,0]	,[H_FF,H_ND],	[H_Mg,0]],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	1,	1]);
	EnemyDataInit(oEnemy_Bari,				2,	1,	1,	1, 	2,	1,	[[H_FF,H_Sh],	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	1,	0,	0,	0,	1,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Beamos,			0,2.5,	0,	0,	0,	0,	[	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		],	[0,	0,	0,	0,	0,	0,	0,	3,	1,	1,	5,	0,	1,	1,	1]);
	EnemyDataInit(oEnemy_Bubble,			0,	0,	0,	0,	3,	0,	[	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	1]);
	EnemyDataInit(oEnemy_Buzz,				2,0.75,	0,	1,	1,	1,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	1,	0,	1,	1,	0,	1,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_BuzzBlob,			3,	1,	0,	1,	3,	0,	[[H_FF,H_Sh],	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	1,	0,	1,	1,	0,	1,	1,	0,	0,	0]);
	EnemyDataInit(oEnemy_Cannon,			0,	0,	0,	0,	0,	0,	[	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		],	[0,	0,	0,	0,	0,	1,	0,	1,	1,	1,	1,	1,	1,	1,	1]);
	EnemyDataInit(oEnemy_Chicken,		   13,	0,	0,	0,	0,	0,	[	H_FF	,	2		,	2		,	1		,	1		,	1		,	1		,	1		,	H_FF	,	0		],	[0,	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Crab,				4,1.25,	1,	1,	3,	1,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	1,	0,	1,	0,	0,	1,	0,	0,	0,	0]);
	//EnemyDataInit(oEnemy_Delavant,		6,	2,	1,	1,	3,	0,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Eyegore,			7,	2,	0,	1,	4,	0,	[[H_FF,H_ND],[2,H_ND]	,[4,H_ND]	,[H_St,H_ND],[H_SD,H_ND],[5,0]		,[H_Fi,H_ND],[H_Fr,0]	,[H_FF,H_ND],[H_Mg,0]	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	2,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Geldman,			6,1.5,	0,	1,	4,	0,	[[H_FF,0]	,[2,0]		,[2,0]		,[H_St,0]	,[H_SD,0]	,[5,0]		,[H_Fi,0]	,[H_Fr,0]	,[H_FF,0]	,[H_Mg,0]	],	[0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Gibdo,				5,1.25,	1,	1,	4,	1,	[	H_FF	,	2		,	3		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	2,	0,	0,	1,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Goriya,			6,1.75,	1,	1,	4,	1,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Guru,				1,1.5,	0,	0,	0,	0,	[	0		,	0		,	0		,	0		,	0		,	0		,	0		,	H_Fr	,	0		,	0		],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Guru_Bar,			0,	0,	0,	0,	0,	0,	[	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		],	[0,	0,	0,	0,	1,	0,	0,	1,	1,	0,	1,	1,	1,	1,	1]);
	EnemyDataInit(oEnemy_HardhatBeetle,		5,1.25,	1,	1,	3,	1,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Helmasaur,			3,	1,	1,	1,	3,	1,	[[H_FF,H_PB],	H_ND	,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	0,	2,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Hinox,				9,	3,	1,	1,	5,	1,	[	H_FF	,	H_ND	,	2		,	H_ND	,	H_ND	,	0		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	1,	2]);
	EnemyDataInit(oEnemy_Hoarder,			2,	1,	1,	1,	1,	1,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	9,	2,	0,	0,	0]);
	EnemyDataInit(oEnemy_Hover,				1,0.75,	1,	1,	3,	0,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	1,	0,	0,	0,	1,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Keese,				1,0.5,	0,	0,	3,	0,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	1,	1,	1,	1,	0,	0,	2,	0,	3,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Kodongo,			4,	1,	0,	0,	3,	1,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	1,	0,	0,	0]);
	EnemyDataInit(oEnemy_Kyameron_Emitter,	0,	0,	0,	0,	4,	0,	[	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		],	[0,	0,	0,	0,	0,	3,	0,	0,	0,	3,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Kyameron_Moving,	1,0.5,	0,	0,	4,	0,	[	H_FF	,	1		,	1		,	1		,	1		,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	//EnemyDataInit(oEnemy_Kyune,			1,	1,	0,	0,	3,	0,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Leever,			4,1.5,	0,	1,	3,	0,	[[H_FF,0]	,[2,H_ND]	,[2,0]		,[H_St,H_ND],[H_SD,H_ND],[5,0]		,[H_Fi,H_ND],[H_Fr,0]	,[H_FF,0]	,[H_Mg,0]	],	[0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	0,	0,	0]);
	//EnemyDataInit(oEnemy_Lynel,			9,	3,	1,	1,	5,	1,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	1,	1]);
	EnemyDataInit(oEnemy_Medusa,			0,	0,	0,	0,	0,	0,	[	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		],	[0,	0,	0,	0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	1,	1]);
	EnemyDataInit(oEnemy_Moldorm,			6,1.5,	1,	1,	2,	1,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Octorok,			4,1.25,	1,	1,	3,	1,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	1,	1,	0,	0,	0]);
	EnemyDataInit(oEnemy_Pikit,				4,	1,	0,	0,	3,	1,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	1,	0,	1,	0,	0,	1,	0,	0,	0,	0]);
	//EnemyDataInit(oEnemy_Pirugusu,		1,	1,	0,	0,	4,	0,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Poe,				1,	1,	0,	0,	3,	0,	[	H_FF	,	2		,	2		,	1		,	1		,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	2,	0,	0,	0,	2,	1,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Popo,				4,	1,	1,	1,	3,	0,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	1,	0,	0,	0,	1,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Rat,				1,0.5,	1,	1,	2,	0,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	1,	1,	1,	1,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_RollingSpike,		0,	2,	0,	0,	0,	0,	[	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		],	[0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	1,	1,	1,	1,	1]);
	EnemyDataInit(oEnemy_Ropa,				4,1.25,	1,	1,	3,	1,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	0,	1,	0,	0,	0]);
	EnemyDataInit(oEnemy_Rope,				2,0.5,	1,	1,	3,	0,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	1,	1,	1,	1,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Skeleton,			3,	1,	1,	1,	3,	1,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	3,	0,	0,	0,	0,	0,	0,	0,	1,	1,	1]);
	EnemyDataInit(oEnemy_SnapDragon,		6,1.75,	1,	1,	4,	1,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	1,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Soldier_Simple,	2,0.5,	1,	1,	3,	1,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	1,	1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Soldier_Advanced,	3,	1,	1,	1,	4,	1,	[[H_FF,H_PB],	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	2,	3,	3,	2,	0,	0,	0,	0,	2,	0,	0,	1,	1,	1]);
	//EnemyDataInit(oEnemy_Soldier_Slasher,	5,	1,	1,	1,	4,	1,	[[H_FF,H_PB],	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	1,	1]);
	//EnemyDataInit(oEnemy_Soldier_Mace,	8,	1,	1,	1,	5,	1,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	1,	0,	0,	0,	0,	0,	0,	0,	0,	1,	1,	1]);
	EnemyDataInit(oEnemy_Tektite,			6,	2,	1,	1,	4,	1,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	3,	1,	0,	1,	1]);
	EnemyDataInit(oEnemy_Wizzrobe,			6,1.75,	0,	1,	3,	0,	[[H_FF,0]	,[2,0]		,[2,0]		,[H_St,0]	,[H_SD,0]	,[5,0]		,[H_Fi,0]	,[H_Fr,0]	,[H_FF,0]	,[H_Mg,0]	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	1,	1,	1]);
	EnemyDataInit(oEnemy_Zazak,				7,	2,	1,	1,	5,	1,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	2,	0,	0,	1,	1,	1])
	EnemyDataInit(oEnemy_Zirro,				5,1.5,	0,	0,	5,	0,	[	H_FF	,	2		,	2		,	H_St	,	H_SD	,	5		,	H_Fi	,	H_Fr	,	H_FF	,	H_Mg	],	[0,	0,	0,	0,	0,	0,	0,	0,	2,	0,	0,	0,	1,	1,	1]);
	EnemyDataInit(oEnemy_Zol,				2,	1,	0,	0,	3,	0,	[[H_FF,0]	,[2,0]		,[2,0]		,[H_St,0]	,[H_SD,0]	,[5,0]		,[H_Fi,0]	,[H_Fr,0]	,[H_FF,0]	,[H_Mg,0]	],	[0,	0,	0,	0,	0,	1,	0,	0,	0,	1,	0,	0,	0,	0,	0]);
												
}


function EnemyDataInit(_ObjIndex, _EnergyIndex, _Attack, _Key, _Item, _PackPoints, _TrapEnemy, _LinkWeaponEffects, _Levels){

	global.EnemyData[_ObjIndex] = {};
	
	global.EnemyData[_ObjIndex][$ "EnergyIndex"] = _EnergyIndex;
	global.EnemyData[_ObjIndex][$ "Attack"] = _Attack;
	global.EnemyData[_ObjIndex][$ "SpecialItem"] = _Key;
	global.EnemyData[_ObjIndex][$ "Item"] = _Item;
	global.EnemyData[_ObjIndex][$ "PackPoints"] = _PackPoints;
	global.EnemyData[_ObjIndex][$ "TrapEnemy"] = _TrapEnemy;
	
	global.EnemyData[_ObjIndex][$ "LinkWeaponEffects"] = array_create(LinkWeapons);
	for(var _WeaponIndex = 0; _WeaponIndex < LinkWeapons; _WeaponIndex++){
		global.EnemyData[_ObjIndex][$ "LinkWeaponEffects"][_WeaponIndex] = _LinkWeaponEffects[_WeaponIndex];
	}
	
	global.EnemyData[_ObjIndex][$ "Levels"] = array_create(DungeonLevels - 1);
	for(var _LevelIndex = 0; _LevelIndex < DungeonLevels - 1; _LevelIndex++){
		global.EnemyData[_ObjIndex][$ "Levels"][_LevelIndex] = _Levels[_LevelIndex];
	}
	
}


function Enemy_CheckHit(){

	
	if(Hit && Hit_Allowed){	

		Hit_Allowed = false;
		Hit_Started = true;
		
		var _LinkWeaponEffect = global.EnemyData[object_index].LinkWeaponEffects[Hit_LinkWeapon];
	

		switch(State){
			
			case EnemyState.Frozen:
				//if frozen and hit by one of these weapons, just set the hit effect to 100 causing 100 damage to destroy any enemy that's frozen, bypassing all the following blocks of code
				switch(Hit_LinkWeapon){
					case LinkWeapon.Sword:
					case LinkWeapon.SwordBeam:
					case LinkWeapon.Arrow:
					case LinkWeapon.Boomerang:
					case LinkWeapon.Hookshot:
					case LinkWeapon.Pot:	
						_LinkWeaponEffect = 100;
						break;
					
					case LinkWeapon.Fire:
					
						if(StopWatch){
							_LinkWeaponEffect = EnemyHitEffect.Fire;
							break;
						}
						
						//turn enemy back to normal if they were frozen and hit with fire
						_LinkWeaponEffect = EnemyHitEffect.NoDamage;
						instance_destroy(OnFireInst);
						KnockBackDone = true;
						break;
						
					default:
						_LinkWeaponEffect = EnemyHitEffect.Ignore;
						break;
						
				}
				break;
			
			case EnemyState.Stunned:
			case EnemyState.StopWatch:
				if(is_array(_LinkWeaponEffect)) _LinkWeaponEffect = _LinkWeaponEffect[0]; //first element is always the hit condition
				break;
			
		}
		
		if(is_array(_LinkWeaponEffect)){
	
			//Effects in brackets are the true/false values after checking a condition	
			switch(object_index){
				
				default: _LinkWeaponEffect = 0; //temp until all enemies with conditions are entered
				
				case oBoss_Armos:		_LinkWeaponEffect = (State == EnemyState.Jumping || State == EnemyState.Shooting ? _LinkWeaponEffect[0] : _LinkWeaponEffect[1]); break;
				case oEnemy_Bari:		_LinkWeaponEffect = (!(CanShock && !global.ItemData[oItem_Skill].Owns[Skill.Resistance]) ? _LinkWeaponEffect[0] : _LinkWeaponEffect[1]); break;
				case oEnemy_BuzzBlob:	_LinkWeaponEffect = (global.ItemData[oItem_Skill].Owns[Skill.Resistance] ? _LinkWeaponEffect[0] : _LinkWeaponEffect[1]); break;
				case oEnemy_Eyegore:	_LinkWeaponEffect = (State == EnemyState.Walking && ( Type == 0 || (Type == 1 && Hit_LinkWeapon == oArrow)) ? _LinkWeaponEffect[0] : _LinkWeaponEffect[1]); break;
				case oEnemy_Zol:		_LinkWeaponEffect = (State != EnemyState.Idle && State != EnemyState.Wake ? _LinkWeaponEffect[0] : _LinkWeaponEffect[1]); break;
			
				case oEnemy_Armos:
				case oEnemy_Geldman:
				case oEnemy_Leever:
					_LinkWeaponEffect = (State == EnemyState.Walking ? _LinkWeaponEffect[0] : _LinkWeaponEffect[1]); 
					break;
				
				case oEnemy_Helmasaur:
					if(Dir == OppositeDir(oLink.Facing)){
						instance_create_layer(x, y, "ObjsHigher_Upper", oWallHit, {PlaySound: true});
						_LinkWeaponEffect = _LinkWeaponEffect[1];
					}else{
						_LinkWeaponEffect = _LinkWeaponEffect[0];
					}
					break;
				
				case oEnemy_Soldier_Advanced:
				case oEnemy_Soldier_Slasher:
					_LinkWeaponEffect = (!Pushback ? _LinkWeaponEffect[0] : _LinkWeaponEffect[1]); break;
				
				case oEnemy_Wizzrobe:	_LinkWeaponEffect = (State == EnemyState.Shooting ? _LinkWeaponEffect[0] : _LinkWeaponEffect[1]); break;
				
			}
			
		}
		

		if(Hit_LinkWeapon == LinkWeapon.Sword && _LinkWeaponEffect == H_FF){
			var _LinkWeaponEffect = EnemyHitEffect.Damage;
			var _Damage = global.LinkSwordDamage[global.ItemData[oItem_Sword].Index][EnergyIndex];
			
		}else if(Hit_LinkWeapon == LinkWeapon.SwordBeam && _LinkWeaponEffect == H_FF){
			var _LinkWeaponEffect = EnemyHitEffect.Damage;
			var _Damage = global.LinkSwordDamage[global.ItemData[oItem_Sword].Index][EnergyIndex] * 0.75;
			
		}else if(_LinkWeaponEffect > 0){
			var _Damage = _LinkWeaponEffect;
			_LinkWeaponEffect = EnemyHitEffect.Damage;						
		}				
		
		switch(_LinkWeaponEffect){

			case EnemyHitEffect.Ignore:
				Hit_Allowed = true;
				break;
			
			case EnemyHitEffect.NoDamage:
				instance_create_layer(Hit_PosX, Hit_PosY, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oWallHit, {PlaySound: true});
				Hit_AllowedTimer = 20;				
				break;
			
			case EnemyHitEffect.Damage:
				Enemy_Hit_KnockBack(false, _Damage);
				break;
				
			case EnemyHitEffect.Stun:
				Enemy_Hit_KnockBack(true, 0);
				break;
				
			case EnemyHitEffect.StunDamage:
				Enemy_Hit_KnockBack(true, 2);
				break;
			
			case EnemyHitEffect.PushBack:
				Enemy_Hit_PushBack(Hit_LinkWeapon);
				break;
				
			case EnemyHitEffect.ShockLink:
				Enemy_Hit_ShockLink();
				break;
				
			case EnemyHitEffect.Freeze:
				Enemy_UpdateState(EnemyState.Frozen);
				break;
				
			case EnemyHitEffect.Fire:
				Enemy_UpdateState(EnemyState.OnFire);
				break;
				
			case EnemyHitEffect.Magic:
				break;
				
			
		}

	
	}
	
	Hit = false;
	
}


function Enemy_LinkWeaponHit(_WeaponIndex, _EnemyInst, _x, _y, _Dir){
	
	var WeaponEffect = global.EnemyData[_EnemyInst.object_index].LinkWeaponEffects[_WeaponIndex];
	
	if(WeaponEffect == EnemyHitEffect.Ignore) return false;
	
	with(_EnemyInst){
		Hit = true;
		Hit_PosX = _x;
		Hit_PosY = _y;
		Hit_DirX = lengthdir_x(1, _Dir);
		Hit_DirY = lengthdir_y(1, _Dir);
		Hit_LinkWeapon = _WeaponIndex;
	}
	
	return true;
	
}

function Enemy_Attack(_MaxAttackPoints){
	//gives the attack points based on the enemy's max amount and Link's armor, subtracting a factor for every Link defense point
	
	if(_MaxAttackPoints == 0) return 0;
	
	if(_MaxAttackPoints < 2)
		var Factor = 0.125;
	else
		var Factor = 0.25;
	
	return max(_MaxAttackPoints - (oLink.DefensePoints * Factor), 0.125)
	
}

function Enemy_Hit_KnockBack(_Stun, _Damage){
	
	if(State == EnemyState.Frozen){
		var _FloorLevelStr = GetFloorLevelString(x, y);
		var SprW = sprite_get_width(sprite_index);
		var SprH = sprite_get_height(sprite_index);
		repeat(ceil((SprW * SprH) / 28)){ //the larger the enemy, the more shards
			instance_create_layer(x, y_base, "ObjsHigher_" + _FloorLevelStr, oIceShard, {z : z});
		}	
		var _PoofX = x - sprite_get_xoffset(sprite_index) + (SprW / 2);
		var _PoofY = y - sprite_get_yoffset(sprite_index) + (SprH / 2);
		instance_create_layer(_PoofX, _PoofY, layer, oPoof_NoSound);
		
		if(!audio_is_playing(Sound_PotShatter)) audio_play_sound(Sound_PotShatter, 1, false);
		Enemy_Destroy();
		exit;
	}
	
	if(UnStunWhenHit){
		UnStunWhenHit = false;
	}
	
	KnockBackColorFrame = 0;
	KnockBackTime = KnockBackTimeLen;
	
	if(KnockBackEnabled){
		vx = Hit_DirX * KnockBackV;
		vy = Hit_DirY * KnockBackV;
		if(!KnockBackIgnoreZRule) vz = -abs(vz); //so enemy moves back down after hit
	}
	
	Energy -= _Damage;
	
	Hit_Stun = _Stun;
	
	if(Hit_PlaySound && !audio_is_playing(Hit_Sound)) audio_play_sound(Hit_Sound, 1, false);	
	
	Enemy_UpdateState(EnemyState.KnockBack);
	
}

function Enemy_Hit_PushBack(_Weapon){

	PushbackTime = PushbackTimeLen;
	
	switch(_Weapon){
		default:
			PushbackTimeLen = 10;
			PushbackV = 3;
			break;
		case LinkWeapon.Bomb:
			PushbackTimeLen = 15;
			PushbackV = 4;
		
	}
	vx = Hit_DirX * PushbackV;
	vy = Hit_DirY * PushbackV;
	
	Enemy_UpdateState(EnemyState.PushBack);
	
}

function Enemy_Hit_ShockLink(){
	
	Enemy_UpdateState(EnemyState.Shock);
	
	Mosaic(MosaicType.Shock);
	
	Hit_AllowedTimer = 20;
	
}

function Enemy_Destroy(){
	instance_destroy(id);
	Destroyed = true;
	Curse_CheckTask(CurseTasks.Kill);
	global.StatsToAdd[Stat.Monsters]++;	
}

function Enemy_PixelRender(_Pal = false, _PalSpr = noone, _PalIndex = 0){
	switch(State){
		default:
			PixelRender_Dim(true, true, _Pal, _PalSpr, _PalIndex, false, noone, false, []);	
			break;
		case EnemyState.KnockBack:
			PixelRender_Dim(true, true, _Pal, _PalSpr, _PalIndex, false, noone, true, KnockBackColors[KnockBackColorFrame]);	
			break;
		case EnemyState.Frozen:
			PixelRender_Dim(true, true, _Pal, _PalSpr, _PalIndex, false, noone, true, [0.0,0.6,1.0]);	
			break;
		case EnemyState.OnFire:
			PixelRender_Dim(true, true, _Pal, _PalSpr, _PalIndex, false, noone, true, [0.55,0.0,0.0]);	
			break;
		
		case EnemyState.StopWatch:
			PixelRender_Dim(true, true, _Pal, _PalSpr, _PalIndex, false, noone, true, KB_Gr);	
			break;
		
	}
}

function SpawnBoss(_RoomIndex){
	
	var VarStruct = {FloorLevel : UPPER, ItemHolding : noone, RoomTemplate: Room.TemplateIndex, SectionID: 0, RoomX : Room.x, RoomY : Room.y};
	
	switch(global.Level.Index){
		case DungeonLevel.CastleJails:
			var inst = instance_create_layer(Room.x + 20, Room.y + 20, "System", oBoss_Armos_C, VarStruct); 				
			break;
				
		case DungeonLevel.LanmolasLair:
			var inst = instance_create_layer(Room.x + 20, Room.y + 20, "System", oBoss_Lanmola_C, VarStruct);
			break;
				
		case DungeonLevel.MoldormsLair:
			var inst = instance_create_layer(Room.x + 128, Room.y + 80, "Objs_Upper", oBoss_Moldorm, VarStruct);			
			break;
		
	}
	
}

function Enemy_UpdateState(NewState){
	
	State = NewState;
	
	switch(State){
		
		case EnemyState.Idle:
			
			switch(object_index){
				
				case oEnemy_Kyameron_Emitter:
					alarm[0] = IdleTime + MovingTime;					
					break;
					
				case oBoss_Moldorm:
					alarm[1] = 60;
					break;
					
				case oEnemy_Eyegore:
					image_index = 0;
					ObjSetImageSpeed(0)
					IdleDelay = true;
					
					alarm[2] = 60;
					break;
				
				case oEnemy_Geldman:
					x = StartX;
					ObjSetY(StartY);
					AllowSpawn = false;
					alarm[2] = 60;
					break;

				case oEnemy_Leever:
					alarm[0] = irandom_range(90, 200);
					break;
					
				case oEnemy_Soldier_Mace:
					Speed = 0;
					image_index = 0;
					ObjSetImageSpeed(0);
					break;
					
				case oEnemy_Wizzrobe:
					Visible = false;
					alarm[0] = 90;
					break;
					
				case oEnemy_Zol:
					ObjSetImageSpeed(0)
					break;
			}
			break;
			
		
		case EnemyState.Wake:
		
			switch(object_index){
				
				case oEnemy_Armos:
					alarm[0] = 60;
					break;
					
				case oEnemy_Eyegore:
					image_index = 1;
					ObjSetImageSpeed(1)
					break;

				case oEnemy_Geldman:
					alarm[0] = 40;
					break;
					
				case oEnemy_Kyameron_Emitter:
					alarm[1] = 120;
					break;

				case oEnemy_Leever:
					image_index = 0;
					break;
					
				case oEnemy_Wizzrobe:
					Dir = DirFaceLink();
					alarm[1] = 60;
					break;
					
				case oEnemy_Zol:
					ObjSetImageSpeed(1)
					//Link stepped close to Zol, so move Zol to Link's x/y position and then wake.
					//Check the new spawn position at Link's x/y to see if there's another Zol there.
					//If so, then move to position outside of other Zol. This is to prevent more than 1 zol teleporting to the same spot
					var ZolInst = instance_place(oLink.x, oLink.y, oEnemy_Zol);
					if(ZolInst != noone){
						var A = point_direction(x, y, oLink.x, oLink.y);
						var IncX = lengthdir_x(1, A);
						var IncY = lengthdir_y(1, A);
						while(!place_meeting(x + IncX, y + IncY, oEnemy_Zol)){
							x = x + IncX;
							ObjSetY(y + IncY);
						}
					}else{
						x = oLink.x;
						ObjSetY(oLink.y);
					}
					break;
					
			}			

			break;
			
		case EnemyState.Standing:
			
			vx = 0;	vy = 0;
			
			switch(object_index){
				
				case oEnemy_Buzz:
					alarm[0] = (choose(0,1,2) == 0 ? 1 : irandom_range(30, 90));
					break;

				case oEnemy_Chicken:
					alarm[0] = 60;
					image_index = 0;
					ObjSetImageSpeed(0);
					break;
					
				case oEnemy_Goriya:

					break;
				
				case oEnemy_Hinox:
					ObjSetImageSpeed(0);
					alarm[1] = 40;
					break;
					
				case oEnemy_Hover:
					alarm[0] = choose(45, 60, 75, 90);
					break;
				
				case oEnemy_Keese:
					CanFly = false;
					alarm[0] = 60;
					alarm[2] = -1;
					break;
					
				case oEnemy_Kodongo:
					if(Type == 1) Dir = DirFaceLink();
					image_index = 0;
					ObjSetImageSpeed(0)
					alarm[0] = Script[# 1, ScriptPos];
					ScriptPos = (ScriptPos + 1) mod ScriptLen;
					break;

				case oEnemy_Octorok:
					ObjSetImageSpeed(0);
					alarm[1] = 30;
					break;

				case oEnemy_Pikit:
					alarm[0] = StandPause + irandom_range(-10, 10);	
					alarm[1] = CanShootPause;
					break;

				case oEnemy_Popo:
					alarm[1] = irandom_range(60, 180);
					break;
				
				
				case oEnemy_Rat:
					alarm[0] = irandom_range(30, 160);
					break;
				
				case oEnemy_Ropa:
					alarm[0] = JumpDelay;
					break;					

				case oEnemy_Skeleton:
					switch(Dir){
						case UP: case DOWN:	NextDir = choose(LEFT, RIGHT); break;
						case LEFT: case RIGHT: NextDir = choose(UP, DOWN); break;
					}
					HeadDir = NextDir;
					alarm[1] = 32;
					ObjSetImageSpeed(0);
					break;
					
				case oEnemy_SnapDragon:
					alarm[0] = 60;
					ObjSetImageSpeed(1);
					break;
					
				case oEnemy_Soldier_Simple:
					ObjSetImageSpeed(0);
					Soldier_UpdateHead(Soldier_Simple_LookSideDir(Dir))
					alarm[0] = 20;
					alarm[1] = -1;
					break;
				
				case oEnemy_Soldier_Advanced:
					image_index = 0;
					ObjSetImageSpeed(0);
					StandingHeadChecks = 6;
					PlayRunSound = true;
					alarm[0] = -1;
					alarm[1] = -1;
					alarm[3] = StandinHeadTurnDelay;
					alarm[4] = -1;
					break;

				case oEnemy_Soldier_Mace:
					image_index = 0;
					ObjSetImageSpeed(0);
					Speed = 0;
					alarm[0] = -1;
					alarm[1] = -1;
					Soldier_UpdateDir(DirFaceLink());
					WeaponInst.SpinDist = WeaponInst.SpinDistStart;
					WeaponInst.SpinAngle = 0;
					alarm[2] = 60;
					SpinAllowed = false;
					break;
				
				case oEnemy_Tektite:
					alarm[0] = irandom_range(30, 90);
					break;
					
				case oEnemy_Zazak:
					ObjSetImageSpeed(0);
					Soldier_UpdateHead(Soldier_Simple_LookSideDir(Dir))
					alarm[0] = 20;
					alarm[1] = -1;
					alarm[2] = -1;
					alarm[3] = -1;
					break;
					
			}
			break;
	

		case EnemyState.Walking:

			switch(object_index){
				
				case oEnemy_Armos:
					image_index = 1;
					vz = JumpVZ;
					break;
					
				case oEnemy_Bari:
					alarm[0] = irandom_range(120, 300);
					break;
				
				case oEnemy_Buzz:
					GravityStatus = true;
					if(choose(0,1) == 0){
						Hops = irandom_range(1, 4);
						vz = 2;
						Speed = WalkSpeed;
					}else{
						Hops = 1;
						vz = 3;
						Speed = JumpSpeed
					}
					Buzz_UpdateDir(choose(LEFT, RIGHT, UP, DOWN));	

					break;

				case oEnemy_Chicken:
					ObjSetImageSpeed(0.5);
					Hops = irandom_range(2, 8);
					GravityStatus = true;
					Gravity = -0.2;
					vz = JumpSpeed;
					Chicken_PickNewDir();	
					break;
					
				case oEnemy_Crab:
					Crab_UpdateDir();
					break;
					
				case oEnemy_Eyegore:
					image_index = 0;
					ObjSetImageSpeed(1);
					Eyegore_UpdateDir(DirFaceLink());
					break;

				case oEnemy_Geldman:
				var DirToLink = point_direction(x, y, oLink.x, oLink.y);
					vx = lengthdir_x(Speed, DirToLink);
					vy = lengthdir_y(Speed, DirToLink);
					alarm[1] = 120;
					break;
					
				case oEnemy_Gibdo:
					Gibdo_UpdateDir(DirFaceLink());
					alarm[0] = irandom_range(60, 150);;
					break;
				
				case oEnemy_Helmasaur:
					Helmasaur_UpdateDir();
					alarm[0] = irandom_range(ChangeDirDelayMin, ChangeDirDelayMax);
					break;
					
				case oEnemy_Hinox:
					ObjSetImageSpeed(0.5);
					//pick a direction that's moving away from walls
					var DirList = ds_list_create();
					var BufferLen = 12;
					if(!place_meeting(x - BufferLen, y, oWall) && !place_meeting(x, y - BufferLen, oWall) && !place_meeting(x, y + BufferLen, oWall)) ds_list_add(DirList, LEFT);
					if(!place_meeting(x + BufferLen, y, oWall) && !place_meeting(x, y - BufferLen, oWall) && !place_meeting(x, y + BufferLen, oWall)) ds_list_add(DirList, RIGHT);
					if(!place_meeting(x, y - BufferLen, oWall) && !place_meeting(x - BufferLen, y, oWall) && !place_meeting(x + BufferLen, y, oWall)) ds_list_add(DirList, UP);
					if(!place_meeting(x, y + BufferLen, oWall) && !place_meeting(x - BufferLen, y, oWall) && !place_meeting(x + BufferLen, y, oWall)) ds_list_add(DirList, DOWN);
					ds_list_shuffle(DirList);
					Hinox_UpdateDir(ds_list_size(DirList) == 0 ? choose(UP, DOWN, LEFT, RIGHT) : DirList[| 0], WalkSpeed);
					ds_list_destroy(DirList);
					break;
				
				case oEnemy_Hoarder:
					Hoarder_UpdateDir();
					break;
					
				case oEnemy_Hover:
					Dir = point_direction(x, y, oLink.x, oLink.y);
					Speed = Speed_Initial;
					vx = lengthdir_x(Speed, Dir);
					vy = lengthdir_y(Speed, Dir);
					FacingDir = vx < 0 ? -1 : 1;
					SlowdownSpeed = choose(0.05, 0.1, 0.2);
					break;
				
				case oEnemy_Keese:
					Dir = point_direction(x, y, oLink.x, oLink.y) + irandom_range(-30, 30);
					vx = lengthdir_x(Speed, Dir);
					vy = lengthdir_y(Speed, Dir);
					AngleDir = choose(-1, 1);
					alarm[1] = irandom_range(60, 120);
					alarm[2] = irandom_range(5, 45);
					
					break;
					
				case oEnemy_Kodongo:
					Script[# 1, ScriptPos] = irandom_range(90, 200);		
					Dir = choose(LEFT, RIGHT, UP, DOWN);						
					Enemy_UpdateV(WalkSpeed);
					image_index = 0;
					ObjSetImageSpeed(1)
					alarm[0] = Script[# 1, ScriptPos];
					ScriptPos = (ScriptPos + 1) mod ScriptLen;
					break;
				
				case oEnemy_Leever:
					alarm[1] = irandom_range(200, 400);
					break;
				
				
				case oEnemy_Octorok:
					Octorok_UpdateDir(choose(LEFT, RIGHT, UP, DOWN));
					ObjSetImageSpeed(1);
					alarm[0] = irandom_range(90, 200);
					break;
					
				case oEnemy_Popo:
					alarm[1] = irandom_range(180, 320);
					var D = irandom_range(0, 359);
					vx = lengthdir_x(MaxSpeed, D);
					vy = lengthdir_y(MaxSpeed, D);
					alarm[2] = MoveDelay;
					break;

				case oEnemy_Rat:
					Rat_UpdateDir(choose(LEFT, RIGHT, UP, DOWN));
					break;

				case oEnemy_Rope:
					Rope_UpdateDir(choose(LEFT, RIGHT, UP, DOWN));
					ObjSetImageSpeed(0.5)
					break;

				case oEnemy_Skeleton:
					Skeleton_UpdateDir(NextDir);
					alarm[0] = irandom_range(4, 15) * 8;
					ObjSetImageSpeed(1);
					break;
					
				case oEnemy_SnapDragon:
					ObjSetImageSpeed(0);
					image_index = 0;
					Hops = irandom_range(2, 8);
					GravityStatus = true;
					vz = JumpSpeed;
					SnapDragon_UpdateDir(choose(LEFT, RIGHT, UP, DOWN));	
					break;
					
				case oEnemy_Soldier_Simple:
					ObjSetImageSpeed(0.5)
					Speed = WalkSpeed;
					Soldier_UpdateDir(HeadDir);
					alarm[1] = irandom_range(60, 200);	
					break;
					
				case oEnemy_Soldier_Advanced:
					ObjSetImageSpeed(0.5);
					Speed = WalkSpeed;
					Soldier_UpdateDir(HeadDir);
					Soldier_UpdateWeaponSprite();
					alarm[2] = irandom_range(100, 500);
					alarm[4] = irandom_range(60, 400);
					break;

				case oEnemy_Soldier_Mace:
					ObjSetImageSpeed(1);
					Speed = WalkSpeed;
					Soldier_Advanced_UpdateRunningDir(false);
					Strafe = false;
					break;
				
				case oEnemy_Zazak:
					ObjSetImageSpeed(1);
					Soldier_UpdateDir(HeadDir);
					alarm[1] = irandom_range(30, 90);	
					break;
				
				case oEnemy_Zirro:
					Dir = Prob(0.6) ? DirFaceLink() : choose(LEFT, RIGHT, UP, DOWN); //hald the time pick Dir that's towards Link
					var AngleOffset = choose(-1, 0, 1);
					switch(Dir){
						case LEFT:
							vx = -Speed;
							vy = Speed * AngleOffset
							break;
						case RIGHT:
							vx = Speed;
							vy = Speed * AngleOffset;
							break;
						case UP:
							vx = Speed * AngleOffset;
							vy = -Speed;
							break;
						case DOWN:
							vx = Speed * AngleOffset;
							vy = Speed;
							break;
		
					}
					alarm[0] = 48;
					break;
					
				case oEnemy_Zol:
					vx = 0;
					vy = 0;
					image_index = 1;
					ObjSetImageSpeed(0)
					Zol_UpdateDir();
					alarm[0] = 20;
					break;

			}
			break;		

		case EnemyState.Running:
			switch(object_index){
				
				case oEnemy_Chicken:
					WallCollide_Bounce = false;
					break;
					
				case oEnemy_Hinox:
					ObjSetImageSpeed(1);
					Hinox_UpdateDir(DirFaceLink(), RunSpeed);
					alarm[1] = -1;
					alarm[2] = -1;
					break;
					
				case oEnemy_Rope:
					Rope_UpdateDir(choose(LEFT, RIGHT, UP, DOWN));
					ObjSetImageSpeed(1)
					break;
					
				case oEnemy_Soldier_Simple:
					ObjSetImageSpeed(1);
					Speed = RunSpeed;
					Soldier_UpdateDir(HeadDir);
					alarm[1] = irandom_range(60, 120);	
					break;
					
				case oEnemy_Soldier_Advanced:
					ObjSetImageSpeed(1);
					Speed = RunSpeed;
					Soldier_Advanced_UpdateRunningDir();
					if(PlayRunSound) audio_play_sound(Sound_Enemy_Chase, 1, false);
					PlayRunSound = false;
					Strafe = false;
					alarm[1] = -1;
					alarm[2] = -1;
					alarm[3] = -1;
					alarm[4] = -1;
					alarm[6] = 200;
					break;

				case oEnemy_Soldier_Slasher:
					ObjSetImageSpeed(1);
					Speed = RunSpeed;
					Soldier_Advanced_UpdateRunningDir();
					Strafe = false;
					break;
			}
			break;
		
		
		case EnemyState.Alerted:
			switch(object_index){
				case oEnemy_Soldier_Simple:
					ObjSetImageSpeed(0);
					vx = 0;
					vy = 0;
					alarm[0] = -1;
					alarm[1] = -1;
					alarm[2] = 30;
					break;
					
				case oEnemy_Soldier_Advanced:
					ObjSetImageSpeed(0);
					vx = 0;
					vy = 0;
					alarm[0] = -1;
					alarm[1] = -1;
					alarm[2] = -1;
					alarm[3] = -1;
					alarm[4] = -1;
					alarm[5] = 30;
					break;
			}
			break;
			
		case EnemyState.Jumping:
			
			GravityStatus = true;
			
			switch(object_index){

				case oEnemy_Chicken:
				
					layer = layer_get_id("Objs_" + GetFloorLevelString(FloorLevel));
					PickedUp = false;						
					x = oLink.x;
					z = 18;
					Gravity = -0.1;
					vz = 0.75;
					
					ObjSetY(oLink.y - 1);
					switch(oLink.Facing){
						case UP: vy = -SpeedThrow; break;
						case DOWN: vy = SpeedThrow; break;
						case LEFT: vx = -SpeedThrow; break;
						case RIGHT: vx = SpeedThrow; break;
					}
					Dir = vx >= 0 ? 1 : -1;
					WallCollide_Bounce = true;
					WallCollide_Bounce_NewVFactor = 0.25;
					mask_index = sEnemy_Chicken; //MI was empty while Link was holding, so have to reset it;
					ObjSetImageSpeed(1);
					audio_play_sound(Sound_Chicken, 1, false);
					audio_play_sound(Sound_Chicken_Fly, 1, false);
					break;
					
				case oEnemy_Kyameron_Emitter:
					image_index = 0;
					break;

				case oEnemy_Pikit:
					Dir = choose(UP, DOWN, LEFT, RIGHT);
					Enemy_UpdateV(choose(Speed1, Speed2, Speed3));
					vz = JumpSpeed;	
					break;
					
				case oEnemy_Ropa:
					var A = point_direction(x, y_base, oLink.x, oLink.y);
					vx = lengthdir_x(1, A);
					vy = lengthdir_y(1, A);
					vz = choose(1,2,3);					
					break;
				
				case oEnemy_Skeleton:
					Dir = DirFaceLink();
					HeadDir = Dir;
					vz = JumpSpeed;
					alarm[0] = -1;
					alarm[1] = -1;
					var D = point_direction(oLink.x, oLink.y, x, y);
					vx = lengthdir_x(JumpSpeed + 0.25, D);
					vy = lengthdir_y(JumpSpeed + 0.25, D);
					break;
					
				case oEnemy_Tektite:
					Tektite_UpdateDir(choose(LEFT, RIGHT, UP, DOWN));
					vz = JumpZ;
					Hops = 1;
					break;
					
				case oEnemy_Zol:
					var A = point_direction(x, y_base, oLink.x, oLink.y);
					vx = lengthdir_x(1, A);
					vy = lengthdir_y(1, A);
					vz = 2;
					LookDir = vx >= 0 ? 1 : -1;
					image_index = 0;
					
					break;
			}
			break;
			
		case EnemyState.Shooting:

			switch(object_index){
				
				case oBoss_Armos:
					oBoss_Armos_C.alarm[5] = -1;
					oBoss_Armos_C.alarm[6] = 8;					
					break;
					
				case oEnemy_Hinox:
					vx = 0; vy = 0;
					alarm[0] = -1;
					alarm[1] = -1;
					alarm[2] = 45;
					Dir = DirFaceLink();
					break;
					
				case oEnemy_Kodongo:
					vx = 0; vy = 0;						
					FireballCount = 0;				
					Kodongo_Shoot();
					alarm[0] = Script[# 1, ScriptPos];
					ScriptPos = (ScriptPos + 1) mod ScriptLen;
					break;
				
				case oEnemy_Octorok:
					ShotCount = Shots;
					alarm[2] = MouthFrameDelay;
					break;

				case oEnemy_Pikit:
					image_index = 0;
					ObjSetImageSpeed(1);
					Shoot = false;
					CanShoot = true;
					alarm[0] = -1;
					alarm[1] = -1;
					break;
				
				case oEnemy_Skeleton:
					vx = 0; 
					vy = 0;
					ObjSetImageSpeed(0);
					Dir = DirFaceLink();
					HeadDir = Dir;
					alarm[2] = 30;
					break;
					
				case oEnemy_Wizzrobe:
					Visible = true;
					alarm[2] = 8;
					break;

				case oEnemy_Zazak:
					ObjSetImageSpeed(0);
					Soldier_UpdateDir(DirFaceLink());
					switch(Dir){
						case LEFT: HeadSpr = sEnemy_Zazak_ShootHead_Left; break;
						case RIGHT: HeadSpr = sEnemy_Zazak_ShootHead_Right;	break;
						case DOWN: HeadSpr = sEnemy_Zazak_ShootHead_Down; break;
					}
					vx = 0; vy = 0;	
					alarm[0] = -1;
					alarm[1] = -1;
					alarm[2] = 30;
					break;
				
				case oEnemy_Zirro:
					vx = 0;
					vy = 0;
					alarm[0] = -1;
					alarm[1] = 24;
					Zirro_Shoot();				

					break;
					
					
			}
			break;
		
		case EnemyState.Sleep:
		
			switch(object_index){
					
				case oEnemy_Eyegore:
					vx = 0;
					vy = 0;
					Dir = DOWN;
					image_index = 2.99;
					ObjSetImageSpeed(-1)
					alarm[0] = -1;
					break;
				
				case oEnemy_Geldman:
					alarm[1] = 0;
					image_index = 0;
					vx = 0;
					vy = 0;
					break;
				
				case oEnemy_Leever:
					image_index = 0;
					vx = 0;
					vy = 0;
					break;
					
				case oEnemy_Wizzrobe:
					image_index = 0;
					alarm[1] = 60;
					alarm[2] = -1;
					alarm[3] = -1;
					break;
					
			}			

		
			break;

		case EnemyState.KnockBack:
		
			switch(object_index){
					
				case oEnemy_Zol:
					image_index = 1;
					break;					
			}			

		
			break;
			
		case EnemyState.Stunned:

			switch(object_index){
					
				default:
					StunCounter = StunTime;
					StunnedShake = false;
					UnStunWhenHit = true;
					StunnedShakeIniX = x;
					break;
					
			}
			break;		

		
		case EnemyState.Shock:

			switch(object_index){
					
				case oEnemy_BuzzBlob:
					vx = 0;
					vy = 0;
					ShockCounter = 90;
					ShockFrame = 0;
					alarm[0] = -1;
					Lighting_UpdateLightStatus(LightIndex, true);
					Lighting_UpdateLightPos(LightIndex, x, y - 7);
					break;					
				
				case oEnemy_Bari:
					vx = 0;
					vy = 0;
					ShockCounter = 90;
					alarm[0] = -1;
					break;
			}
			break;
		
		case EnemyState.Frozen:
			vx = 0;	vy = 0;	
			Hit_Allowed = true;
			FrozenSparkleCounter = FrozenSparkleTime;
			break;
		
		case EnemyState.OnFire:
			vx = 0;	vy = 0;	
			OnFireCounter = OnFireTime;
			OnFireInst = instance_create_layer(x, y - 2, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oFireEffect);
			OnFireInst.sprite_index = sFireEffect_Long;
			if(!audio_is_playing(Sound_Enemy_Kill)) audio_play_sound(Sound_Enemy_Kill, 1, false);
			break;
		
		case EnemyState.StopWatch:
			
			vx = 0;	vy = 0;	
			ObjSetImageSpeed(0);
			StopWatch = true;
			switch(object_index){
					
				case oEnemy_Wizzrobe:
					Visible = true;
					break;					
				
			}
			break;
		
			
	}
	
	Enemy_UpdateSprite(State);
	
}


function Enemy_UpdateSprite(_State){
	
	switch(_State){
		
		case EnemyState.Idle:
			switch(object_index){
				
				case oEnemy_Eyegore:
					sprite_index = sEnemy_Eyegore_Stand;
					break;
				
				case oEnemy_Geldman:
					sprite_index = sEmptyMask;
					break;
					
				case oEnemy_Kyameron_Emitter:
					sprite_index = sEmptyMask;
					break;

				case oEnemy_Leever:
					sprite_index = sEmptyMask;
					break;
					
				case oEnemy_Zol:
					sprite_index = sEnemy_Zol_Wake;
					break;
			}
			break;
		
		case EnemyState.Wake:
			switch(object_index){
				
				case oEnemy_Kyameron_Emitter:
					sprite_index = sEnemy_Kyameron_Emitter;
					break;
					
				case oEnemy_Eyegore:
					sprite_index = sEnemy_Eyegore_Stand;
					break;
				
				case oEnemy_Geldman:
					sprite_index = sEnemy_Geldman_Wake;
					break;
				
				case oEnemy_Leever:
					sprite_index = sEnemy_Leever_Wake;
					break;
					
				case oEnemy_Wizzrobe:
					switch(Dir){
						case LEFT:	sprite_index = (Type == 0 ? sEnemy_Wizzrobe_Left : sEnemy_Wizzrobe2_Left); break;
						case RIGHT:	sprite_index = (Type == 0 ? sEnemy_Wizzrobe_Right : sEnemy_Wizzrobe2_Right); break;
						case UP:	sprite_index = (Type == 0 ? sEnemy_Wizzrobe_Up : sEnemy_Wizzrobe2_Up); break;
						case DOWN:	sprite_index = (Type == 0 ? sEnemy_Wizzrobe_Down : sEnemy_Wizzrobe2_Down); break;
					}
					break;

			}			
			break;
			
		case EnemyState.Standing:

			switch(object_index){
				
				case oEnemy_Buzz:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Buzz_Left; break;
						case RIGHT:	sprite_index = sEnemy_Buzz_Right; break;
						case UP:	sprite_index = sEnemy_Buzz_Up; break;
						case DOWN:	sprite_index = sEnemy_Buzz_Down; break;
					}
					break;
					
				case oEnemy_BuzzBlob:
					sprite_index = sEnemy_BuzzBlob;
					break;

				case oEnemy_Goriya:
					sprite_index = sEnemy_Goriya_Stand;
					switch(Dir){
						case LEFT:	image_index = 2; break;
						case RIGHT:	image_index = 3; break;
						case UP:	image_index = 1; break;
						case DOWN:	image_index = 0; break;
					}
					break;

				case oEnemy_Hinox:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Hinox_Walk_Left; break;
						case RIGHT:	sprite_index = sEnemy_Hinox_Walk_Right; break;
						case UP:	sprite_index = sEnemy_Hinox_Walk_Up; break;
						case DOWN:	sprite_index = sEnemy_Hinox_Walk_Down; break;
					}
					break;
					
				case oEnemy_Hover:
					sprite_index = sEnemy_Hover_Standing; 
					break;
					
				case oEnemy_Keese:
					sprite_index = asset_get_index("sEnemy_" + Keese_GetSpriteStr() + "_Standing"); 
					break;
					
				case oEnemy_Kodongo:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Kodongo_Walk_Left; break;
						case RIGHT:	sprite_index = sEnemy_Kodongo_Walk_Right; break;
						case UP:	sprite_index = sEnemy_Kodongo_Walk_Up; break;
						case DOWN:	sprite_index = sEnemy_Kodongo_Walk_Down; break;
					}
					break;

				case oEnemy_Octorok:
					switch(Dir){
						case LEFT:	
						case RIGHT:	sprite_index = sEnemy_Octorok_LeftRight; break;
						case UP:	
						case DOWN:	sprite_index = sEnemy_Octorok_UpDown; break;
					}
					break;

				case oEnemy_Pikit:
					sprite_index = sEnemy_Pikit;
					break;
					
				case oEnemy_Rat:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Rat_Stand_Left; break;
						case RIGHT:	sprite_index = sEnemy_Rat_Stand_Right; break;
						case UP: sprite_index = sEnemy_Rat_Stand_Up;	break;
						case DOWN: sprite_index = sEnemy_Rat_Stand_Down;	break;
					}	
					break;

				case oEnemy_Skeleton:
					sprite_index = sEnemy_SkeletonBody_Standing;
					image_index = Dir - 1;					
					break;
					
				case oEnemy_Soldier_Simple:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Soldier_Simple_Left; break;
						case RIGHT:	sprite_index = sEnemy_Soldier_Simple_Right; break;
						case UP: sprite_index = sEnemy_Soldier_Simple_Up;	break;
						case DOWN: sprite_index = sEnemy_Soldier_Simple_Down;	break;
					}	
					break;

				case oEnemy_Soldier_Mace:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Soldier_Slasher_Left; break;
						case RIGHT:	sprite_index = sEnemy_Soldier_Slasher_Right; break;
						case UP: sprite_index = sEnemy_Soldier_Slasher_Up;	break;
						case DOWN: sprite_index = sEnemy_Soldier_Slasher_Down;	break;
					}	
					break;
				
				case oEnemy_Tektite:
					sprite_index = sEnemy_Tektite_Standing; 
					break;
					
				case oEnemy_Zazak:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Zazak_Left; break;
						case RIGHT:	sprite_index = sEnemy_Zazak_Right; break;
						case UP: sprite_index = sEnemy_Zazak_Up;	break;
						case DOWN: sprite_index = sEnemy_Zazak_Down;	break;
					}						
					break;
					
			}
			break;
	

		case EnemyState.Walking:

			switch(object_index){
					
				case oEnemy_Bari:
					sprite_index = sEnemy_Bari_Walking;
					break;
				
				case oBoss_Moldorm:
					sprite_index = sBoss_Moldorm_Head;
					break;
					
				case oEnemy_Buzz:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Buzz_Left; break;
						case RIGHT:	sprite_index = sEnemy_Buzz_Right; break;
						case UP:	sprite_index = sEnemy_Buzz_Up; break;
						case DOWN:	sprite_index = sEnemy_Buzz_Down; break;
					}
					break;
					
				case oEnemy_BuzzBlob:
					sprite_index = sEnemy_BuzzBlob;
					break;

				case oEnemy_Eyegore:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Eyegore_Walk_Left; break;
						case RIGHT:	sprite_index = sEnemy_Eyegore_Walk_Right; break;
						case UP:	sprite_index = sEnemy_Eyegore_Walk_Up; break;
						case DOWN:	sprite_index = sEnemy_Eyegore_Walk_Down; break;
					}
					break;

				case oEnemy_Geldman:
					sprite_index = sEnemy_Geldman_Walk;
					break;
					
				case oEnemy_Gibdo:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Gibdo_Left; break;
						case RIGHT:	sprite_index = sEnemy_Gibdo_Right; break;
						case UP:	sprite_index = sEnemy_Gibdo_Up; break;
						case DOWN:	sprite_index = sEnemy_Gibdo_Down; break;
					}
					break;

				case oEnemy_Goriya:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Goriya_Left; break;
						case RIGHT:	sprite_index = sEnemy_Goriya_Right; break;
						case UP:	sprite_index = sEnemy_Goriya_Up; break;
						case DOWN:	sprite_index = sEnemy_Goriya_Down; break;
					}
					break;
				
				case oEnemy_Helmasaur:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Helmasaur_Left; break;
						case RIGHT:	sprite_index = sEnemy_Helmasaur_Right; break;
						case UP:	sprite_index = sEnemy_Helmasaur_Up; break;
						case DOWN:	sprite_index = sEnemy_Helmasaur_Down; break;
					}					
					break;
					
				case oEnemy_Hinox:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Hinox_Walk_Left; break;
						case RIGHT:	sprite_index = sEnemy_Hinox_Walk_Right; break;
						case UP:	sprite_index = sEnemy_Hinox_Walk_Up; break;
						case DOWN:	sprite_index = sEnemy_Hinox_Walk_Down; break;
					}
					break;
					
				case oEnemy_Hover:
					sprite_index = sEnemy_Hover_Walking; 
					break;

				case oEnemy_Keese:
					sprite_index = asset_get_index("sEnemy_" + Keese_GetSpriteStr() + "_Flying"); 
					break;
					
				case oEnemy_Kodongo:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Kodongo_Walk_Left; break;
						case RIGHT:	sprite_index = sEnemy_Kodongo_Walk_Right; break;
						case UP:	sprite_index = sEnemy_Kodongo_Walk_Up; break;
						case DOWN:	sprite_index = sEnemy_Kodongo_Walk_Down; break;
					}
					break;

				case oEnemy_Leever:
					sprite_index = sEnemy_Leever_Walking;
					break;	
					
				case oEnemy_Moldorm:
					sprite_index = sEnemy_Moldorm_Head;
					break;

				case oEnemy_Octorok:
					switch(Dir){
						case LEFT:	
						case RIGHT:	sprite_index = sEnemy_Octorok_LeftRight; break;
						case UP:	
						case DOWN:	sprite_index = sEnemy_Octorok_UpDown; break;
					}
					break;
					
				case oEnemy_Rat:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Rat_Walk_Left; break;
						case RIGHT:	sprite_index = sEnemy_Rat_Walk_Right; break;
						case UP: sprite_index = sEnemy_Rat_Walk_Up;	break;
						case DOWN: sprite_index = sEnemy_Rat_Walk_Down;	break;
					}	
					break;

				case oEnemy_Rope:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Rope_Left; break;
						case RIGHT:	sprite_index = sEnemy_Rope_Right; break;
						case UP:	sprite_index = sEnemy_Rope_Up; break;
						case DOWN:	sprite_index = sEnemy_Rope_Down; break;
					}
					break;

				case oEnemy_Skeleton:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_SkeletonBody_Walking_Left; break;
						case RIGHT:	sprite_index = sEnemy_SkeletonBody_Walking_Right; break;
						case UP: 
						case DOWN: 
							sprite_index = sEnemy_SkeletonBody_Walking_UpDown;
							break;
					}	
					break;
					
				case oEnemy_SnapDragon:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_SnapDragon_Up; break;
						case RIGHT:	sprite_index = sEnemy_SnapDragon_Down; break;
						case UP:	sprite_index = sEnemy_SnapDragon_Up; break;
						case DOWN:	sprite_index = sEnemy_SnapDragon_Down; break;
					}
					break;
					
				case oEnemy_Soldier_Simple:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Soldier_Simple_Left; break;
						case RIGHT:	sprite_index = sEnemy_Soldier_Simple_Right; break;
						case UP: sprite_index = sEnemy_Soldier_Simple_Up;	break;
						case DOWN: sprite_index = sEnemy_Soldier_Simple_Down;	break;
					}	
					break;

				case oEnemy_Soldier_Advanced:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Soldier_Advanced_Left; break;
						case RIGHT:	sprite_index = sEnemy_Soldier_Advanced_Right; break;
						case UP: sprite_index = sEnemy_Soldier_Advanced_Up;	break;
						case DOWN: sprite_index = sEnemy_Soldier_Advanced_Down;	break;
					}	
					break;

				case oEnemy_Soldier_Mace:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Soldier_Slasher_Left; break;
						case RIGHT:	sprite_index = sEnemy_Soldier_Slasher_Right; break;
						case UP: sprite_index = sEnemy_Soldier_Slasher_Up;	break;
						case DOWN: sprite_index = sEnemy_Soldier_Slasher_Down;	break;
					}	
					break;
				
				case oEnemy_Zazak:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Zazak_Left; break;
						case RIGHT:	sprite_index = sEnemy_Zazak_Right; break;
						case UP: sprite_index = sEnemy_Zazak_Up;	break;
						case DOWN: sprite_index = sEnemy_Zazak_Down;	break;
					}						
					break;
					
				case oEnemy_Zirro:
					switch(DirFaceLink()){
						case LEFT:	sprite_index = sEnemy_Zirro_Left; break;
						case RIGHT:	sprite_index = sEnemy_Zirro_Right; break;
						case UP: sprite_index = sEnemy_Zirro_Up; break;
						case DOWN: sprite_index = sEnemy_Zirro_Down; break;
					}						
					break;
					
				case oEnemy_Zol:
					sprite_index = sEnemy_Zol;
					break;

			}
				
			break;		
				
		case EnemyState.Running:
			switch(object_index){

				case oEnemy_Hinox:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Hinox_Walk_Left; break;
						case RIGHT:	sprite_index = sEnemy_Hinox_Walk_Right; break;
						case UP:	sprite_index = sEnemy_Hinox_Walk_Up; break;
						case DOWN:	sprite_index = sEnemy_Hinox_Walk_Down; break;
					}
					break;
					
				case oEnemy_Rope:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Rope_Left; break;
						case RIGHT:	sprite_index = sEnemy_Rope_Right; break;
						case UP:	sprite_index = sEnemy_Rope_Up; break;
						case DOWN:	sprite_index = sEnemy_Rope_Down; break;
					}
					break;				

				case oEnemy_Soldier_Simple:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Soldier_Simple_Left; break;
						case RIGHT:	sprite_index = sEnemy_Soldier_Simple_Right; break;
						case UP: sprite_index = sEnemy_Soldier_Simple_Up;	break;
						case DOWN: sprite_index = sEnemy_Soldier_Simple_Down;	break;
					}	
					break;

				case oEnemy_Soldier_Advanced:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Soldier_Advanced_Left; break;
						case RIGHT:	sprite_index = sEnemy_Soldier_Advanced_Right; break;
						case UP: sprite_index = sEnemy_Soldier_Advanced_Up;	break;
						case DOWN: sprite_index = sEnemy_Soldier_Advanced_Down;	break;
					}	
					break;
					
				case oEnemy_Soldier_Slasher:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Soldier_Slasher_Left; break;
						case RIGHT:	sprite_index = sEnemy_Soldier_Slasher_Right; break;
						case UP: sprite_index = sEnemy_Soldier_Slasher_Up;	break;
						case DOWN: sprite_index = sEnemy_Soldier_Slasher_Down;	break;
					}	
					break;
					
			}
			break;
		
		case EnemyState.Jumping:
			
			switch(object_index){
				
				case oEnemy_Buzz:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Buzz_Left; break;
						case RIGHT:	sprite_index = sEnemy_Buzz_Right; break;
						case UP:	sprite_index = sEnemy_Buzz_Up; break;
						case DOWN:	sprite_index = sEnemy_Buzz_Down; break;
					}
					break;

				case oEnemy_Geldman:
					sprite_index = sEnemy_Geldman_Jump;
					break;
					
				case oEnemy_Kyameron_Emitter:
					sprite_index = sEnemy_Kyameron_Jumping;
					break;

				case oEnemy_Pikit:
					sprite_index = sEnemy_Pikit;
					break;

				case oEnemy_Skeleton:
					sprite_index = sEnemy_SkeletonBody_Jumping;
					switch(Dir){
						case UP:	
						case DOWN:	image_index = 0; break;
						case LEFT:	image_index = 1; break;
						case RIGHT:	image_index = 2; break;
					}				
					break;
					
				case oEnemy_Tektite:
					sprite_index = sEnemy_Tektite_Jumping; 
					break;
					
				case oEnemy_Zol:
					sprite_index = sEnemy_Zol;
					break;
					
			}
			break;
			
		case EnemyState.Shooting:

			switch(object_index){

				case oEnemy_Hinox:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Hinox_Bomb_Left; break;
						case RIGHT:	sprite_index = sEnemy_Hinox_Bomb_Right; break;
						case UP:	sprite_index = sEnemy_Hinox_Bomb_Up; break;
						case DOWN:	sprite_index = sEnemy_Hinox_Bomb_Down; break;
					}
					break;
					
				case oEnemy_Kodongo:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Kodongo_Shoot_Left; break;
						case RIGHT:	sprite_index = sEnemy_Kodongo_Shoot_Right; break;
						case UP:	sprite_index = sEnemy_Kodongo_Shoot_Up; break;
						case DOWN:	sprite_index = sEnemy_Kodongo_Shoot_Down; break;
					}
					break;

				case oEnemy_Octorok:
					switch(Dir){
						case LEFT:	
						case RIGHT:	sprite_index = sEnemy_Octorok_LeftRight; break;
						case UP:	
						case DOWN:	sprite_index = sEnemy_Octorok_UpDown; break;
					}
					break;

				case oEnemy_Pikit:
					sprite_index = sEnemy_Pikit_Shooting;
					break;
				
				case oEnemy_Skeleton:
					sprite_index = sEnemy_SkeletonBody_Standing;
					image_index = Dir - 1;
					break;
					
				case oEnemy_Zazak:
					switch(Dir){
						case LEFT:	sprite_index = sEnemy_Zazak_Left; break;
						case RIGHT:	sprite_index = sEnemy_Zazak_Right; break;
						case UP: sprite_index = sEnemy_Zazak_Up;	break;
						case DOWN: sprite_index = sEnemy_Zazak_Down;	break;
					}						
					break;

				case oEnemy_Zirro:
					switch(DirFaceLink()){
						case LEFT:	sprite_index = sEnemy_Zirro_Attack_Left; break;
						case RIGHT:	sprite_index = sEnemy_Zirro_Attack_Right; break;
						case UP: sprite_index = sEnemy_Zirro_Up; break;
						case DOWN: sprite_index = sEnemy_Zirro_Attack_Down; break;
					}						
					break;
					
			}
				
			break;

		case EnemyState.Sleep:
			switch(object_index){

				case oEnemy_Eyegore:
					sprite_index = sEnemy_Eyegore_Stand;
					break;

				case oEnemy_Geldman:
					sprite_index = sEnemy_Geldman_Sleep;
					break;

				case oEnemy_Leever:
					sprite_index = sEnemy_Leever_Sleep;
					break;					

			}			
			break;
			
		case EnemyState.Shock:

			switch(object_index){
					
				case oEnemy_Bari:
					sprite_index = sEnemy_Bari_Shock;
					break;

				case oEnemy_BuzzBlob:
					sprite_index = sEnemy_BuzzBlob_Shock;
					break;

					
			}
			break;
				
		
	}
			
}

function Enemy_UpdateV(Speed){
	
	vx = 0;	vy = 0;
	switch(Dir){
		case LEFT:	vx = -Speed; break;
		case RIGHT:	vx = Speed; break;
		case UP:	vy = -Speed;break;
		case DOWN:	vy = Speed;	break;
	}		
		
}

function Enemy_WallCollisionNewDir(Orientation){
	
	switch(Orientation){
		case HORIZONTAL:
			var Dir1 = LEFT;
			var Dir2 = RIGHT;
			var Dir3 = UP;
			var Dir4 = DOWN;
			var Wall1 = ObjCollision(x, y - 6, oWall);
			var Wall2 = ObjCollision(x, y + 6, oWall);
			break;
		case VERTICAL:
			var Dir1 = UP;
			var Dir2 = DOWN;
			var Dir3 = LEFT;
			var Dir4 = RIGHT;
			var Wall1 = ObjCollision(x - 6, y, oWall);
			var Wall2 = ObjCollision(x + 6, y, oWall);
			break;
	}

	var OppositeDir = (Dir == Dir1 ? Dir2 : Dir1);
	if(Wall1 == noone && Wall2 == noone)
		return choose(Dir3, Dir4, OppositeDir);
	else if(Wall1 == noone && Wall2 != noone)
		return choose(Dir3, OppositeDir);
	else if(Wall1 != noone && Wall2 == noone)
		return choose(Dir4, OppositeDir);
	else
		return OppositeDir;
		
}

function Enemy_LinkInSight(_Dir, _Offset, _Distance){
	
	if(!Sight || FloorLevel != oLink.FloorLevel) return false;
	
	//Checks a rectangle in front of enemy of width 2x_Offset at _Distance away
	switch(_Dir){
		case UP:
			var SightX1 = x - _Offset; var SightY1 = y - _Distance;	var SightX2 = x + _Offset; var SightY2 = y;					
			break;
		case DOWN:
			var SightX1 = x - _Offset; var SightY1 = y; var SightX2 = x + _Offset; var SightY2 = y + _Distance;	
			break;
		case LEFT:
			var SightX1 = x - _Distance; var SightY1 = y - 6 - _Offset; var SightX2 = x; var SightY2 = y - 6 + _Offset;	
			break;
		case RIGHT:
			var SightX1 = x; var SightY1 = y - 6 - _Offset; var SightX2 = x + _Distance; var SightY2 = y - 6 + _Offset;	
			break;
	}
	
	//temp for drawing
	//global.SightX1 = SightX1;
	//global.SightY1 = SightY1;
	//global.SightX2 = SightX2;
	//global.SightY2 = SightY2;
	
	
	return collision_rectangle(SightX1, SightY1, SightX2, SightY2, oLink, false, true);
			
}


function Enemy_Reset(_RoomIndex){
	
	var TRoom = global.Level.DungeonTemplate.Rooms[_RoomIndex];
	with(oEnemy){
			
		//skip the following enemies
		switch(object_index){
			case oBoss_Armos:
			case oBoss_Moldorm:
			case oEnemy_Guru:
			case oEnemy_Kyameron_Moving:	
				continue;
		}
			
		//only reset enemies that are in the transition Room
		if(collision_rectangle(TRoom.x, TRoom.y, TRoom.x + TRoom.width - 1, TRoom.y + TRoom.height - 1, self, false, false)){
				
			switch(object_index){
				default:
					var inst = instance_create_layer(Reset_StartX, Reset_StartY, layer, object_index, {FloorLevel : self.FloorLevel, 
																										ItemHolding : self.ItemHolding, 
																										RoomTemplate : self.RoomTemplate,
																										SectionID : self.SectionID,
																										RoomX : self.RoomX,
																										RoomY : self.RoomY});
					break;

			}

			for(var i = 0; i < array_length(SaveVariables); i++){
				var VarName = SaveVariables[i];
				variable_instance_set(inst, VarName, variable_instance_get(self, VarName))
			}
					
			instance_destroy(id);
		}
	}

}

function Enemy_SetEnergy(_EnergyIndex){
	EnergyIndex = _EnergyIndex;
	MaxEnergy = global.EnemyHitsToKill[Swords.Basic][EnergyIndex];
	Energy = MaxEnergy;
}

function Enemy_UpdateChainSegment(MainInst, ConnectedInst, MaxDist){

	if(point_distance(ConnectedInst.x, ConnectedInst.y, MainInst.x, MainInst.y) > MaxDist){
		var Angle = point_direction(MainInst.x, MainInst.y, ConnectedInst.x, ConnectedInst.y);
		ConnectedInst.x = MainInst.x + lengthdir_x(MaxDist, Angle); 
		ConnectedInst.y = MainInst.y + lengthdir_y(MaxDist, Angle);
	}
	
}

function RenderInWater(){

	if(DoWater){
		PixelRender_Dim(true, true, false, noone, 0, false, noone, false, []);

		if(InWater) draw_sprite(sInWater, global.InWaterImgIndex, x, y + InWaterOffsetY);

		shader_reset();	
	}

}
