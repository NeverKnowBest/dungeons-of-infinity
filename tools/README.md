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
| GameMaker | IDE 2024.13.1.193 / Runtime 2024.13.1.242 (Template Editor: 2023.11.0.121 / 2023.11.0.157). See the root README | Opening `game/` and the projects under `editors/` |
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
