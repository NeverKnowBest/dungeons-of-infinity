# Zelda: Dungeons of Infinity

Source code and development assets for Dungeons of Infinity and its editors, all developed originally by Justin Bohemier and maintained by the fan community.

# ZDOI Discord Server
https://discord.gg/2FY2G63VXa

## Layout

```
game/                      GameMaker project for the game (Zelda.yyp)
editors/
  dungeon-editor/          GameMaker project: edits dungeon layouts (data_d)
  template-editor/         GameMaker project: older room template editor
  room-template-parser/    GameMaker project: converts Tiled JSON to data_r
data/
  room-templates/          Tiled room template maps (*.json) + "Tiled Objects" images
  sample-saves/            Example save/user data for testing
art/                       Art sources (Aseprite files, tileset, title screen, characters, misc)
docs/                      Game manual sources, design diagrams, screenshots, reference material
tools/                     List of external tools (binaries not included)
```

# Original Archives
The original version of this repo is separately hosted at the sites below, if you need them for any reason:

* Archive.org: https://archive.org/details/dungeons-of-infinity-src-1.2.1
* Personal Mirror: https://castie.ddns.net/zdoi/dungeons-of-infinity-1.2.1-src.zip

## GameMaker versions

These are the versions each project was last saved and built with (taken from
each `.yyp` file's `MetaData.IDEVersion`; runtime pairings from GameMaker's
release feed). For preservation purposes, I'm documenting them as v1.2.1/stable before we update and maintain the main branch.

| Project | IDE | Runtime | Last shipped build |
|---------|-----|---------|--------------------|
| `game/Zelda.yyp` | 2024.13.1.193 | 2024.13.1.242 | v1.2.1.0 (Windows) |
| `editors/dungeon-editor/Dungeon Editor.yyp` | 2024.13.1.193 | 2024.13.1.242 | Windows, VM |
| `editors/room-template-parser/Room Templates.yyp` | 2024.13.1.193 | 2024.13.1.242 | Windows, VM |
| `editors/template-editor/Template Editor.yyp` | 2023.11.0.121 | 2023.11.0.157 | Windows, VM |

Older versions of Game Maker can be downloaded from https://releases.gamemaker.io/.
