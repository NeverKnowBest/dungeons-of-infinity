# Dungeons of Infinity (o que já existe)

Fonte: código do jogo neste repositório (out/2026). A tabela principal é `Enemies_InitData` em `game/scripts/__Enemies/__Enemies.gml`; as velocidades vêm do `Create` de cada objeto. Para os números do original, veja `alttp.md`.

## Como o DoI mede as coisas

* **Energia:** cada inimigo tem um índice de energia (0 a 14). O índice diz quantos golpes de espada ele aguenta, pela tabela `global.EnemyHitsToKill[pontos de ataque][índice]` (veja abaixo). A maldição "Tough Enemies" soma 1 ao índice (exceto 13 e 14).
* **Ataque:** dano ao Link em corações. A defesa da túnica tira 1/4 de coração por ponto, com mínimo de 1/8 (`Enemy_Attack`). A maldição "Tough Enemies" multiplica por 1.5.
* **Pack points:** custo do inimigo na hora de povoar uma sala. Cada sala recebe um orçamento que cresce com o nível e o tamanho da sala; inimigos maiores gastam mais.
* **Peso por nível:** quantas cópias do inimigo entram no sorteio daquele nível (0 = não aparece). Torres de parede (Beamos, canhão, Medusa) são sorteadas à parte, nas paredes.
* **Efeito por arma:** cada inimigo tem um efeito para espada, pote, flecha, bumerangue, gancho, bomba, fogo, gelo, raio da espada, pedra e transformação: dano (número), sem dano, atordoar, empurrar, congelar, queimar, petrificar, transformar ou uma função própria (`H_FF`).

### Golpes para matar, por pontos de ataque

Pontos de ataque = espada (Basic 1, Steel 2, Long 3, Dragon 4, Blood 5, Master 6) + luvas (0 a 2), menos 1 com a maldição "Attack Reduced" (`ATTACK()` em `__Link.gml`). Linhas de `global.EnemyHitsToKill`:

| Ataque | Índice 0 e 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 |
|--------|--------------|---|---|---|---|---|---|---|---|----|----|----|----|
| 1 | 1 e 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 10 | 14 | 18 | 24 |
| 2 | 1 e 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 9 | 13 | 16 | 22 |
| 3 | 1 e 1 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 8 | 12 | 15 | 20 |
| 4 | 1 e 1 | 1 | 2 | 3 | 3 | 4 | 5 | 6 | 7 | 7 | 10 | 14 | 18 |
| 5 | 1 e 1 | 1 | 1 | 2 | 3 | 3 | 4 | 5 | 6 | 6 | 9 | 13 | 16 |
| 6 | 1 e 1 | 1 | 1 | 2 | 2 | 3 | 3 | 4 | 5 | 5 | 8 | 12 | 15 |
| 7 | 1 e 1 | 1 | 1 | 1 | 2 | 2 | 3 | 3 | 4 | 4 | 7 | 11 | 14 |
| 8 | 1 e 1 | 1 | 1 | 1 | 1 | 2 | 2 | 2 | 3 | 3 | 6 | 10 | 13 |

O índice 14 não morre. O golpe giratório dobra o dano da espada (1.5 contra chefes). Flecha: efeito da tabela + ataque / 2.5 (arredondado para baixo). Bomba: sempre 4. Outras armas com dano: efeito + 0.25 por ponto de ataque acima de 1. O raio da espada usa o ataque menos 2.

Os índices 10, 11 e 12 são dos chefes, o 13 é do Moldorm com a maldição e o 14 é para o que não morre (galinha).

## Níveis

| Índice | `DungeonLevel` | Nome no jogo | Classe de dungeon | Música | Chefe |
|--------|----------------|--------------|-------------------|--------|-------|
| 0 | `Start` | Destroy Agahnim (entrada com chuva) | Special 0 | `Start` | |
| 1 | `Castle` | Hyrule Castle | `Castle` | `Castle` | |
| 2 | `CastleBasement` | Castle Basement | `CastleBasement` | `Castle` | |
| 3 | `CastleJails` | Castle Prison | `CastleJails` | `Castle` | Armos |
| 4 | `Catacombs` | Catacombs | `CatacombsSewers` | `Dungeon1` | |
| 5 | `Sewers` | Sewers | `CatacombsSewers` | `Dungeon1` | |
| 6 | `Village` | Rebel Village | Special 2 | `Village_Cave` | |
| 7 | `LanmolasLair` | Lanmola's Lair | `BossesRuins` | `Dungeon2` | Lanmola |
| 8 | `Ruins` | Ancient Ruins | `BossesRuins` | `Dungeon1` | |
| 9 | `WaterTemple` | Water Temple | `BossesRuins` | `Dungeon1` | |
| 10 | `Mines` | Dwarven Mining Town | Special 3 | `Mines` | |
| 11 | `MoldormsLair` | Moldorm's Lair | `BossesRuins` | `Dungeon2` | Moldorm |
| 12 | `Aghanim1` | Agahnim's Fortress | `Aghanim` | `Dungeon3` | |
| 13 | `Aghanim2` | Agahnim | Special 1 | `Boss_Final_Hallway` | Agahnim |

Nomes em `__Init.gml` (`global.DungeonNames`), classes em `Dungeon_PickClass`, músicas em `global.Music_LevelSongIndex` (`__Music.gml`), chefes em `Dungeon_IsBossLevel`. No roadmap, "nível 2" é o castelo (o nível 1 é a entrada).

## Inimigos

Velocidade em px por quadro. "Golpes" é com ataque 1 (espada Basic, sem luvas). "Por nível" quer dizer que o objeto troca os valores da tabela no próprio `Create`; veja "Variantes por nível" logo abaixo.

| Objeto | Energia | Golpes | Ataque | Velocidade | No ALttP (id) | Arquétipo | Onde aparece (peso) |
|--------|---------|--------|--------|------------|---------------|-----------|---------------------|
| `oEnemy_Bubble` | 0 | 1 | 1.25 ou 2.25 | 1 a 1.25 | Antifada, 15 | Armadilha | Lanmola 2, Ruínas 1, Templo da Água 1, Moldorm 1, Fortaleza 1 |
| `oEnemy_Buzz` | 0 | 1 | 0.75 | pulo 2.25, anda 1.5 | sem equivalente | Saltador pequeno | Esgotos 1, Lanmola 2, Ruínas 1 |
| `oEnemy_Hoarder` | 0 | 1 | 1.25 | 0.8 | Hoarder, 17 | Foge | Lanmola 1, Ruínas 2, Moldorm 3 |
| `oEnemy_Hover` | 0 | 1 | 1.5 | 2 (desacelera) | Hover, 81 | Voador | Esgotos 3, Templo da Água 2 |
| `oEnemy_Keese` | 0 | 1 | 0.25 ou 1.5 | 1 | Keese, 6F | Voador | Porão 1, Prisão 1, Catacumbas 2, Esgotos 1, Ruínas 2, Templo da Água 2 |
| `oEnemy_Kyameron_Moving` | 0 | 1 | 0.75 | 1.5 | Kyameron, 9A | Armadilha | criado pelo `oEnemy_Kyameron_Emitter` |
| `oEnemy_Poe` | por nível | 1, 4 ou 7 (Catacumbas, outros, Fortaleza) | 1, 1.5 ou 2 |  | Poe, 19 | Voador | Catacumbas 2, Ruínas 2, Templo da Água 1, Fortaleza 2 |
| `oEnemy_Rat` | 0 | 1 | 0.25 | 1.5 | Rato, 6D | Andarilho | Porão 2, Prisão 1, Catacumbas 1, Esgotos 2, Ruínas 1 |
| `oEnemy_Rope` | 1 | 2 | 0.5 | 0.75, investida 1.25 | Rope, 6E | Investida | Porão 1, Prisão 1, Catacumbas 1, Esgotos 1 |
| `oEnemy_Bari` | por nível | 4 ou 6 | 1.25 ou 2.25 | 0.25 a 0.65 | Bari, 23 e 24 | Voador e divisor | Esgotos 2, Templo da Água 1, Fortaleza 2 |
| `oEnemy_Zol` | 2 | 3 | 1.25 |  | Zol, 8F | Emboscada e saltador | Esgotos 2, Templo da Água 1 |
| `oEnemy_BuzzBlob` | 3 | 4 | 1.25 | 0.15 | Buzzblob, 0D | Andarilho | Esgotos 1, Lanmola 1, Ruínas 1, Moldorm 1 |
| `oEnemy_Pikit` | 3 | 4 | 1.25 | 0.75 a 1.25, pulo 1.5 | Pikit, AA | Saltador | Esgotos 2, Lanmola 1 |
| `oEnemy_Popo` | 3 | 4 | 1.5 | até 0.4 | Popo, 4E | Andarilho | Esgotos 3 |
| `oEnemy_Skeleton` | 3 | 4 | 1 | 1, pulo 2.5 | Stalfos, A7 | Saltador | Catacumbas 2 |
| `oEnemy_Crab` | 4 | 5 | 1.25 | 0.5 | Caranguejo, 58 | Andarilho | Esgotos 2, Lanmola 1 |
| `oEnemy_Gibdo` | por nível | 5 ou 7 | 1.25 ou 2.25 | 0.75 a 1 | Gibdo, 8B | Perseguidor | Catacumbas 2, Lanmola 3 |
| `oEnemy_Helmasaur` | 4 | 5 | 1.5 | 1 | Mini Helmasaur, 13 | Investida, blindado | Ruínas 2 |
| `oEnemy_Kodongo` | por nível | 5 ou 7 | 1.75 ou 2.5 | 1 a 1.25 | Kodongo, 86 | Andarilho e atirador | Ruínas 2, Moldorm 3, Fortaleza 1 |
| `oEnemy_Leever` | 4 | 5 | 1.75 |  | Leever, 71 | Emboscada | Lanmola 2 |
| `oEnemy_Moldorm` | 4 | 5 | 2 | 1.5 | Mini Moldorm, 18 | Andarilho | Moldorm 4 |
| `oEnemy_Octorok` | por nível | 5 ou 6 | 1.5 ou 2 | 1.5 a 1.75 | Octorok, 08 | Andarilho e atirador | Lanmola 2, Moldorm 2 |
| `oEnemy_Ropa` | por nível | 5 ou 7 | 1.75 ou 2.5 |  | Ropa, 22 | Saltador | Lanmola 2, Moldorm 3, Fortaleza 1 |
| `oEnemy_Wizzrobe` | por nível | 5 ou 6 (Templo da Água, Fortaleza) | 2.5 ou 3 |  | Wizzrobe, 9B | Atirador | Templo da Água 3, Fortaleza 2 |
| `oEnemy_HardhatBeetle` | 5 | 6 | 2.25 | 0.5 | Hardhat Beetle, 26 | Andarilho | Templo da Água 3 |
| `oEnemy_SnapDragon` | por nível | 6 ou 8 | 2 ou 2.75 | 0.75 a 1, pulo 2.5 | Snapdragon, 0E | Saltador | Lanmola 1, Fortaleza 2 |
| `oEnemy_Geldman` | 5 | 6 | 2 | 1.25 | Geldman, 4C | Emboscada | Lanmola 2 |
| `oEnemy_Goriya` | 6 | 7 | 2.5 | 1 | Goriya (LoZ, LA) | Atirador (bumerangue) | Ruínas 3 |
| `oEnemy_Zirro` | 6 | 7 | 2.25 | 0.75 | Zirro, A8 e A9 | Voador | Ruínas 2, Fortaleza 1 |
| `oEnemy_Zazak` | 6 | 7 | 2.75 | 0.75 | Zazak, A5 e A6 | Andarilho e atirador | Templo da Água 2 |
| `oEnemy_Eyegore` | 7 | 8 | 3 | 1 | Eyegore, 83 e 84 | Blindado | Templo da Água 3 |
| `oEnemy_Tektite` | 8 | 9 | 3 | 1.2 | Tektite, C9 | Saltador | Moldorm 2, Fortaleza 2 |
| `oEnemy_Armos` | 9 | 10 | 3.5 | 0.75 | Estátua Armos, 51 | Emboscada | Fortaleza 3 |
| `oEnemy_Hinox` | 9 | 10 | 3.75 | 0.5, corre 1 | Hinox, 11 | Andarilho e atirador | Fortaleza 5 |
| `oEnemy_Beamos` | 0 | 1 | 2, 2.75 ou 3.5 (por nível) |  | Beamos, 61 | Torre | Lanmola 3, Ruínas 3, Templo da Água 3, Fortaleza 4 |
| `oEnemy_Cannon` | 0 | 1 | 0 |  | Canhão, 66 | Torre | Esgotos 1, Lanmola 1, Ruínas 1, Templo da Água 1, Moldorm 1, Fortaleza 1 |
| `oEnemy_Guru` | 0 | 1 | 1.5 a 3.25 |  | Firebar, 7E | Armadilha | criado pelo `oEnemy_Guru_Bar` (as bolas da barra) |
| `oEnemy_Guru_Bar` | 0 | 1 | do `oEnemy_Guru` |  | Firebar, 7E | Armadilha | Catacumbas 1, Lanmola 1, Ruínas 1, Templo da Água 2, Moldorm 1, Fortaleza 1 |
| `oEnemy_Kyameron_Emitter` | 0 | 1 | 0 |  | Kyameron, 9A | Armadilha (gera gotas) | Esgotos 2, Templo da Água 2 |
| `oEnemy_Medusa` | 0 | 1 | 0 |  | Medusa, C5 | Torre | Lanmola 2, Ruínas 1, Templo da Água 1, Moldorm 1, Fortaleza 1 |
| `oEnemy_RollingSpike` | 0 | 1 | 2 | 1 | Roller, 5D | Armadilha | Lanmola 1, Ruínas 1, Templo da Água 1, Moldorm 1, Fortaleza 1 |
| `oEnemy_MovingSpikeBlock` | 0 | 1 | 2 | 2.5 | Spike Block, 8A | Armadilha | Lanmola 1, Ruínas 1, Templo da Água 1, Moldorm 1, Fortaleza 1 |
| `oEnemy_Soldier_Advanced` | por nível | 3 a 10 (tabela abaixo) | por nível | 0.5, corre 1 | Soldado azul e vermelho, 41 e 43 | Patrulheiro e perseguidor | Castelo 2, Porão 3, Prisão 3, Catacumbas 2, Templo da Água 2, Fortaleza 5 |
| `oEnemy_Soldier_Simple` | por nível | 2 ou 3 (tabela abaixo) | 0.5 | 0.5, corre 1 | Soldado verde, 42 | Patrulheiro | Castelo 3, Porão 3, Prisão 2 |
| `oEnemy_Soldier_Mace` | por nível | 5 ou 10 (tabela abaixo) | 1 ou 3.25 | 0.75 | Ball and Chain, 6A | Perseguidor | Prisão 1, Fortaleza 2 |
| `oEnemy_Chicken` | 14 | não morre | 0 | 0.75, corre 1.25 | Cucco, 0B | Andarilho | salas especiais (`__Dungeon_Draw_SpecialObjs_Forced`) |
| `oEnemy_FootSoldier` | 14 | não morre | 0 |  | sem equivalente | Parado, não machuca (`CanHurtLink = false`) | salas especiais (`__Dungeon_Draw_SpecialObjs_Forced`) |
| `oEnemy_Wallmaster` | 14 | não morre | 0.25 + 0.25 por nível | ataque 1.5 | Wallmaster, 90 | Emboscada | só com o desafio WallMaster: aparece junto do Link no começo de cada nível (menos entrada, vila, minas e Agahnim) |

### Variantes por nível

Estes objetos ignoram a energia e o ataque de `EnemyDataInit` (ou só o ataque) e escolhem pelo nível, no `Create` (variável `Type`). Os níveis estão em ordem de índice: "a partir de" inclui o próprio nível.

| Objeto | Regra | Variante 0: energia (golpes), ataque | Variante 1 |
|--------|-------|--------------------------------------|------------|
| `oEnemy_Bari` | 1 na Fortaleza | azul: 3 (4), 1.25 | vermelho: 5 (6), 2.25 |
| `oEnemy_Bubble` | 1 a partir de Moldorm | 0 (1), 1.25 | 0 (1), 2.25 |
| `oEnemy_Gibdo` | 1 a partir de Lanmola | 4 (5), 1.25 | 6 (7), 2.25 |
| `oEnemy_Keese` | 1 depois de Ruínas | 0 (1), 0.25 | 0 (1), 1.5 |
| `oEnemy_Kodongo` | 1 depois de Ruínas | 4 (5), 1.75 | 6 (7), 2.5 |
| `oEnemy_Octorok` | 1 depois de Lanmola | 4 (5), 1.5 | 5 (6), 2 |
| `oEnemy_Ropa` | 1 a partir de Moldorm | 4 (5), 1.75 | 6 (7), 2.5 |
| `oEnemy_SnapDragon` | 1 depois de Lanmola | 5 (6), 2 | 7 (8), 2.75 |
| `oEnemy_Guru` | `Gurus_GetType()`: 1 no Templo da Água, 2 em Moldorm e Fortaleza | ataque 1.5 | ataque 2.5 (tipo 1), 3.25 (tipo 2) |
| `oEnemy_Poe` | por nível | Catacumbas: 0 (1), 1 | outros: 3 (4), 1.5; Fortaleza: 6 (7), 2 |
| `oEnemy_Wizzrobe` | por nível | Templo da Água: 4 (5), 2.5 | Fortaleza: 5 (6), 3 |
| `oEnemy_Beamos` | por nível | ataque 2 | Templo da Água 2.75, Fortaleza 3.5 |
| `oEnemy_Wallmaster` | conta | ataque 0.25 + 0.25 x índice do nível | |

### Soldados por nível

Os soldados escolhem cor, energia e ataque pelo nível, no `Create` do objeto (os da Fortaleza, pela cabeça sorteada, no `Step_1`). Outros inimigos que mudam por nível estão na tabela acima.

| Objeto | Nível | Cor | Energia (golpes) | Ataque |
|--------|-------|-----|------------------|--------|
| `oEnemy_Soldier_Simple` | Castelo, Porão | verde, azul | 1 (2) | 0.5 |
| `oEnemy_Soldier_Simple` | Prisão | cinza | 2 (3) | 0.5 |
| `oEnemy_Soldier_Advanced` | Castelo | verde | 2 (3) | 0.5 |
| `oEnemy_Soldier_Advanced` | Porão | azul | 2 (3) | 0.5 |
| `oEnemy_Soldier_Advanced` | Prisão, Catacumbas | cinza | 3 (4) | 0.75 |
| `oEnemy_Soldier_Advanced` | Templo da Água | azul | 6 (7) | 1.75 |
| `oEnemy_Soldier_Advanced` | Fortaleza | vermelho, grande, cabeça de porco (garfo) | 7 (8) | 2.5 |
| `oEnemy_Soldier_Advanced` | Fortaleza | vermelho, grande, cabeça de porco 2 (lança) | 8 (9) | 2.75 |
| `oEnemy_Soldier_Advanced` | Fortaleza | vermelho, grande, cabeça de demônio (espada) | 9 (10) | 3 |
| `oEnemy_Soldier_Mace` | Prisão | cinza | 4 (5) | 1 |
| `oEnemy_Soldier_Mace` | Fortaleza | dourado | 9 (10) | 3.25 |

### No projeto, sem dados

Estes objetos estão no `Zelda.yyp` mas não têm entrada em `Enemies_InitData`, então nunca são sorteados: `oEnemy_Delavant`, `oEnemy_Kyune`, `oEnemy_Lynel`, `oEnemy_Pirugusu`, `oEnemy_Soldier_Slasher`. Os cinco têm a linha de `EnemyDataInit` comentada em `__Enemies.gml`. Antes de usar um deles, confira se o código está completo.

## Chefes

| Objeto | Energia | Golpes | Ataque | Velocidade | No ALttP | Sala e fluxo |
|--------|---------|--------|--------|------------|----------|--------------|
| `oBoss_Armos` | 10 | 10 cada | 1 | anda 1.25, pulo 3 (`oBoss_Armos_C`) | Cavaleiros Armos | Nível 3 (Prisão); controlador `oBoss_Armos_C` |
| `oBoss_Lanmola` | 11 | 14 | 2.25 | 0.75 | Lanmolas | Nível 7; controlador `oBoss_Lanmola_C`, terra e pedras em objetos próprios |
| `oBoss_Moldorm` | 12 | pela cauda (`oBoss_Moldorm_Tail`) | contato | varia por fase (`SpeedIndex`) | Moldorm | Nível 11 |
| `oBoss_Aghanim` | 12 | 18 | 1.75 | disparo 6.5 | Agahnim | Nível 13; na tabela, a espada dá choque no Link (ou nada) e a bomba tira 4; o resto do dano é tratado no próprio objeto |

Sons próprios dos chefes: `Sound_Boss_Hit`, `Sound_Boss_Destroy`, `Sound_MoldormSkitter`, `Sound_AghanimCharge`, `Sound_AghanimChargeFast`, `Sound_AghanimEnergyBeam`, `Sound_Quake`, `Sound_Sand1`, `Sound_Sand2`.

## Clima e efeitos que já existem

* **Chuva e relâmpago:** `oIntro` (só no nível `Start`). Gotas `oRainDrop` e respingos `oRainSplash`, som `Sound_Rain` guardado em `global.RainSound`. O relâmpago é um flash branco da tela que liga de 30 a 180 quadros e dura 2 ou 3 (alarmes 1 e 2 do `oIntro`, desenho no `Draw`). O som da chuva continua tocando no castelo (`Dungeon_InitLevel`). Não há som de trovão.
