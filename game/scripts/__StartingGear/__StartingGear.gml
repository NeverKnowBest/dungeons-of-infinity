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

global.GearSprites = [	sEmptyMask, 0, 0, 0,
						sItem_Rupee, 0, -1, -3,
						sItem_BagSlot, 0, 0, -1,
						sItem_HeartPiece, 0, 0, -2,
						sItem_Shield, 0, 0, -2,
						sItem_Rod, 0, 0, -1,
						sItem_Orb, Orb.Fire, 0, -2,						
						sItem_Potion, Potion.Antidote, 0, 0
					 ]
#macro GearItems 8