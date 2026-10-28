# Áreas externas: proposta (F12a)

Proposta da etapa F12a para virar a F12b ("Áreas externas", no `docs/roadmap.md`). Base: a ficha `docs/ref/alttp-overworld.md` e a leitura do gerador do DoI. Do jogo, só o tileset por região existe (F6b); o resto não está implementado. As escolhas que dependiam do Guilherme foram decididas em out/2026 e estão no fim ("Decisões do Guilherme").

## A ideia, conferida

A ideia do Guilherme: área externa é uma fase como as dungeons (mesmo gerador, ficha e pools), com salas de overworld no lugar das salas internas, e a troca de capítulo vira um deslocamento de área (castelo para a floresta, floresta para a Deku Tree). A vila e as minas continuam como centros de NPC, fora do modelo.

O estudo confirma que cabe:

* O overworld do ALttP (e mais ainda o do Link's Awakening e do NES) é uma grade de telas ligadas pelas bordas; a fase do DoI é uma grade de salas ligadas por portas. Os dois são "salas mais ligações", e a troca de tela pela borda do ALttP é o mesmo movimento da troca de sala do DoI (a câmera rola, o Link anda alguns passos).
* A área pequena do ALttP (512x512) é exatamente uma sala 2x2 do DoI (quadrantes de 256 px).
* Tudo o que a ficha de fase já tem continua valendo: `Depth`, `NextPool`, `ExitLook`, `Enemies`, `Song`, `Boss`, `SaveBefore`. O que muda é o tipo de layout, o desenho das salas, a passagem entre elas e como se entra e sai da fase.
* O ALttP liga lugares fechados e abertos sempre do mesmo jeito: sai-se de um lugar fechado para fora por uma porta ou caverna, e entra-se por outra. Isso dá o vocabulário das transições entre capítulos.

## Modo de layout aberto

* **Campo novo na ficha:** `Layout` com `Dungeon` (padrão, tudo como hoje) ou `Outdoor`. Uma fase `Outdoor` muda os padrões que não fazem sentido ao ar livre: sem teto (`Ceiling`), nunca escura (`Dark` Never), sem celas, sem chaves e portas trancadas, sem espinhos de chão, sem cortinas. Cada regra da dungeon que for desligada vira um campo da ficha, não um `if` espalhado (a mesma regra da F4).
* **Classe de layout nova** (`DungeonClass.Outdoor`): os layouts de grade de salas (as posições e as ligações) continuam sendo templates, como os das dungeons, com uma sala de chegada e uma sala de saída. A diferença é que as ligações são **passagens pela borda**, não portas.
* **Tamanhos de sala:** 1x1, 2x1, 1x2 e 2x2 quadrantes são o comum. 2x2 é a área pequena do ALttP; 1x1 e 2x1 são as telas de passagem, como as do Minish Cap e do Link's Awakening. Uma sala 4x4 (a área grande do ALttP) pode aparecer de vez em quando, também nas dungeons internas (decisão 1), então o gerador da F12b prevê salas maiores que 2x2. Uma fase externa teria o mesmo número de salas que uma dungeon (10 a 13), com mais 2x2.
* **Conteúdo da sala:** desenhado por tiles (blocos de 16x16 de um tileset da região), não pelas paredes geradas das dungeons. A colisão sai do atributo de cada tile (sólido, água, borda de mão única, escada, mato), como no ALttP; o jogo cria os `oWall` a partir dele ao montar a sala. Por cima, objetos que o DoI já tem: arbusto (`oBush`), pedra (`oRock`), placa (`oSign`), baús, área de inimigos.
* **Composição:** o ajudante de salas (como o `make_rooms.py` da F11) ganha um modo externo, com os motivos medidos no ALttP pelo `owdump.py` (a regra da F11b: disposição só a partir de salas reais). Motivos de partida, da ficha: massa de floresta em grade de 32 px, platô com penhasco, escada e borda de mão única, grupos de arbustos espelhados ao lado de portas e caminhos, cerca em linha, caminho de 32 a 64 px ligando as passagens, rio com ponte.
* **Salas especiais** (loja, fada, tesouro, sala secreta): ao ar livre viram interiores. A sala especial é uma caverna ou casa com entrada na sala externa; entrando, a sala interna é uma sala de dungeon comum (os templates especiais de hoje servem). A sala secreta com bomba vira a caverna atrás de uma parede rachada no penhasco, e a escada sob pedra também pode esconder uma.
* **Inimigos:** densidade de referência do ALttP, cerca de 0,75 inimigo por quadrante de 256 px (menos que uma sala de dungeon); os pesos continuam nas `Enemies` da ficha. Mortos continuam mortos ao voltar à sala, como nas dungeons (decisão 2).
* **Clima:** o `oWeather` previsto no piloto (chuva e relâmpagos) e uma neblina como a da Lost Woods, por fase.

## Passagem pela borda

* **Onde ficam as passagens:** nas mesmas posições de porta que o gerador já usa (`DOOR_XY`), para ele continuar casando as ligações entre salas vizinhas sem mudança. Cada passagem tem uma largura: 48 ou 64 px no padrão (as mais comuns no ALttP) e às vezes um campo aberto de 128 px ou mais. O desenho da sala abre a floresta ou o penhasco naquele trecho.
* **Troca de sala:** a mesma rolagem de câmera das dungeons, disparada quando o Link sai pela passagem; não há moldura de porta.
* **Borda de mão única:** objeto novo de pulo (o Link pula a borda e cai no chão livre depois dela). Dá atalhos de volta e laços de um sentido só. Regra para o gerador: o caminho da chegada até a saída principal nunca depende de subir uma borda de mão única, e nenhuma sala pode virar beco sem volta.
* **Penhascos e escadas:** uma camada só (como no ALttP): penhasco é sólido, escada é chão, a altura é só desenho. O andar de baixo das dungeons (`Main_Lower`) não é usado ao ar livre.
* **Obstáculos que pedem item** (pedra para a luva, parede de bomba, alvo do gancho, água funda) só fecham o que é opcional: tesouro, atalho, a saída extra. A regra das saídas do DoI ("a principal nunca fica escondida") vale para qualquer obstáculo. O DoI tem luva, gancho e bombas; botas, nadadeiras, martelo e pá não existem no jogo e ficam de fora da primeira versão (decisão 5), mas itens novos vêm logo, por dados (etapa de ferramenta nas Ideias do roadmap).

## Visuais de transição

O ALttP usa um círculo que fecha sobre o Link (a íris) ao entrar num lugar fechado, e o círculo que abre ao sair; a troca de área ao ar livre só rola. Proposta, com os visuais como entradas novas de `global.ExitLooks` (a regra da F4b: visual novo sem mexer no gerador):

* **Da dungeon para fora:** a saída que leva a uma fase externa é uma porta para o lado de fora (a porta grande do castelo, com luz entrando) ou uma parede explodida (o exemplo da decisão da F4b). Na fase externa, o Link chega saindo de uma boca de caverna ou de uma porta na face do penhasco da sala de chegada.
* **De fora para a dungeon:** a saída é um marco na sala de saída: boca de caverna, portão de dungeon, a boca da Deku Tree. O Link anda até ela e entra.
* **De fora para fora** (floresta para campina): a saída é uma passagem na borda do mapa que leva para fora da grade, uma "estrada", e a chegada é o Link entrando pela borda da sala de chegada.
* **O efeito de tela** entre fases é o escurecer de hoje do DoI em todas, por enquanto (decisão 3); a íris do ALttP nas que entram ou saem de um lugar fechado fica como melhoria futura. A Lost Woods tem ainda o mosaico, que pode ser o efeito de chegada de uma floresta.
* **O que falta no visual de saída de hoje:** ele sempre desenha um vão numa parede de cima ou de baixo e o Link anda pelos degraus. Para os visuais acima, o visual ganha o lugar onde fica (na parede, num marco dentro da sala, na borda) e as animações de entrar e de sair andando, sem degraus.

## O que a F6b precisa prever no tileset por região (feito na F6b)

Números da ficha: uma região externa do ALttP (várias áreas) usa de 150 a 490 blocos de 16x16 e de 190 a 430 tiles de 8x8 já coloridos; uma área sozinha, de 84 a 386 blocos.

* **Um tileset por região, separado do `sTiles`.** A faixa de tema de hoje (1248x48, 936 tiles de 8x8) até comporta uma região externa em número de tiles, mas as dungeons desenham as paredes lendo colunas fixas da faixa. Uma sala externa é pintada tile a tile pelo template, então precisa de um tileset próprio com índices estáveis: a imagem `sTiles_<Regiao>` (que o importador já gera) vira um tileset do GameMaker e um tileset do Tiled.
* **Uma tabela de atributos por tile** no tileset da região (sólido, água funda e rasa, borda de mão única nas quatro direções e diagonais, escada, entrada, mato, chão), que é a fonte da colisão. Ela pode vir da ROM para tiles do ALttP (o `owdump.py` já lê os atributos) e ser escrita à mão para gráficos de outros jogos.
* **O bloco de 16x16 como unidade de pintura** (o map16 do ALttP), com os tiles de 8x8 já coloridos (sem troca de paleta).
* **Tiles animados** (água, flores) listados à parte, com os quadros.
* **Sons ambientes em loop** (chuva, vento), além do trovão que a F6b já prevê.
* **Ferramenta de extração:** cortar os blocos de áreas escolhidas do ALttP num tileset mais a tabela de atributos (`owdump.py` já tem a leitura e a renderização). É ela que permite recombinar peças da ROM em vez de desenhar.

O que a F6b entregou (out/2026; detalhes em `docs/dev/engine-notes.md`, "Tile bands and region tilesets"):

* `owdump.py tiles <áreas> --region <regiao>` corta os blocos em `incoming/<regiao>/tiles/` (tiles de 8x8 já coloridos, uma vez só cada com os giros reaproveitados, blocos de 16x16, classe de cada tile tirada do atributo da ROM, índices estáveis quando se acrescentam áreas). O exterior do castelo (área 0x1B) já está cortado: `ts_CastleTop`, 271 tiles e 386 blocos.
* O importador faz disso o tileset `ts_<Regiao>` e `data/tiles/<Regiao>.json`; a ficha nomeia com `RegionTiles`; o jogo pinta por bloco (`RegionTiles_PaintBlock`, camadas próprias acima do piso) e lê a classe de volta (`RegionTiles_ClassAt`), a base da colisão. Formato aberto para gráficos de outros jogos (classes escritas à mão) e para tiles animados (`animated`, vazio no ALttP por enquanto).
* Faixa de tema por região no `sTiles` (`TilesBand`), para regiões em forma de dungeon como o topo do castelo, e efeitos sonoros (`sounds/`, `tools/alttp/sfx.py`) para os sons ambientes em loop e o trovão.
* Fica para a F12b: as salas pintadas tile a tile pelos templates (com as transformações e as meias salas), a colisão criada a partir das classes e a água animada do ALttP.

## O que a F12b-1 entregou (out/2026)

Só o que o telhado do castelo pedia (detalhes em `docs/dev/engine-notes.md`, "Painted rooms"):

* Sala pintada tile a tile: template inteiro (`Whole`) com as camadas de tiles `Region` e `RegionOpen`, montado pelo `make_rooms.py` a partir de um kit de peças recortadas de uma área do ALttP (`tools/templates/paint_rooms.py`, o mapa da área em `tiles/areas.json`).
* As transformações do gerador valem para a pintura (as 8 conferidas numa foto); cada sala diz quais aceita, por padrão original e espelho.
* Colisão: `oWall` a partir dos tiles sólidos (`solid` por tile, das classes). Bordas de mão única, arbustos, pedras, buracos e água funda ainda são paredes.
* Campo `Layout` na ficha (`Dungeon` ou `Outdoor`) e passagem pela borda nas posições de porta: a porta aberta de uma fase `Outdoor` não tem moldura, só a passagem pintada. A classe de layouts continua a do castelo (`data_d`); uma classe de layout aberta própria, a chegada e a saída fora da parede e as portas trancadas, escondidas e de saída ao ar livre ficam para as partes seguintes.

## Grafo de ramificações: o que já existe e o que falta

O grafo pedido: o castelo (capítulo 1) leva ao porão, ao topo ou a uma área externa (capítulo 2); a prisão (capítulo 3, com chefe) vem do porão ou do topo; a Deku Tree (capítulo 3) vem da área externa.

**Já suportado** (lido em `__Levels.gml`, `__Dungeon.gml`, `__Doors.gml` e `oLink`):

* `NextPool` por fase, com pesos: o castelo pode ter três destinos (`[[CastleBasement, 2], [CastleTop, 1], [<externa>, 1]]`). Cada saída sorteia o destino sozinha; com duas saídas, a run oferece no máximo dois dos três.
* Fases diferentes que levam à mesma (porão e topo com `Next` CastleJails) e a convergência depois (Deku Tree com `Next` no capítulo 4).
* `Depth` por fase: as variantes do mesmo capítulo usam as mesmas fórmulas de dificuldade, chance e preço (todas usam `LevelDef.Depth`). As comparações por índice que restam (`EnemyStats` de Keese, Octorok, Gibdo...) funcionam se a fase nova apontar para uma fase existente.
* Chefe por fase (`Boss`, `BossSpawn`) e a regra "fase com chefe não tem saída extra". A Deku Tree com chefe próprio é só a ficha dela.
* `SaveBefore` pela fase de destino, `RunPath` e o save da fase escolhida passam pela sala de descanso.

**Falta:**

1. **Tipo de layout** (`Layout` Outdoor) e a classe de layout aberta, com a passagem pela borda (acima).
2. **Chegada:** hoje é sempre por uma escadaria na parede de cima ou de baixo (`StartDir` só UP ou DOWN, a porta `Entrance` da sala de chegada). Faltam a chegada pela borda (as quatro direções), a chegada saindo de caverna ou porta, e o padrão de `StartDir` deixa de vir da paridade do índice da fase (fases novas ficam no fim do enum).
3. **Saída:** `Dungeon_PlanExits` põe as saídas como portas na parede de cima ou de baixo, e todo layout tem a sala de saída com três portas de saída. Fase externa precisa de saída num marco dentro da sala ou numa passagem da borda, e a saída extra escondida numa caverna de bomba.
4. **Visual de saída com lugar e animação** (acima): hoje ele só sabe vão de parede com degraus.
5. **Sala de descanso:** ela é montada com a ficha da fase anterior (`Dungeon_InitSaveLevel(global.Level.Index)`), então depois de uma fase externa sairia com o tema dela numa sala de dungeon. Falta uma sala de descanso externa (uma clareira ou uma casa) ou uma regra que diga de onde vem o visual dela. O defeito já anotado da sala de descanso logo depois do castelo (o `RunStart`) também precisa sair antes de o castelo ramificar para uma fase com `SaveBefore`.
6. **Regra de capítulo como checagem:** nada garante hoje que as variantes de um capítulo concordem. Faltam no validador: todo destino da `NextPool` tem `Depth` igual ao da fase mais 1; as variantes do mesmo `Depth` concordam em `Boss` (capítulo de chefe tem chefe em todas as variantes) e em `SaveBefore`.
7. **Mapa e bússola:** o mapa desenha portas entre salas; passagens pela borda e marcos de saída precisam de ícones próprios (junta com a ideia do `MapIcon` por visual de saída).
8. **Ramo com fim próprio** (decisão 4): uma fase cujo chefe encerra a run, com a tela de vitória, as conquistas e o registro no Hall of Fame desse final. Hoje só a fase `FinalBoss` (Agahnim) termina a run, e a regra 6 (todo destino da `NextPool` no `Depth` seguinte) não pode exigir que todo ramo chegue ao último capítulo.
9. **Regras de dungeon espalhadas** que precisam respeitar o `Layout`: chaves e portas trancadas, sala do chefe com porta grande, kinstones, desafio do Wallmaster, cortinas, tochas, teto. Levantar a lista exata no começo da F12b (busca por `LevelDef.` e `Room.` nos scripts de desenho).

## Decisões do Guilherme (out/2026)

Não há mais decisões abertas nesta proposta. Também estão em `docs/roadmap.md` (Decisões, "Áreas externas: decisões").

1. **Tamanho das salas:** 1x1 a 2x2 quadrantes são o comum; salas 4x4 podem aparecer de vez em quando, inclusive nas dungeons internas. O gerador da F12b deve prever isso (salas maiores que 2x2 na grade, nos templates e nas portas).
2. **Inimigos ao voltar a uma sala externa:** continuam mortos, como nas salas do DoI.
3. **Efeito de tela entre fases:** o escurecer de sempre, por enquanto. A íris do ALttP fica como melhoria futura nas transições entre fora e dentro.
4. **Ramos:** podem se reencontrar (ex.: o ramo externo volta às Catacumbas), mas também pode haver ramos que terminam a run em si mesmos, com final e chefe próprios, como os caminhos alternativos do Binding of Isaac. A estrutura de ramificações deve prever um ramo com fim próprio (anotado na F12b e nas Ideias do roadmap): hoje a vitória é a fase `FinalBoss` (Agahnim), então um ramo com fim próprio pede que a fase diga se o chefe dela encerra a run, com a tela de vitória, as conquistas e o Hall of Fame desse final.
5. **Itens que o DoI não tem** (botas, nadadeiras, martelo, pá): ficam fora da primeira versão das áreas externas, mas itens novos vão entrar logo. Antes, uma etapa de ferramenta para itens por dados, como a F7 fez com os inimigos (Ideias do roadmap).
6. **Primeira área externa:** a campina em volta do castelo, com gráficos do ALttP (a ROM, pelo `owdump.py tiles`). A Deku Tree e os outros jogos ficam para depois de o ALttP se esgotar (prioridade de conteúdo, `docs/design/direcao.md`).
