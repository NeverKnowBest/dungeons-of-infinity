# Engine notes

Working notes on how the Dungeons of Infinity engine is put together, kept so that new work (and new sessions) can start fast.

## Levels and rooms

* A level is a grid of rooms. Layouts live in `game/datafiles/data/data_d` (dungeon templates, by class; the Special class holds fixed layouts such as the save tent and the Sanctuary hub at index 5).
* Each room uses a room template from `game/datafiles/data/data_r`, exported from the Tiled maps in `data/room-templates/`. Class Other = 9, subclass Unique = 2 holds hand made rooms like `Sanctuary`.
* Rooms are made of 256px quadrants: a 2x2 room is 512x512. Template object coordinates are relative to the room's top left corner.
* Collision is only `oWall` instances, created with `WallObj_Create(layer, x, y, tilesW, tilesH)` (8px tiles).
* Instance layers by depth: `ObjsHigher_Upper` 400, `Objs_Upper` 600, `ObjsDoors_Upper` 700, `ObjsFloor_Upper` 800, tile floors 1400. Anything drawn with `PixelRender_Normal()` needs a `FloorLevel` variable.
* `data_r` and `data_d` are stored with Git LFS.

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

## Achievements (`scripts/__Achievements`)

* `global.AchievementList` entries: `Key`, `Statue`, `Name`, `Desc`, `Skin` reward, `Gear` reward. Statues (bronze, silver, gold) group them and are revealed when all of theirs are done.
* Saved per user in `User.Achievements` (struct of keys), plus `User.Skin` and `User.BonusItem`.
* Hooks: `Achievements_OnLevelStart` (Dungeon_InitLevel), `Achievements_OnBossDefeated` (crystal pickup in oLink Step), `Achievements_OnGameWon` (oBoss_Aghanim), `Achievements_CheckStats` (end of `User_UpdateStats`). Nothing unlocks while cheats are on.

## Assets from A Link to the Past

Room pictures, sprites and music were taken from the original game with small harnesses built on the zelda3 reimplementation (room render with animated tiles, sprite OAM dump, SPC music render). Music is split into an intro and a loop (`Music_Sanctuary_Intro`, `Music_Sanctuary_Main`).
