enum SlotState{
	Idle,
	Spin,
	Win	
}

enum MothulaSlotSymbol{
	None,
	Cherry,
	Plum,
	Orange,
	Bell,
	Seven,
	Jackpot	
}

global.MothulaSlot_ReelSymbols = [	
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Cherry,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Bell,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Plum,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Seven,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Jackpot,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Cherry,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Orange,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Plum,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Jackpot,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Bell,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Cherry,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Seven,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Orange,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Jackpot,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Plum,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Cherry,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Bell,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Seven,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Plum,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Jackpot,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Orange,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Bell,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Seven,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Cherry,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Plum,
									MothulaSlotSymbol.None,
									MothulaSlotSymbol.Jackpot,
								]

global.MothulaSlot_ReelIndexes = array_length(global.MothulaSlot_ReelSymbols);
global.MothulaSlot_ReelSymbolCount = global.MothulaSlot_ReelIndexes / 2;

global.MothulaSlot_ReelH = global.MothulaSlot_ReelSymbolCount * 32;

global.MothulaSlot_ReelSprite = noone;

MothulaSlot_CreateReel();

function MothulaSlot_CreateReel(){
	
	var MothulaSlot_ReelSurface = surface_create(48, global.MothulaSlot_ReelH);
	
	surface_set_target(MothulaSlot_ReelSurface);
	draw_clear_alpha(c_black, 0.0);	
	
	for(var _ReelPos = 0; _ReelPos < global.MothulaSlot_ReelSymbolCount; _ReelPos++){
		
		var _Symbol = global.MothulaSlot_ReelSymbols[(_ReelPos * 2) + 1];
		var _SymbolPos = ((_ReelPos + 1) mod global.MothulaSlot_ReelSymbolCount) * 32;
		
		draw_sprite(sArcade_Mothula_Symbols, _Symbol - 1, 0, _SymbolPos);
		
	}
	
	surface_reset_target();	
	
	global.MothulaSlot_ReelSprite = sprite_create_from_surface(MothulaSlot_ReelSurface, 0, 0, 48, global.MothulaSlot_ReelH, false, false, 0, 0);
	
	surface_free(MothulaSlot_ReelSurface);
	
}
