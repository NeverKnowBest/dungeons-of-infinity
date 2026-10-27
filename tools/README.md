# External tools

These third-party tools were used during development. Their binaries are **not**
stored in this repo. Download them from the archives if you need them for any reason:

* Archive.org: https://archive.org/details/dungeons-of-infinity-src-1.2.1
* Personal Mirror: https://castie.ddns.net/zdoi/dungeons-of-infinity-1.2.1-src.zip

The full original tool folder (including binaries) is preserved in the project's
archived `.zip` backups.

Never commit ROMs (`.sfc`, `.smc`), save files or emulator states. `.gitignore`
blocks the common extensions.

## Needed to work on the project

| Tool | Version used | Used for |
|------|--------------|----------|
| GameMaker | IDE 2024.13.1.193 / Runtime 2024.13.1.242 (Template Editor: 2023.11.0.121 / 2023.11.0.157). See the root README | Opening `game/` and `editors/dungeon-editor`. Room templates are converted by `templates/convert.py` (the old GameMaker parser was retired in roadmap F5) |
| [Tiled](https://www.mapeditor.org/) | 1.11.2 | Editing room templates in `data/room-templates/` |
| Aseprite | n/a | Editing the `.aseprite` / `.ase` art sources in `art/` |
| xzip (xgasoft GameMaker extension) | 1.0.2 | Zip support in the game. Already imported into `game/`, so you only need it again to update the extension |

## Optional / historical

| Tool | Version used | Used for |
|------|--------------|----------|
| [Stockfish](https://stockfishchess.org/) | n/a | Chess engine for the village chess NPC. That NPC is currently disabled (see `game/datafiles/Change Log.txt`). The bridge scripts are in `stockfish-bridge/` |
| [AutoIt](https://www.autoitscript.com/) | n/a | Compiling `stockfish-bridge/*.au3` and `editors/dungeon-editor/WinOnTop.au3` |
| SNES GSS (SNES Game Sound System, by Shiru) | 1.42 | SNES-style music/sound experiments |
| SPCTool | n/a | Playing and ripping SPC music for reference |
| vSNES | 2.91 | Viewing SNES savestates to rip reference graphics |
| SNESTilesKitten | n/a | Viewing and editing SNES tile graphics |
| ZSNES | 1.51 | SNES emulator for reference play |
| [Lunar IPS](https://www.fusoya.eu/) | n/a | Applying IPS patches to reference ROMs |
| PaletteGenerator | 3.0.1 | Generating color palettes |
| Retro Palette Swapper | 1.0 | Palette-swapping sprites |

## `stockfish-bridge/`

Our own AutoIt scripts that let the game talk to `Stockfish.exe` over the UCI
protocol. The game writes command files (`Command`), and `SF.au3` relays them to
Stockfish and writes the responses back. `UCI notes.txt` has quick notes on the
protocol.

## Scripts added in this fork

### `check/` (Python 3, standard library only)

`validate.py` checks the project without GameMaker. Run it before every delivery:

```
python tools/check/validate.py            # report; exit code 1 on errors
python tools/check/validate.py --orphans  # list folders on disk that Zelda.yyp does not register
python tools/check/validate.py --strict   # warnings also fail
```

| Check | Level |
|-------|-------|
| Every resource in `Zelda.yyp` exists on disk (ignoring letter case, like Windows) | error |
| Resource path only matches ignoring letter case (breaks on Linux and macOS) | warning |
| Resource folder on disk that `Zelda.yyp` does not register (orphan) | warning |
| Asset name used by two resources | error |
| Object parent, sprite, mask and collision objects are in the project | error |
| Every event in an object's `eventList` has its `.gml` file | error |
| `.gml` file that is not an event of the object (never runs) | warning |
| Sprite frame images and sound files exist | error |
| Global function defined in two scripts | error |
| Asset style name (`sX`, `oX`, `Sound_X`, `Music_X`) used in GML that does not exist | warning (error if it only exists as an orphan) |
| Array literal starting with `#RRGGBB` | error |
| Lower case text drawn with `global.Font_Small` | warning |
| `a[i] = ...i++` (GML evaluates the right side first) | warning |
| Level rule on `global.Level.Index` (`switch`, comparison or formula) outside `__Levels` and `__Test`: read a `LevelDef` field instead | warning |
| Every included file in `Zelda.yyp` exists on disk | error |
| `data_d`, the room template files (`game/datafiles/data/rooms`) and the Tiled templates parse as JSON (LFS pointers are skipped) | error |
| The room template files match what `templates/convert.py` makes from the Tiled maps right now (adds about 10 s) | error |
| A data file over 45 MB (GitHub warns at 50 MB) | warning |
| Arrows or em dashes in the Portuguese docs (including `docs/ref/` and `docs/regioes/`) | warning |
| Region spec (`docs/regioes/*.md`) has every `##` section and every header field (`* **Capítulo:**`...) of `_modelo.md` and a valid `**Estado:**` | error |
| Every `ExitLook` the level sheet names is a look of `ExitLooks_Init` (`__Doors.gml`) | error |
| Region spec cites an asset (`oX`, `sX`, `Sound_X`, `Music_X` in backticks) that is not in `Zelda.yyp`, unless the line says "(novo)" | error |
| Reference sheet (`docs/ref/*.md`) cites an asset that is not in `Zelda.yyp` | warning |
| A cited `docs/...md` file does not exist | warning |
| Test scenario (`test/scenarios/*.json`) with an unknown step, key, cheat, enemy object or enum name | error |

When a new GML or data trap is found, add a check here.

### `test/` (Python 3, standard library only; needs GameMaker installed)

Automated test (roadmap F3): compiles the game with Igor, runs a scenario with nobody at the keyboard and prints the result as text. The game side is `game/scripts/__Test` (test mode) and the object `oTest`.

```
python tools/test/run.py smoke                       # a scenario in test/scenarios (or a path to a .json)
python tools/test/run.py smoke --no-build            # run the last build again (8 s instead of about 80 s); only when no GML changed
python tools/test/run.py --sheet Castle --seeds 4    # contact sheet: levels of seeds 1..4, every room in one PNG
python tools/test/run.py --sheet Sewers --seeds 7,9  # chosen seeds
python tools/test/run.py smoke --full                # also print the "step" lines of the log
```

* It finds the active runtime (`C:\ProgramData\GameMakerStudio2-LTS2026\runtime.json`) and the IDE user folder in `%APPDATA%` by itself, builds in `%TEMP%\doi-test` and passes the scenario through the environment variable `DOI_TEST` (the game also takes `-test <file>`). The file goes to `%LOCALAPPDATA%\Zelda\test\scenario.json`.
* Results are copied to `tools/test/out/` (ignored by git): `log.txt` and the PNGs. The script prints compile and runtime errors from the run output, the log, and `RESULT: ok` (exit code 0) when the log ends with `end ok` and has no `FAIL` line. `--timeout` (default 600 s) stops a run that hangs.
* The game window opens and runs by itself; it keeps going without focus and ignores the real keyboard. Sound is muted unless the scenario says `"sound": true`. Nothing is saved (user file, stats, achievements, options).
* `scenario.py` reads and checks scenarios; the validator uses it too.

Reference runs (roadmap F4): `baseline.py` runs every `scenarios/ref_*.json` (one per level: three builds of the level with `"dump": true`, the level's enemies with per-level stats in a `probe` step, a short walk, a contact sheet of seeds 2 and 3) and keeps the results under a label, so two versions of the code can be compared.

```
python tools/test/baseline.py save before                # compiles once and runs the 14 ref_* scenarios (about 15 min)
python tools/test/baseline.py save after --only Mines    # only the scenarios whose name contains "Mines"
python tools/test/baseline.py save after --no-build      # reuse the last build
python tools/test/baseline.py compare before after       # SAME, or every text line and image that differs
```

* Results go to `tools/test/baseline/<label>/<scenario>/` (ignored by git, about 60 MB per label). The same code gives the same files, so any difference is a change in behaviour (or in the dumped data: a renamed or removed global shows up too).
* A baseline of the code before a change can be made after the change too: `git worktree add --detach %TEMP%\doi-base HEAD`, copy the test tools in, `save before` there and copy `tools/test/baseline/before` back (see `docs/dev/receitas.md`, "Comparar antes e depois").
* `compare` shows pixel counts for images when Pillow is installed. It ignores the `step` lines of the log: they echo the scenario as GML writes it, and the key order changes between builds.
* F4 result, for reference: every file the same except three lines per dump, the globals `DungeonNames` and `Music_LevelSongIndex` (gone) and `LevelDefs` (new).
* F4b result: SAME in all 14 against the F4 baseline. A busy PC can make one `oMusic` line differ (`SongPlaying_Intro`, `SongPlaying_Inst`): the music intro ends on the real clock, so a slower run reaches the loop before the third build. Run that scenario again (`save <label> --only ref_01 --no-build`) with nothing else running before calling it a change.

Scenario format (JSON). Strings like `"Swords.Master"` become the GML enum value; `level` and `item` also take a bare name (`"Sewers"`, `"Shield"`).

| Key | Meaning |
|-----|---------|
| `name` | Name in the log |
| `seed` | Random seed (default 1). The same scenario on the same code always plays the same way |
| `level` | First level (`DungeonLevel` name, default `Castle`), or `"Hub"` for the Sanctuary |
| `cheats` | Cheat keys of `global.CheatList` turned on (`"Cheat_Inf_Health"`...) |
| `items` | Items given at the start: `{"item": "Sword", "index": "Swords.Master", "amount": 1}` |
| `max_frames` | The test fails with `timeout` after this many frames (default 36000) |
| `speed` | Frames per second (default 60) |
| `sound` | `true` to hear it |
| `dump` | `true`: every level built writes `dump_<n>_<level>_s<seed>.txt` (level and room structs, instances with their variables, MD5 of each tile layer per room, globals). For comparing two versions of the code |
| `levels` | Temporary changes to the level sheet for this test only: `{"Castle": {"NextPool": [["CastleBasement", 1], ["Catacombs", 1]]}, "Catacombs": {"ExitLook": "StairsUp"}}`. Field names are checked against `Level_Create`, `NextPool` takes level names, `ExitLook` a look of `ExitLooks_Init`. For trying a branch of the run that no level has yet (`scenarios/branch_exits.json`) |
| `steps` | List of steps, run in order (below) |

| Step | Keys | What it does |
|------|------|--------------|
| `wait` | `frames` | Waits |
| `hold` | `keys` (list), `frames` | Holds the keys together. Keys: `up down left right sword action item map strafe inventory menu_access hud` |
| `press` | `key`, `frames` (default 8) | Holds one key, then releases it for 4 frames |
| `shot` | `name` | Screenshot of the game view at 1x (256x224, no HUD) to `<name>.png` |
| `room` | `x`, `y` | Moves Link into the room at that grid position (0..7), just inside one of its doors |
| `level` | `level`, `seed` | Builds a level (the next level of a run normally comes through the stairs) |
| `spawn` | `enemy`, `dist` (default 48) | Creates an enemy object (`oEnemy_Rat`) in front of Link |
| `probe` | `enemies` (list), `dist` | Creates each enemy in front of Link, logs a `probe` line with its variables (energy, attack, `Type`...) and removes it. Only enemies that exist in that level: soldiers crash elsewhere |
| `give` | `item`, `index`, `amount` | Gives an item |
| `state` | | Logs level, room, Link's position and health, enemies and kills |
| `log` | `text` | Writes a note in the log |
| `expect` | `alive`, `level`, `room` (`[x, y]`), `enemies`, `kills_min`, `exit_level` | Checks; a mismatch is a `FAIL` line. `"exit_level": true`: the current level is the one the last `exit` step's door leads to (not the rest stop) |
| `exit` | `which` (`main` or `extra`), `frames` (default 60) | Puts Link 40 px in front of the level's main or extra exit (roadmap F4b) and walks into it for `frames`. Fails if there is no such exit |
| `sheet` | `level`, `seeds` | Contact sheet (what `--sheet` runs): `sheet_<level>_<seed>.png` per seed and `sheet_<level>.png` with all of them at half size |
| `end` | | Ends the test (it also ends after the last step) |

Log lines start with the frame (`f152`): `start`, `level <index> "<name>" rooms= dungeon=`, `room <index> grid= size= template=<class>/<subclass>/<name>#<id>`, `kill <object>`, `damage`, `dead`, `boss defeated`, `shot`, `dump <file>`, `probe <object> ...`, `state`, `expect ok`, `levels <index> "<name>" <field>=<value>` (scenario changes), `exits main-><level> count=1|2 extra=room <n> grid= Top|Bottom [secret]-><level> main=room <n> grid=` (only in levels whose exits can lead to more than one level), `exit main|extra room= -> level <n>`, `FAIL ...`, `crash ...` (a GML error, with the stack) and last `end ok|timeout|crash|error`.

### `templates/` (Python 3, standard library only)

Room template conversion, ported from the old GameMaker project `editors/room-template-parser` (retired in roadmap F5; it is in the git history):

```
python tools/templates/convert.py                  # Tiled maps in data/room-templates -> game/datafiles/data/rooms/<Class>.json
python tools/templates/convert.py -o out/rooms     # write somewhere else
python tools/templates/convert.py --summary        # also print the template count per class and subclass
python tools/templates/compare.py OLD NEW          # compare two rooms folders (or old data_r files) by content (exit code 1 if they differ)
```

| File | What it does |
|------|--------------|
| `convert.py` | Reads the ten `Room Templates <Class>.json` maps, makes positions relative to each room, joins the Main Upper/Lower halves, computes door and zone codes and writes one file per class, one template per line (about 10 s). How the data works: `docs/dev/engine-notes.md`, "Room templates" |
| `rt_tables.py` | Transform tables (gid, door position, section id, rotation, pot and switch block directions), generated once from the GML `GetTransformed*` functions. Gid names resolve through the `TemplateObjGID` enum in the game's `__RoomTemplates.gml` |
| `compare.py` | Content comparison of two sets of room templates (a rooms folder or an old single file `data_r`), ignoring key order and int versus float. Template order inside a subclass counts (it changes what a seed builds) |

The output was checked equal to the last `data_r` written by the GameMaker parser (roadmap F5). The room files are plain git, not LFS, so `git diff` shows which templates changed (one line each).

### `hub/` (Python 3, Pillow, numpy)

Builds the Sanctuary hub: room pictures, sprites, objects and data. Paths are relative to the repo, so run them from anywhere.

| Script | What it does |
|--------|--------------|
| `gm_assets.py` | Writes GameMaker 2024 sprites (multi frame, fps, origin), sounds and objects, and registers them in `Zelda.yyp`. Re-running a sprite keeps its frame ids, so files overwrite in place |
| `tiledjson.py` | Serializes objects the way Tiled writes `data/room-templates/*.json` |
| `gids.py` | Tiled gid of each template object type, read from `__RoomTemplates.gml` |
| `build2.py` | Shared helpers: load/save `data_d`, remove objects from the Tiled map, rebuild the room templates (`room_templates()`, calls `templates/convert.py`) |
| `build3.py` | Writes the hub rooms (Sanctuary 2x2, Hall of Fame 2x1) into the Tiled map (Other/Unique templates), rebuilds the room templates from it and writes `data_d` (Special template 5). Edit `ROOMS` to add a room or an NPC. Re-running gives the hub rooms new Tiled ids (harmless) |
| `festive_draw.py` | The Flute Boy's counter decor over `sanct_base4.png` (writes `sanct_base6.png`) |
| `build_pics.py` | Church picture with the side door (`church_base.png`) |
| `build_hall3.py` | Hall of Fame picture (`hall3_base.png`) |
| `statues.py` | Statue figures and pedestals (metal recolor of boss sprites, silhouettes) |
| `z3room.py`, `objrender.py` | Render a zelda3 room dump (BG layers, animated tiles) and OBJ tiles |
| `loopfind.py`, `envloop.py` | Find loop points in rendered SPC music |

Order for the hub pictures: `festive_draw.py`, `build_pics.py`, `build_hall3.py`, `statues.py`, then copy the PNGs into the sprites with `gm_assets.sprite(...)`. Previews go to `hub/preview/` (ignored by git).

`data_d` is a Git LFS file. Make sure the real file is checked out (`git lfs pull`) before running `build3.py`. Install the dependencies with `python -m pip install --user pillow numpy`.

### `alttp/` (C, needs the zelda3 source and your own ROM)

Small harnesses compiled against [zelda3](https://github.com/snesrev/zelda3) (the C reimplementation of ALttP). They load the game's assets (`zelda3_assets.dat`, built from your ROM by zelda3's own asset script) and dump data:

| File | Dumps |
|------|-------|
| `roomdump.c` | A dungeon room: VRAM, palettes, BG1/BG2 tilemaps and tile attributes (render it with `hub/z3room.py`). `ANIMFRAME=n` copies animated tile frame n first |
| `sprdump.c` | OBJ VRAM and palettes of an overworld area, plus sprite OAM flags (for extracting NPC sprites) |
| `musicdump.c` | A song rendered to PCM through the SPC emulator (`TRACE=1` prints the song pointer) |
| `entm.c` | The entrance to music table |

Build them like zelda3's own `main.c`: compile the file together with zelda3's `src/*.c` and `snes/*.c` (minus `src/main.c`), with zelda3's include paths.
