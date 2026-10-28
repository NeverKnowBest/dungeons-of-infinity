#macro GAMEDIR_DATA "data\\"
#macro GAMEDIR_DATA_CONTROLLERS GAMEDIR_DATA + "controller_db\\"
#macro GAMEFILE_DUNGEONTEMPLATES GAMEDIR_DATA + "data_d"
#macro GAMEDIR_ROOMTEMPLATES GAMEDIR_DATA + "rooms\\"
#macro GAMEDIR_TILES GAMEDIR_DATA + "tiles\\"

#macro USERSFILE "Users"
#macro XZIPFILE_USERS "UserData"
#macro XZIPFILE_ARCADES "AHS"



#macro VERSION "1.2.2 CE"


#macro DEBUG false



#macro NONE 0

#macro UP 1
#macro TOP 1
#macro DOWN 2
#macro BOTTOM 2
#macro LEFT 3
#macro RIGHT 4
#macro ALLDIR 5
#macro TOPLEFT 6
#macro TOPRIGHT 7
#macro BOTTOMLEFT 8
#macro BOTTOMRIGHT 9

#macro TOP_BOTTOM 0
#macro LEFT_RIGHT 1

#macro TOP_LEFT 0
#macro TOP_RIGHT 1
#macro BOTTOM_LEFT 2
#macro BOTTOM_RIGHT 3

#macro HORIZONTAL 1
#macro VERTICAL 2

#macro LOWER 0
#macro UPPER 1
#macro UPPERLOWER 2

#macro NO 0
#macro YES 1

#macro TilesetW 156
#macro VillageTilesY 76
// LevelTilesY and LevelTilesY_Base are in scripts/__Levels

#macro CAM_W 256
#macro CAM_H 224

enum VP{
	Screen,
	Main,
	Map
}

global.DirStr[UP] = "Up";
global.DirStr[DOWN] = "Down";
global.DirStr[LEFT] = "Left";
global.DirStr[RIGHT] = "Right";



