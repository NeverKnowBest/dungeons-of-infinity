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
* The only command line parameter the game reads is `-test <file>` (test mode, below; the environment variable `DOI_TEST` does the same). The original had `-t` and `-d` handling in `InitScreen` inside an old `Init` script that was not in the project (deleted in F1; see the 1.2.1 source on archive.org).
* GML evaluates the right side of an assignment before the index on the left: `a[i] = f(i++)` stores at the incremented `i` (the level sheet came out shifted by one). Use `a[i] = f(i); i++;` or explicit indices.
* When Claude writes a file through a shell heredoc on these PCs, a double backslash arrives as a single one and accented text can arrive in the wrong code page: GML strings with an escaped `\n` became real line breaks and `\r`/`\t` in Windows paths became control characters in `tools/README.md`. Write such files with the editor tools, or build backslashes with `chr(92)` and run Python with `PYTHONUTF8=1`.
* Level specific rules live in the level sheet (`scripts/__Levels`, below). Code should read `LevelDef.<field>`, never compare `global.Level.Index` with a `DungeonLevel` member.

## Building and running from the command line

`tools/test/run.py` does all of this by itself (finds the runtime and the user folder, builds in `%TEMP%\doi-test`, runs a test scenario); see "Automated tests" below. Igor is the build tool the IDE runs:

```
<runtime>\bin\igor\windows\x64\Igor.exe -j=8 --project="<repo>\game\Zelda.yyp" --user="%APPDATA%\GameMakerStudio2-LTS2026\<user folder>" --runtimePath="<runtime>" --runtime=VM --prefabs="C:\ProgramData\GameMakerStudio2-LTS2026\Prefabs" --cache="<temp>\cache" --temp="<temp>\temp" -- Windows Run
```

* `<runtime>` is `C:\ProgramData\GameMakerStudio2-LTS2026\Cache\runtimes\runtime-2026.0.0.23` (the active one is named in `C:\ProgramData\GameMakerStudio2-LTS2026\runtime.json`). The user folder is the one inside `%APPDATA%\GameMakerStudio2-LTS2026` (`unknownUser_unknownUserID` when nobody is signed in to the IDE).
* `--prefabs` is required: the project uses the `gm_filter_heathaze` and `gm_filter_pixelate` prefabs, and without it the asset compiler stops with "Prefab libraries that cannot be located".
* `Run` compiles (about a minute) and starts the game; the command only returns when the game closes, so run it in the background. It writes the build to `output/` inside the current folder, so start it from a temporary folder, not from the repository. Everything the game prints (`show_debug_message`, runtime warnings, compile errors) goes to the command output.
* `PackageZip` (making an executable) fails with "Permission Error: Unable to obtain permission to execute" when nobody is signed in to the IDE; `Run` works anyway.
* Screenshots and key presses during a test: PowerShell with `user32` (`SetForegroundWindow`, `GetWindowRect`, `keybd_event`) and `System.Drawing` (`CopyFromScreen`) on the `Runner` process window, holding each key about 0.15 s. Close the game with `Stop-Process -Name Runner`.
* Known noise in the output, not errors of ours: `oCredits_Step_0 ... Index did not map to an existing sound instance` and `Intro_ShowLink ... existing audio asset`.
* After a `Run` build the game data is `%TEMP%\doi-test\output\Zelda\Zelda.win`; `<runtime>\windowsd\Runner.exe -game <that file>` starts it again without compiling (8 s; `run.py --no-build`).

## Automated tests (`scripts/__Test`, roadmap F3)

* Test mode starts in `oInit`: `Test_Init` (Create) looks for `-test <file>` or `DOI_TEST`, reads the scenario from the save folder and creates `oTest` (persistent, at -10000,-10000 so room deactivation never reaches it). `Test_Begin` (instead of `room_goto_next` to the title) makes a throwaway user, turns on the scenario's cheats and goes to `Room_Dungeon`, where `oGame` calls `Test_StartLevel` instead of building the intro.
* Nothing is written to disk in test mode: `User_Save`, `Settings_SaveIni` and the arcade high scores return early, and `Error()` logs a FAIL instead of opening a message box (a message box would hang the test). Unhandled GML errors go to `Test_OnCrash` (`exception_unhandled_handler`), which logs the message and the stack.
* Input: steps call `input_verb_set` every frame. Two traps of the Input library (7.0.1): a player with no source (nobody pressed a key yet) does not update its verbs at all, so test mode sets the player to ghost (`input_player_ghost_set(true)`, which also ignores the real keyboard); and forced verbs are dropped while the window has no focus, so `INPUT_ALLOW_OUT_OF_FOCUS` is true in test mode only. `global.AltTabPause` is turned off too.
* `oTest` runs the steps in its End Step, like `oLink` builds the next level there: room activation and level building must happen after the Step events.
* Building a new level over another one: `Dungeon_Clear` only destroys active instances, so every room must be woken first with `instance_activate_all()`, and activation takes one event to process. The game does it in `oLink`'s Step (stairs) and builds in the End Step; `oTest` does the same (its Step activates, the next End Step builds). Skipping it leaves enemies of the old level alive, and they crash later with a room index out of range.
* Screenshots: in Post Draw (`Draw_77`) `application_surface` holds the finished frame without the HUD (drawn later, in Draw GUI). The game view is view 1, drawn at 4x at port (288, 0, 1024x896); `Test_CaptureView` copies it back at 1x. Copy with alpha writes off over an opaque surface, or the PNG comes out partly transparent.
* Contact sheet: `Test_SheetStart` hides Link, pauses the game (`global.Paused`) and drives `oCamera` with `Override` (the camera then keeps X/Y as set). Each room is activated in turn and pictured in 256x224 steps. `oLink` must stay active (re-activate him after deactivating a room): `oCamera`'s End Step exits when he does not exist.
* Determinism: `Test_BuildLevel` sets the seed and reshuffles the user's dungeon layout order (`DungeonSeq_Init`, normally done once per new user). A scenario run from the start always plays the same way. But building the same level and seed again later in the same run gives a different level, because the generator keeps state between levels (treasure limiter, prisoners, shop keepers...). So compare levels between runs, not inside one.
* Hooks in the game code: `Test_OnKill` in `Enemy_Destroy`, `Test_Event` in `Achievements_OnBossDefeated`, `Test_OnLevelBuilt` in `Dungeon_InitLevel`. All do nothing outside test mode. More events can be logged the same way.
* The music in a dump depends on the real clock: `oMusic` switches from the intro to the loop when the intro sound ends, so on a busy PC (another test or the validator running) the third build of `ref_01`/`ref_02` can show `SongPlaying_Intro=0`. Not a generator change; run it again alone.
* Level dumps (`"dump": true`): `Test_OnLevelBuilt` runs after every room is built and before `Link_SetStartingPos` puts the rooms to sleep (`with(all)` skips deactivated instances, and activating them again only takes effect in the next event). It writes the level and room structs, every instance with its plain variables and an MD5 of each tile layer per room; `Test_DumpGlobals` (after `Dungeon_InitLevel`) adds the plain global variables. Two runs of the same code give the same file, except the `Time_*` globals (wall clock), which are left out.
* The intro level (`Start`) cannot be rebuilt in the middle of a test: `oIntro` keeps running and crashes on instances of the old level. Its reference scenario only dumps the first build.
* `oCamera.SetToRoomIndex(room, true)` activates the new room and then deactivates the current one, so calling it for the room Link is already in puts Link and the room to sleep (the next frame crashes on `oLink`). `Test_PlaceLink` skips it for the same room.
* Scenario `"levels"` changes level sheet fields for that test only (`Test_ChangeLevels`, applied in `Test_Begin`), e.g. a branch no level has yet; step `exit` puts Link in front of the main or extra exit and walks into it; `expect` `"exit_level": true` checks that the level reached is the one that exit led to.
* Debug cheats that work outside tests too: `Test_GotoRoom(gridX, gridY)` (Link just inside one of the room's doors), `Test_SpawnEnemy(objectName, dist)` (in front of Link), `Test_GiveItem(class, index, amount)`.

## Level sheet (`scripts/__Levels`, roadmap F4)

* `global.LevelDefs[DungeonLevel.X]` is one struct per level, made by `Level_Create` (defaults of a normal dungeon level) and filled in `Levels_Init` (called in `INIT` right after `Enemies_InitData`). The macro `LevelDef` is the current level's entry (`global.LevelDefs[global.Level.Index]`). Each field has a comment in the constructor.
* `global.Level.Index` is still the key: it is saved with the run, the hub keeps it on Castle, and the stairs go to `Level_NextIndex()` (where the exit taken leads, else `LevelDef.Next`; see "Branched exits"). Only the sheet and the test mode compare it with `DungeonLevel` members.
* Three fields point at another level on purpose: `Theme` (whose art: `LevelTilesY` and every decoration rule written as `switch(LevelDef.Theme)` in `__Dungeon_Draw_*`, `__Decor`, `oCurtain`, `oWallLight`, `oWaterfall`), `BaseTheme` (`LevelTilesY_Base`: door frames, holes, floor trims, stairs; Agahnim borrows the fortress ones) and `EnemyStats` (the level whose stats the enemies with a per-level `Create` take). For today's levels they equal the level itself; a new level that reuses the castle art sets `Theme: DungeonLevel.Castle`.
* `Depth` is how far into the run the level is (1 = Hyrule Castle); difficulty formulas use it (pack points, chances, shop prices, Wallmaster, the HUD progress bar). Old "past the castle" checks are `LevelDef.Depth > Level_Depth(DungeonLevel.Castle)`.
* `Special` (`LevelSpecial`) marks the four levels with fixed layouts and code of their own (intro, village, mines, Agahnim); the rules that only make sense there (grid positions, houses, NPCs) check it.
* Enemies: `Enemies` lists `[object, weight]` (weight = tickets in the draw), `PackPoints` changes an enemy's pack points in that level (`{oEnemy_Rat: 1}`). `Level_EnemyWeight(object)` reads it; the room generator still walks the objects in index order, so the random draws are the same as with the old table.
* The constructor's field names must not match an enum, macro, function or asset name: `SecretDoor = SecretDoor.Crack` inside `with(struct)` is ambiguous, so the field is `SecretDoorType`.

## Branched exits (roadmap F4b)

* A level's exit is not a room: it is a door with `DoorStatus.Exit` in the top or bottom wall of a room, drawn as a stairway in the doorway; Link walking into it goes `Descending` (`CheckDoors` in `__Link`). Every layout in `data_d` has one exit room with three Exit doors (top, left, right before the transform); `Dungeon_InitLevel` keeps the one on the side `StartDir` asks for and marks the others `Unused`. That room is `RoomIndex_BossAdjacent` in every level; in boss levels its top door leads to the boss room instead, and the boss room's top door becomes the exit when the crystal is picked up. The room template class Stairs is unrelated: rooms with inner stairs between the upper and lower floor.
* Pools in the level sheet: `NextPool` (where exits lead, default `[[Next, 1]]`), `ExitCount`, `ExitHidden`, `ExitMinDistance`; `Level_PoolPick` draws from `[value, weight]` pairs and uses no random number for a single entry. `Dungeon_PlanExits` (right after the room structs, before the secret rooms and the templates) does nothing more unless `Level_Branches` (the pool has two different levels): so today's levels draw nothing and are built as before F4b (the 14 reference scenarios compare SAME).
* The extra exit is added to `Room.Doors` only (never to the layout's `DungeonRoom.Doors`), always as the last door, with `ExitDest` set; code that walks `Room.Doors` must not index `DungeonRoom.Doors` with the same index (the carpet code did; fixed). Where it goes: a 1-wide room with only upper-floor doors and no section, door position 12 (top middle) or 6 (bottom middle) with no room behind that wall, at least `ExitMinDistance` columns from the main exit room and on the other side of the map's middle column. Hidden: a special room with one door, made secret (`Dungeon_HideSpecialRoom`) and never with an Illusion wall (that one is walked through, not bombed). No candidate: hidden falls back to visible, then to one exit. If no room template has a door there, `Dungeon_DropExtraExit` takes it out and the template is picked again. Not in boss levels (it would skip the boss) nor in fixed layouts (`Special`).
* `global.Level.Exits` = `{Dest, ExtraRoom, ExtraPosition, ExtraSecret}`. `Door_ExitDest(oDoor)` is the level a door leads to (the door struct's `ExitDest`, else `Exits.Dest`; in the rest stop, `Level_NextIndex()`). Taking an exit stores it in `global.RunPath.Next`, which the End Step of `oLink` reads through `Level_NextIndex()` (falls back to `LevelDef.Next`); it lives through the rest stop and goes into the save (`SaveData.NextLevel`). `Dungeon_InitLevel` resets it. The intro still uses `LevelDef.Next` to enter the castle.
* Looks: `global.ExitLooks` (`ExitLooks_Init`, `__Doors`), named by the destination level's `ExitLook`. `Door_DrawTiles` draws the door sides and calls `Door_ExitLook(inst).Draw` for the beam and the doorway; the sound when Link goes down and the large map icon also come from the look. `StairsDown` is the old exit (beam 58, doorway 60 on top / 58 at the bottom); `StairsUp` is what the entrance of every level shows (ordinary beam 50, doorway 58 on top / 60 at the bottom, drawn by `oLink`'s End Step on arrival).
* To keep the reference dumps comparable, the new state lives in structs (`global.Level.Exits`, `global.RunPath`, `global.ExitLooks`) and in the door structs, not in plain globals or `oDoor` variables: the dumps skip structs.

## Enemies (`scripts/__Enemies`)

* `Enemies_InitData` registers every enemy with `EnemyDataInit(object, energy index, attack, special item, item, pack points, [weapon effects])`. Which levels it appears in, and how often, is in the level sheet (`Enemies`). An enemy object with no entry is never placed by the room generator (several exist: Delavant, Kyune, Lynel, Pirugusu, Soldier_Slasher).
* Energy index means hits to kill, through `global.EnemyHitsToKill[attack points][index]`. Attack points are `ATTACK()` = sword index + 1 + glove index (minus the curse). Damage to Link is `Attack` in hearts minus 0.25 per defense point, at least 1/8 (`Enemy_Attack`).
* Many enemies override the table's energy and attack in their own `Create`, by level: soldiers, Poe, Wizzrobe, Beamos (`switch(LevelDef.EnemyStats)`), and Bari, Bubble, Gibdo, Keese, Kodongo, Octorok, Ropa, SnapDragon (`Type` from a comparison with `LevelDef.EnemyStats`), Wallmaster (formula on `LevelDef.Depth`), Guru bars (`LevelDef.GuruBarType`). Fortress soldiers set theirs in `Step_1` from the random head. `docs/ref/doi.md` lists them all; check the object before trusting the table.
* Soldiers (`oEnemy_Soldier_Advanced`, `_Simple`, `_Mace`) only set up their weapon in the levels their `switch` lists; created anywhere else they crash (`Weapon not set`). Give a new level `EnemyStats` of a level that has them.
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
