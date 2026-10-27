event_inherited();

WallInst.image_yscale = 3.5;

Front = irandom(4);

//list of players. Shuffle list and pick first entry, then delete it. This is so we don't pick the same player twice
var Players = 14;
if(ds_list_size(global.Arcade_UsedPlayers) == 0){
	for(var i = 0; i < Players; i++){
		ds_list_add(global.Arcade_UsedPlayers, i);
	}
	ds_list_shuffle(global.Arcade_UsedPlayers);
}


if(LevelDef.TMNTRoom){
	PlayerSprite = asset_get_index("sArcadePlayerTMNT");
}else{
	PlayerSprite = asset_get_index("sArcadePlayer" + string(global.Arcade_UsedPlayers[| 0]));
	ds_list_delete(global.Arcade_UsedPlayers, 0);
}

PlayerY = y + 4;
PlayerImageIndex = choose(0,1,2);
alarm[1] = 8;

