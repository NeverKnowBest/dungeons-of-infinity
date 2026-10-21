if(global.Paused) exit;

if(State == EnemyState.Walking) Angle = (Angle + RotSpeed) mod 360;


Gurus_Update();