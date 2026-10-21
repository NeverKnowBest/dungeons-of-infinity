
if(GameOver) exit;


if(Spawned){

	vx = cos(FlyTimeX / (2 * Pattern));
	vy = sin(FlyTimeY / 1.5) + 0.3 + (oZerberk_MiniArcade_Game.Level * 0.05);

	FlyTimeX += 0.15;
	FlyTimeY += 0.15;

	if(y > oZerberk_MiniArcade_Game.GameH - 13 || place_meeting(x + vx, y + vy, oZerberk_MiniArcade_Ship)){
		
		audio_play_sound(sndZerberk_MiniArcade_Death, 1, false);
		
		instance_create_depth(oZerberk_MiniArcade_Ship.x, oZerberk_MiniArcade_Ship.y, oZerberk_MiniArcade_Ship.depth - 5, oZerberk_MiniArcade_Explosion);
		
		oZerberk_MiniArcade_Ship.visible = false;
		oZerberk_MiniArcade_Ship.GameOver = true;
		
		oZerberk_MiniArcade_Game.alarm[4] = 4;
		oZerberk_MiniArcade_Game.GenerateAliens = false;
		
		with(oZerberk_MiniArcade_Alien) GameOver = true;
		
	}
	
}


if(!Spawned){
	vy -= 0.075;
	if(vy <= 0){
		FlyTimeX = random(6.28);
		Spawned = true;
	}
}

x += (vx + (oZerberk_MiniArcade_Game.Level * 0.015 * sign(vx)));
y += vy;

if(x + vx < ClampBuffer || x + vx > oZerberk_MiniArcade_Game.GameW - ClampBuffer - 1){
	x = clamp(x, ClampBuffer, oZerberk_MiniArcade_Game.GameW - ClampBuffer - 1)
	FlyTimeX += 3.14;
	//vx *= -1;
}