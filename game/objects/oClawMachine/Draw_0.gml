
PixelRender(true, true, false, noone, 0, false, []);

draw_sprite(sClawMachine_Window, clamp(5 - Prizes, 0, 5), x + 3, y + 14);

var _ClawX = x + 2 + ClawX;
var _ClawY = y + 14;

switch(State){
	case ClawMachineState.RaiseClaw:
	case ClawMachineState.DropPrize:
		if(Win) draw_sprite(sClawMachine_Item, 0, _ClawX + 1.5, _ClawY + ClawY + 5 + DropItemY);		
		break;
}

draw_sprite_stretched(sClawMachine_Claw, ClawImg, _ClawX, _ClawY, 9, 8 + ClawY);

draw_self();

//draw_text(x, y, string(Prizes));

shader_reset();