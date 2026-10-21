var _BagSelected = global.Inventory.SlotSelected[0];
var _SlotSelected = global.Inventory.SlotSelected[1];


var _FanInventory = input_check("strafe");

if(_FanInventory){
	Fan = InventoryFanStatus.Open;
	FanPosition += OpenSpeed;
}else{
	if(Fan == InventoryFanStatus.Open) Fan = InventoryFanStatus.Close;
	FanPosition -= OpenSpeed;
}
FanPosition = clamp(FanPosition, 0, 1);
if(FanPosition == 0) Fan = InventoryFanStatus.None;

for(var _BagIndex = 0; _BagIndex < Inventory_Bags; _BagIndex++){
	
	if(_BagIndex == InventoryBag.Main || _BagIndex == _BagSelected) continue;
	
	var _Bag = global.Inventory.Bags[_BagIndex];
	
	if(!_Bag.Owns) continue;
	
	if(_FanInventory){
		_Bag.Status = InventoryBagStatus.Opening;
	}else if(Fan == InventoryFanStatus.Close){
		_Bag.Status = InventoryBagStatus.Closing;
	}
	
}		


if(_BagSelected == InventoryBag.Main && _SlotSelected < global.Inventory.Bags[InventoryBag.Main].Columns){
	var _Bag = global.Inventory.Bags[_SlotSelected];
	if(_Bag.Status != InventoryBagStatus.Open) _Bag.Status = InventoryBagStatus.Opening;
}

for(var _BagIndex = 0; _BagIndex < Inventory_Bags; _BagIndex++){
	
	var _Bag = global.Inventory.Bags[_BagIndex];
	
	var _PositionDir = 0;
	
	_FanShiftX = 0;
	
	switch(_Bag.Status){
		
		case InventoryBagStatus.Open:
			if(_BagIndex != InventoryBag.Main && _BagSelected == InventoryBag.Main && _SlotSelected != _BagIndex){
				_Bag.Status = InventoryBagStatus.Closing;
				_PositionDir = -1;
			}
			break;
				
		case InventoryBagStatus.Closed:

			break;
			
		case InventoryBagStatus.Opening:
			_PositionDir = 1;
			break;
			
		case InventoryBagStatus.Closing:
			_PositionDir = -1;
			break;		
		
	}

	_Bag.Position += (OpenSpeed * _PositionDir);
	_Bag.Position = clamp(_Bag.Position, 0, 1);
		
	if(_Bag.Position == 0){
		_Bag.Status = InventoryBagStatus.Closed;
	}else if(_Bag.Position == 1) _Bag.Status = InventoryBagStatus.Open;
	
	//shift the food and pendant bags if bomb bag or both the food and pendant bags are owed
	if(global.Inventory.Bags[InventoryBag.Bombs].Owns || (global.Inventory.Bags[InventoryBag.Food].Owns && global.Inventory.Bags[InventoryBag.Pendants].Owns)){
		switch(_BagIndex){
			case InventoryBag.Food: _FanShiftX = FanPosition * -FanXOffset; break;
			case InventoryBag.Pendants: _FanShiftX = FanPosition * FanXOffset; break;				
		}
	}
	
	_Bag.X = lerp(_Bag.X1 + _FanShiftX, _Bag.X2 + _FanShiftX, _Bag.Position);
	_Bag.Y = lerp(_Bag.Y1, _Bag.Y2, _Bag.Position);
		
}


if(global.Inventory.Bags[InventoryBag.Main].Status == InventoryBagStatus.Closed) instance_destroy();
