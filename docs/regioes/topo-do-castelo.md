# Região: Topo do Castelo

Piloto do plano de ferramentas: a primeira região feita pelo fluxo novo (spec, importação, ficha de fase, templates, inimigos, validador, teste). Reaproveita os inimigos do castelo, então o risco fica nas ferramentas e não em mecânicas novas.

* **Estado:** em produção
* **Origem:** ALttP, Castelo de Hyrule na noite da chuva (abertura do jogo), parte de fora e alta do castelo
* **Tipo:** telhado do castelo visto de cima (área 0x1B do overworld do ALttP), montado como uma dungeon (`Layout` Outdoor, layouts do castelo)
* **Fase:** `DungeonLevel.CastleTop` (novo), nome no jogo "Castle Rooftops"
* **Capítulo:** variante do capítulo 2 (`Depth` 2), ao lado do Castle Basement. Vem depois do capítulo 1 (Hyrule Castle, a entrada do castelo) e segue para o capítulo 3 (Castle Prison, com o chefe)
* **Pools de saída:** entra na `NextPool` do Hyrule Castle com peso 1, ao lado do Castle Basement com peso 2 (cada saída do castelo leva ao topo em 1 de cada 3 sorteios). A `NextPool` dele é só o Castle Prison; `ExitCount` e `ExitHidden` no padrão da ficha
* **Visual da saída:** escadaria para cima (`StairsUp`, já existe: é a escada da entrada de toda fase)
* **Gráficos:** `incoming/topo-do-castelo/`: o tileset `ts_CastleTop` (área 0x1B cortada da ROM pelo `owdump.py tiles`) e o trovão (`Sound_Thunder`)

## Ideia

Em vez de entrar pelos corredores, o Link sobe pelos telhados e passarelas do castelo, debaixo da tempestade da abertura. É o mesmo castelo e os mesmos guardas, mas ao ar livre: chuva caindo sobre a tela, relâmpagos que clareiam tudo por um instante e o trovão logo depois. Chega-se a ele por uma escadaria que sobe, e no fim uma escada desce de volta para dentro, rumo à prisão.

## Visual

* O telhado do Castelo de Hyrule como na área 0x1B do ALttP: o terraço verde-azulado é o piso, o alto creme pontilhado e a face bege com rebites das muretas são as paredes. As salas são pintadas tile a tile com o `ts_CastleTop` (salas pintadas, F12b-1), com peças recortadas da própria área, então a luz e a perspectiva são as do original.
* Passagem é um corte reto na mureta (em cima, embaixo e dos lados), sem moldura de porta.
* Decoração: torres de lâmpada verde encostadas na mureta de cima, o brasão de Hyrule no piso e o portão da Torre de Agahnim na mureta de cima.
* A noite é a mesma da entrada (nível `Start`): tela azulada e escura, chuva caindo e relâmpagos que clareiam tudo, com o trovão logo depois.
* Portas trancadas, fechadas, secretas, de entrada e de saída usam o desenho das portas do castelo dentro do corte da mureta (veja Decisões).

## Salas

* Mesma classe de dungeon e mesmos layouts do castelo (`DungeonClass.Castle`, `data_d`); muda o conjunto de salas: `CastleTop`, escrito pelo `tools/templates/make_rooms.py` e escolhido por `RoomSet` na ficha.
* 12 salas pintadas, cada uma com um conjunto de portas e uma decoração: 1x1 Terrace (a da prévia aprovada), Crossroads, TwinGates, Rampart, TowerGate, LampCourt e LowGates; 1x2 LongTerrace e LongRampart; 2x1 WideTerrace, WideRampart e WideCourt. Os conjuntos de portas são os menores que cobrem todas as salas que os layouts do castelo deram em 12 sementes (cenário `castle_top_layouts`): 136 de 156 salas saem pintadas.
* Sem salas de obstáculo (`ObstacleRooms = false`): são quebra-cabeças de dungeon.
* Salas especiais (loja, tesouro e as outras que o castelo sorteia) e salas com seção (parte da sala separada no layout) usam as salas compartilhadas com o tema do castelo: são o interior das torres.
* Referência para a F8: salas da Torre de Agahnim e o exterior do castelo no ALttP (as ids saem na conversão).

## Inimigos

| Objeto | Peso | Variante (energia, ataque, cor) | Ficha |
|--------|------|---------------------------------|-------|
| `oEnemy_Soldier_Simple` | 3 | verde, energia 1, ataque 0.5 (igual ao castelo) | `docs/ref/doi.md` |
| `oEnemy_Soldier_Advanced` | 2 | verde, energia 2, ataque 0.5 (igual ao castelo) | `docs/ref/doi.md` |
| `oEnemy_Keese` | 1 | padrão (energia 0, ataque 0.25) | `docs/ref/doi.md` |

Os soldados usam a mesma tabela do castelo. O morcego entra com peso baixo: são os morcegos do porão espantados pela tempestade, e ele já existe no porão e na prisão. Nenhum inimigo novo.

## Chefe

Nenhum. O capítulo 2 não tem chefe (o do capítulo 3, Armos, continua na prisão).

## Itens e recompensas

Iguais aos do castelo (baús, potes e o que mais o castelo sortear). Nenhuma conquista nova na primeira versão; uma conquista de "achar o telhado" pode vir depois, junto com outras de conteúdo novo (roadmap, passo 3).

## Música e som

* Música do castelo (`SongIndex.Castle`, `Music_Castle_Intro` e `Music_Castle_Main`).
* Chuva (`Sound_Rain`) tocando o nível inteiro, no mesmo volume da entrada (o `oIntro` e o castelo usam 0.3).
* Trovão: `Sound_Thunder`, extraído da ROM na F6b (`incoming/topo-do-castelo/sounds/Thunder.wav`, 1.69 s, pelo `tools/alttp/sfx.py 2 0x36`). No ALttP é o efeito 0x36 (54) de `sound_effect_1`, a porta 2 do APU, tocado pelo `OverworldOverlay_HandleRain` (zelda3, `src/overworld.c`).

## Clima e efeitos

* O clima é o `oWeather`, tirado do `oIntro` e usado pela entrada e por esta região (campo `Weather` da ficha, `{Thunder: true}` aqui): gotas `oRainDrop`, respingos `oRainSplash`, flash branco de 2 ou 3 quadros a cada 30 a 180 e a tinta azul da noite.
* Ritmo do ALttP como referência: no original o céu pisca nos quadros 3 a 5, 36 a 44 e 88 a 90 de um ciclo de 256, e o trovão toca no quadro 36. O DoI mantém o sorteio e toca o trovão 12 quadros depois do flash (se o anterior já acabou).
* Com o desafio de escuridão ligado, o relâmpago segue a regra que o `oIntro` já tem.

## Regras especiais

Nenhuma na primeira versão. Ideias para depois (não fazer agora): vento que empurra o Link nas passarelas, buraco no telhado que leva direto à prisão.

## Mudanças no código

A ficha de fase (F4) e os caminhos ramificados (F4b) já existem, então a região é uma entrada nova na ficha:

* `DungeonLevel` ganha o membro do topo (novo) e `Levels_Init` a entrada: `Depth` 2, `Next` e `NextPool` no Castle Prison, `Theme` e `EnemyStats` do castelo, `ExitLook` "StairsUp", a música e a lista de inimigos acima.
* `NextPool` do Hyrule Castle: `[[DungeonLevel.CastleBasement, 2], [<topo>, 1]]`. Só isso liga o sorteio de saídas no castelo (quantas, escondida, destino); nenhuma outra fase muda.
* Salas: conjunto de salas `CastleTop` (novo) em `data/room-templates/sets/CastleTop/rooms.json` e `RoomSet = "CastleTop"` na ficha (a escolha por conjunto já existe desde a F11).
* Clima: criar `oWeather` (novo) no começo da fase e passar o `oIntro` a usá-lo para a chuva e o relâmpago.
* Os soldados: confirmar se usam os números do castelo (`EnemyStats` do castelo, como decidido) agora que a fase está no capítulo 2, onde o porão usa os dele.
* `tools/check/validate.py` e `docs/dev/engine-notes.md`: registrar o que for aprendido.

## Pronto quando

* Em várias runs, o capítulo 2 aparece às vezes como o topo do castelo (por uma escadaria para cima no Hyrule Castle), com as salas do conjunto CastleTop, chuva, relâmpago e trovão, e o capítulo seguinte é a prisão normal.
* Cenários de teste da F3: começar no topo do castelo com semente fixa, andar até a escada de saída e conferir no log que as salas carregaram, os soldados apareceram e nada deu erro; folha de contato com 5 sementes mostrando as salas.
* O validador passa e a entrada (nível `Start`) continua igual com o `oWeather` (novo).
* O Guilherme joga uma run e aprova o visual.

## Decisões

* Mesmos inimigos do castelo, chuva e relâmpagos como no começo da run (roadmap, out/2026).
* É o piloto do plano de ferramentas: só começa depois das etapas F1 a F10, para testar o fluxo inteiro.
* Chance de 1 em 3 e o morcego com peso 1 foram escolhas do Claude dentro da direção de design; mudar se o Guilherme preferir.
* É variante do capítulo 2 (`Depth` 2, no lugar do Castle Basement), entre o Hyrule Castle e o Castle Prison, e a saída que leva a ele é a escadaria para cima (Guilherme, out/2026). A versão anterior desta spec o punha no lugar do Hyrule Castle; isso foi corrigido.
* O topo é o telhado do castelo visto de cima, como na área 0x1B do ALttP: telhado verde-azulado no chão, passarelas creme com pinos e face bege como paredes, a entrada da Torre de Agahnim (Guilherme, out/2026). A faixa do castelo recolorida (paredes em pedra bege com ameias, piso claro) foi recusada: é o castelo por dentro com outra cor. As seções Tipo, Visual e Salas acima ainda descrevem a versão de dungeon e serão reescritas com a F12b.
* F12b-1 feita (out/2026): o Guilherme aprovou a prévia da sala 1x1 do terraço (terraço verde-azulado como piso, muretas creme e bege como paredes, torres de lâmpada verde dos dois lados da passagem de cima, brasão de Hyrule no meio). A ficha ganhou `Layout` Outdoor, `RoomSet` CastleTop, `Ceiling` false e `Dark` Never; o conjunto `CastleTop` (`data/room-templates/sets/CastleTop/rooms.json`) tem só essa sala, "Terrace", com portas 12 e 6. As outras salas da fase, a chuva (o `oWeather` (novo)), as portas trancadas e de saída ao ar livre e os cenários da fase são o resto do piloto. As seções Visual e Salas acima ainda descrevem a versão de dungeon.
* A região espera a F12b: as salas saem pintadas tile a tile com o `ts_CastleTop`, porque as paredes do DoI são simétricas (um canto girado faz os quatro) e não dão a luz do telhado do ALttP (Guilherme escolheu a F12b em vez de uma faixa com quatro cantos, out/2026).
* Já feito e mantido para a F12b: a ficha `DungeonLevel.CastleTop` ("Castle Rooftops", `Depth` 2, `Next` Castle Prison, `ExitLook` "StairsUp", `RegionTiles` "CastleTop", os inimigos acima), o trovão e o `ts_CastleTop`. Ela ficou fora de toda `NextPool` até a F12b-1 (o Guilherme pediu); o resto do piloto religou o Hyrule Castle com o peso 1 dela ao lado do 2 do porão. A faixa recusada saiu do `sTiles`.
* Resto do piloto feito (out/2026, escolhas do Claude dentro da direção, a aprovar): 11 salas pintadas novas no conjunto `CastleTop` com aberturas laterais (o mesmo corte reto da passagem aprovada) e salas 2x1 próprias (sala pintada nunca gira); `oWeather` com chuva, relâmpago, trovão e a noite; Hyrule Castle com `NextPool` `[[CastleBasement, 2], [CastleTop, 1]]`; sem salas de obstáculo; salas especiais e de seção como interiores de torre (salas compartilhadas do castelo); portas especiais com o desenho das portas do castelo no corte da mureta. O trovão não entrou na entrada (nível `Start`), que ficou igual.
