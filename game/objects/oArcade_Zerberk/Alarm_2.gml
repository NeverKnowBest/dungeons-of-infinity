/// @description Reset after death

if(Lives == 0){
	State = ArcadeState.GameOver;
	Arcade_Hiscore_Check(ArcadeGame.Zerberk);
}else{
	Lives--;
	Zerberk_Level_Reset();
}