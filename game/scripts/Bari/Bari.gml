
function Bari_UpdateDir(NewA, NewDir){
	
	CircleR = irandom_range(6, 12) * (Type = 1 ? 1.5 : 1);
	CircleA = NewA;
	CircleV = choose(1, 1.25, 1.5, 1.75, 2)  * (Type = 1 ? 1.5 : 1);
	CircleX = x + lengthdir_x(CircleR, CircleA);
	CircleY = y + lengthdir_y(CircleR, CircleA);
	CircleDir = NewDir;
	alarm[1] = irandom_range(20, 120);

}