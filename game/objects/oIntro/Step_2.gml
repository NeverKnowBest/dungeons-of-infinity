DrawDarkScreen = true;
with(oLinkDeath){
	if(ShowRed || Falling || FadeToGameOver || GameOver || ShowMenu) other.DrawDarkScreen = false;
}
