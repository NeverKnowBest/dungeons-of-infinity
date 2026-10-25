<p align="center">
  <img src="docs/readme/title.gif" alt="Zelda: Dungeons of Infinity title screen" width="512">
</p>

<h1 align="center">Zelda: Dungeons of Infinity</h1>

<p align="center">
  <b>A roguelike in Hyrule.</b> Every run, a new dungeon.<br>
  Source code and development assets for Dungeons of Infinity and its editors,<br>
  originally developed by Justin Bohemier and maintained by the fan community.
</p>

<p align="center">
  <a href="https://discord.gg/2FY2G63VXa">ZDOI Discord</a> ·
  <a href="https://archive.org/details/dungeons-of-infinity-src-1.2.1">Original 1.2.1 source</a> ·
  <a href="#license">License</a>
</p>

---

## About

Dungeons of Infinity is a fan made roguelike built on the look and feel of
*A Link to the Past*. Each run is a chain of randomly generated dungeon floors
assembled from hand made room templates, with enemies, items, shops, villages
and bosses that change from run to run.

This fork continues the 1.2.1 source with bug fixes and new content.

<table>
  <tr>
    <td><img src="docs/screenshots/Zelda%20Dungeons%20of%20Infinity%206.jpg" alt="Water temple"></td>
    <td><img src="docs/screenshots/Zelda%20Dungeons%20of%20Infinity%207.jpg" alt="Inventory"></td>
    <td><img src="docs/screenshots/Zelda%20Dungeons%20of%20Infinity%203.jpeg" alt="Castle"></td>
  </tr>
</table>

## Features

* Procedurally generated floors built from room templates
* Areas from the castle and its jails to catacombs, sewers, ruins, mines and the water temple
* Bosses: Armos Knights, Lanmola, Moldorm and Agahnim
* Classic items, upgrades, shops and villages between dungeons
* Multiple save slots, a cheats menu and an in game map

## Running from source

1. Install GameMaker **2024.13.1** (older builds are at https://releases.gamemaker.io/).
2. Clone this repo with Git LFS enabled (`git lfs install` before cloning), so room data and images download properly.
3. Open `game/Zelda.yyp` and run it.

## Changes in this fork

* Fixed noise in the minimap on unexplored rooms after picking up the map
* Fixed the crash when saving the cheats menu before starting a run
* Fixed the dungeon map turning empty with cheats on
* New: the Sanctuary hub. Every run starts in the Sanctuary, with its original look and music

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

## GameMaker versions

These are the versions each project was last saved and built with (taken from
each `.yyp` file's `MetaData.IDEVersion`; runtime pairings from GameMaker's
release feed), documented as v1.2.1/stable for preservation.

| Project | IDE | Runtime | Last shipped build |
|---------|-----|---------|--------------------|
| `game/Zelda.yyp` | 2024.13.1.193 | 2024.13.1.242 | v1.2.1.0 (Windows) |
| `editors/dungeon-editor/Dungeon Editor.yyp` | 2024.13.1.193 | 2024.13.1.242 | Windows, VM |
| `editors/room-template-parser/Room Templates.yyp` | 2024.13.1.193 | 2024.13.1.242 | Windows, VM |
| `editors/template-editor/Template Editor.yyp` | 2023.11.0.121 | 2023.11.0.157 | Windows, VM |

## Original archives

The original 1.2.1 source is also hosted here:

* Archive.org: https://archive.org/details/dungeons-of-infinity-src-1.2.1
* Personal mirror: https://castie.ddns.net/zdoi/dungeons-of-infinity-1.2.1-src.zip

## License

Dungeons of Infinity is a non commercial fan project, released under
[CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/).
Original game by **Justin Bohemier**; maintained by the ZDOI community.
*The Legend of Zelda* and all related names and characters are trademarks of
Nintendo. This project is not affiliated with or endorsed by Nintendo.
