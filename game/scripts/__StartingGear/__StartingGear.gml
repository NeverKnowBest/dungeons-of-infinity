enum StartingGear{
	None,
	Rupees,
	Inventory,
	Heart,
	Shield,
	Rod,
	Orbs,	
	Antidotes
}

// Menu label and icon of each bonus item, keyed by StartingGear
global.GearInfo = [];
global.GearInfo[StartingGear.None] =		{ Label: "None",										Sprite: sEmptyMask,			Image: 0,					OffsetX: 0,		OffsetY: 0 };
global.GearInfo[StartingGear.Rupees] =		{ Label: string(StartingGear_Rupees) + " Rupees",		Sprite: sItem_Rupee,		Image: 0,					OffsetX: -1,	OffsetY: -3 };
global.GearInfo[StartingGear.Inventory] =	{ Label: "+1 Inv Slot",									Sprite: sItem_BagSlot,		Image: 0,					OffsetX: 0,		OffsetY: -1 };
global.GearInfo[StartingGear.Heart] =		{ Label: "+1 Health",									Sprite: sItem_HeartPiece,	Image: 0,					OffsetX: 0,		OffsetY: -2 };
global.GearInfo[StartingGear.Shield] =		{ Label: "Wooden Shield",								Sprite: sItem_Shield,		Image: 0,					OffsetX: 0,		OffsetY: -2 };
global.GearInfo[StartingGear.Rod] =			{ Label: "Rod of Stone",								Sprite: sItem_Rod,			Image: 0,					OffsetX: 0,		OffsetY: -1 };
global.GearInfo[StartingGear.Orbs] =		{ Label: string(StartingGear_Orbs) + " Fire Orbs",		Sprite: sItem_Orb,			Image: Orb.Fire,			OffsetX: 0,		OffsetY: -2 };
global.GearInfo[StartingGear.Antidotes] =	{ Label: "Antidote",									Sprite: sItem_Potion,		Image: Potion.Antidote,		OffsetX: 0,		OffsetY: 0 };
