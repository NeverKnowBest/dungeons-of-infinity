# Região: Topo do Castelo

Piloto do plano de ferramentas: a primeira região feita pelo fluxo novo (spec, importação, ficha de fase, templates, inimigos, validador, teste). Reaproveita os inimigos do castelo, então o risco fica nas ferramentas e não em mecânicas novas.

* **Estado:** em produção
* **Telas da área (F18, out/2026):** a fase deixou de ser salas fechadas com portas e passou a ser a própria área 0x1B do ALttP em telas com borda aberta (`LevelLayout.Screens`, conjunto `CastleTopArea`). Prévia no jogo aprovada pelo Guilherme; falta ele jogar uma run e aprovar.
* **Origem:** ALttP, arredores do Castelo de Hyrule na noite da chuva (abertura do jogo), área 0x1B do overworld
* **Tipo:** área externa, a própria área 0x1B em 10 telas com borda aberta (`Layout` Screens)
* **Fase:** `DungeonLevel.CastleTop` (o nome do membro ficou do piloto), nome no jogo "Castle Grounds" (era "Castle Rooftops")
* **Capítulo:** variante do capítulo 2 (`Depth` 2), ao lado do Castle Basement. Vem depois do capítulo 1 (Hyrule Castle, a entrada do castelo) e segue para o capítulo 3 (Castle Prison, com o chefe)
* **Pools de saída:** entra na `NextPool` do Hyrule Castle com peso 1, ao lado do Castle Basement com peso 2 (cada saída do castelo leva a ela em 1 de cada 3 sorteios). A `NextPool` dela é só o Castle Prison; `ExitCount` e `ExitHidden` no padrão da ficha
* **Visual da saída:** no Hyrule Castle, a saída que leva a ela é a escadaria para cima (`StairsUp`). Nela, o Link chega andando pela estrada de terra da borda sul (`ArriveLook` "Edge") e sai entrando pela porta da frente do castelo, no alto da escada do pátio (`OwnExitLooks` "Doorway")
* **Gráficos:** `incoming/topo-do-castelo/`: o tileset `ts_CastleTop` (área 0x1B cortada da ROM pelo `owdump.py tiles`) e o trovão (`Sound_Thunder`)

## Ideia

O Link sai do castelo pela escadaria e se vê do lado de fora, na noite da chuva da abertura do ALttP: a estrada de terra, a ponte sobre o rio, o muro de fora com o portão gradeado, o fosso e o pátio com a porta do castelo. Os guardas patrulham os gramados. Ele acha a chave nos arredores, abre o portão e entra de volta pela porta da frente, rumo à prisão.

## Visual

* A área 0x1B do ALttP como ela é, pintada tile a tile com o `ts_CastleTop`: muretas, fosso, rio, ponte, portão, pátio, árvores e moitas da ROM. Nada é cortado nem inventado; a colisão é a das classes dos tiles.
* A noite é a mesma da entrada (nível `Start`): tela azulada e escura, chuva caindo e relâmpagos que clareiam tudo, com o trovão logo depois.
* O fosso e os telhados são piso na ROM, mas ficam fora de alcance (cercados por muretas); nenhum inimigo nasce lá.
* Portão aberto: as barras da grade viram o caminho de pedra que passa por baixo do arco (o arco com os pinos verdes fica).

## Salas

* Conjunto `CastleTopArea`, escrito pelo `tools/templates/paint_screens.py` a partir de `data/room-templates/sets/CastleTopArea/area.json`: 10 telas. O eixo do castelo (x 512) cairia na divisa de duas telas de 256 px, com a porta, o portão e a ponte em cima da emenda, então o miolo são duas salas 2x2 (como as do Village): CastleFront (castelo, fosso e metade de cima do pátio, com a porta) e Gatehouse (metade de baixo do pátio, portão, ponte e gramado do sul). Nas laterais, 8 telas 1x1: WestTower, WestLawn, WestMoat, WestBank, EastTower, EastLawn, EastMoat e SouthRoad.
* Sorteio: WestTower, EastTower e WestBank ficam com chance de 0,6 cada (fora, a borda do vizinho fecha); a área inteira pode sair espelhada.
* Arquitetura característica: o muro do castelo com o fosso em volta do pátio; telas com borda aberta, sem portas entre elas.
* Sala marco: o pátio diante da porta da frente do castelo, com a escada e as torres de lâmpada.
* Baús e áreas de inimigo saem da própria ferramenta: áreas sobre o piso alcançável, um baú encostado em mureta, cerca ou moita.
* As salas pintadas com portas do piloto (conjunto `CastleTop`, F12b) continuam no repositório e nos testes dele (`levels` nos cenários `castle_top_*`), fora da fase.

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

* Mecânica própria: a área aberta. Telas com borda aberta (o Link sai pela borda e a câmera corre), a chave escondida nos arredores (num baú ou com um guarda) abre o portão gradeado do muro de fora, e só então o pátio e a saída.
* Ideias para depois (não fazer agora): o buraco sob a moita a leste (a passagem secreta do ALttP para dentro do castelo) como segredo, vento nas passarelas.

## Mudanças no código

* Ficha `CastleTop`: `Layout` Screens, `RoomSet` "CastleTopArea", `StartDir` UP, `ArriveLook` "Edge", `OwnExitLooks` {Top: "Doorway"}, `RegionTiles` "CastleTop", os inimigos abaixo.
* `LevelLayout.Screens` (F18): layout montado do `screens.json` (`Screens_Layout`), template por nome (`RoomTemplates_PickScreen`), bordas abertas e fechadas (`Screens_Open`, `RegionRoom_OffLane`), faixa que segura os inimigos na tela (`Screens_EnemyEdges`), transição aberta e câmera entre telas de alturas diferentes (`Cam_InitTransitionRoom`), tranca que abre o caminho da ROM (`Door_DrawTiles`), visuais `Edge` e `Doorway`. Detalhes em `docs/dev/engine-notes.md`, "Screens of an area".
* Teste: cenário `castle_top_screens` (passos `painted` com `all` e `edges`).

## Pendências

1. O Guilherme joga uma run que passe pelos arredores do castelo e aprova (roteiro de teste da entrega da F18).
2. Segredos: o buraco sob a moita a leste, como no ALttP (ideia acima), quando o Guilherme quiser.
3. As pendências das rodadas anteriores (salas pintadas com portas) ficaram com o conjunto `CastleTop`, fora da fase.

## Pronto quando

* Em várias runs, o capítulo 2 aparece às vezes como os arredores do castelo (por uma escadaria para cima no Hyrule Castle), com chuva, relâmpago e trovão, e o capítulo seguinte é a prisão normal.
* Cenários: `castle_top_screens` (colisão tile a tile de todas as telas, todas as bordas abertas atravessadas, tranca e saída, em três sorteios) e `castle_top` (Hyrule Castle, arredores, prisão) passam.
* O validador passa.
* O Guilherme joga uma run e aprova o visual.

## Decisões

* Terceira rodada (out/2026, Guilherme escolheu a opção A na prévia): salas com seção pintadas com uma mureta de pedra do telhado, em vez de tirar as seções do topo. Como a mureta grossa do ALttP não cabe entre as portas de uma sala 1x1, ela segue a linha dos trilhos do DoI, 24 px de altura e 16 de largura, feita com as peças da própria moldura. O portão de saída abre quando o Link encosta nele de frente, como a porta do palácio do ALttP.
* Revisão do Guilherme (out/2026, prévias 1 a 4 aprovadas): sem portas de dungeon ao ar livre; portão da Torre de Agahnim na chegada e na saída, com a animação da ROM, e a saída na parede de cima (ou a escada da frente do castelo quando não cabe); torre com o pé; mureta contínua entre salas, com peças inteiras; salas com vista para baixo; natureza em cima do telhado, com grama tomando o piso; salas especiais pintadas como a região. Poças de chuva ficaram de fora (o ALttP não tem).

* Mesmos inimigos do castelo, chuva e relâmpagos como no começo da run (roadmap, out/2026).
* É o piloto do plano de ferramentas: só começa depois das etapas F1 a F10, para testar o fluxo inteiro.
* Chance de 1 em 3 e o morcego com peso 1 foram escolhas do Claude dentro da direção de design; mudar se o Guilherme preferir.
* É variante do capítulo 2 (`Depth` 2, no lugar do Castle Basement), entre o Hyrule Castle e o Castle Prison, e a saída que leva a ele é a escadaria para cima (Guilherme, out/2026). A versão anterior desta spec o punha no lugar do Hyrule Castle; isso foi corrigido.
* O topo é o telhado do castelo visto de cima, como na área 0x1B do ALttP: telhado verde-azulado no chão, passarelas creme com pinos e face bege como paredes, a entrada da Torre de Agahnim (Guilherme, out/2026). A faixa do castelo recolorida (paredes em pedra bege com ameias, piso claro) foi recusada: é o castelo por dentro com outra cor. As seções Tipo, Visual e Salas acima ainda descrevem a versão de dungeon e serão reescritas com a F12b.
* F12b-1 feita (out/2026): o Guilherme aprovou a prévia da sala 1x1 do terraço (terraço verde-azulado como piso, muretas creme e bege como paredes, torres de lâmpada verde dos dois lados da passagem de cima, brasão de Hyrule no meio). A ficha ganhou `Layout` Outdoor, `RoomSet` CastleTop, `Ceiling` false e `Dark` Never; o conjunto `CastleTop` (`data/room-templates/sets/CastleTop/rooms.json`) tem só essa sala, "Terrace", com portas 12 e 6. As outras salas da fase, a chuva (o `oWeather` (novo)), as portas trancadas e de saída ao ar livre e os cenários da fase são o resto do piloto. As seções Visual e Salas acima ainda descrevem a versão de dungeon.
* A região espera a F12b: as salas saem pintadas tile a tile com o `ts_CastleTop`, porque as paredes do DoI são simétricas (um canto girado faz os quatro) e não dão a luz do telhado do ALttP (Guilherme escolheu a F12b em vez de uma faixa com quatro cantos, out/2026).
* Já feito e mantido para a F12b: a ficha `DungeonLevel.CastleTop` ("Castle Rooftops", `Depth` 2, `Next` Castle Prison, `ExitLook` "StairsUp", `RegionTiles` "CastleTop", os inimigos acima), o trovão e o `ts_CastleTop`. Ela ficou fora de toda `NextPool` até a F12b-1 (o Guilherme pediu); o resto do piloto religou o Hyrule Castle com o peso 1 dela ao lado do 2 do porão. A faixa recusada saiu do `sTiles`.
* Resto do piloto feito (out/2026, escolhas do Claude dentro da direção, a aprovar): 11 salas pintadas novas no conjunto `CastleTop` com aberturas laterais (o mesmo corte reto da passagem aprovada) e salas 2x1 próprias (sala pintada nunca gira); `oWeather` com chuva, relâmpago, trovão e a noite; Hyrule Castle com `NextPool` `[[CastleBasement, 2], [CastleTop, 1]]`; sem salas de obstáculo; salas especiais e de seção como interiores de torre (salas compartilhadas do castelo); portas especiais com o desenho das portas do castelo no corte da mureta. O trovão não entrou na entrada (nível `Start`), que ficou igual.
* F18 (out/2026, Guilherme): telas da área. A fase é a própria área 0x1B em telas com borda aberta, nada cortado nem inventado. Escolhas do Claude dentro da direção, mostradas na prévia no jogo e aprovadas: miolo em duas salas 2x2 (o eixo do castelo cairia na emenda de duas telas), entrada pela estrada da borda sul, chave nos arredores abrindo o portão gradeado, saída pela porta da frente do castelo, três telas de canto opcionais e o espelho, e o nome no jogo "Castle Grounds".
