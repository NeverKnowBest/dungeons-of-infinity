GameW = 128;
GameH = 112;
GameCentre = GameW / 2;
GameSurface = surface_create(GameW, GameH);

BorderW = (sprite_width - 1) / 2;

ScreenW = GameW + (2 * BorderW);
ScreenH = GameH + (2 * BorderW);
ScreenX = (global.Arcade_ActiveInst.CamW - ScreenW) / 2;
ScreenY = (global.Arcade_ActiveInst.CamH - ScreenH) / 2;

Score = 0;
Hiscore = Arcade_Hiscore_Load(ArcadeGame.SporkInvaders);
if(Hiscore == -1) Hiscore = 200;

Level = 0;
State = MiniArcadeState.Title;

ShowLevel = false;
ShowScore = false;

LevelChange = false;
GenerateAliens = false;
ExplodeCount = 0;




