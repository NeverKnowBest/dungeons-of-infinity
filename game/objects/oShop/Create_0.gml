
TileW = ShopW / 8;
TileH = ShopH / 8;

ShopKeeperInst = noone;

Slots = 0;
Inventory = 0;

ItemsSold = 0;

FloorLevel = GetFloorLevelID(x, y);
FloorLevelStr = GetFloorLevelString(FloorLevel);

Slots = Shop_GetSlotCount();

Inventory = array_create(Slots, noone);	

//
//global.Dungeon_Shop_ExistsInRoom[RoomIndex] = true;
//global.Dungeon_Shop_Type[RoomIndex] = ShopType;


if(ShopType == ShopTypes.Various){
		
	ShopKeeperInst = instance_create_layer(x + (ShopW / 2), y+21, "Objs_" + FloorLevelStr, oShopKeeper, {ShopType : ShopType});
	
	if(global.Level.Index == DungeonLevel.Mines){
		
		ShopKeeperInst.sprite_index = sShopKeeper_Mines;
	
	}else if(global.Level.Index == DungeonLevel.Aghanim1 && !global.ShopkeeperJustin){
		
		ShopKeeperInst.sprite_index = sShopKeeper_Justin;
		global.ShopkeeperJustin = true;
		
	}else{		
		
		if(ds_list_size(global.UnusedShopKeepers) > 0){
			//pick first shop keeper index from shuffled list, then delete it from the list so it's not picked twice
			var ShopKeeperIndex = global.UnusedShopKeepers[| 0];
			ds_list_delete(global.UnusedShopKeepers, 0);
		}else{
			//if all shop keepers were used, just pick random one
			ShopKeeperIndex = irandom_range(0, ShopKeeperIDs - 2);
		}
		ShopKeeperInst.sprite_index = asset_get_index("sShopKeeper" + string(ShopKeeperIndex));
	}

	ShopKeeperInst.ShopInst = id;

	//torches
	if(global.Level.Rooms[RoomIndex].Lighting && global.ChallengeOptions[ChallengeOption.Darkness] != ChallengeOption_Darkness.NoLights){			
		var Torch1 = instance_create_layer(x, y, "ObjsDoors_" + FloorLevelStr, oTorch, {RoomIndex : RoomIndex, Lit: true});
		var Torch2 = instance_create_layer(x + ShopW - 16, y, "ObjsDoors_" + FloorLevelStr, oTorch, {RoomIndex : RoomIndex, Lit: true});
		if(Slots == 2){
			//dim the lights a bit if there's only 2 slots, otherwise it's too bright
			var NewRGB = Torch1.LightMaxRGB - 0.075;
			Lighting_UpdateLight_RGB(RoomIndex, Torch1.LightIndex, [NewRGB, NewRGB, NewRGB]);
			Lighting_UpdateLight_RGB(RoomIndex, Torch2.LightIndex, [NewRGB, NewRGB, NewRGB]);
		}
		if(Slots > 3){
			//dim the lights a bit if there's only 2 slots, otherwise it's too bright
			var NewRGB = Torch1.LightMaxRGB + 0.1;
			Lighting_UpdateLight_RGB(RoomIndex, Torch1.LightIndex, [NewRGB, NewRGB, NewRGB]);
			Lighting_UpdateLight_RGB(RoomIndex, Torch2.LightIndex, [NewRGB, NewRGB, NewRGB]);
		}
	}

}
	
//Create and place items

var _ItemList = ds_list_create(); //keep track of items created to send to Shop_CreateItem function which will pick items so that certrain classes that only allow 1 won't be picked multiple times
for(var SlotIndex = 0; SlotIndex < Slots; SlotIndex++){		
	var ItemInst = Shop_CreateItem(SlotIndex);
}
ds_list_destroy(_ItemList);
	
Shop_SpaceItems();	
	




DB_Init = false;
DB_Started = false

#region DialogueBox
	
	Dialogue_Shop_NotEnoughRupees = "Sorry kid, you don't have enough rupees. Come back when you have more.";
	Dialogue_Shop_AlreadyOwn = "You already own that item.";
	Dialogue_Shop_Downgrade = "You can't downgrade your item.";
	Dialogue_Shop_Cursed = "Beat it kid!";
	Dialogue_Shop_MaxKeys = "You can't hold any more keys.";
	Dialogue_Shop_MaxHearts = "You already have maximum heart containers.";
	Dialogue_Shop_MaxSlots = "You already have maximum inventory slots.";

	function DBScriptFunction_Shop_ItemName(){
		return Item_Name(oLink.ShopItemLook.Class, oLink.ShopItemLook.Index, oLink.ShopItemLook.Amount) + ": " + string(oLink.ShopItemLook.Price_Modified) + " rupees";
	} 

	function DBScriptFunction_Shop_ItemInfo(){
		return Item_Info(oLink.ShopItemLook.Class, oLink.ShopItemLook.Index);
	} 
	
	function DBScriptFunction_Shop_CheckCost(){
		return global.Inventory.ItemData[ItemClass.Rupee].Amount < oLink.ShopItemLook.Price_Modified;	
	}

	function DBScriptFunction_Shop_CheckHearts(){
		if(oLink.ShopItemLook.Class == ItemClass.HeartPiece){
			return global.Inventory.ItemData[ItemClass.HeartPiece].Amount >= ChallengeMax_Hearts;
		}else return false;
	}
	
	function DBScriptFunction_Shop_CheckSlots(){
		if(oLink.ShopItemLook.Class == ItemClass.BagSlot){
			return Inventory_FindLockedSlot() == -1;
		}else return false;
	}
	
	function DBScriptFunction_Shop_CheckCursed(){
		return Curse_Check(CurseEffects.ShopsNoSell);
	}

	function DBScriptFunction_Shop_CheckAlreadyOwn(){
		
		var _ItemClass = oLink.ShopItemLook.Class;
		var _ItemIndex = oLink.ShopItemLook.Index;
		
		switch(global.ItemData[_ItemClass].Type){
			case ItemType.Inv_Upg:
				if(_ItemIndex == global.Inventory.ItemData[_ItemClass].Index) return true
				break;
			case ItemType.Inv_Bool:
			case ItemType.Inv_Chrg:
				if(global.Inventory.ItemData[_ItemClass].Owns[_ItemIndex]) return true
				break;
		}
		
		return false
	}

	function DBScriptFunction_Shop_CheckDowngrade(){
		
		var _ItemClass = oLink.ShopItemLook.Class;
		var _ItemIndex = oLink.ShopItemLook.Index;
		
		return global.ItemData[_ItemClass].Type == ItemType.Inv_Upg && _ItemIndex < global.Inventory.ItemData[_ItemClass].Index;

	}
	

	var H = 23;
	
	DB_Script = ds_grid_create(5, H); var i = 0; 
	var A=0;//A=address
	DB_Script[# 0, A] = DBScriptCode.IfGoto;			DB_Script[# ++i, A] = method(self, DBScriptFunction_Shop_CheckCursed);		DB_Script[# ++i, A] = 7;	DB_Script[# ++i, A] = A+1;								i = 0; A++;
	DB_Script[# 0, A] = DBScriptCode.Dialogue_Buy;		DB_Script[# ++i, A] = method(self, DBScriptFunction_Shop_ItemName);			DB_Script[# ++i, A] = A+1;	DB_Script[# ++i, A] = H-2;	DB_Script[# ++i, A] = H-3;	i = 0; A++;
	DB_Script[# 0, A] = DBScriptCode.IfGoto;			DB_Script[# ++i, A] = method(self, DBScriptFunction_Shop_CheckAlreadyOwn);	DB_Script[# ++i, A] = 9;	DB_Script[# ++i, A] = A+1;								i = 0; A++;
	DB_Script[# 0, A] = DBScriptCode.IfGoto;			DB_Script[# ++i, A] = method(self, DBScriptFunction_Shop_CheckDowngrade);	DB_Script[# ++i, A] = 11;	DB_Script[# ++i, A] = A+1;								i = 0; A++;
	DB_Script[# 0, A] = DBScriptCode.IfGoto;			DB_Script[# ++i, A] = method(self, DBScriptFunction_Shop_CheckHearts);		DB_Script[# ++i, A] = 13;	DB_Script[# ++i, A] = A+1;								i = 0; A++;
	DB_Script[# 0, A] = DBScriptCode.IfGoto;			DB_Script[# ++i, A] = method(self, DBScriptFunction_Shop_CheckSlots);		DB_Script[# ++i, A] = 15;	DB_Script[# ++i, A] = A+1;								i = 0; A++;
	DB_Script[# 0, A] = DBScriptCode.IfGoto;			DB_Script[# ++i, A] = method(self, DBScriptFunction_Shop_CheckCost);		DB_Script[# ++i, A] = 17;	DB_Script[# ++i, A] = H-1;								i = 0; A++;
	DB_Script[# 0, A] = DBScriptCode.Error;				DB_Script[# ++i, A] = A+1;																																		i = 0; A++;
	DB_Script[# 0, A] = DBScriptCode.Dialogue_NoSound;	DB_Script[# ++i, A] = Dialogue_Shop_Cursed;									DB_Script[# ++i, A] = H-2;															i = 0; A++;
	DB_Script[# 0, A] = DBScriptCode.Error;				DB_Script[# ++i, A] = A+1;																																		i = 0; A++;
	DB_Script[# 0, A] = DBScriptCode.Dialogue_NoSound;	DB_Script[# ++i, A] = Dialogue_Shop_AlreadyOwn;								DB_Script[# ++i, A] = H-2;															i = 0; A++;
	DB_Script[# 0, A] = DBScriptCode.Error;				DB_Script[# ++i, A] = A+1;																																		i = 0; A++;
	DB_Script[# 0, A] = DBScriptCode.Dialogue_NoSound;	DB_Script[# ++i, A] = Dialogue_Shop_Downgrade;								DB_Script[# ++i, A] = H-2;															i = 0; A++;
	DB_Script[# 0, A] = DBScriptCode.Error;				DB_Script[# ++i, A] = A+1;																																		i = 0; A++;
	DB_Script[# 0, A] = DBScriptCode.Dialogue_NoSound;	DB_Script[# ++i, A] = Dialogue_Shop_MaxHearts;								DB_Script[# ++i, A] = H-2;															i = 0; A++;
	DB_Script[# 0, A] = DBScriptCode.Error;				DB_Script[# ++i, A] = A+1;																																		i = 0; A++;
	DB_Script[# 0, A] = DBScriptCode.Dialogue_NoSound;	DB_Script[# ++i, A] = Dialogue_Shop_MaxSlots;								DB_Script[# ++i, A] = H-2;															i = 0; A++;
	DB_Script[# 0, A] = DBScriptCode.Error;				DB_Script[# ++i, A] = A+1;																																		i = 0; A++;
	DB_Script[# 0, A] = DBScriptCode.Dialogue_NoSound;	DB_Script[# ++i, A] = Dialogue_Shop_NotEnoughRupees;						DB_Script[# ++i, A] = H-2;															i = 0; A++;
	DB_Script[# 0, A] = DBScriptCode.Error;				DB_Script[# ++i, A] = A+1;																																		i = 0; A++;
   	DB_Script[# 0, A] = DBScriptCode.Dialogue			DB_Script[# ++i, A] = method(self, DBScriptFunction_Shop_ItemInfo);			DB_Script[# ++i, A] = 1;															i = 0; A++;
   	DB_Script[# 0, A] = DBScriptCode.End;				DB_Script[# ++i, A] = 0;																																		i = 0; A++;
   	DB_Script[# 0, A] = DBScriptCode.End;				DB_Script[# ++i, A] = 1;																																		

#endregion