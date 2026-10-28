# Receitas

Passo a passo das tarefas que se repetem. Detalhes do motor em `engine-notes.md`; scripts em `tools/README.md`.

## Antes de qualquer coisa

* As salas do jogo ficam em `game/datafiles/data/rooms/` (um arquivo por classe, git normal) e são geradas pelo `tools/templates/convert.py`; não edite à mão. Os layouts (`data_d`) estão no Git LFS; os dois PCs têm o LFS, mas num clone sem LFS ele é só um ponteiro de texto.
* Teste o GML no jogo, em qualquer um dos dois PCs: pelo IDE ou com um cenário de teste automático (`python tools/test/run.py`, receita "Teste automático" abaixo).
* Rode `python tools/check/validate.py` antes de entregar. Ele pega recursos faltando, eventos sem arquivo, assets inexistentes no GML e as armadilhas abaixo.
* Só compila o que está no `Zelda.yyp`. O código morto da versão original foi apagado na F1; se o validador acusar uma pasta órfã nova (por exemplo, um recurso removido no IDE, que deixa a pasta no disco), apague a pasta.
* GML que já deu problema: um array literal não pode começar com cor `#RRGGBB` (`[#` é acessor de ds_grid); use `make_colour_rgb`. `global.Font_Small` só tem letras maiúsculas.

## Teste automático (cenário)

1. Comece pelo `boot` (`python tools/test/run.py boot`): ele compila, monta a primeira fase e fecha. Erro de compilação ou de GML aparece em texto na saída do script.
2. Para testar uma mudança, copie `tools/test/scenarios/smoke.json` para um cenário com nome do assunto e escreva só os passos que provam a mudança: a fase (`level`), itens e cheats, os comandos (`hold`, `press`, `room`, `spawn`) e as checagens (`expect`, `state`, `shot` quando a imagem importa). Formato em `tools/README.md` ("test/").
3. Ache as salas da fase pelo log: as linhas `room` e `sheet` mostram a posição no grid e o template de cada uma. Para ir direto a uma sala, `{"do": "room", "x": 4, "y": 4}`.
4. Rode e leia o `RESULT` e o log. Para repetir sem mudar o GML (só o cenário), use `--no-build`.
5. Se um passo falhar, olhe a linha `FAIL` ou `crash` e o print do momento antes de mexer no código. A mesma semente sempre joga igual, então o erro se repete.
6. Cenário que prova algo que pode quebrar de novo fica em `tools/test/scenarios/` (o validador confere todos).

## Folha de contato de uma fase

1. `python tools/test/run.py --sheet <Fase> --seeds 4` (nomes do enum `DungeonLevel`: Castle, Sewers, Mines...). Para sementes escolhidas: `--seeds 7,9,12`.
2. Saem `tools/test/out/sheet_<nível>_<semente>.png` (fase inteira em 1x) e `sheet_<nível>.png` (todas lado a lado, em meio tamanho). O log lista cada sala com grid e template.
3. Serve para conferir salas novas e a variedade da geração sem jogar. Para comparar antes e depois de uma mudança, rode as mesmas sementes nas duas versões.

## Comparar antes e depois (cenários de referência)

Para mudanças que não deveriam mudar o jogo (refatoração, faxina, troca de tabela por ficha):

1. Antes de mexer no código: `python tools/test/baseline.py save before` (compila e roda os 14 `ref_*`, uns 15 min; rode em segundo plano). Se já mexeu, faça o baseline numa cópia do commit: `git worktree add --detach %TEMP%/doi-base HEAD`, copie para lá as ferramentas de teste que mudaram, rode `save before` nela e copie `tools/test/baseline/before` de volta. Não rode dois testes ao mesmo tempo: o `run.py` fecha qualquer `Runner.exe` aberto.
2. Depois da mudança: `python tools/test/baseline.py save after` e `python tools/test/baseline.py compare before after`.
3. `SAME` prova que as 14 fases são geradas igual (salas, objetos e suas variáveis, tiles, globais, folhas de contato). Se aparecer diferença, leia as linhas: global renomeado ou removido de propósito é esperado; qualquer outra coisa é mudança de comportamento. Se a mudança cria sprites ou surfaces, todo dump muda nos números delas: compare com `--handles`, que ignora esses números.
4. Fase nova ganha um `ref_NN_<Fase>.json` copiado de um parecido (no `probe`, só inimigos que existem na fase).

## Sala nova no hub

1. Monte a imagem da sala (veja "Imagem de sala a partir do ALttP"). Use uma camada de baixo (`sHub_<Nome>`) e, se houver partes que cobrem o Link (topo de paredes, lustres), uma de cima (`sHub_<Nome>_Over`).
2. Em `tools/hub/build3.py`, acrescente a sala em `ROOMS`: nome do template, posição livre no mapa do Tiled, posição no grid (até 8x8; o Santuário ocupa 3..4, o Hall 5..6) e tamanho (1x1, 2x1, 1x2 ou 2x2). Rode o script.
3. Em `__Hub.gml`: `Hub_RoomTemplateName` devolve o nome pela posição no grid; em `Hub_CreateScenery` acrescente o `case` da sala com as imagens, as paredes (`Hub_CreateWalls`, retângulos em tiles de 8 px), objetos e portas.
4. Porta entre salas do hub: um `oHubDoor` no vão da porta (caixa de gatilho) com `DestTemplate`, `DestX`, `DestY` (posição de chegada, já no vão da outra porta) e `DestFacing`. A troca de sala rola a câmera como nas dungeons (`oHubTravel`).
5. Teste: andar por todas as bordas, passar pelas portas nos dois sentidos, conferir que o Link não entra em paredes nem fica atrás de objetos que deveriam cobri-lo.

## Template de sala no Tiled

1. Abra o mapa da classe em `data/room-templates/` (`Room Templates <Classe>.json`) no Tiled 1.10 ou mais novo.
2. Desenhe o retângulo da sala na camada `Rooms` (tamanho em múltiplos de 256; meia sala de 256x128 só nas classes Main) e preencha `type` com a subclasse quando a classe for por tipo (Special, Other, Village, Mines, Obstacles). Os objetos vão nas camadas de mesmo nome, sempre com a propriedade `Room` apontando para o retângulo.
3. Gere as salas do jogo: `python tools/templates/convert.py --summary`. Ele avisa camada desconhecida, objeto sem `Room`, tamanho de sala inválido e porta fora das posições de porta, e grava `game/datafiles/data/rooms/<Classe>.json`.
4. Confira no `git diff` que só mudou o arquivo da classe e só as linhas das salas novas ou alteradas (cada template é uma linha). Para comparar com uma versão anterior pelo conteúdo: `python tools/templates/compare.py <pasta antiga> game/datafiles/data/rooms`.
5. Rode o validador (ele acusa se o mapa do Tiled mudou e as salas não foram geradas de novo) e teste no jogo.

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

## Especificação de região

1. Copie `docs/regioes/_modelo.md` para `docs/regioes/<nome>.md` e preencha todas as seções. Estado começa em "ideia" ou "especificada".
2. Números de inimigos, chefes e itens: tire de `docs/ref/` (ALttP em `alttp.md`, o que já existe em `doi.md`). Se faltar um jogo ou um inimigo, pesquise uma vez e acrescente a ficha lá (veja `docs/ref/README.md`), não na spec.
3. Cite os assets entre crases (`oEnemy_Rat`, `Sound_Rain`). Para os que ainda vão ser criados, escreva "(novo)" na linha.
4. Rode `python tools/check/validate.py`: ele acusa seção faltando, estado inválido e asset inexistente.
5. Mostre a spec ao Guilherme antes de construir; o que ele decidir vai na seção Decisões.
6. Ao avançar, atualize o Estado (em produção, pronta).

## Estágio alternativo (variante de capítulo, ex.: topo do castelo no capítulo 2)

Como os níveis são montados hoje:

* Tudo o que muda de um nível para outro está na ficha de fase, `game/scripts/__Levels/__Levels.gml` (`global.LevelDefs`, um bloco por nível; cada campo tem comentário no `Level_Create`). Detalhes em `docs/dev/engine-notes.md` ("Level sheet" e "Branched exits").
* A run é uma sequência de capítulos (o `Depth` da ficha); as fases com o mesmo `Depth` são variantes do capítulo. Uma variante entra na run pelas saídas das fases do capítulo anterior: a `NextPool` de cada uma (`[[fase, peso], ...]`) sorteia para onde cada saída leva. Enquanto a `NextPool` de uma fase tiver um destino só, ela não sorteia nada e sai igual a antes da F4b.
* Cada nível escolhe uma classe de dungeon (`Class`): um conjunto de layouts em `data_d` (grade de salas, portas, escadas) e de salas em `game/datafiles/data/rooms/` (templates do Tiled, por classe e subclasse).
* O visual vem dos tiles do DoI (`sTiles`, linhas do tema `Theme` em `LevelTilesY`) desenhados a partir dos templates, mais as regras de decoração de cada tema (`switch(LevelDef.Theme)`). Os inimigos vêm da lista `Enemies` da ficha (objeto e peso).
* A saída do nível não é uma sala: é uma porta com status `Exit` na parede de cima ou de baixo de uma sala (a classe de templates Stairs é outra coisa, as escadas internas entre os dois andares de uma sala). O desenho dela vem do `ExitLook` da fase de destino.

Passos:

1. Novo valor no fim de `DungeonLevel` e uma entrada no `Levels_Init`. Copie a entrada do nível mais parecido e mude o que for diferente: `Name`, `Depth` (o capítulo do qual ela é variante), `Theme` e `EnemyStats` do nível cujo visual e inimigos ele usa (`DungeonLevel.Castle` no topo do castelo), `Class`, `Song`, `Enemies`, escuridão, água, obstáculos. `Next` (e, se o próximo capítulo tiver variantes, `NextPool`) aponta para o próximo capítulo.
2. Caminho: acrescente a fase nova na `NextPool` de cada fase do capítulo anterior, com o peso que dá a chance desejada (ex.: Hyrule Castle `[[DungeonLevel.CastleBasement, 2], [<nova>, 1]]` leva ao topo em 1 de cada 3 saídas). Isso já liga o sorteio de quantas saídas a fase tem e se a extra fica escondida (`ExitCount`, `ExitHidden`, padrão na ficha).
3. Visual da saída: `ExitLook` na entrada da fase nova (`"StairsDown"` é o padrão, `"StairsUp"` a escadaria para cima). Para um visual que ainda não existe, acrescente uma entrada em `ExitLooks_Init` (`__Doors.gml`): uma função que desenha a viga e o vão da porta de saída em cima e embaixo, o som de saída, a animação do Link (`LinkAnim`: quatro sprites `global.LinkSpr_<LinkAnim>_Top1/_Bottom1/_Top2/_Bottom2` criadas em `LinkSprites_Construct` e apagadas em `LinkSprites_Destroy`; `LinkSprite_Remix` deriva uma de outra existente, escolhendo, deslocando e espelhando quadros), o som de chegada (`ArriveSound`), o vão por onde o Link chega na fase seguinte (`Entrance`, a coluna do tile de decoração em cima e embaixo) e o ícone do mapa. O Link deve sempre acompanhar os degraus desenhados no vão, na saída e na chegada. Nem o gerador nem o Link mudam.
4. Layouts: no editor de dungeons (`editors/dungeon-editor`) ou gerando o JSON do `data_d` direto.
5. Salas: templates novos no Tiled (`data/room-templates/`), convertidos para `game/datafiles/data/rooms/` com `tools/templates/convert.py` (veja "Template de sala no Tiled"). Para o topo do castelo dá para reaproveitar os templates do castelo e trocar o tema de parede/piso (propriedades `ForceWallTheme` e `ForceFloorTheme`).
6. Clima: a chuva e o relâmpago do começo da run estão no `oIntro` (gotas `oRainDrop`, respingos `oRainSplash`, flash nos alarmes 1 e 2, som `Sound_Rain`). Para outra região, extraia a chuva do `oIntro` para um controlador próprio (veja `docs/regioes/topo-do-castelo.md`).
7. Inimigos: reaproveite os do castelo; é só a lista `Enemies` da entrada, com `EnemyStats` de um nível onde eles existem (os soldados só funcionam nos níveis que o `Create` deles conhece).
8. Teste: antes de existir a fase, dá para ver o sorteio com uma ramificação temporária no cenário (chave `"levels"`, como em `tools/test/scenarios/branch_exits.json`); com ela pronta, folha de contato da fase anterior com várias sementes e o passo `exit` para atravessar cada saída.
9. Cenário de referência `ref_NN_<Fase>.json` para a fase nova (veja "Comparar antes e depois").

## Conteúdo de outro Zelda (ex.: Minish Cap)

Ter os sprites e o código original ajuda muito, mas não é uma tradução 1 para 1:

* O código do original é de outra máquina (GBA, assembly ou decompilação em C) e conversa com o hardware dele (OAM, tilemaps, física em subpixels). Aqui cada inimigo é um objeto do GameMaker que precisa conversar com o DoI: estados (`EnemyState`), dano (`EnemyHitsToKill`, `Enemy_CheckHit`), drops, colisão com `oWall`, salas, pausa, iluminação e paletas.
* O que se aproveita direto: sprites e animações, padrões de movimento e ataque, tempos e números (vida, velocidade, dano), sons e músicas.
* Ordem sugerida: primeiro os sprites e um inimigo simples (andar e tocar no Link); depois os que atiram; por último o chefe, com sala própria.
* Para cada inimigo novo: objeto filho do inimigo do DoI mais parecido, sprite por direção e estado, `EnemyDataInit` com energia e ataque, e o inimigo na lista `Enemies` da ficha do nível onde ele aparece.
