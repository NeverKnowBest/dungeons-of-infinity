if(GameOver) exit;

var KeyLeft = input_check("left");
var KeyRight = input_check("right");
var KeyShoot = input_check("sword");


vx = 0;

if(KeyLeft) vx = -2;
if(KeyRight) vx = 2;

x += vx;

x = clamp(x, 5, oZerberk_MiniArcade_Game.GameW - 5);

if (KeyShoot){
	if(GunActive && !Shoot){
		instance_create_depth(x, y - 8, depth + 5, oZerberk_MiniArcade_Laser)
		alarm[0] = 12;
		Shoot = true;
	}

}else{
	GunActive = true;
	Shoot = false;
	alarm[0] = -1;
}
