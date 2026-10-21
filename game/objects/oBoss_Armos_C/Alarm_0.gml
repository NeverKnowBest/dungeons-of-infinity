/// @description Script Timer
if(State == EnemyState.Shooting) exit;

WaypointScriptIndex = (WaypointScriptIndex + 1) mod WaypointPatterns;

Armos_Waypoints_Set();