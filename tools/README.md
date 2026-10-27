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
| Every included file in `Zelda.yyp` exists on disk | error |
| `data_d`, the room template files (`game/datafiles/data/rooms`) and the Tiled templates parse as JSON (LFS pointers are skipped) | error |
| The room template files match what `templates/convert.py` makes from the Tiled maps right now (adds about 10 s) | error |
| A data file over 45 MB (GitHub warns at 50 MB) | warning |
| Arrows or em dashes in the Portuguese docs (including `docs/ref/` and `docs/regioes/`) | warning |
| Region spec (`docs/regioes/*.md`) has every `##` section of `_modelo.md` and a valid `**Estado:**` | error |
| Region spec cites an asset (`oX`, `sX`, `Sound_X`, `Music_X` in backticks) that is not in `Zelda.yyp`, unless the line says "(novo)" | error |
| Reference sheet (`docs/ref/*.md`) cites an asset that is not in `Zelda.yyp` | warning |
| A cited `docs/...md` file does not exist | warning |

When a new GML or data trap is found, add a check here.

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
