enum CurseEffects{
	RupeesNoValue,
	MagicNoValue,
	HealthNoValue,
	HeartsReduceHealth,
	MagicUsesDouble,
	HealthDrain,
	ShopsNoSell,
	ShopsMaxPrice,
	PendantsNoWork,
	AttackReduced,
	DefenseReduced,
	MapNotVisible,
	ToughEnemies
}
#macro EnumCount_CurseEffects 13

enum CurseTasks{
	Kill,
	Treasures,
	Buy,
	Collect
}
#macro EnumCount_CurseTasks 4

#macro Curse_AttDefReduction 3

global.CurseEffectStrArray = [
	"Collected rupees are\\worth nothing.",
	"Items that replenish\\magic won't work.",
	"Items that replenish\\health won't work.",
	"Picking up hearts reduce\\your health.",
	"Items that use magic use\\twice as much.",
	"Your health keeps draining\\down to 2 hearts.",
	"Shops refuse to sell you\\anything.",
	"Shops will only sell at\\the highest prices.",
	"Pendants no longer\\work.",
	"Attack points are\\reduced by " + string(Curse_AttDefReduction) + ".",
	"Defense points are\\reduced by " + string(Curse_AttDefReduction) + ".",
	"The map is hidden.",
	"Enemies are tougher."
]


global.Cursed = false;

global.CurseEffect = 0;
global.CurseEffectStr = ""

global.CurseTask = 0;
global.CurseTaskStr = "";
global.CurseTaskItem = -1;
global.CurseTaskCount = 0;

global.CurseHealthDrainDelay = 420;

global.CurseLastEffect = -1;
global.CurseLastTask = -1;
global.CurseLastTaskItem = -1;

//special case where if you need to open treasures and you open the last one, and the effect is health items or rupees don't work, and it's a heart piece or rupees, make this true so items get consumed.
//The order of events causes the items not to get consumed since item gets consumed first before the curse check.
//No other way to do this right now without recoding a bunch of stuff
global.CurseTreasure_HeartPiece = false; 
global.CurseTreasure_Rupees = false; 

//when getting a curse, set this to a random value which counts down each treasure opened. If this value is not 0 you can't get a curse. Thise is to prevent multiple curses in a row after being blocked
global.CurseLimiter = 0;

function GenerateCurse(){
	
	var _CurseEffectList = ds_list_create_sequence(0, EnumCount_CurseEffects - 1);
	var _CurseTaskList = ds_list_create_sequence(0, EnumCount_CurseTasks - 1);
	
	//remove any effect or task that doesn't apply based on challenges
	if(global.Challenges[Challenges.NoMap]){
		ds_list_finddelete(_CurseEffectList, CurseEffects.MapNotVisible);
	}

	
	//remove effects that would be boring depending on things like lack of inventory, att/def points, etc
	
	if(!Inventory_ItemExists(ItemClass.Pendant)) ds_list_finddelete(_CurseEffectList, CurseEffects.PendantsNoWork);
	
	if(	!Inventory_ItemExists(ItemClass.Cape) && 
		!Inventory_ItemExists(ItemClass.Medallion) && 
		!Inventory_ItemExists(ItemClass.Rod) && 
		!Inventory_ItemExists(ItemClass.Ring) && 
		!Inventory_ItemExists(ItemClass.Cane)){
			ds_list_finddelete(_CurseEffectList, CurseEffects.MagicUsesDouble);
			ds_list_finddelete(_CurseEffectList, CurseEffects.MagicNoValue);
	}
	
	//If attack and/or defense points aren't enough to reduce, then don't use these effects
	if(oLink.AttackPoints <= Curse_AttDefReduction) ds_list_finddelete(_CurseEffectList, CurseEffects.AttackReduced);
	if(oLink.DefensePoints < Curse_AttDefReduction) ds_list_finddelete(_CurseEffectList, CurseEffects.DefenseReduced);
	
	
	//remove the last used curse effect if there's more than 1 to choose from, to give the player some variety
	if(ds_list_size(_CurseEffectList) > 1 && global.CurseLastEffect != -1){
		ds_list_finddelete(_CurseEffectList, global.CurseLastEffect);
	}
	
	
	ds_list_shuffle(_CurseEffectList);

	if(DEBUG){
		global.CurseEffect = _CurseEffectList[| 0];
	}else{
		global.CurseEffect = _CurseEffectList[| 0];
	}
	global.CurseEffectStr = global.CurseEffectStrArray[global.CurseEffect];
	global.CurseLastEffect = global.CurseEffect;
	
	
	//specific effects can't have any task, some don't make sense like ShopsNoSell and CurseTasks.Buy together
	switch(global.CurseEffect){
		case CurseEffects.ShopsMaxPrice:
		case CurseEffects.ShopsNoSell:
		case CurseEffects.RupeesNoValue: 
			ds_list_finddelete(_CurseTaskList, CurseTasks.Buy);
			break;
	}
	
	
	 //don't use the treasure task if there's other treasures in the room.
	if(instance_number(oItem_Treasure) > 1) ds_list_finddelete(_CurseTaskList, CurseTasks.Treasures);
	
	//remove the last used curse task if there's more than 1 to choose from, to give the player some variety
	if(ds_list_size(_CurseTaskList) > 1 && global.CurseLastTask != -1){
		ds_list_finddelete(_CurseTaskList, global.CurseLastTask);
	}
	
	ds_list_shuffle(_CurseTaskList);
	if(DEBUG){
		global.CurseTask = _CurseTaskList[| 0];
	}else{
		global.CurseTask = _CurseTaskList[| 0];
	}
	global.CurseLastTask = global.CurseTask;
	
	ds_list_destroy(_CurseEffectList);
	ds_list_destroy(_CurseTaskList);
	
	
	switch(global.CurseTask){
		case CurseTasks.Kill:
			global.CurseTaskCount = choose(15, 20, 25, 30, 35, 40, 45, 50);
			global.CurseTaskStr = "Kill " + string(global.CurseTaskCount) + " enemies.";			
			break;
		
		case CurseTasks.Treasures:
			global.CurseTaskCount = choose(2, 3, 3, 3, 4, 4, 5);
			global.CurseTaskStr = "Open " + string(global.CurseTaskCount) + " treasures.";
			break;
		
		case CurseTasks.Buy:
			global.CurseTaskCount = choose(1, 1, 1, 1, 2, 2, 3);
			global.CurseTaskStr = "Buy " + string(global.CurseTaskCount) + " shop" + (global.CurseTaskCount == 1 ? " item." : " items.");
			break;
		
		case CurseTasks.Collect:
		
			//make a list of the items you may have to collect. Some effects will cause some items to be removed from the list. At the end, randomly pick an item from the list for the collect task
			var ItemList = ds_list_create();
			ds_list_add(ItemList, ItemClass.Rupee, ItemClass.Rupee, ItemClass.Rupee, ItemClass.Heart, ItemClass.Heart, ItemClass.Heart, ItemClass.HeartPiece);
			
			
			switch(global.CurseEffect){
				case CurseEffects.RupeesNoValue: 
					ds_list_finddelete_all(ItemList, ItemClass.Rupee); 
					ds_list_finddelete_all(ItemList, ItemClass.HeartPiece); //don't use heart piece as item to collect when rupees aren't worth anything because you will most likely need to buy the heart and might not have enough rupees
					break;
					
				case CurseEffects.HeartsReduceHealth: 
					ds_list_finddelete_all(ItemList, ItemClass.Heart); 
					break;
			}
			
			if(!Item_Allowed(ItemClass.HeartPiece, 0, ItemFrom.Anywhere)) ds_list_finddelete_all(ItemList, ItemClass.HeartPiece);

			//remove the last used curse item if there's more than 1 to choose from, to give the player some variety
			if(ds_list_size(ItemList) > 1 && global.CurseLastTaskItem != -1){
				ds_list_finddelete(ItemList, global.CurseLastTaskItem);
			}


			ds_list_shuffle(ItemList);
			global.CurseTaskItem = ItemList[| 0];
			global.CurseLastTaskItem = global.CurseTaskItem;
			ds_list_destroy(ItemList)
			
			switch(global.CurseTaskItem){
				case ItemClass.Rupee: global.CurseTaskCount = irandom_range(2, 5) * 20; var ItemStr = " rupees."; break;
				case ItemClass.Heart: global.CurseTaskCount = irandom_range(5, 10); var ItemStr = " hearts."; break;											
				case ItemClass.HeartPiece: global.CurseTaskCount = 1; var ItemStr = " heart container."; break;						
			}
	
			global.CurseTaskStr = "Collect " + string(global.CurseTaskCount) + ItemStr;			
			break;
		
		
	}
	
	Link_UpdateAttackDefence();
	
}

function Curse_Check(_CurseEffect){
	return global.Cursed && global.CurseEffect == _CurseEffect;
}

function Curse_CheckTask(_Task, _ItemClass = -1, _Amount = 1){
	
	if(global.Cursed){
		
		if(global.CurseTask == _Task && (_ItemClass == -1 || _ItemClass == global.CurseTaskItem)){
			
			global.CurseTaskCount -= _Amount;
	
			if(global.CurseTaskCount <= 0){
				
				global.CurseTaskCount = 0;
				
				if(oLink.State == LinkState.Star){
					oLink.UncurseAfterStar = true;
					return false
				}else{
					MsgBox("Task completed!\\You are now uncursed.",,, Curse_Done);
				}
				
				return true;
				
			}		
		}		
	}
	
	return false;
	
}

function Curse_Done(){
	
	global.Cursed = false;			
	
	Link_UpdateAttackDefence();
	
	if(global.CurseEffect == CurseEffects.ToughEnemies){
		//put enemy energies back to normal
		
		with(oEnemy){
			var _OldEnergy = Energy;
			var _NewEnergyIndex = max(EnergyIndex - 1, 0);
			Enemy_SetEnergy(_NewEnergyIndex);
			Energy = min(_OldEnergy, Energy);
		}
		with(oBoss_Lanmola_C){ //special case for Lanmola boss
			EnergyIndex--;
			EnergyMax = Enemy_GetMaxEnergy(EnergyIndex);
			Energy[0] = min(Energy[0], EnergyMax);
			Energy[1] = min(Energy[1], EnergyMax);
			Energy[2] = min(Energy[2], EnergyMax);			
		}
	}
	
}

function Curse_GetItemUncurseMsg(_ItemClass, _ItemIndex){
	
	if(global.Cursed){
		if(_ItemClass == ItemClass.Pendant && _ItemIndex == Pendant.Immunity && global.CurseEffect != CurseEffects.PendantsNoWork){
			MsgBox("You are now uncursed!",,Sound_Antidote, method(self, Curse_Done));
			global.Cursed = false; //add a curse false here even though Curse_Done will be called, if your task is done by getting the pendant of immunity, the MsgBox in Curse_Check will also be called. So prevent that by cancelling the curse early
		}
	}	
	
}