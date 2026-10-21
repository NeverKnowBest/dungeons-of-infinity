enum Coupon{
	Blue,	//15% off
	Silver, //30% off
	Gold,	//50% off
	Green,	//magic item
	Red,	//health item
	Pink	//Treasure
	
}

global.CouponModifier[Coupon.Blue] = 0.85;
global.CouponModifier[Coupon.Silver] = 0.7;
global.CouponModifier[Coupon.Gold] = 0.5;
global.CouponModifier[Coupon.Green] = 0;
global.CouponModifier[Coupon.Red] = 0;
global.CouponModifier[Coupon.Pink] = 0;

function Coupon_PickIndex(_ItemFrom){
	
	switch(_ItemFrom){
		
		case ItemFrom.Treasure:
			return choose(	Coupon.Silver,Coupon.Silver,
							Coupon.Green,Coupon.Green,
							Coupon.Red,Coupon.Red,
							Coupon.Gold);
		
		case ItemFrom.Pot:
		case ItemFrom.EnemyTiny:
		case ItemFrom.EnemySmall:
		case ItemFrom.EnemyMedium:
			return choose(	Coupon.Blue,Coupon.Blue,Coupon.Blue,
							Coupon.Silver,
							Coupon.Pink);
		
		case ItemFrom.EnemyLarge:
			return choose(	Coupon.Blue,Coupon.Blue,Coupon.Blue,Coupon.Blue,
							Coupon.Silver,Coupon.Silver,Coupon.Silver,Coupon.Silver,Coupon.Silver,Coupon.Silver,
							Coupon.Gold,
							Coupon.Green,Coupon.Green,
							Coupon.Red,Coupon.Red,
							Coupon.Pink,Coupon.Pink);
	}
	
	return choose(Coupon.Blue,Coupon.Blue,Coupon.Silver);
	
}

function Coupon_NewPrice(_Price, _ShopItemClass, _ShopItemIndex){
	
	if(Inventory_NoItemIsEquiped) return _Price
	
	if(Inventory_EquipedItem.ItemClass != ItemClass.Coupon) return _Price
	
	
	var _NewPrice = _Price;	
	
	var _CouponIndex = Inventory_EquipedItem.ItemIndex;
	var _ApplyCoupon = false;
		
	switch(_CouponIndex){
		case Coupon.Blue:
		case Coupon.Silver:
		case Coupon.Gold:
			_ApplyCoupon = true;
			break;
				
		case Coupon.Green:
			
			switch(_ShopItemClass){
				case ItemClass.MagicLarge:
					_ApplyCoupon = true;
					break;
						
				case ItemClass.Potion:
					switch(_ShopItemIndex){
						case Potion.Magic:
						case Potion.HealthMagic:
							_ApplyCoupon = true;
							break;							
					}
					break;
					
			}
			break;
				
		case Coupon.Red:
			
			switch(_ShopItemClass){
				case ItemClass.Food:
				case ItemClass.Pop:
				case ItemClass.HeartPiece:
					_ApplyCoupon = true;
					break;	
						
				case ItemClass.Potion:
					switch(_ShopItemIndex){
						case Potion.Milk:
						case Potion.Health:
						case Potion.HealthMagic:
							_ApplyCoupon = true;
							break;							
					}
					break;
					
			}
			break;
		
		case Coupon.Pink:
			_ApplyCoupon = (_ShopItemClass == ItemClass.Treasure);
			break;
	}
		
	if(_ApplyCoupon) _NewPrice = round(_NewPrice * global.CouponModifier[_CouponIndex]);

	
	return _NewPrice
	
}