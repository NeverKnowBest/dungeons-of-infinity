// Feather disable GM2064
// Link sets DB_Init when he talks to an NPC
if(!DB_Init) exit;
DB_Init = false;
if(instance_exists(oHallGallery) || instance_exists(oMenu_Game) || instance_exists(oDialogueBox)) exit;
instance_create_layer(0, 0, "System", oHallGallery, { Index: Index });
