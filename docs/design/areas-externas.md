# Áreas externas: proposta (F12a)

Proposta da etapa F12a para virar a F12b ("Áreas externas", no `docs/roadmap.md`). Base: a ficha `docs/ref/alttp-overworld.md` e a leitura do gerador do DoI. Nada aqui está implementado. As escolhas marcadas **(decidir)** dependem do Guilherme e estão juntas no fim.

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
* **Tamanhos de sala:** 1x1, 2x1, 1x2 e 2x2 quadrantes. 2x2 é a área pequena do ALttP; 1x1 e 2x1 são as telas de passagem, como as do Minish Cap e do Link's Awakening. Sem 4x4 (a área grande do ALttP): numa run curta, uma sala gigante é só caminhada. Uma fase externa teria o mesmo número de salas que uma dungeon (10 a 13), com mais 2x2.
* **Conteúdo da sala:** desenhado por tiles (blocos de 16x16 de um tileset da região), não pelas paredes geradas das dungeons. A colisão sai do atributo de cada tile (sólido, água, borda de mão única, escada, mato), como no ALttP; o jogo cria os `oWall` a partir dele ao montar a sala. Por cima, objetos que o DoI já tem: arbusto (`oBush`), pedra (`oRock`), placa (`oSign`), baús, área de inimigos.
* **Composição:** o ajudante de salas (como o `make_rooms.py` da F11) ganha um modo externo, com os motivos medidos no ALttP pelo `owdump.py` (a regra da F11b: disposição só a partir de salas reais). Motivos de partida, da ficha: massa de floresta em grade de 32 px, platô com penhasco, escada e borda de mão única, grupos de arbustos espelhados ao lado de portas e caminhos, cerca em linha, caminho de 32 a 64 px ligando as passagens, rio com ponte.
* **Salas especiais** (loja, fada, tesouro, sala secreta): ao ar livre viram interiores. A sala especial é uma caverna ou casa com entrada na sala externa; entrando, a sala interna é uma sala de dungeon comum (os templates especiais de hoje servem). A sala secreta com bomba vira a caverna atrás de uma parede rachada no penhasco, e a escada sob pedra também pode esconder uma.
* **Inimigos:** densidade de referência do ALttP, cerca de 0,75 inimigo por quadrante de 256 px (menos que uma sala de dungeon); os pesos continuam nas `Enemies` da ficha. Se eles voltam ao reentrar na sala é uma escolha **(decidir)**.
* **Clima:** o `oWeather` previsto no piloto (chuva e relâmpagos) e uma neblina como a da Lost Woods, por fase.

## Passagem pela borda

* **Onde ficam as passagens:** nas mesmas posições de porta que o gerador já usa (`DOOR_XY`), para ele continuar casando as ligações entre salas vizinhas sem mudança. Cada passagem tem uma largura: 48 ou 64 px no padrão (as mais comuns no ALttP) e às vezes um campo aberto de 128 px ou mais. O desenho da sala abre a floresta ou o penhasco naquele trecho.
* **Troca de sala:** a mesma rolagem de câmera das dungeons, disparada quando o Link sai pela passagem; não há moldura de porta.
* **Borda de mão única:** objeto novo de pulo (o Link pula a borda e cai no chão livre depois dela). Dá atalhos de volta e laços de um sentido só. Regra para o gerador: o caminho da chegada até a saída principal nunca depende de subir uma borda de mão única, e nenhuma sala pode virar beco sem volta.
* **Penhascos e escadas:** uma camada só (como no ALttP): penhasco é sólido, escada é chão, a altura é só desenho. O andar de baixo das dungeons (`Main_Lower`) não é usado ao ar livre.
* **Obstáculos que pedem item** (pedra para a luva, parede de bomba, alvo do gancho, água funda) só fecham o que é opcional: tesouro, atalho, a saída extra. A regra das saídas do DoI ("a principal nunca fica escondida") vale para qualquer obstáculo. O DoI tem luva, gancho e bombas; botas, nadadeiras, martelo e pá não existem no jogo e ficam de fora até virarem itens.

## Visuais de transição

O ALttP usa um círculo que fecha sobre o Link (a íris) ao entrar num lugar fechado, e o círculo que abre ao sair; a troca de área ao ar livre só rola. Proposta, com os visuais como entradas novas de `global.ExitLooks` (a regra da F4b: visual novo sem mexer no gerador):

* **Da dungeon para fora:** a saída que leva a uma fase externa é uma porta para o lado de fora (a porta grande do castelo, com luz entrando) ou uma parede explodida (o exemplo da decisão da F4b). Na fase externa, o Link chega saindo de uma boca de caverna ou de uma porta na face do penhasco da sala de chegada.
* **De fora para a dungeon:** a saída é um marco na sala de saída: boca de caverna, portão de dungeon, a boca da Deku Tree. O Link anda até ela e entra.
* **De fora para fora** (floresta para campina): a saída é uma passagem na borda do mapa que leva para fora da grade, uma "estrada", e a chegada é o Link entrando pela borda da sala de chegada.
* **O efeito de tela** entre fases é escolha **(decidir)**: o escurecer de hoje do DoI em todas, ou a íris do ALttP nas que entram ou saem de um lugar fechado. A Lost Woods tem ainda o mosaico, que pode ser o efeito de chegada de uma floresta.
* **O que falta no visual de saída de hoje:** ele sempre desenha um vão numa parede de cima ou de baixo e o Link anda pelos degraus. Para os visuais acima, o visual ganha o lugar onde fica (na parede, num marco dentro da sala, na borda) e as animações de entrar e de sair andando, sem degraus.

## O que a F6b precisa prever no tileset por região

Números da ficha: uma região externa do ALttP (várias áreas) usa de 150 a 490 blocos de 16x16 e de 190 a 430 tiles de 8x8 já coloridos; uma área sozinha, de 84 a 386 blocos.

* **Um tileset por região, separado do `sTiles`.** A faixa de tema de hoje (1248x48, 936 tiles de 8x8) até comporta uma região externa em número de tiles, mas as dungeons desenham as paredes lendo colunas fixas da faixa. Uma sala externa é pintada tile a tile pelo template, então precisa de um tileset próprio com índices estáveis: a imagem `sTiles_<Regiao>` (que o importador já gera) vira um tileset do GameMaker e um tileset do Tiled.
* **Uma tabela de atributos por tile** no tileset da região (sólido, água funda e rasa, borda de mão única nas quatro direções e diagonais, escada, entrada, mato, chão), que é a fonte da colisão. Ela pode vir da ROM para tiles do ALttP (o `owdump.py` já lê os atributos) e ser escrita à mão para gráficos de outros jogos.
* **O bloco de 16x16 como unidade de pintura** (o map16 do ALttP), com os tiles de 8x8 já coloridos (sem troca de paleta).
* **Tiles animados** (água, flores) listados à parte, com os quadros.
* **Sons ambientes em loop** (chuva, vento), além do trovão que a F6b já prevê.
* **Ferramenta de extração:** cortar os blocos de áreas escolhidas do ALttP num tileset mais a tabela de atributos (`owdump.py` já tem a leitura e a renderização). É ela que permite recombinar peças da ROM em vez de desenhar.

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
8. **Regras de dungeon espalhadas** que precisam respeitar o `Layout`: chaves e portas trancadas, sala do chefe com porta grande, kinstones, desafio do Wallmaster, cortinas, tochas, teto. Levantar a lista exata no começo da F12b (busca por `LevelDef.` e `Room.` nos scripts de desenho).

## Decisões que dependem do Guilherme

1. **Tamanho das salas externas:** 1x1 a 2x2 quadrantes, sem a área grande de 4x4 do ALttP (proposta), ou também 4x4?
2. **Inimigos ao reentrar numa sala externa:** continuam mortos, como nas salas do DoI (proposta: evita farmar e voltar atrás numa run), ou voltam, como no ALttP?
3. **Efeito de tela entre fases:** escurecer do DoI em todas (proposta para começar, sem efeito novo) ou a íris do ALttP ao entrar e sair de lugar fechado?
4. **Capítulo 4 depois da Deku Tree:** a Deku Tree leva às Catacumbas, como a prisão, ou o ramo externo continua separado por mais capítulos?
5. **Itens que o DoI não tem** (botas, nadadeiras, martelo, pá): ficam de fora das áreas externas (proposta) ou entram como itens novos junto com elas?
6. **Primeira área externa:** qual é (a floresta que leva à Deku Tree, ou uma campina em volta do castelo, que reaproveita os gráficos do ALttP sem depender de outro jogo)? Isso decide se o tileset da primeira região sai da ROM do ALttP ou de outro Zelda. Nota: a Deku Tree é do Ocarina of Time (3D); nos Zeldas 2D os parentes são a Maku Tree (Oracles) e o Deepwood Shrine (Minish Cap), o que pesa na escolha da origem dos gráficos.
