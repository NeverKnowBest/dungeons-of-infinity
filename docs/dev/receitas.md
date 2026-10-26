# Receitas

Passo a passo das tarefas que se repetem. Detalhes do motor em `engine-notes.md`; scripts em `tools/README.md`.

## Antes de qualquer coisa

* Os dados do jogo (`game/datafiles/data/data_r` e `data_d`) estão no Git LFS. Garanta os arquivos reais antes de editar (no clone sem LFS eles são só ponteiros de texto).
* O código GML não pode ser testado no ambiente do Claude (não há GameMaker). Teste no PC de casa (veja `CLAUDE.md`).
* GML que já deu problema: um array literal não pode começar com cor `#RRGGBB` (`[#` é acessor de ds_grid); use `make_colour_rgb`. `global.Font_Small` só tem letras maiúsculas.

## Sala nova no hub

1. Monte a imagem da sala (veja "Imagem de sala a partir do ALttP"). Use uma camada de baixo (`sHub_<Nome>`) e, se houver partes que cobrem o Link (topo de paredes, lustres), uma de cima (`sHub_<Nome>_Over`).
2. Em `tools/hub/build3.py`, acrescente a sala em `ROOMS`: nome do template, posição livre no mapa do Tiled, posição no grid (até 8x8; o Santuário ocupa 3..4, o Hall 5..6) e tamanho (1x1, 2x1, 1x2 ou 2x2). Rode o script.
3. Em `__Hub.gml`: `Hub_RoomTemplateName` devolve o nome pela posição no grid; em `Hub_CreateScenery` acrescente o `case` da sala com as imagens, as paredes (`Hub_CreateWalls`, retângulos em tiles de 8 px), objetos e portas.
4. Porta entre salas do hub: um `oHubDoor` no vão da porta (caixa de gatilho) com `DestTemplate`, `DestX`, `DestY` (posição de chegada, já no vão da outra porta) e `DestFacing`. A troca de sala rola a câmera como nas dungeons (`oHubTravel`).
5. Teste: andar por todas as bordas, passar pelas portas nos dois sentidos, conferir que o Link não entra em paredes nem fica atrás de objetos que deveriam cobri-lo.

## Imagem de sala a partir do ALttP

1. Descubra o número da sala no ALttP (wikis e o próprio zelda3 ajudam).
2. Gere o dump com `tools/alttp/roomdump.c` e renderize com `tools/hub/z3room.py` (camada baixa e alta separadas; tiles animados com `ANIMFRAME`).
3. Colisão: os atributos de tile do dump dizem o que é parede; converta em retângulos (como `sanct_walls.json`).
4. Para variar uma sala, recorte e recombine peças da mesma sala ou do mesmo tileset (foi assim com a porta lateral, que é a porta da frente girada, e com o Hall, montado com as paredes do corredor da igreja). Não copie uma sala inteira para outro uso: o Guilherme percebe e não gosta.
5. Monte uma prévia em PNG, olhe e só depois gere os sprites.

## NPC no hub

1. Sprite: `sVillager_<Nome>_Down` (e `_Up`, `_Left`, `_Right` se existir). Se não houver no DoI, extraia da ROM com `sprdump.c` (veja como foi feito o Flute Boy em `tools/hub/flute/`).
2. Objeto `oVillager_<Nome>` com pai `oNPC_Sitting` (`gm_assets.obj`).
3. No `ROOMS` do `build3.py`: objeto NPC (gid 209), nome `Villager_<Nome>`, propriedades `Dialogue` (uma fala por linha; `?` no começo faz pergunta sim/não) e `NoWall` se a colisão for feita à parte. A posição é o canto superior esquerdo do sprite.
4. Para abrir um menu depois da fala, veja `oVillager_FluteBoy` (Step_2: quando `DB_Started`, espera a caixa de diálogo fechar e cria `oMenu_Game` com um `Mode`).

## Conquista nova

1. Acrescente em `global.AchievementList` (`__Achievements.gml`): `Key`, `Statue`, `Name`, `Desc` (o que pedir), `Skin` e `Gear` (recompensa ou -1).
2. Chame `Achievement_Unlock("Key")` onde ela acontece, ou estenda `Achievements_CheckStats` se depender das estatísticas.
3. Regras: a recompensa é segredo até ser conquistada (não aparece na galeria nem nos menus). Nada é liberado com cheats ligados.

## Música da ROM

1. `musicdump.c` renderiza a música (carregue o banco certo: intro ou indoor/overworld).
2. Ache o ponto de loop com `loopfind.py`, corte em `Intro` e `Main`.
3. `gm_assets.sound(...)`, depois acrescente em `SongIndex` e na tabela de músicas (`__Music.gml`).

## Estágio alternativo (ex.: topo do castelo no nível 2)

Como os níveis são montados hoje:

* Cada nível (`enum DungeonLevel`) escolhe uma classe de dungeon (`Dungeon_PickClass`): um conjunto de layouts em `data_d` (grade de salas, portas, escadas) e de salas em `data_r` (templates do Tiled, por classe e subclasse).
* O visual vem dos tiles do DoI (`sTiles`, linhas por tema em `LevelTilesY`) desenhados a partir dos templates. Inimigos, baús e objetos vêm das propriedades dos templates e das tabelas de inimigos por nível (`__Enemies.gml`, `EnemyDataInit`).

Passos:

1. Novo valor em `DungeonLevel` (ou uma variante sorteada no lugar do nível 2) e o caso em `Dungeon_PickClass`, `Dungeon_StartDir`, `Dungeon_IsBossLevel` e tabelas por nível.
2. Layouts: no editor de dungeons (`editors/dungeon-editor`) ou gerando o JSON do `data_d` direto.
3. Salas: templates novos no Tiled (`data/room-templates/`), convertidos para `data_r` pelo `editors/room-template-parser`. Para o topo do castelo dá para reaproveitar os templates do castelo e trocar o tema de parede/piso (propriedades `ForceWallTheme` e `ForceFloorTheme`).
4. Clima: a chuva do começo da run é `oRainController` (gotas e respingos); relâmpago seria um flash de tela com som, no mesmo controlador.
5. Inimigos: reaproveite os do castelo; só a tabela do nível muda.

## Conteúdo de outro Zelda (ex.: Minish Cap)

Ter os sprites e o código original ajuda muito, mas não é uma tradução 1 para 1:

* O código do original é de outra máquina (GBA, assembly ou decompilação em C) e conversa com o hardware dele (OAM, tilemaps, física em subpixels). Aqui cada inimigo é um objeto do GameMaker que precisa conversar com o DoI: estados (`EnemyState`), dano (`EnemyHitsToKill`, `Enemy_CheckHit`), drops, colisão com `oWall`, salas, pausa, iluminação e paletas.
* O que se aproveita direto: sprites e animações, padrões de movimento e ataque, tempos e números (vida, velocidade, dano), sons e músicas.
* Ordem sugerida: primeiro os sprites e um inimigo simples (andar e tocar no Link); depois os que atiram; por último o chefe, com sala própria.
* Para cada inimigo novo: objeto filho do inimigo do DoI mais parecido, sprite por direção e estado, `EnemyDataInit` com energia e ataque, e a tabela do nível onde ele aparece.
