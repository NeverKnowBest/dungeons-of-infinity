event_inherited();

Size = EnemySize.Small;

Gravity = -0.125;

DirX = 0;
DirY = 0;
MoveCount = 0;
LookDir = 1;
WallCollide_Bounce = true;

CheckForWater = true;
InWaterSprW = sprite_width + 4;
InWaterSprYOffset = -2;

//areas that Zol can spawn in. These will be the same as the enemy areas in the templates. This is to prevent him from spawning near stairs where he can get stuck
var _Room = global.Level.Rooms[RoomIndex];
var EnemyAreaArray = global.Templates_Room[_Room.TemplateClass][_Room.TemplateSubClass][_Room.TemplateIndex][$ "Sections"][SectionID][$ "Enemies"];
EnemyAreasInTemplate = array_length(EnemyAreaArray);
SpawnAreas = ds_grid_create(4, EnemyAreasInTemplate); //x1, y1, x2, y2
for(var i = 0; i < EnemyAreasInTemplate; i++){
	var _x1 = _Room.x + EnemyAreaArray[i].x;
	var _y1 = _Room.y + EnemyAreaArray[i].y;
	var _x2 = _x1 + EnemyAreaArray[i].width - 1;
	var _y2 = _y1 + EnemyAreaArray[i].height - 1;
	ds_grid_add(SpawnAreas, 0, i, _x1);
	ds_grid_add(SpawnAreas, 1, i, _y1);
	ds_grid_add(SpawnAreas, 2, i, _x2);
	ds_grid_add(SpawnAreas, 3, i, _y2);
}

Enemy_UpdateState(EnemyState.Idle);