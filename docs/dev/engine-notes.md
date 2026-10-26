# Engine notes

Working notes on how the Dungeons of Infinity engine is put together, kept so that new work (and new sessions) can start fast.

## Levels and rooms

* A level is a grid of rooms. Layouts live in `game/datafiles/data/data_d` (dungeon templates, by class; the Special class holds fixed layouts such as the save tent and the Sanctuary hub at index 5).
* Each room uses a room template from `game/datafiles/data/data_r`, exported from the Tiled maps in `data/room-templates/`. Class Other = 9, subclass Unique = 2 holds hand made rooms like `Sanctuary`.
* Rooms are made of 256px quadrants: a 2x2 room is 512x512. Template object coordinates are relative to the room's top left corner.
* Collision is only `oWall` instances, created with `WallObj_Create(layer, x, y, tilesW, tilesH)` (8px tiles).
* Instance layers by depth: `ObjsHigher_Upper` 400, `Objs_Upper` 600, `ObjsDoors_Upper` 700, `ObjsFloor_Upper` 800, tile floors 1400. Anything drawn with `PixelRender_Normal()` needs a `FloorLevel` variable.
* `data_r` and `data_d` are stored with Git LFS.

## Project files

* Only resources listed in `game/Zelda.yyp` are compiled. The repo also has hundreds of folders that are not in it (old scripts such as `_Enemies` next to the live `__Enemies`, old `Init` and `Dungeon_Init`, unused sprites and objects). They never run; `tools/check/validate.py --orphans` lists them. Search results often hit both versions, so check the `.yyp` first.
* An object's `.gml` files only run if the event is in the object's `eventList` in its `.yy`. Several objects have leftover event files that never run (the validator warns about them).
* Some resource folders differ from the `.yyp` only in letter case (`objects/ocape` for `oCape`). Windows does not care; Linux tools do.
* `data_r`, `data_d` and the manuals and references in `docs/` (PDF, DOCX, MHTML) are Git LFS files. Claude's cloud sandbox clones the repo anonymously and cannot fetch LFS objects, so there they are only pointers (the validator skips them). Work that needs their contents is done on the home PC or with the files attached.
* The live game reads no command line parameters. The `-t` and `-d` handling in `InitScreen` is in the dead `Init` script.
* Level specific rules are spread through the code as `switch(global.Level.Index)` and `== DungeonLevel.X` checks (Mines: doors, decor, shop, waterfall colour, chance tables...). A new level means finding all of them until the level table (roadmap F4) exists.

## Enemies (`scripts/__Enemies`)

* `Enemies_InitData` registers every enemy with `EnemyDataInit(object, energy index, attack, special item, item, pack points, [weapon effects], [weight per level])`. An enemy object with no entry is never placed by the room generator (several exist: Delavant, Kyune, Lynel, Pirugusu, Soldier_Slasher).
* Energy index means hits to kill, through `global.EnemyHitsToKill[attack points][index]`. Attack points are `ATTACK()` = sword index + 1 + glove index (minus the curse). Damage to Link is `Attack` in hearts minus 0.25 per defense point, at least 1/8 (`Enemy_Attack`).
* Many enemies override the table's energy and attack in their own `Create`, by level: soldiers, Poe, Wizzrobe, Beamos (`switch(global.Level.Index)`), and Bari, Bubble, Gibdo, Guru, Keese, Kodongo, Octorok, Ropa, SnapDragon (`Type` from a level comparison), Wallmaster (formula). Fortress soldiers set theirs in `Step_1` from the random head. `docs/ref/doi.md` lists them all; check the object before trusting the table.
* The level columns in `EnemyDataInit` stop at Aghanim1 (13 columns for 14 levels).
* Numbers for every enemy are collected in `docs/ref/doi.md`.

## Weather

* Rain and lightning only exist in `oIntro` (level `Start`): `oRainDrop`, `oRainSplash`, `Sound_Rain` kept in `global.RainSound` (still playing in the castle). Lightning: alarm 1 sets `global.GlobalLighting = false` for 2 or 3 frames (alarm 2), every 30 to 180 frames; the `Draw` paints the white flash. No thunder sound in the project.
* `objects/oRainController` is an orphan (not in `Zelda.yyp`).

## NPCs

* Template object gid 209 (NPC) creates the object `"o" + name`. Properties: `Dialogue` (lines split by `\n`, one line per talk; a `?` prefix makes it a yes/no question), `Response`, `NoWall` (any value: no collision box).
* `oNPC` adds the sprite offset to x and y, so the template position is the sprite's top left corner. Sprites are found by name: `s<Name>_Down`, `_Up`, `_Left`, `_Right`.
* `oNPC_Sitting` is the parent of simple villagers. Link talks to the NPC found at `(x, bbox_top - 5)`; `DB_Started` is set on the NPC when its dialogue box opens.

## Menus

* Title menu: `oMenu`. In game: `oMenu_Game`, with `Mode` = `"Pause"` (pause menu), `"Depart"` (Sanctuary door) or `"Wardrobe"` (Flute Boy).
* Pages are built with `Menu_Create(page, title, rows, config)` and rows with `Menu_Item`, `Menu_BackItem`, `Menu_Toggle`, `GameMenu_Link`... `GameMenu_Open(page)` switches page and resizes the frame.
* Extra row fields drawn by `oMenu_Game`: `LabelFn(row)`, `LockedFn(row)` (grayed out), `ValueFn(row)` (right aligned text), `HintFn(row)` (footer text in hub menus), `OnDraw(row, frameX, y, valueRight)`.
* `global.Font_Small` only has upper case letters.

## Sanctuary hub (`scripts/__Hub`)

* `Menu_StartGame` and giving up a run set `global.HubPending`; `oGame` then calls `Dungeon_InitHubLevel` instead of building a run. `global.HubLevel` is true while in the hub; `global.Level.Index` stays `DungeonLevel.Castle`.
* The room is a pre-rendered picture of the original ALttP room 0x12 (`sHub_Sanctuary` under Link, `sHub_Sanctuary_Over` over him, `sHub_SanctuaryFlame` for the animated lamps) plus walls from `Hub_SanctuaryWalls()`.
* `oHubExit` at the front door opens the Depart menu (bonus item, challenges); "Set out" calls `Hub_StartRun`.
* The Flute Boy (`oVillager_FluteBoy`) opens the Wardrobe after his line.
* The hub layout has two rooms: the Sanctuary (2x2, grid 3,3) and the Hall of Fame (2x1, grid 5,3). `Hub_RoomTemplateName` picks the template by grid position and `Hub_CreateScenery` builds each room. The rooms are not joined by engine doors: `oHubDoor` (a trigger box in a doorway painted on the picture) creates `oHubTravel`, which moves Link to the other doorway with `Hub_MoveLinkTo` (activates the room, returns the camera target), scrolls the camera there 4px per frame like a dungeon room change, deactivates the old room and makes Link walk in.
* Hall of Fame: four statues along the top wall (`Hub_CreateStatue`: `oHallStatue` draws the pedestal and the bottom of the figure at depth 750, under Link; `oHallStatueTop` draws the rest over him; a wall covers the pedestal and the space behind it, so Link can't walk behind). `oHallStatue` is an `oNPC` child so Link can talk to it (all oNPC events replaced); talking opens `oHallGallery` with only that statue: up/down picks an achievement to read what it asks for (rewards are never shown). Sprites: `sHall_Statue_*` (figure; frame 0 revealed, frame 1 silhouette) and `sHall_Pedestal` (frame = tier).
* Hub pictures and statue sprites are built offline by the scripts in `tools/hub/` (see `tools/README.md`).
* Testing: the game can be run from the GameMaker IDE on the user's home PC; `%LOCALAPPDATA%/Zelda/options.ini` with `Fullscreen="0"` and `AltTabPause="0"` keeps it in a window. Keys: arrows, Alt talks, Ctrl sword, Enter/Escape menus.
* GML gotcha: `[#` starts a ds_grid accessor, so an array literal can't start with a `#RRGGBB` colour; use `make_colour_rgb`.

## Achievements (`scripts/__Achievements`)

* `global.AchievementList` entries: `Key`, `Statue`, `Name`, `Desc`, `Skin` reward, `Gear` reward. Statues (bronze, silver, gold) group them and are revealed when all of theirs are done.
* Saved per user in `User.Achievements` (struct of keys), plus `User.Skin` and `User.BonusItem`.
* Hooks: `Achievements_OnLevelStart` (Dungeon_InitLevel), `Achievements_OnBossDefeated` (crystal pickup in oLink Step), `Achievements_OnGameWon` (oBoss_Aghanim), `Achievements_CheckStats` (end of `User_UpdateStats`). Nothing unlocks while cheats are on.

## Assets from A Link to the Past

Room pictures, sprites and music were taken from the original game with small harnesses built on the zelda3 reimplementation (room render with animated tiles, sprite OAM dump, SPC music render). Music is split into an intro and a loop (`Music_Sanctuary_Intro`, `Music_Sanctuary_Main`).
