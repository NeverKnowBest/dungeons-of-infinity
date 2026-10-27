# Engine notes

Working notes on how the Dungeons of Infinity engine is put together, kept so that new work (and new sessions) can start fast.

## Levels and rooms

* A level is a grid of rooms. Layouts live in `game/datafiles/data/data_d` (dungeon templates, by class; the Special class holds fixed layouts such as the save tent and the Sanctuary hub at index 5).
* Each room uses a room template from `game/datafiles/data/rooms/` (one file per class), converted from the Tiled maps in `data/room-templates/`. Class Other = 9, subclass Unique = 2 holds hand made rooms like `Sanctuary`.
* Rooms are made of 256px quadrants: a 2x2 room is 512x512. Template object coordinates are relative to the room's top left corner.
* Collision is only `oWall` instances, created with `WallObj_Create(layer, x, y, tilesW, tilesH)` (8px tiles).
* Instance layers by depth: `ObjsHigher_Upper` 400, `Objs_Upper` 600, `ObjsDoors_Upper` 700, `ObjsFloor_Upper` 800, tile floors 1400. Anything drawn with `PixelRender_Normal()` needs a `FloorLevel` variable.
* `data_d` is stored with Git LFS. The room template files are plain git (see `.gitattributes`), so their diffs show which templates changed.

## Room templates (`game/datafiles/data/rooms`)

* `tools/templates/convert.py` builds the room template files from the Tiled maps (one per class: `Room Templates <Class>.json`). It is a port of the old GameMaker project `editors/room-template-parser` (deleted in F5, oct/2026; it is in the git history), and its output was checked equal, by content, to the last `data_r` that project wrote. `game/scripts/__RoomTemplates` and `__Transformations` hold the same enums and transform tables on the game side.
* Until F5 everything was one 46 MB file in Git LFS, `data_r`. Now it is `game/datafiles/data/rooms/<Class>.json`, one file per class, with one template per line. Main_Upper alone is 37.6 MB; GitHub warns at 50 MB, so split it by subclass if it gets close (the validator warns at 45 MB). Each file is an included file in `Zelda.yyp` (`datafiles/data/rooms`).
* `RoomTemplates_Load` reads the ten files in class order into `global.Templates_Room[class][subclass][template]` and prints `Room templates loaded: [[42.0,231.0],...]` (the template counts) to the run output. Class order: Main_Upper, Main_Lower, Stairs, Jails, Village, Mines, Obstacles, Sections, Special, Other. The subclass is the room size (1x1, 1x2, 2x1) for the size based classes, or the Tiled room `type` (Obstacles: Blocks, MovingFloors, SpikeBlocks; Special: Fairy, Shop, GemPond, Treasure, TreasureLarge, Rupee, Gem, Kinstone; Other: Boss, Start, Unique, Save; Village: Main, House, Maze, Exit; Mines: Main, House).
* A Tiled map has a `Rooms` layer (one rectangle per template, with `type` and properties such as `Symetry` and `Split_MainSectionIDs`), one object layer per object type of the class, and for some classes a `Sections` group (Main_Upper has 5 sub groups: Main, 1-3-6-8, 2-4-5-7, 9-...-16, 17-20; the others only Main). Every object has a `Room` property pointing to its room rectangle. The lists of layers per class are in `convert.py` (`OBJ_TYPES`, `SECTION_OBJ_TYPES`) and in `RoomTemplates_Load`.
* Object positions become relative to the room; a rotated Tiled object (90, -90, 180) is turned into a plain box first (`RoomTemplates_FixObjRotation`).
* Main_Upper and Main_Lower templates are half rooms (256x128 or 256x256). The converter joins every pair whose `SplitConnections` match: the second half is flipped vertically (and also flipped both ways when both halves have `Symetry` 0) and placed under the first. Then touching side walls are joined, duplicated doors removed and carpet door lists merged. That is why 46 Main_Upper halves become 273 rooms. Template 11115 joined with itself unflipped is skipped on purpose (bad zones).
* `DoorCode`: one number per transform (None, FlipH, FlipV, FlipHV, RotateCW, RotateCCW, FlipHRotateCW, FlipHRotateCCW); bit n-1 is set when there is a door at position n (1..24, the coordinates are in `DOOR_XY` / `Data_InitDoorCoordinates`) after that transform. `ZoneCodes[transform][section][zone]` is the same per zone. Doors get `Position` and `Location`. Village, Mines and Other get no codes and allow no transform.
* Numbers are written as floats (`16.0`), like GameMaker writes its reals. The old `data_r` ended with a zero byte (GameMaker `buffer_string`); the new files do not, and `buffer_read(..., buffer_string)` still reads them whole (tested in game).
* Carpet `DoorsFrom` and `DoorsTo` are strings in Tiled. The GML transform split them with `CSVToList` (strings) and still worked in game, so the converter treats them as numbers (the comparison with the real `data_r` showed no difference).
* The old parser ended with `RoomTemplates_GenerateImageSheet` (a debug PNG that read a `RoomMapSpr` nobody set); the converter does not port it.

## Project files

* Only resources listed in `game/Zelda.yyp` are compiled. The 424 folders that were on disk but not in it (old scripts such as `_Enemies`, `Init` and `Dungeon_Init`, unused sprites and objects) were deleted in the F1 cleanup (oct/2026); the original 1.2.1 code is on archive.org if one is ever needed. The validator warns about any new orphan folder (`--orphans` lists them).
* When a resource is removed from the project in the IDE, GameMaker leaves its folder on disk. Delete the folder too, or the validator flags it as an orphan.
* An object's `.gml` files only run if the event is in the object's `eventList` in its `.yy`. The leftover event files of the original were deleted in F1; the validator warns about new ones.
* Resource folder names must match the `.yyp` letter case exactly (`objects/oCape`, not `objects/ocape`); Windows does not care, Linux tools do. The 48 mismatches were fixed in F1 and the validator warns about new ones. On Windows a case only rename is not seen by Git with `core.ignorecase=true` (the default); use `git mv old tmp` then `git mv tmp New`.
* `data_d`, the audio and the manuals and references in `docs/` (PDF, DOCX, MHTML) are Git LFS files. Both PCs (home and work) have Git LFS, so the real files are there. A clone without LFS (Claude's cloud sandbox, for example) only has pointers; the validator skips them.
* The live game reads no command line parameters. The original had `-t` and `-d` handling in `InitScreen` inside an old `Init` script that was not in the project (deleted in F1; see the 1.2.1 source on archive.org).
* Level specific rules are spread through the code as `switch(global.Level.Index)` and `== DungeonLevel.X` checks (Mines: doors, decor, shop, waterfall colour, chance tables...). A new level means finding all of them until the level table (roadmap F4) exists.

## Building and running from the command line

Found while testing F5 on the work PC (oct/2026); it is the first piece of F3. Igor is the build tool the IDE runs:

```
<runtime>\bin\igor\windows\x64\Igor.exe -j=8 --project="<repo>\game\Zelda.yyp" --user="%APPDATA%\GameMakerStudio2-LTS2026\<user folder>" --runtimePath="<runtime>" --runtime=VM --prefabs="C:\ProgramData\GameMakerStudio2-LTS2026\Prefabs" --cache="<temp>\cache" --temp="<temp>\temp" -- Windows Run
```

* `<runtime>` is `C:\ProgramData\GameMakerStudio2-LTS2026\Cache\runtimes\runtime-2026.0.0.23` (the active one is named in `C:\ProgramData\GameMakerStudio2-LTS2026\runtime.json`). The user folder is the one inside `%APPDATA%\GameMakerStudio2-LTS2026` (`unknownUser_unknownUserID` when nobody is signed in to the IDE).
* `--prefabs` is required: the project uses the `gm_filter_heathaze` and `gm_filter_pixelate` prefabs, and without it the asset compiler stops with "Prefab libraries that cannot be located".
* `Run` compiles (about a minute) and starts the game; the command only returns when the game closes, so run it in the background. It writes the build to `output/` inside the current folder, so start it from a temporary folder, not from the repository. Everything the game prints (`show_debug_message`, runtime warnings, compile errors) goes to the command output.
* `PackageZip` (making an executable) fails with "Permission Error: Unable to obtain permission to execute" when nobody is signed in to the IDE; `Run` works anyway.
* Screenshots and key presses during a test: PowerShell with `user32` (`SetForegroundWindow`, `GetWindowRect`, `keybd_event`) and `System.Drawing` (`CopyFromScreen`) on the `Runner` process window, holding each key about 0.15 s. Close the game with `Stop-Process -Name Runner`.
* Known noise in the output, not errors of ours: `oCredits_Step_0 ... Index did not map to an existing sound instance` and `Intro_ShowLink ... existing audio asset`.

## Enemies (`scripts/__Enemies`)

* `Enemies_InitData` registers every enemy with `EnemyDataInit(object, energy index, attack, special item, item, pack points, [weapon effects], [weight per level])`. An enemy object with no entry is never placed by the room generator (several exist: Delavant, Kyune, Lynel, Pirugusu, Soldier_Slasher).
* Energy index means hits to kill, through `global.EnemyHitsToKill[attack points][index]`. Attack points are `ATTACK()` = sword index + 1 + glove index (minus the curse). Damage to Link is `Attack` in hearts minus 0.25 per defense point, at least 1/8 (`Enemy_Attack`).
* Many enemies override the table's energy and attack in their own `Create`, by level: soldiers, Poe, Wizzrobe, Beamos (`switch(global.Level.Index)`), and Bari, Bubble, Gibdo, Guru, Keese, Kodongo, Octorok, Ropa, SnapDragon (`Type` from a level comparison), Wallmaster (formula). Fortress soldiers set theirs in `Step_1` from the random head. `docs/ref/doi.md` lists them all; check the object before trusting the table.
* The level columns in `EnemyDataInit` stop at Aghanim1 (13 columns for 14 levels).
* Numbers for every enemy are collected in `docs/ref/doi.md`.

## Weather

* Rain and lightning only exist in `oIntro` (level `Start`): `oRainDrop`, `oRainSplash`, `Sound_Rain` kept in `global.RainSound` (still playing in the castle). Lightning: alarm 1 sets `global.GlobalLighting = false` for 2 or 3 frames (alarm 2), every 30 to 180 frames; the `Draw` paints the white flash. No thunder sound in the project.

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
* Testing: the game can be run from the GameMaker IDE on either PC, or from the command line (see "Building and running from the command line"); `%LOCALAPPDATA%/Zelda/options.ini` with `Fullscreen="0"` and `AltTabPause="0"` keeps it in a window. Keys: arrows, Alt talks, Ctrl sword, Enter/Escape menus.
* GML gotcha: `[#` starts a ds_grid accessor, so an array literal can't start with a `#RRGGBB` colour; use `make_colour_rgb`.

## Achievements (`scripts/__Achievements`)

* `global.AchievementList` entries: `Key`, `Statue`, `Name`, `Desc`, `Skin` reward, `Gear` reward. Statues (bronze, silver, gold) group them and are revealed when all of theirs are done.
* Saved per user in `User.Achievements` (struct of keys), plus `User.Skin` and `User.BonusItem`.
* Hooks: `Achievements_OnLevelStart` (Dungeon_InitLevel), `Achievements_OnBossDefeated` (crystal pickup in oLink Step), `Achievements_OnGameWon` (oBoss_Aghanim), `Achievements_CheckStats` (end of `User_UpdateStats`). Nothing unlocks while cheats are on.

## Assets from A Link to the Past

Room pictures, sprites and music were taken from the original game with small harnesses built on the zelda3 reimplementation (room render with animated tiles, sprite OAM dump, SPC music render). Music is split into an intro and a loop (`Music_Sanctuary_Intro`, `Music_Sanctuary_Main`).
