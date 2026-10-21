enum EnemyState{
	Idle,
	Wake,
	Standing,
	Walking,
	Running,
	Jumping,
	Charging,
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
	Stone,
	Transformed,
	Killed
}

enum EnemyHitEffect{
	Function = -10,
	Transform,
	Stone,
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

enum EnemySize{
	Tiny,
	Small,
	Medium,
	Large
}

enum EnemyTransformation{
	Bomb,
	Heart,
	Rupees
}

#macro PauseCheck  if(global.Paused || State == EnemyState.KnockBack || State == EnemyState.PushBack || State == EnemyState.Stunned || State == EnemyState.Frozen || State == EnemyState.OnFire || State == EnemyState.Stone) { ObjPause();	exit; } else image_speed = LastImageSpeed

//knockback colors
#macro KB_R [1.0,0.0,0.0]
#macro KB_G [0.0,1.0,0.0]
#macro KB_B [0.0,0.0,1.0]
#macro KB_Br [-1,-1,-1] //bright
#macro KB_Gr [-2,-2,-2] //Greyscale
#macro KB_In [-3,-3,-3] //invert

//H = Hit Effect IDs. Using small names to make entering data in the table easier
#macro H_FF -10 //Function (value determined by some condition)
#macro H_Tr -9 //Transform
#macro H_ST -8 //Stone
#macro H_Fr -7 //Freeze
#macro H_Fi -6 //Fire
#macro H_Sh -5 //Shock Link
#macro H_SD -4 //Stun Damage
#macro H_St -3 //Stun
#macro H_PB -2 //Push Back
#macro H_ND -1 //No Damage (wall hit effect)
// 0 = Ignore
//0.5= Ignore but register hit
//>0.5= Damage amount

#macro EnemyEnergyConsideredDead 0.05 //amount if enemy energy <= than this amount is considered dead. This is because global.LinkSwordDamage might have very small fractional values slightly larger than 0, making Link have to hit it 1 extra time to kill it if the bounds were <= 0

#macro BombDmg 4

#macro EnergyIndexes 15

function Enemies_InitData(){
	
	global.EnemyHitsToKill[0] = array_create(EnergyIndexes); //index 0 will take on the same values as index 1
	//Table that says how many hits we want to kill an enemy with n Attack points:
	//					Link			Enemy Energy index
	//				  Attk Pts   0	1	2	3	4	5	6	7	8	9	10	11	12  13, 14		<- 10,11,12 are reserved for the bosses, 13 is for Moldorm when enemies are tougher, 14 for the chicken, 0 not used
	global.EnemyHitsToKill[1] =	[1,	2,	3,	4,	5,	6,	7,	8,  9, 10,	10,	14,	18,	24, 999];
	global.EnemyHitsToKill[2] =	[1,	1,	2,	3,	4,	5,	6,	7,	8,  9,	 9,	13,	16,	22, 999];
	global.EnemyHitsToKill[3] =	[1,	1,	1,	2,	3,	4,	5,	6,	7,	8,	 8,	12,	15,	20, 999];
	global.EnemyHitsToKill[4] =	[1,	1,	1,	2,	3,	3,	4,	5,	6,	7,	 7,	10,	14,	18, 999];
	global.EnemyHitsToKill[5] =	[1,	1,	1,	1,	2,	3,	3,	4,	5,	6,	 6,	 9,	13,	16, 999];
	global.EnemyHitsToKill[6] =	[1,	1,	1,	1,	2,	2,	3,	3,	4,	5,	 5,	 8,	12,	15, 999];
	global.EnemyHitsToKill[7] =	[1,	1,	1,	1,	1,	2,	2,	3,	3,	4,	 4,	 7,	11, 14, 999];
	global.EnemyHitsToKill[8] =	[1,	1,	1,	1,	1,	1,	2,	2,	2,	3,	 3,	 6,	10,	13, 999];
	

	//then create a table that holds the damage needed for each attack index to kill the enemy in n hits from the table above.
	//Link will then use this table to determine how much damage his sword inflicts.
	//Example: An enemy with a max energy of 6, if we want to kill it in 3 hits with, we need to inflict 6 / 3 = 2 damage to do that
	for(var _AttackIndex = 1; _AttackIndex <= 8; _AttackIndex++){
		global.LinkSwordDamage[_AttackIndex] = array_create(EnergyIndexes);
		for(var _EnergyIndex = 0; _EnergyIndex < EnergyIndexes; _EnergyIndex++){
			global.LinkSwordDamage[_AttackIndex][_EnergyIndex] = global.EnemyHitsToKill[1][_EnergyIndex] / global.EnemyHitsToKill[_AttackIndex][_EnergyIndex];			
		}
	}
	//attack index 0
	for(var _EnergyIndex = 0; _EnergyIndex < EnergyIndexes; _EnergyIndex++){
		global.EnemyHitsToKill[0][_EnergyIndex] = global.EnemyHitsToKill[1][_EnergyIndex];
		global.LinkSwordDamage[0][_EnergyIndex] = global.LinkSwordDamage[1][_EnergyIndex];
	}
	
									     //					Pack	Hit effects for link weapons. Values in brackets are the true/false values after testing a condition												Levels		   
									     //Ene Atk SItm	Itm	Pts	[   SWORD   ,   POT     ,   ARROW   , BOOMERANG ,  HOOKSHOT ,   BOMB    ,   FIRE    ,     ICE   ,SWORD BEAM	,	STONE	,TRANSFORM ]	[St,Cas,Bsm,Jai,Cat,Sew,Vil,Lan,Rns,Wat,Min,Mol,Ag1]
	EnemyDataInit(oBoss_Armos,			   10,	1,	0,	0,	0,	[[H_FF,H_ND],	H_ND	,[1.5,H_ND]	,	H_ND	,	H_ND	,[BombDmg/2,0],[2,H_ND]	,[2,H_ND]	,	H_ND	,[2,H_ND]	,[2,H_ND]	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oBoss_Lanmola,		   11,2.25,	0,	0,	0,	[	H_FF	,	H_ND	,	1.5		,	H_ND	,	H_ND	,	0		,	2		,	2		,	H_ND	,	2		,	2		],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oBoss_Moldorm,		   12,	0,	0,	0,	0,	[	0.5		,	H_ND	,	H_ND	,	H_ND	,	H_ND	,	0		,	H_ND	,	H_ND	,	H_ND	,	H_ND	,	H_ND	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oBoss_Moldorm_BodyL,	    0,	0,	0,	0,	0,	[	0		,	H_ND	,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oBoss_Moldorm_BodyS,	    0,	0,	0,	0,	0,	[	0		,	H_ND	,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oBoss_Moldorm_Tail,		0,	0,	0,	0,	0,	[	0.5		,	H_ND	,	0.5		,	H_ND	,	H_ND	,	0		,	0.5		,	0.5		,	H_ND	,	0.5		,	0.5		],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oBoss_Aghanim,		   12,1.75,	0,	0,	0,	[[H_Sh,0]	,	H_ND	,	H_ND	,	H_ND	,	H_ND	,[4,0]		,	H_ND	,	H_ND	,	H_ND	,	H_ND	,	0		],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	
	
	EnemyDataInit(oEnemy_Bubble,		    0,	1,	0,	0,	5,	[[H_FF,0]	,	0		,	0		,	0		,	0		,	0		,	0		,	0		,[H_FF,0]	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	2,	1,	1,	0,	1,	1]); 
	EnemyDataInit(oEnemy_Buzz,				0,0.75,	1,	1,	1,	[	H_FF	,	2		,	2		,	9		,	9		,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	1,	0,	2,	1,	0,	0,	0,	0]); 
	EnemyDataInit(oEnemy_Hoarder,			0,1.25,	1,	1,	1,	[	H_FF	,	2		,	2		,	9		,	9		,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	1,	2,	0,	0,	3,	0]);
	EnemyDataInit(oEnemy_Hover,				0,1.5,	1,	1,	3,	[	H_FF	,	2		,	2		,	9		,	9		,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	3,	0,	0,	0,	2,	0,	0,	0]);
	EnemyDataInit(oEnemy_Keese,				0,0.25,	0,	0,	3,	[	H_FF	,	2		,	2		,	9		,	9		,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	1,	1,	2,	1,	0,	0,	2,	2,	0,	0,	0]);
	EnemyDataInit(oEnemy_Kyameron_Moving,	0,0.75,	0,	0,	0,	[	H_FF	,	1		,	1		,	9		,	9		,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Poe,				0,	1,	0,	0,	3,	[	H_FF	,	2		,	2		,	9		,	9		,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	2,	0,	0,	0,	2,	1,	0,	0,	2]);
	EnemyDataInit(oEnemy_Rat,				0,0.25,	1,	1,	2,	[	H_FF	,	2		,	2		,	9		,	9		,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	2,	1,	1,	2,	0,	0,	1,	0,	0,	0,	0]);
	//EnemyDataInit(oEnemy_Kyune,			0,	1,	0,	0,	3,	[	H_FF	,	2		,	2		,	9		,	9		,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	//EnemyDataInit(oEnemy_Pirugusu,		0,	1,	0,	0,	4,	[	H_FF	,	2		,	2		,	9		,	9		,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1]);
	
	EnemyDataInit(oEnemy_Rope,				1,0.5,	1,	1,	3,	[	H_FF	,	2		,	2		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	1,	1,	1,	1,	0,	0,	0,	0,	0,	0,	0]);	
	
	EnemyDataInit(oEnemy_Bari,				2,1.25,	1,	1, 	3,	[[H_FF,H_Sh],	2		,	2		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	2,	0,	0,	0,	1,	0,	0,	2]); 
	EnemyDataInit(oEnemy_Zol,				2,1.25,	0,	1,	3,	[[H_FF,0]	,[2,0]		,[2,0]		,[H_St,0]	,[H_St,0]	,[BombDmg,0],[H_Fi,0]	,[H_Fr,0]	,[H_FF,0]	,[H_ST,0]	,[H_Tr,0]	],	[0,	0,	0,	0,	0,	2,	0,	0,	0,	1,	0,	0,	0]);
	
	EnemyDataInit(oEnemy_BuzzBlob,			3,1.25,	0,	1,	3,	[[H_FF,H_Sh],	2		,	2		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	1,	0,	1,	1,	0,	0,	1,	0]); 
	EnemyDataInit(oEnemy_Pikit,				3,1.25,	0,	0,	3,	[	H_FF	,	2		,	2		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	2,	0,	1,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Popo,				3,1.5,	1,	1,	3,	[	H_FF	,	2		,	2		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	3,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Skeleton,			3,	1,	1,	1,	4,	[	H_FF	,	2		,	2		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	2,	0,	0,	0,	0,	0,	0,	0,	0]);
	//EnemyDataInit(oEnemy_Soldier_Slasher,	3,	1,	1,	1,	4,	[[H_FF,H_PB],	2		,	2		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1]);
	
	EnemyDataInit(oEnemy_Crab,				4,1.25,	1,	1,	3,	[	H_FF	,	2		,	2		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	2,	0,	1,	0,	0,	0,	0,	0]); 
	EnemyDataInit(oEnemy_Gibdo,				4,1.25,	1,	1,	4,	[	H_FF	,	2		,	2		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	2,	0,	0,	3,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Helmasaur,			4,1.5,	1,	1,	3,	[[H_FF,H_PB],	H_ND	,	2		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	0,	2,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Kodongo,			4,1.75,	1,	1,	3,	[	H_FF	,	2		,	2		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	0,	2,	0,	0,	3,	1]);
	EnemyDataInit(oEnemy_Leever,			4,1.75,	0,	1,	3,	[[H_FF,0]	,[2,H_ND]	,[2,0]		,[H_St,H_ND],[H_St,H_ND],[BombDmg,0],[H_Fi,H_ND],[H_Fr,0]	,[H_FF,0]	,[H_ST,0]	,[H_Tr,0]	],	[0,	0,	0,	0,	0,	0,	0,	2,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Moldorm,			4, 2  ,	1,	1,	3,	[	H_FF	,	2		,	2		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	4,	0]);
	EnemyDataInit(oEnemy_Octorok,			4,1.5,	1,	1,	3,	[	H_FF	,	2		,	2		,	H_St	,	H_St	,	BombDmg ,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	2,	0,	0,	0,	2,	0]);
	EnemyDataInit(oEnemy_Ropa,				4,1.75,	1,	1,	3,	[	H_FF	,	2		,	2		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	2,	0,	0,	0,	3,	1]);
	EnemyDataInit(oEnemy_Wizzrobe,			4,2.5,	0,	1,	3,	[[H_FF,0]	,[2,0]		,[9,0]		,[H_St,0]	,[H_St,0]	,[BombDmg,0],[H_Fi,0]	,[H_Fr,0]	,[H_FF,0]	,[H_ST,0]	,[H_Tr,0]	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	3,	0,	0,	2]);

	
	EnemyDataInit(oEnemy_HardhatBeetle,		5,2.25,	1,	1,	3,	[	H_FF	,	2		,	2		,	H_St	,	H_St	,	BombDmg ,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	3,	0,	0,	0]);
	EnemyDataInit(oEnemy_SnapDragon,		5,  2,	1,	1,	4,	[	H_FF	,	2		,	2		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	2]);
	EnemyDataInit(oEnemy_Geldman,			5,	2,	0,	1,	5,	[[H_FF,0]	,[2,0]		,[2,0]		,[H_St,0]	,[H_St,0]	,[BombDmg,0],[H_Fi,0]	,[H_Fr,0]	,[H_FF,0]	,[H_ST,0]	,[H_Tr,0]	],	[0,	0,	0,	0,	0,	0,	0,	2,	0,	0,	0,	0,	0]);
	
	//EnemyDataInit(oEnemy_Delavant,			6,	2,	0,	1,	4,	[[H_FF,0]	,[2,0]	,[2,0]		,[H_St,0]	,[H_St,0]	,[BombDmg,0],[H_Fi,0]	,[H_Fr,0]	,[H_FF,0]	,[H_ST,0]	,[H_Tr,0]	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Goriya,			6,2.5,	1,	1,	5,	[	H_FF	,	2		,	2		,	H_St	,	H_St	,	BombDmg ,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	0,	3,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Zirro,				6,2.25,	0,	0,	5,	[	H_FF	,	2		,	9		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	0,	2,	0,	0,	0,	1]); 
	EnemyDataInit(oEnemy_Zazak,				6,2.75,	1,	1,	5,	[	H_FF	,	2		,	2		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	2,	0,	0,	0]); 
	
	EnemyDataInit(oEnemy_Eyegore,			7,  3,	1,	1,	6,	[[H_FF,H_ND],[2,H_ND]	,[4,H_ND]	,[H_St,H_ND],[H_St,H_ND],[BombDmg,0],[H_Fi,H_ND],[H_Fr,0]	,[H_FF,H_ND],[H_ST,0]	,[H_Tr,0]	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	3,	0,	0,	0]); 
	
	EnemyDataInit(oEnemy_Tektite,			8,	3,	1,	1,	5,	[	H_FF	,	2		,	9		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	2,	2]);
	
	EnemyDataInit(oEnemy_Armos,				9,3.5,	1,	1, 	6,	[[H_FF,H_ND],[2,H_ND]	,[2,H_ND]	,	H_ND	,	H_ND	,[BombDmg,0],[H_Fi,H_ND],[H_Fr,0]	,[H_FF,H_ND],[H_ST,0]	,	[H_Tr,0]],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	3]); 
	EnemyDataInit(oEnemy_Hinox,				9,3.75,	1,	1,	6,	[	H_FF	,	H_ND	,	H_ND	,	H_ND	,	H_ND	,	0		,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	5]);
	//EnemyDataInit(oEnemy_Lynel,			9,	5,	1,	1,	5,	[	H_FF	,	2		,	2		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1]);

	EnemyDataInit(oEnemy_Beamos,		    0,  2,	0,	0,	0,	[	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	H_ST	,	0		],	[0,	0,	0,	0,	0,	0,	0,	3,	3,	3,	0,	0,	4]); 
	EnemyDataInit(oEnemy_Cannon,		    0,	0,	0,	0,	0,	[[H_FF,0]	,	0		,	0		,	0		,	0		,	0		,	H_Fi	,	H_Fr	,[H_FF,0]	,	H_ST	,	0		],	[0,	0,	0,	0,	0,	1,	0,	1,	1,	1,	0,	1,	1]); 
	EnemyDataInit(oEnemy_Guru,				0,	0,	0,	0,	0,	[	0		,	0		,	0		,	0		,	0		,	0		,[H_Fi,0]	,[H_Fr,0]	,	0		,	0		,	0		],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]); 
	EnemyDataInit(oEnemy_Guru_Bar,		    0,	0,	0,	0,	0,	[	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		],	[0,	0,	0,	0,	1,	0,	0,	1,	1,	2,	0,	1,	1]);
	EnemyDataInit(oEnemy_Kyameron_Emitter,  0,	0,	0,	0,	3,	[	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		],	[0,	0,	0,	0,	0,	2,	0,	0,	0,	2,	0,	0,	0]);
	EnemyDataInit(oEnemy_Medusa,		    0,	0,	0,	0,	0,	[[H_FF,0]	,	0		,	0		,	0		,	0		,	0		,	H_Fi	,	H_Fr	,[H_FF,0]	,	H_ST	,	0		],	[0,	0,	0,	0,	0,	0,	0,	2,	1,	1,	0,	1,	1]);
	EnemyDataInit(oEnemy_RollingSpike,	    0,  2,	0,	0,	0,	[	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	0		,	H_ST	,	0		],	[0,	0,	0,	0,	0,	0,	0,	1,	1,	1,	0,	1,	1]);
	EnemyDataInit(oEnemy_MovingSpikeBlock,  0,	2,	0,	0,	0,	[[H_FF,0]	,	0		,	0		,	0		,	0		,	0		,	0		,	0		,[H_FF,0]	,	H_ST	,	0		],	[0,	0,	0,	0,	0,	0,	0,	1,	1,	1,	0,	1,	1]);
	
	EnemyDataInit(oEnemy_Soldier_Advanced,	0,	0,	1,	1,	4,	[[H_FF,H_PB],	2		,	2		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	2,	3,	3,	2,	0,	0,	0,	0,	2,	0,	0,	5]); 
	EnemyDataInit(oEnemy_Soldier_Simple,	0,  0,	1,	1,	3,	[	H_FF	,	2		,	2		,	H_St	,	H_St	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	3,	3,	2,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Soldier_Mace,		0,	0,	1,	1,	6,	[	H_FF	,	2		,	2		,	H_ND	,	H_ND	,	BombDmg	,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	1,	0,	0,	0,	0,	0,	0,	0,	0,	2]);
	
	EnemyDataInit(oEnemy_Chicken,		   14,	0,	0,	0,	0,	[	H_FF	,	1		,	1		,	1		,	1		,	1		,	H_Fi	,	H_Fr	,	H_FF	,	H_ST	,	H_Tr	],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_FootSoldier,	   14,	0,	0,	0,	0,	[	H_FF	,	1		,	1		,	1		,	1		,	1		,	H_ND	,	H_ND	,	H_FF	,	0		,	0		],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	EnemyDataInit(oEnemy_Wallmaster,	   14,	2,	0,	0,	0,	[	H_FF	,	1		,	1		,	1		,	1		,	1		,	1		,	1		,	H_FF	,	1		,	1		],	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]);
	
	global.KnockBackColors = array_create(0);
	array_push(global.KnockBackColors, KB_R,KB_R,KB_G,KB_G,KB_In,KB_In,KB_B,KB_B,KB_Br,KB_Br,KB_In,KB_In,KB_R,KB_R,KB_G,KB_G,KB_In,KB_In,KB_B,KB_B,KB_Br,KB_Br,KB_In,KB_In);
	global.KnockBackColorFrames = array_length(global.KnockBackColors);

}

function EnemyDataInit(_ObjIndex, _EnergyIndex, _Attack, _SpecialItem, _Item, _PackPoints, _LinkWeaponEffects, _Levels){

	global.EnemyData[_ObjIndex] = {};
	
	global.EnemyData[_ObjIndex][$ "EnergyIndex"] = _EnergyIndex;
	global.EnemyData[_ObjIndex][$ "Attack"] = _Attack;
	global.EnemyData[_ObjIndex][$ "SpecialItem"] = _SpecialItem;
	global.EnemyData[_ObjIndex][$ "Item"] = _Item;
	global.EnemyData[_ObjIndex][$ "PackPoints"] = _PackPoints;
	
	global.EnemyData[_ObjIndex][$ "LinkWeaponEffects"] = array_create(LinkWeapons);
	for(var _WeaponIndex = 0; _WeaponIndex < LinkWeapons; _WeaponIndex++){
		global.EnemyData[_ObjIndex][$ "LinkWeaponEffects"][_WeaponIndex] = _LinkWeaponEffects[_WeaponIndex];
	}
	
	global.EnemyData[_ObjIndex][$ "Levels"] = array_create(DungeonLevels - 1);
	for(var _LevelIndex = 0; _LevelIndex < DungeonLevels - 1; _LevelIndex++){
		global.EnemyData[_ObjIndex][$ "Levels"][_LevelIndex] = _Levels[_LevelIndex];
	}
	
}

function Enemy_LinkWeaponHit(_WeaponClass, _WeaponIndex, _EnemyInst, _x, _y, _Dir){

	with(_EnemyInst){
	
		if(!is_struct(global.EnemyData[object_index])) return false;
	
		Hit_LinkWeaponEffect = global.EnemyData[object_index].LinkWeaponEffects[_WeaponClass];

		switch(State){
			
			case EnemyState.Frozen:
				//if frozen and hit by one of these weapons, just set the hit effect to 100 causing 100 damage to destroy any enemy that's frozen, bypassing all the following blocks of code
				
				switch(object_index){
					case oEnemy_Guru:
						Hit_LinkWeaponEffect = EnemyHitEffect.Ignore;
						break;
				}
				
				switch(_WeaponClass){

					case LinkWeaponClass.Transform:
						Hit_LinkWeaponEffect = EnemyHitEffect.Transform;
						break;
						
					case LinkWeaponClass.Sword:
					case LinkWeaponClass.SwordBeam:
					case LinkWeaponClass.Fire:
					case LinkWeaponClass.Stone:
					case LinkWeaponClass.Bomb:
					case LinkWeaponClass.Arrow:
					case LinkWeaponClass.Boomerang:
					case LinkWeaponClass.Hookshot:
					case LinkWeaponClass.Pot:	
						Hit_LinkWeaponEffect = 100;
						break;
						
					default:
						Hit_LinkWeaponEffect = EnemyHitEffect.Ignore;
						break;
						
				}
				break;
			
			case EnemyState.Stunned:
				if(is_array(Hit_LinkWeaponEffect)) Hit_LinkWeaponEffect = Hit_LinkWeaponEffect[0]; //first element is always the hit condition
				break;
				
			case EnemyState.Stone:
				switch(_WeaponClass){
					case LinkWeaponClass.Stone:
						Hit_LinkWeaponEffect = EnemyHitEffect.Ignore;
						break;
					
					default:
						if(is_array(Hit_LinkWeaponEffect)) Hit_LinkWeaponEffect = Hit_LinkWeaponEffect[0]; //first element is always the hit condition
						break;
				}
				
				break;
			
		}

		if(_WeaponClass == LinkWeaponClass.Sword && oLink.State == LinkState.Star){ //sloppy fix for gurus, when hitting them while star, they would misallign themselves
			Energy = 1;
			Hit_LinkWeaponEffect = 100;
		}else{
				
			if(is_array(Hit_LinkWeaponEffect)){
	
				//Effects in brackets are the true/false values after checking a condition	

				switch(object_index){
					
					//extra enemies you can hit when you have blood or master sword
					case oEnemy_Bubble:		
					case oEnemy_MovingSpikeBlock:
					case oEnemy_Medusa:
					case oEnemy_Cannon:
						Hit_LinkWeaponEffect = (SwordLevel(Swords.Blood) ? Hit_LinkWeaponEffect[0] : Hit_LinkWeaponEffect[1]); 
						break;
						
					case oBoss_Armos:
						
						if(id == oBoss_Armos_C.LastArmos_Inst){
							Hit_LinkWeaponEffect = _WeaponClass == LinkWeaponClass.Arrow ? Hit_LinkWeaponEffect[1] : Hit_LinkWeaponEffect[0];//((oBoss_Armos_C.LastArmos_Jump || State == EnemyState.KnockBack || alarm[6] != -1 || !Hit_Allowed) ? 0 : (_WeaponClass == LinkWeaponClass.Sword ? 1.5 : 1));
						}else{
							Hit_LinkWeaponEffect = (State == EnemyState.Jumping || State == EnemyState.Shooting ? Hit_LinkWeaponEffect[0] : Hit_LinkWeaponEffect[1]); 
						}
						break;
						
					case oEnemy_Bari:		Hit_LinkWeaponEffect = ((!CanShock || SwordLevel(Swords.Dragon) || oLink.Cape) ? Hit_LinkWeaponEffect[0] : Hit_LinkWeaponEffect[1]); break;
					case oEnemy_BuzzBlob:	Hit_LinkWeaponEffect = ((SwordLevel(Swords.Dragon) || oLink.Cape) ? Hit_LinkWeaponEffect[0] : Hit_LinkWeaponEffect[1]); break;
					case oEnemy_Eyegore:	Hit_LinkWeaponEffect = (State == EnemyState.Walking ? Hit_LinkWeaponEffect[0] : Hit_LinkWeaponEffect[1]); break;
					case oEnemy_Zol:		Hit_LinkWeaponEffect = ((State != EnemyState.Idle && State != EnemyState.Wake) ? Hit_LinkWeaponEffect[0] : Hit_LinkWeaponEffect[1]); break;
		
					case oEnemy_Armos:
					case oEnemy_Geldman:
					case oEnemy_Leever:
						Hit_LinkWeaponEffect = (State == EnemyState.Walking ? Hit_LinkWeaponEffect[0] : Hit_LinkWeaponEffect[1]); 
						break;
					
					case oEnemy_Guru:
						switch(Type){
							case 0: //yellow guru
								Hit_LinkWeaponEffect = (_WeaponClass == LinkWeaponClass.Ice ? Hit_LinkWeaponEffect[0] : Hit_LinkWeaponEffect[1]);
								break;
							case 1: //blue guru
								Hit_LinkWeaponEffect = (_WeaponClass == LinkWeaponClass.Fire ? Hit_LinkWeaponEffect[0] : Hit_LinkWeaponEffect[1]);
								break;
							case 2: //red guru
								Hit_LinkWeaponEffect = EnemyHitEffect.Ignore;
								break;
							
						}						
						break;
						
					case oEnemy_Delavant:
						Hit_LinkWeaponEffect = (State == EnemyState.Idle ? Hit_LinkWeaponEffect[1] : Hit_LinkWeaponEffect[0]); 
						break;
						
					case oEnemy_Helmasaur:
						if(Dir == OppositeDir(oLink.Facing) && !SwordLevel(Swords.Master)){
							instance_create_layer(x, y, "ObjsHigher_Upper", oWallHit, {PlaySound: true});
							Hit_LinkWeaponEffect = Hit_LinkWeaponEffect[1];
						}else{
							Hit_LinkWeaponEffect = Hit_LinkWeaponEffect[0];
						}
						break;
				
					case oEnemy_Soldier_Advanced:
					case oEnemy_Soldier_Slasher:
						Hit_LinkWeaponEffect = (Pushback ? Hit_LinkWeaponEffect[1] : Hit_LinkWeaponEffect[0]); 
						break;
				
					case oEnemy_Wizzrobe:	Hit_LinkWeaponEffect = (State == EnemyState.Shooting ? Hit_LinkWeaponEffect[0] : Hit_LinkWeaponEffect[1]); break;
					
					case oBoss_Aghanim: Hit_LinkWeaponEffect = (State == EnemyState.Standing || State == EnemyState.Shooting? Hit_LinkWeaponEffect[0] : Hit_LinkWeaponEffect[1]); break;
				}

			
			}
		
		}
	
		if(Hit_LinkWeaponEffect == EnemyHitEffect.Ignore) return false;
	
		Hit = true;
		Hit_PosX = _x;
		Hit_PosY = _y;
		Hit_DirX = lengthdir_x(1, _Dir);
		Hit_DirY = lengthdir_y(1, _Dir);
		Hit_LinkWeaponClass = _WeaponClass;
		Hit_LinkWeaponIndex = _WeaponIndex;
		
	}
	
	return true;
	
}

function Enemy_CheckHit(){

	
	if(State == EnemyState.KnockBack){
		//allow arrows to hit/damage enemy even if they're in knockback state already
		if(Hit && Hit_LinkWeaponClass == LinkWeaponClass.Arrow && Energy > EnemyEnergyConsideredDead){
			Hit_Allowed = true;
		}
	}
	
	if(!Hit || !Hit_Allowed){
		Hit = false;
		exit;
	}


	Hit_Allowed = false;
	Hit_Started = true;
		
	var _AttackPts = ATTACK();
	
	if(Hit_LinkWeaponClass == LinkWeaponClass.Sword && Hit_LinkWeaponEffect == H_FF){
		Hit_LinkWeaponEffect = EnemyHitEffect.Damage;
		var _Damage = global.LinkSwordDamage[_AttackPts][EnergyIndex];
		if(oLink.State == LinkState.SwordSpin){
			_Damage *= (Enemy_IsBoss(object_index) ? 1.5 : 2);
		}
		
	}else if(Hit_LinkWeaponClass == LinkWeaponClass.Arrow && Hit_LinkWeaponEffect >= 1){
		var _Damage = Hit_LinkWeaponEffect + floor(_AttackPts / 2.5);
		Hit_LinkWeaponEffect = EnemyHitEffect.Damage;
		
	}else if(Hit_LinkWeaponClass == LinkWeaponClass.Bomb && Hit_LinkWeaponEffect >= 1){
		Hit_LinkWeaponEffect = EnemyHitEffect.Damage;
		var _Damage = BombDmg;
			
	}else if(Hit_LinkWeaponClass == LinkWeaponClass.SwordBeam && Hit_LinkWeaponEffect == H_FF){
		Hit_LinkWeaponEffect = EnemyHitEffect.Damage;
		var _Damage = global.LinkSwordDamage[max(_AttackPts - 2, 1)][EnergyIndex];						
	}else if(Hit_LinkWeaponEffect >= 1){
		var _Damage = Hit_LinkWeaponEffect + (max(_AttackPts - 1, 0) * 0.25);
		Hit_LinkWeaponEffect = EnemyHitEffect.Damage;						
	}				
		
	switch(Hit_LinkWeaponEffect){
			
		case 0.5: //ignore but register hit
			Hit_AllowedTimer = 30;
			break;
				
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
			Enemy_Hit_PushBack(Hit_LinkWeaponClass);
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
				
		case EnemyHitEffect.Stone:
			Enemy_UpdateState(EnemyState.Stone);
			instance_create_layer(ObjCenterX(), ObjCenterY(), "ObjsHigher_" + GetFloorLevelString(FloorLevel), oPoof);					
			audio_play_sound(Sound_Cane_Magic, 1, false);
			break;
				
		case EnemyHitEffect.Transform:
			Enemy_UpdateState(EnemyState.Transformed, Hit_LinkWeaponIndex);
			break;
				
			
	}
	
	Hit = false;
	
}

function Enemy_Attack(_MaxAttackPoints){
	
	//gives the attack points based on the enemy's max amount and Link's armor, subtracting a factor for every Link defense point
	
	if(_MaxAttackPoints == 0) return 0;
	
	if(Curse_Check(CurseEffects.ToughEnemies)) _MaxAttackPoints *= 1.5; 
	
	return max(_MaxAttackPoints - (oLink.DefensePoints * 0.25), 0.125)
	
}

function Enemy_Hit_KnockBack(_Stun, _Damage){
	
	if(State == EnemyState.Frozen){
		
		var _Layer = "ObjsHigher_" + GetFloorLevelString(FloorLevel);
		
		switch(object_index){
			
			case oEnemy_Guru:
				break;
				
			default:
				var SprW = sprite_get_width(sprite_index);
				var SprH = sprite_get_height(sprite_index);
				var _Shards = ceil((SprW * SprH) / 28); //the larger the enemy, the more shards

				repeat(_Shards){ 
					instance_create_layer(x, y_base, _Layer, oIceShard, {FloorLevel : FloorLevel, z : z});
				}	
				var _PoofX = x - sprite_get_xoffset(sprite_index) + (SprW / 2);
				var _PoofY = y - sprite_get_yoffset(sprite_index) + (SprH / 2);
				instance_create_layer(_PoofX, _PoofY, layer, oPoof_NoSound);
				break;
			
			case oEnemy_RollingSpike:
				switch(Dir){
					case VERTICAL:
					
						var _Sections = W / 16;

						for(var i = 0; i < _Sections; i++){
							var _Shards = irandom_range(3,5); //the larger the enemy, the more shards
							
							var _x = x + (i * 16);
							var _y = y_base + 8;
							repeat(_Shards){ 
								instance_create_layer(_x, _y, _Layer, oIceShard, {FloorLevel : FloorLevel, z : z});
							}	
							var _PoofX = _x;
							var _PoofY = _y;
							instance_create_layer(_PoofX, _PoofY, layer, oPoof_NoSound);							
						}
						break;
					case HORIZONTAL:
					
						var _Sections = H / 16;

						for(var i = 0; i < _Sections; i++){
							var _Shards = irandom_range(3,5); //the larger the enemy, the more shards
							
							var _x = x + 8;
							var _y = y_base + (i * 16);
							repeat(_Shards){ 
								instance_create_layer(_x, _y, _Layer, oIceShard, {FloorLevel : FloorLevel, z : z});
							}	
							var _PoofX = _x;
							var _PoofY = _y;
							instance_create_layer(_PoofX, _PoofY, layer, oPoof_NoSound);							
						}						
						break;
					
				}
				break;
			
		}

		
		audio_play_sound_stopall(Sound_PotShatter);
		
		Enemy_Destroy();
		if(ItemHolding != -1) Enemy_DestroySpawnItem(ItemHolding, Size);
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
		case LinkWeaponClass.Bomb:
			PushbackTimeLen = 15;
			PushbackV = 4;
		
	}
	vx = Hit_DirX * PushbackV;
	vy = Hit_DirY * PushbackV;
	
	Enemy_UpdateState(EnemyState.PushBack);
	
}

function Enemy_Hit_ShockLink(){
	
	Enemy_UpdateState(EnemyState.Shock);
	
	ShockLink(other.id, true);
	
	Hit_AllowedTimer = 20;
	
}

function Enemy_Destroy(){
	instance_destroy(id);
	Destroyed = true;
	Curse_CheckTask(CurseTasks.Kill);
	global.StatsToAdd[Stat.Monsters]++;	
}

function Enemy_DestroySpawnItem(_ItemClass, _Size, _SpawnType = ItemSpawnType.DropShort, _ItemExplosionAllowed = true){
	
	if(_ItemClass == -1 || _ItemClass == noone) exit;
	
	//check if the spawn item is a stopwatch, if so, make sure there's enough enemies in the room
	if(_ItemClass == ItemClass.Stopwatch){
		if(!Enemy_StopWatchItem_Allowed()) _ItemClass = Probs_RandomItemClass_Pot(true, true);
	}
	
	if(_Size == EnemySize.Tiny){
		//spawn only simple items for tiny enemies, food is ok since only food class 0 will be generated from tiny enemies
		switch(_ItemClass){
			case ItemClass.MagicLarge:
			case ItemClass.Kinstone:
			case ItemClass.Orb:
			case ItemClass.Gem:
			case ItemClass.Pop:
				_ItemClass = Probs_RandomItemClass_Pot(true, true);
				break;
		}
		
	}


	var _RupeeAmount = 0;
	var _HeartAmount = 0;
	var _MagicAmount = 0;
			
	if( _ItemExplosionAllowed && (_Size == EnemySize.Large || _Size == EnemySize.Medium) && !(global.Level.Rooms[RoomIndex].TemplateClass == RoomTemplateClass.Stairs && FloorLevel == UPPER)){ //don't do item explosion if on upper level of stair template, if they drop over the rail they end up disappearing or getting stuck beneath the upper floor
		
		if(Prob(Chance_EnemyItemExplosion)){
		
			switch(_ItemClass){
				default:
					
					switch(_Size){
						
						case EnemySize.Large:
							_RupeeAmount = choose(0, 0, 0, 0, irandom_range(2, 12));
							_HeartAmount = choose(0, 0, 0, 0, 0, 1, 1, 2);
							_MagicAmount = choose(0, 0, 0, 0, 0, 1, 1, 2);
							break;
						
						case EnemySize.Medium:
							_RupeeAmount = choose(0, 0, 0, 0, irandom_range(1, 6));
							_HeartAmount = choose(0, 0, 0, 0, 0, 1);
							_MagicAmount = choose(0, 0, 0, 0, 0, 1);
							break;
						
					}							
					break;
					
				case ItemClass.Rupee:
				
					switch(_Size){
						
						case EnemySize.Large:
							_RupeeAmount = irandom_range(5, 25);
							_HeartAmount = choose(0, 0, 0, 0, 0, 1, 1, 2);
							_MagicAmount = choose(0, 0, 0, 0, 0, 1, 1, 2);
							break;
						
						case EnemySize.Medium:
							_RupeeAmount = irandom_range(2, 12);
							_HeartAmount = choose(0, 0, 0, 0, 0, 1);
							_MagicAmount = choose(0, 0, 0, 0, 0, 1);
							break;
						
					}		
					break;
				
				case ItemClass.Heart:
					switch(_Size){
						
						case EnemySize.Large:
							_HeartAmount = choose(1, 1, 1, 1, 2, 2, 3);
							_RupeeAmount = choose(0, 0, 0, 0, irandom_range(2, 12));
							_MagicAmount = choose(0, 0, 0, 0, 0, 1, 1, 2);
							break;
						
						case EnemySize.Medium:
							_HeartAmount = choose(1, 1, 1, 1, 2);
							_RupeeAmount = choose(0, 0, 0, 0, irandom_range(1, 6));
							_MagicAmount = choose(0, 0, 0, 0, 0, 1);
							break;
						
					}						
					break;
				
				case ItemClass.Magic:
					switch(_Size){
						
						case EnemySize.Large:
							_MagicAmount = choose(1, 1, 1, 2, 2, 3);
							_RupeeAmount = choose(0, 0, 0, 0, irandom_range(2, 12));
							_HeartAmount = choose(0, 0, 0, 0, 0, 1, 1, 2);
							break;
						
						case EnemySize.Medium:
							_MagicAmount = choose(1, 1, 1, 2);
							_RupeeAmount = choose(0, 0, 0, 0, irandom_range(1, 6));
							_HeartAmount = choose(0, 0, 0, 0, 0, 1);
							break;
						
					}						
					break;
				
			}
			
			
		}
	
	}

	ItemExplosion(x, y_base, clamp(FloorLevel, LOWER, UPPER), ItemFromEnemySize(_Size), _RupeeAmount, _HeartAmount, _MagicAmount, _ItemClass, _SpawnType);
	
}

function Enemy_StopWatchItem_Allowed(){
	
	if(global.Level.DungeonTemplate.Rooms[RoomIndex].Section_ID != 0) return false;
	
	if(oLink.StarActive) return false;
	
	if(instance_exists(oItem_Stopwatch) || instance_exists(oItem_Star)) return false;
	
	var EnemiesForStopWatch = 0;
	with(oEnemy){
		switch(object_index){
			case oEnemy_Guru_Bar:
				return false;
		}
		if(Enemy_GoodForSpecialAttack(id) && State != EnemyState.Frozen && Size > EnemySize.Tiny) EnemiesForStopWatch++;
	}
	
	return EnemiesForStopWatch >= 2
	
}

function Enemy_PixelRender(_Pal = false, _PalSpr = noone, _PalIndex = 0, _DoLighting = true, _Alpha = 1){
	
	switch(State){
		default:
			PixelRender_Dim(_DoLighting, _DoLighting, _Pal, _PalSpr, _PalIndex, false, 0,,_Alpha);	
			break;
		case EnemyState.KnockBack:
			PixelRender_Dim(_DoLighting, _DoLighting, _Pal, _PalSpr, _PalIndex, true, global.KnockBackColors[KnockBackColorFrame],,_Alpha);	
			break;
		case EnemyState.Frozen:
			PixelRender_Dim(_DoLighting, _DoLighting, _Pal, _PalSpr, _PalIndex, true, [0.0,0.6,1.0],,_Alpha);	
			break;
		case EnemyState.OnFire:
			PixelRender_Dim(_DoLighting, _DoLighting, _Pal, _PalSpr, _PalIndex, true, [0.55,0.0,0.0],,_Alpha);	
			break;
		
		case EnemyState.Stone:
			PixelRender_Dim(_DoLighting, _DoLighting, _Pal, _PalSpr, _PalIndex, true, KB_Gr,,_Alpha);	
			break;
		
	}
}

function SpawnBoss(_RoomIndex){
	
	//if(DEBUG) exit;
	
	if(!global.Level.IsBossLevel || _RoomIndex != global.Level.RoomIndex_Boss) exit;
	
	var VarStruct = {FloorLevel : UPPER, ItemHolding : -1, SectionID: 0, RoomIndex : _RoomIndex};
	
	switch(global.Level.Index){
		
		case DungeonLevel.CastleJails:
			var inst = instance_create_layer(Room.x + 20, Room.y + 20, "System", oBoss_Armos_C, VarStruct); 				
			break;
				
		case DungeonLevel.LanmolasLair:
			var inst = instance_create_layer(Room.x + 20, Room.y + 20, "System", oBoss_Lanmola_C, VarStruct);
			break;
				
		case DungeonLevel.MoldormsLair:
			var inst = instance_create_layer(Room.x + 128, Room.y + 80, "ObjsHigher_Upper", oBoss_Moldorm, VarStruct);			
			break;
			
	}
	
}

function Enemy_UpdateState(NewState, Variable = 0){
	
	//Fix for rare stopwatch bug. Sometimes enemies' alarms would be right at 0 when they were transformed, causing their alarm code to run anyways(usually switching states), so the stone state would cancel itself.
	//This only lets certain states relating to hitting/destroying, etc to be updated if they are stoned. This might apply to other states like fire, etc, but I haven't witnessed this yet
	if(State == EnemyState.Frozen){
		switch(NewState){
			default:
				exit;
				break;
			case EnemyState.KnockBack:
			//case EnemyState.Frozen:
			case EnemyState.Transformed:
			case EnemyState.Hit:
			case EnemyState.Killed:
			case EnemyState.OnFire:
				break;
		}
		
	}
	
	State = NewState;
	
	switch(State){
		
		case EnemyState.Idle:
			
			switch(object_index){
				
				case oEnemy_Delavant:
					alarm[1] = 60;
					break;
					
				case oEnemy_Kyameron_Emitter:
					alarm[0] = IdleTime;
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
					alarm[0] = irandom_range(60, 180);
					break;
					
				case oEnemy_Soldier_Mace:
					Speed = 0;
					image_index = 0;
					ObjSetImageSpeed(0);
					break;

				case oEnemy_Wallmaster:
					vx = 0;
					vy = 0;
					image_index = 1;
					alarm[0] = -1;
					alarm[1] = IdleFrames;
					break;
					
				case oEnemy_Wizzrobe:
					Visible = false;
					alarm[0] = SleepDelay;
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
				
				case oEnemy_Delavant:
					Visible = true;
					break;
					
				case oEnemy_Eyegore:
					image_index = 1;
					ObjSetImageSpeed(1)
					break;

				case oEnemy_Geldman:
					alarm[0] = 40;
					break;
					
				case oEnemy_Kyameron_Emitter:
					alarm[1] = 90;
					break;

				case oEnemy_Leever:
					image_index = 0;
					break;
					
				case oEnemy_Wizzrobe:
					Dir = DirFaceLink();
					alarm[1] = SpawnDelay;
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
					alarm[0] = (Prob(0.3) ? 1 : irandom_range(30, 90));
					break;

				case oEnemy_Chicken:
					alarm[0] = 60;
					image_index = 0;
					ObjSetImageSpeed(0);
					break;
					
				case oEnemy_Goriya:
					alarm[3] = irandom_range(60, 100);
					OpenMouth = false;
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

					layer = global.LayerID_ObjsHighest;
					FloorLevel = UPPERLOWER;
					
					//check for holes, if on hole, fly away
					var _OnWallInst = collision_point(x, y_base, oWall, false, true);
					
					if(_OnWallInst != noone){
						if(_OnWallInst.IsHole){
							Enemy_UpdateState(EnemyState.Walking);
							break;
						}
					}

	
					//check if on any tiles that may be above floors, if so keep on highest layer
					if(tilemap_get_at_pixel(global.TMID_Tiles_Ceiling, x, y_base) != 0) break;
					if(tilemap_get_at_pixel(global.TMID_Tiles_Highest, x, y_base) != 0) break;
					if(tilemap_get_at_pixel(global.TMID_Tiles_Higher, x, y_base) != 0) break;
					if(tilemap_get_at_pixel(global.TMID_Decor_Upper, x, y_base) != 0) break;
					if(tilemap_get_at_pixel(global.TMID_Walls_Upper, x, y_base) != 0) break;
					if(tilemap_get_at_pixel(global.TMID_StairMonumentsDecor, x, y_base) != 0) break;
					if(tilemap_get_at_pixel(global.TMID_StairMonuments, x, y_base) != 0) break;
					if(tilemap_get_at_pixel(global.TMID_Decor_Lower, x, y_base) != 0) break;
					if(tilemap_get_at_pixel(global.TMID_Walls_Lower, x, y_base) != 0) break;

					
					//if on upper floor
					if(tilemap_get_at_pixel(global.TMID_Floor_Upper, x, y_base) != 0){
						layer = global.LayerID_Objs_Upper;
						FloorLevel = UPPER;
						break;
					}
					
					//if on lower floor
					if(tilemap_get_at_pixel(global.TMID_Floor_Lower, x, y_base) != 0){
						layer = global.LayerID_Objs_Lower;
						FloorLevel = LOWER;
						break;
					}						
			

					break;
					
				case oEnemy_Kodongo:
					if(Type == 1 && !oLink.Cape) Dir = DirFaceLink();
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
					alarm[1] = -1;
					alarm[3] = StandinHeadTurnDelay;
					alarm[4] = -1;
					break;
				
				case oEnemy_Soldier_Mace:
					Speed = 0;
					Soldier_UpdateDir(Dir);
					alarm[0] = -1;
					alarm[1] = -1;
					alarm[3] = -1;
					alarm[4] = irandom_range(40, 160);
					ObjSetImageSpeed(0);
					if(instance_exists(WeaponInst)) WeaponInst.State = State;
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
					GravityStatus = true;
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
					Buzz_UpdateDir(RandomDir());	

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
				
				case oEnemy_Goriya:
					Goriya_UpdateDir(RandomDir());
					OpenMouth = false;
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
					Hinox_UpdateDir(ds_list_size(DirList) == 0 ? RandomDir() : DirList[| 0], WalkSpeed);
					ds_list_destroy(DirList);
					break;
				
				case oEnemy_Hoarder:
					Hoarder_UpdateDir();
					break;
					
				case oEnemy_Hover:
					Dir = (oLink.Cape ? irandom(359) : point_direction(x, y, oLink.x, oLink.y));
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
					layer = global.LayerID_ObjsHighest;
					FloorLevel = UPPERLOWER;
					break;
					
				case oEnemy_Kodongo:
					Script[# 1, ScriptPos] = irandom_range(90, 200);		
					Dir = RandomDir();						
					Enemy_UpdateV(WalkSpeed);
					image_index = 0;
					ObjSetImageSpeed(1)
					alarm[0] = Script[# 1, ScriptPos];
					ScriptPos = (ScriptPos + 1) mod ScriptLen;
					break;
				
				case oEnemy_Leever:
					alarm[1] = irandom_range(200, 400);
					Leever_UpdateDir();
					break;
				
				
				case oEnemy_Octorok:
					Octorok_UpdateDir(RandomDir());
					ObjSetImageSpeed(1);
					ShotCount = 0;
					alarm[0] = irandom_range(90, 200);
					alarm[1] = -1;
					alarm[2] = -1;
					alarm[3] = -1;
					alarm[4] = -1;
					break;
					
				case oEnemy_Popo:
					alarm[1] = irandom_range(180, 320);
					var D = irandom_range(0, 359);
					vx = lengthdir_x(MaxSpeed, D);
					vy = lengthdir_y(MaxSpeed, D);
					alarm[2] = MoveDelay;
					break;

				case oEnemy_Rat:
					Rat_UpdateDir(RandomDir());
					break;

				case oEnemy_Rope:
					Rope_UpdateDir(RandomDir());
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
					SnapDragon_UpdateDir(RandomDir());	
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
					SpinAllowed = true;
					break;
				
				case oEnemy_Zazak:
					ObjSetImageSpeed(1);
					Soldier_UpdateDir(HeadDir);
					alarm[1] = irandom_range(30, 90);	
					break;
				
				case oEnemy_Zirro:
					Dir = Prob(0.6) ? DirFaceLink() : RandomDir(); //hald the time pick Dir that's towards Link
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
					Rope_UpdateDir(RandomDir());
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
					if(PlayRunSound) audio_play_sound_stopall(Sound_Enemy_Chase);
					PlayRunSound = false;
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
					Dir = RandomDir();
					Enemy_UpdateV(choose(Speed1, Speed2, Speed3));
					vz = JumpSpeed;	
					break;
					
				case oEnemy_Ropa:
					var A = (oLink.Cape ? irandom(359) : point_direction(x, y_base, oLink.x, oLink.y));
					vx = lengthdir_x(1, A);
					vy = lengthdir_y(1, A);
					vz = choose(1,2,3);	
					layer = global.LayerID_ObjsHighest;
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
					layer = global.LayerID_ObjsHighest;

					break;
					
				case oEnemy_Tektite:
					Tektite_UpdateDir(RandomDir());
					layer = global.LayerID_ObjsHighest;
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
					
				case oEnemy_Delavant:
					ShootCounter = 0;
					Enemy_ShootRedBall(x, y);
					alarm[2] = ShootDelay;
					break;
			
				case oEnemy_Hinox:
					vx = 0; vy = 0;
					alarm[0] = -1;
					alarm[1] = -1;
					alarm[2] = 40;
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
					ShotCount = Octorok_Shots();
					alarm[0] = -1;
					alarm[1] = -1;
					alarm[2] = MouthFrameDelay;
					alarm[3] = -1;
					alarm[4] = -1;
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

				case oEnemy_Soldier_Mace:
					image_index = 0;
					ObjSetImageSpeed(0);
					Speed = 0;
					alarm[0] = -1;
					alarm[1] = -1;
					if(!WeaponInst.Spin){
						WeaponInst.SpinDist = WeaponInst.SpinDistStart;
						WeaponInst.SpinAngle = 0;
						alarm[2] = 60;
						SpinAllowed = false;
					}else SpinAllowed = true;
					
					break;
				
				case oEnemy_Wallmaster:
					var _Dir = point_direction(x, y, oLink.x, oLink.y - 6);
					vx = lengthdir_x(AttackSpeed, _Dir);
					vy = lengthdir_y(AttackSpeed, _Dir);
					image_index = 0;
					alarm[0] = AttackFrames;
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
				
				case oEnemy_Delavant:
					image_index = image_number - 1;
					ObjSetImageSpeed(-1);						
					DirtInst.image_index = DirtInst.image_number - 1;
					break;
					
				case oEnemy_Eyegore:
					vx = 0;
					vy = 0;
					Dir = DOWN;
					image_index = 2.99;
					ObjSetImageSpeed(-1);
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
					alarm[1] = SpawnDelay;
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
					Lighting_UpdateLight_Visible(RoomIndex, LightIndex, true);
					Lighting_UpdateLight_Pos(RoomIndex, LightIndex, x, y - 7);
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
			
			switch(object_index){
				case oEnemy_Guru:
				case oEnemy_Guru_Bar:
				case oEnemy_Wallmaster:
					break;
			}
			
			vx = 0;	vy = 0;	
			StopWatch = true;
			Hit_Allowed = true;
			FrozenSparkleCounter = FrozenSparkleTime;
			Enemy_TransformUpdate();
			var _PoofInst = instance_create_layer(ObjCenterX(), ObjCenterY(), EffectLayer(FloorLevel), instance_exists(oPoof) ? oPoof_NoSound : oPoof);	
			_PoofInst.depth = depth - 5;
			audio_play_sound_stopall(Sound_Cane_Magic);
			audio_play_sound_stopall(Sound_Chicken_Hit);
			break;
		
		case EnemyState.OnFire:
			
			if(object_index == oEnemy_Guru || object_index == oEnemy_Guru_Bar) break;
			
			vx = 0;	vy = 0;	
			OnFireCounter = OnFireTime;
			OnFireInst = instance_create_layer(x, y - 2, EffectLayer(FloorLevel), oFireEffect, {FloorLevel : FloorLevel});
			OnFireInst.sprite_index = sFireEffect_Long;
			OnFireInst.depth = depth - 5;
			audio_play_sound_stopall(Sound_Enemy_Kill);
			break;
		
		case EnemyState.Transformed:

			Enemy_Destroy();
			
			Enemy_DestroySpawnItem(ItemHolding, Size, ItemSpawnType.DropScatter);
			
			var _FloorLevel = clamp(FloorLevel, LOWER, UPPER); //clamp in case enemy is UPPERLOWER (2)
			
			switch(Variable - 3){
				case EnemyTransformation.Bomb:
					var _BombInst = instance_create_layer(x, y_base - 4, "Objs_" + GetFloorLevelString(_FloorLevel), oBomb, {FloorLevel : _FloorLevel});
					_BombInst.z = 8;
					_BombInst.vz = 1.25
					_BombInst.State = PickupObjState.Travelling;
					_BombInst.alarm[0] = Bomb_IgniteDelayWand;
					break;
					
				case EnemyTransformation.Heart:
					
					var _HeartPiece = -1;
					
					switch(Size){
						case EnemySize.Tiny:
							var _Hearts = 1;
							break;
						case EnemySize.Small:
							var _Hearts = choose(1, 1, 1, 2);
							break;
						case EnemySize.Medium:
							var _Hearts = choose(1, 1, 1, 2, 2);
							break;
						case EnemySize.Large:
							var _Hearts = choose(1, 1, 2, 2, 3);
							if(Prob(0.015) && Item_Allowed(ItemClass.HeartPiece)) _HeartPiece = ItemClass.HeartPiece;
							break;
						
					}	
					
					ItemExplosion(x, y_base, _FloorLevel, ItemFrom.Enemy, 0, _Hearts, 0, _HeartPiece);

					break;
					
				case EnemyTransformation.Rupees:
					
					var _Gem = -1;
					
					switch(Size){
						case EnemySize.Tiny:
							var _Rupees = irandom_range(1, 5);
							break;
						case EnemySize.Small:
							var _Rupees = irandom_range(2, 8);
							break;
						case EnemySize.Medium:
							var _Rupees = irandom_range(3, 10);
							break;
						case EnemySize.Large:
							var _Rupees = irandom_range(4, 15);
							if(Prob(0.05) && Item_Allowed(ItemClass.Gem)) _Gem = ItemClass.Gem;
							break;
						
					}	
					
					if(object_index == oEnemy_Chicken) _Rupees = irandom_range(3, 10);
					
					ItemExplosion(x, y_base, _FloorLevel, ItemFrom.Enemy, _Rupees,,,_Gem);
					
					break;				
			}
			
			var _PoofInst = instance_create_layer(ObjCenterX(), ObjCenterY(), EffectLayer(_FloorLevel), oPoof);	
			_PoofInst.depth = depth - 5;
			audio_play_sound_stopall(Sound_Cane_Magic);
			break;
			
		case EnemyState.Stone:

			Hit_Allowed = true;
			Stoned = true;
			
			Enemy_TransformUpdate();

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
				
				case oEnemy_Delavant:
					sprite_index = sEnemy_Delavant_Wake;
					break;
					
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
						case LEFT:	sprite_index = Sprite_Left; break;
						case RIGHT:	sprite_index = Sprite_Right; break;
						case UP:	sprite_index = Sprite_Up; break;
						case DOWN:	sprite_index = Sprite_Down; break;
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
						case LEFT:	sprite_index = Sprite_Left; break;
						case RIGHT:	sprite_index = Sprite_Right; break;
						case UP:	sprite_index = Sprite_Up; break;
						case DOWN:	sprite_index = Sprite_Down; break;
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
						case LEFT:	sprite_index = global.Level.Index == DungeonLevel.Catacombs ? sEnemy_Rope2_Left : sEnemy_Rope_Left; break;
						case RIGHT:	sprite_index = global.Level.Index == DungeonLevel.Catacombs ? sEnemy_Rope2_Right : sEnemy_Rope_Right; break;
						case UP:	sprite_index = global.Level.Index == DungeonLevel.Catacombs ? sEnemy_Rope2_Up : sEnemy_Rope_Up; break;
						case DOWN:	sprite_index = global.Level.Index == DungeonLevel.Catacombs ? sEnemy_Rope2_Down : sEnemy_Rope_Down; break;
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
						case LEFT:	sprite_index = global.Level.Index == DungeonLevel.Catacombs ? sEnemy_Rope2_Left : sEnemy_Rope_Left; break;
						case RIGHT:	sprite_index = global.Level.Index == DungeonLevel.Catacombs ? sEnemy_Rope2_Right : sEnemy_Rope_Right; break;
						case UP:	sprite_index = global.Level.Index == DungeonLevel.Catacombs ? sEnemy_Rope2_Up : sEnemy_Rope_Up; break;
						case DOWN:	sprite_index = global.Level.Index == DungeonLevel.Catacombs ? sEnemy_Rope2_Down : sEnemy_Rope_Down; break;
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

				case oEnemy_Delavant:
					sprite_index = sEnemy_Delavant;
					break;
					
					
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
						case LEFT:	sprite_index = Sprite_Left; break;
						case RIGHT:	sprite_index = Sprite_Right; break;
						case UP:	sprite_index = Sprite_Up; break;
						case DOWN:	sprite_index = Sprite_Down; break;
					}
					break;

				case oEnemy_Pikit:
					sprite_index = sEnemy_Pikit_Shooting;
					break;
				
				case oEnemy_Skeleton:
					sprite_index = sEnemy_SkeletonBody_Standing;
					image_index = Dir - 1;
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
				
				case oEnemy_Delavant:
					sprite_index = sEnemy_Delavant_Wake;
					break;
					
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
		
		case EnemyState.Stone:
			switch(object_index){
					
				case oEnemy_Bari:
					sprite_index = sEnemy_Bari_Walking;
					break;

				case oEnemy_BuzzBlob:
					sprite_index = sEnemy_BuzzBlob;
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

function Enemy_ShootRedBall(_x, _y){
	
	var inst = instance_create_layer(_x, _y, "ObjsHigher_" + FloorLevelStr, oRedBall);
	var Angle = point_direction(_x, _y, oLink.x, oLink.y - 6);
	inst.vx = lengthdir_x(2, Angle);
	inst.vy = lengthdir_y(2, Angle);
	
	if(oCamera.InView(_x, _y)) audio_play_sound(Sound_Medusa, 1, false);
	
}

function Enemy_WallCollisionNewDir(Orientation){
	
	switch(Orientation){
		case HORIZONTAL:
			var Dir1 = LEFT;
			var Dir2 = RIGHT;
			var Dir3 = UP;
			var Dir4 = DOWN;
			var Wall1 = ObjCollision(x, y - 6, oWall, FloorLevel);
			var Wall2 = ObjCollision(x, y + 6, oWall, FloorLevel);
			break;
		case VERTICAL:
			var Dir1 = UP;
			var Dir2 = DOWN;
			var Dir3 = LEFT;
			var Dir4 = RIGHT;
			var Wall1 = ObjCollision(x - 6, y, oWall, FloorLevel);
			var Wall2 = ObjCollision(x + 6, y, oWall, FloorLevel);
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
	
	if(!Sight || FloorLevel != oLink.FloorLevel || oLink.Cape) return false;
	
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
	
	
	return (collision_rectangle(SightX1, SightY1, SightX2, SightY2, oLink, false, true) != noone);
			
}

function Enemy_Reset(_RoomIndex){
	
	with(oEnemy){
			
		//skip the following enemies
		switch(object_index){
			case oBoss_Armos:
			case oBoss_Moldorm:
			case oBoss_Moldorm_BodyL:
			case oBoss_Moldorm_BodyS:
			case oBoss_Moldorm_Tail:
			case oEnemy_Guru:
			case oEnemy_Guru_Bar:
			case oEnemy_Kyameron_Moving:
			case oEnemy_Wallmaster:
				
				continue;
		}
		
		switch(object_index){
			case oEnemy_Chicken:
			
				if(instance_exists(oLink.ItemHolding)){
					if(id == oLink.ItemHolding.id) continue;	
				}
				
				with(id){
					Enemy_UpdateState(EnemyState.Walking);
					Scared = false;
				}
				continue;
				break;
		}

		if(RoomIndex == _RoomIndex){
			
			instance_destroy(id);
			
			var inst = instance_create_layer(Reset_StartX, Reset_StartY, layer, object_index, { FloorLevel : self.FloorLevel, 
																								ItemHolding : self.ItemHolding, 
																								SectionID : self.SectionID,
																								RoomIndex : self.RoomIndex});

			for(var i = 0; i < array_length(SaveVariables); i++){
				var VarName = SaveVariables[i];
				variable_instance_set(inst, VarName, variable_instance_get(id, VarName))
			}
			
		}
	}
	
	with(oEnemy_Guru_Bar){
		if(RoomIndex == _RoomIndex){

			var inst = instance_create_layer(Reset_StartX, Reset_StartY, layer, object_index, { FloorLevel : self.FloorLevel, 
																								ItemHolding : self.ItemHolding, 
																								SectionID : self.SectionID,
																								RoomIndex : self.RoomIndex,
																								Angle: self.Angle,
																								GurusDestroyed: self.GurusDestroyed});
					
			instance_destroy(id);
		}		
	}

}

function Enemy_SetEnergy(_EnergyIndex){
	EnergyIndex = Enemy_CheckEnergyIndex(_EnergyIndex);
	EnergyMax = Enemy_GetMaxEnergy(EnergyIndex);
	Energy = EnergyMax;
}

function Enemy_GetMaxEnergy(_EnergyIndex){
	return global.EnemyHitsToKill[Swords.Basic][_EnergyIndex];
}

function Enemy_CheckEnergyIndex(_EnergyIndex){
	
	if(_EnergyIndex >= EnergyIndexes - 2) return _EnergyIndex;
	
	if(Curse_Check(CurseEffects.ToughEnemies)) _EnergyIndex++;
	
	return _EnergyIndex;
	
}

function Enemy_TransformUpdate(){

	if(variable_instance_exists(id, "LightIndex")) LightIndex = Lighting_DestroyLight(RoomIndex, LightIndex);
	
	switch(object_index){
		
		case oEnemy_Kyameron_Emitter:
			sprite_index = sEnemy_Kyameron_Emitter;
			break;
			
		case oEnemy_Zol:
			sprite_index = sEnemy_Zol;
			break;
			
		case oEnemy_Leever:
			sprite_index = sEnemy_Leever_Walking;
			break;
			
		case oEnemy_Geldman:
			sprite_index = sEnemy_Geldman_Walk;
			break;
			
		case oEnemy_Wizzrobe:
			Visible = true;
			break;					
				
		case oEnemy_Chicken:
			StopWatch = false;
			break;
				
		case oEnemy_Beamos:
			Beamos_DestroyLaserLights();
			EyeLight = Lighting_DestroyLight(RoomIndex, EyeLight);
			Beamos_Laser_Reset();
			break;
					
	}	
	
}

function Enemy_GoodForSpecialAttack(_EnemyIndex){
	
	//returns true if enemy is good for things like stars and stopwatches
	return !Enemy_IsWall(_EnemyIndex) && !Enemy_CanBeHidden(_EnemyIndex) && !Enemy_IsInvincible(_EnemyIndex) && !Enemy_IsObstacle(_EnemyIndex)
	
}

function Enemy_GoodForTrap(_EnemyIndex){
	
	switch(_EnemyIndex){
		
		//don't use small weak enemies
		case oEnemy_BuzzBlob:
		case oEnemy_Hover:
		case oEnemy_Rat:
		case oEnemy_Rope:

			return false
			
	}
	
	return Enemy_GoodForSpecialAttack(_EnemyIndex) && !Enemy_CanFly(_EnemyIndex)
	
}

function Enemy_IsWall(_EnemyIndex){
	
	switch(_EnemyIndex){
		
		case oEnemy_Beamos:
		case oEnemy_Cannon:
		case oEnemy_Medusa:
			return true
			break;
			
	}
	
	return false;	
}

function Enemy_IsUnderground(_EnemyIndex){

	switch(_EnemyIndex){

		case oEnemy_Delavant:
		case oEnemy_Geldman:
		case oEnemy_Leever:
			return true
			break;
			
	}
	
	return false;
	
}

function Enemy_CanBeHidden(_EnemyIndex){
	
	if(Enemy_IsUnderground(_EnemyIndex)) return true
	
	switch(_EnemyIndex){
		case oEnemy_Wizzrobe:
		case oEnemy_Zol:
			return true
			break;
			
	}
	
	return false;	
}

function Enemy_IsInvincible(_EnemyIndex){

	switch(_EnemyIndex){

		case oEnemy_Bubble:
		case oEnemy_Kyameron_Emitter:
		case oEnemy_Wallmaster:
			return true
			break;
			
	}
	
	return false;	
}

function Enemy_IsObstacle(_EnemyIndex){

	switch(_EnemyIndex){

		case oEnemy_Guru:
		case oEnemy_Guru_Bar:
		case oEnemy_RollingSpike:
		case oEnemy_MovingSpikeBlock:
			return true
			break;
			
	}
	
	return false;	
}

function Enemy_CanJump(_EnemyIndex){

	switch(_EnemyIndex){

		case oEnemy_Skeleton:
		case oEnemy_Tektite:
		case oEnemy_Ropa:
			return true
			break;
			
	}
	
	return false;	
	
}

function Enemy_CanFly(_EnemyIndex){

	switch(_EnemyIndex){

		case oEnemy_Keese:
		case oEnemy_Kyune:
		case oEnemy_Poe:
		case oEnemy_Zirro:
			return true
			break;
			
	}
	
	return false;	
}

function Enemy_DrawShadow(_ShadowSpr = sShadow_Large, _Alpha = 1){
	PixelRender_Dim(true, false, false, noone, 0, false, [],,_Alpha);
	draw_sprite(_ShadowSpr, 0, x, y_base);
	shader_reset();		
}

function ItemFromEnemySize(_Size){
	switch(_Size){
		case EnemySize.Tiny: return ItemFrom.EnemyTiny
		case EnemySize.Small: return ItemFrom.EnemySmall
		case EnemySize.Medium: return ItemFrom.EnemyMedium
		case EnemySize.Large: return ItemFrom.EnemyLarge
		
	}

}

function Enemy_IsBoss(_ObjIndex){
	
	switch(_ObjIndex){
		case oBoss_Armos:
		case oBoss_Lanmola:
		case oBoss_Lanmola_Tail:
		case oBoss_Lanmola_Body:
		case oBoss_Moldorm:
		case oBoss_Moldorm_Tail:
		case oBoss_Moldorm_BodyS:
		case oBoss_Moldorm_BodyL:
			return true;
					
	}	
	
	return false
	
}