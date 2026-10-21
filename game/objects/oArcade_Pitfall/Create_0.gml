event_inherited();


CamW = 160;
CamH = 140;

RoomW = 488;
RoomH = CamH;

CamX = 0;
CamXMin = CamX;
CamXMax = RoomW - CamW;
CamDir = 1;

CamW_2 = CamW / 2;
CamH_2 = CamH / 2;
CamW_3 = CamW / 3;
CamH_3 = CamH / 3;
CamW_4 = CamW / 4;
CamH_4 = CamH / 4;


Harry = noone;
HarryStartX = CamX + 32;
HarryStartY = 112;


Music = Pitfall_Music1;

NextEnemy = choose(oPitfall_Scorpion, oPitfall_Bat);
NextEnemySpawnX = CamX + CamW_2;


Score = 0;
Hiscore = Arcade_Hiscore_Load(ArcadeGame.Pitfall);
if(Hiscore == -1) Hiscore = 5000;

ShowNewHiscore = false;

