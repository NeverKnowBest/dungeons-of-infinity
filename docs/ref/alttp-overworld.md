# A Link to the Past: overworld

Fonte: ROM americana lida com `tools/alttp/owdump.py` (endereços e tabelas de nomes do zelda3, `assets/extract_resources.py` e `assets/tables.py`) e a lógica do zelda3 (`src/overworld.c`, `src/tile_detect.c`, `src/sprite.c`, `src/player.c`, `src/load_gfx.c`), lida em out/2026 (etapa F12a). Os números são do mundo da luz (Light World) salvo quando dito; o mundo das trevas tem a mesma estrutura. Para conferir ou medir de novo, os comandos estão no fim.

A proposta de como isso vira ferramenta no DoI está em `docs/design/areas-externas.md`.

## Estrutura

* **Grade de áreas.** Cada mundo é uma grade de 8x8 telas de mapa de 512x512 px. Uma **área pequena** ocupa uma tela (512x512); uma **área grande** ocupa 2x2 telas (1024x1024). No mundo da luz há 32 áreas pequenas e 8 grandes (Lost Woods, Tower of Hera, Death Mountain leste, Kakariko, Hyrule Castle, Eastern Palace, Desert, Lake Hylia). As áreas 0x80 a 0x9f são especiais (bosque da Master Sword, cachoeira dos Zora, telas de sobreposição).
* **Câmera.** A tela do SNES mostra 256x224; dentro da área a câmera rola livre, seguindo o Link. A área pequena tem cerca de 2x2 telas de câmera (512 px são 2 de largura e 2,3 de altura); a grande, cerca de 4x4.
* **No DoI:** a sala do DoI é feita de quadrantes de 256 px. A área pequena do ALttP tem o tamanho exato de uma sala 2x2 do DoI; a grande seria 4x4, que o DoI não tem.
* **Escala.** O Link ocupa 16x24 px, um map16 de largura. Para pensar em "Links": uma abertura de 48 px tem 3 Links de largura, uma copa de árvore grande tem 4. A grade do jogo (8, 16 e 32 px) começa no canto de cima à esquerda da área; não é medida pelo Link, mas o map16 tem a largura dele.
* **Blocos.** Cada tela de 512 px é uma grade de 16x16 **map32** (blocos de 32x32), guardada comprimida na ROM (bytes altos e baixos separados). Cada map32 são 4 **map16** (16x16), e cada map16 são 4 tiles de 8x8 com paleta e espelhamento. O comportamento (parede, água, borda...) é um **atributo por tile de 8x8**, tirado do número do tile.
* **Quantos blocos uma área usa:** de 84 a 386 map16 diferentes por área (a maioria entre 130 e 200); a casa do Link usa 186. Somando as áreas de uma "região" (floresta, lago, deserto, Kakariko): 310 a 491 map16 e 190 a 430 tiles de 8x8 com paleta. O limite do hardware é 512 tiles por área. O mundo da luz inteiro usa 2045 map16 e 5331 map32.
* **Do que o chão é feito (mundo da luz, por tile de 8x8):** sólido 36% (árvores, penhascos, paredes, casas), chão comum (caminho de terra, areia) 25%, grama 21%, água funda 5%, rampa de penhasco (parede diagonal) 4%, mato alto 1,7%, bordas de mão única 3,7% no total, arbustos 1,2%, água rasa 1,1%, escadas 0,2%, pedras 0,3%.
* **Os map32 mais usados** são preenchimentos: copa de floresta, areia, grama, face de penhasco, água. A composição de uma área é preenchimento mais bordas (orla da floresta, beira do penhasco, margem) mais marcos (casa, árvore grande, entrada). Veja `owdump.py vocab`.

## Passagem de tela

* **Pela borda.** Quando o Link chega a 4 a 6 px da borda da área andando para fora, o jogo troca para a área vizinha na grade (`OverworldHandleTransitions`): a câmera rola até a área nova e o Link entra alguns passos. Na troca, recarrega gráficos e paleta, recarrega todos os inimigos e só troca a música se a faixa for outra. É o mesmo movimento da troca de sala das dungeons (e do DoI).
* **Transição especial.** Entrar ou sair da Lost Woods (área 0x00 e a do mundo das trevas) usa mosaico com escurecer em vez da rolagem simples. Quatro lugares levam a áreas especiais por um tile específico no chão (o bosque da Master Sword, a cachoeira dos Zora): `Overworld_CheckSpecialSwitchArea`.
* **Aberturas medidas** (`owdump.py edges`, só a pé, as duas áreas passáveis no mesmo trecho da borda): das 80 ligações entre vizinhos do mundo da luz, 58 têm passagem a pé, 6 só nadando e 16 são fechadas (penhasco, floresta, fosso). Uma ligação aberta tem de 1 a 6 aberturas (1, 2 e 3 são igualmente comuns). Largura das 150 aberturas: 59% têm até 64 px (a mais comum, 48 px), 25% entre 80 e 144 px e o resto são campos abertos de 160 a 416 px.
* **Bordas de mão única (ledges).** Atributos 0x28 (pula para o norte), 0x29 (para o sul), 0x2a (oeste), 0x2b (leste) e 0x2c a 0x2f (diagonais). O Link pula quando empurra a borda com os três pontos de detecção do lado dela e cai no primeiro chão livre depois dela (`Link_FindValidLandingTile_North` e as outras direções). Não dá para voltar pelo mesmo lugar. Desenho: o platô tem o penhasco com a face visível no lado de baixo e a borda baixa (o lábio) nos outros lados.
* **Penhascos e escadas.** A face do penhasco é sólida (rampas diagonais nos cantos, atributo 0x10 a 0x1b). O jeito de subir é uma escada de pedra cortada no penhasco (atributo 0x22 e 0x30 a 0x37, 32 px de largura), uma entrada de caverna que sai em cima, ou uma borda de mão única no caminho de volta. Platô típico: escada de um lado, borda de mão única do outro (atalho de descida), como em volta da casa do Link.
* **Entradas.** 80 pontos de entrada no mundo da luz (porta de casa, boca de caverna na face do penhasco, portão de dungeon, a toca da árvore na Lost Woods) e 9 buracos para cair. A entrada é um map16 com atributo de entrada (0x8e, 0x8f); a porta de madeira de uma casa se abre quando o Link anda nela e fica aberta (`Overworld_UseEntrance`). Entradas escondidas ficam na tabela de segredos (abaixo): escada sob pedra, parede que abre com bomba, buraco sob arbusto.
* **Visuais da transição.** Entrar por uma porta ou caverna: um círculo (o "spotlight", íris) fecha sobre o Link e a sala abre com o círculo se abrindo (`Module0F_SpotlightClose`, `Module10_SpotlightOpen`). Buraco: o Link cai, a tela escurece e ele cai na sala de baixo. Sair de uma sala: o Link aparece andando para fora da porta ou caverna, com o círculo abrindo. Passagem pela borda: rolagem, sem escurecer.

## Obstáculos e itens

Tabela de força (`kGetBestActionToPerformOnTile_a` em `src/player.c`) e comportamento dos atributos (`TileDetect_ExecuteInner` em `src/tile_detect.c`):

| Obstáculo | Atributo | O que pede | Observação |
|-----------|----------|------------|------------|
| Arbusto (verde e o de outra cor) | 0x50, 0x51 | nada (corta com a espada ou levanta) | volta ao reentrar na área |
| Placa (sign) | 0x54 | nada (levanta; de frente, lê) | |
| Pedra pequena clara | 0x52 | Power Glove | |
| Pedra pequena escura | 0x53 | Titan's Mitt | |
| Pedra grande clara | 0x55 | Power Glove (tabela do zelda3) | 32x32 |
| Pedra grande escura | 0x56 | Titan's Mitt | 32x32 |
| Pilha de pedras que cai na batida | 0x57 | Pegasus Boots (investida) | |
| Água funda | 0x08 | Zora's Flippers | sem elas é parede |
| Estaca de martelo | tile 0x21b | Hammer | |
| Chão que se cava | 0x48, 0x4a | Shovel | também a grama comum |
| Parede de caverna rachada | segredo "Bombable" | bombas | abre e fica aberta (salvo no jogo) |
| Alvo do gancho | 0x27 | Hookshot | |
| Mato alto | 0x40 | nada | o Link fica mais lento, a espada corta |
| Cacto, espinho | 0x44 | nada | machuca |

* **Segredos** (tabela por área, map16 escondido sob arbusto, pedra ou mato): no mundo da luz, 147 segredos: rupia verde 41, item aleatório 38, bomba 17, coração 16, abelha 14, portal (só a partir do mundo das trevas) 6, escada escondida sob pedra 5, parede de bomba 4, buraco sob arbusto 3, caranguejo de pedra 3. Toca o som de segredo quando o que aparece é uma passagem.
* **Regra do ALttP:** o caminho principal até a próxima dungeon nunca pede um item que o jogador ainda não pode ter; o item abre atalhos, segredos e o caminho seguinte.

## Inimigos

* **Listas por área e por fase da história:** no mundo da luz, uma lista para o começo (chuva), outra para a primeira parte e outra para a segunda; no mundo das trevas, uma lista só. Cada inimigo tem uma posição fixa (célula de 16x16) na lista da área.
* **Densidade:** área pequena (512x512) tem em média 3,0 inimigos (0 a 8); área grande, 7,9 (0 a 19). É cerca de 0,75 inimigo por quadrante de 256x256 na área pequena e 0,5 na grande, bem menos que uma sala de dungeon.
* **Como nascem e voltam** (`Overworld_LoadSprites`, `Sprite_Overworld_ProximityMotivatedLoad`, `Sprite_KillSelf`): ao entrar na área, as posições da lista são marcadas; cada inimigo nasce quando a câmera chega perto da célula dele (uma faixa logo fora da tela), uma vez. Se ele sai para longe da tela, some e volta a nascer no ponto de origem quando a câmera passar de novo. Morto, não volta enquanto o Link estiver na área. Saindo da área e voltando, todos voltam (a área recarrega a lista). Arbustos cortados também voltam.
* **Os mais comuns** (mundo da luz, primeira e segunda parte): soldado azul 57, Octorok 34, Buzz Blob 31, corvo 27, Armos 27 (em volta do Palácio do Leste), soldado verde 21, caranguejo 17, Tektite 15, Octorok de 4 direções 11, arqueiro 10, caranguejo de arbusto (esconde-se sob arbusto) 9, abelha 8, abutre 6, Ghini 5, soldados de lança 5 a 8. Arquétipos e números estão em `alttp.md`.
* Há também os "overlords", que não são inimigos: geradores de pedras que caem, de inimigos que saem do chão, etc.

## Música e clima

* **Música por área e fase da história** (tabela da ROM, 4 colunas no mundo da luz): no começo (chuva), o tema "Beginning" com chuva forte de som ambiente em volta do castelo (áreas 12, 13, 14, 1A, 1B, 22, 2A, 2B, 2C) e sem chuva no resto. Depois, o tema do overworld em todo lugar, menos a Lost Woods (tema da floresta, nas duas primeiras fases) e Kakariko (tema da vila, áreas 18, 22, 28 e 29). No mundo das trevas, o tema dele, e na Death Mountain das trevas o tema da montanha com vento.
* **Sobreposições** (camada BG1 por cima do mapa, `Overworld_LoadOverlays`): neblina e copa na Lost Woods; nuvens na Death Mountain (áreas 03, 05, 07) e na das trevas; chuva em todo o mundo da luz até a Zelda ser resgatada; chuva no Misery Mire até usar o Ether. A chuva tem o som ambiente e relâmpagos.
* O som ambiente (chuva, vento) é uma faixa separada da música e para ao sair da área que o tem.

## Motivos de composição

Contagens do `stats` e medidas tiradas das imagens do `owdump.py png` sobre a grade do jogo (8, 16 e 32 px a partir do canto da área). As larguras de caminho, rio e ponte foram medidas a olho em poucas áreas e são aproximadas; as de abertura de borda são exatas (`edges`).

* **Floresta.** A massa da floresta são copas de 64x64 sobrepostas numa grade de 32 px; ela forma as "paredes" da área. As clareiras são caminhos sinuosos de 48 a 96 px. Árvores soltas: copa de 32x32 com tronco, ou a árvore grande de 64x64 com raízes. Troncos caídos (32 de largura, 96 a 144 de comprimento) servem de obstáculo ou passagem. Tocos e flores pequenas no chão das clareiras.
* **Penhascos.** Platôs com a face do penhasco visível embaixo (32 a 48 px de altura), cantos em 45 graus, bordas de mão única no lado baixo e escada de 32 px para subir. Bocas de caverna na face do penhasco, centradas num trecho reto.
* **Arbustos.** Em grupos de 2x2 a 3x2 (16 px cada) dos dois lados de uma porta ou de um caminho, quase sempre espelhados; arbustos soltos na beira dos caminhos. Grupos maiores (18 a 32) só em jardins e campos (castelo, Kakariko). Pedras em fileira de 2 a 4.
* **Cercas.** Estacas de madeira de 16 px em linha, retas ou na diagonal, em volta de casas e jardins. Sebes baixas e muretas de pedra no castelo e em Kakariko.
* **Caminhos.** Terra de 32 a 64 px ligando as aberturas da borda às entradas; curvas em 45 graus; flores em pontos de 16 px nas margens.
* **Água.** Rios de 48 a 96 px com margem desenhada, lagos com margem recortada, pontes de 32 a 48 px nos caminhos.
* **Casas.** Telhado de cerca de 96x64 com a porta no meio de baixo, um quintal com arbustos espelhados e às vezes cerca. Kakariko põe as casas numa grade, com sebes entre elas.
* **Simetria.** As áreas são orgânicas no todo, mas os marcos são simétricos: casa e quintal, jardim do castelo, entrada de dungeon com estátuas dos dois lados.

## Outros Zeldas top down (só o que ajuda a decidir)

* **Link's Awakening e Oracles (Game Boy):** o overworld é uma grade de telas de 160x128, uma tela é uma "sala", a troca é por rolagem de tela inteira. Inimigos voltam ao reentrar na tela. É o modelo mais parecido com a grade de salas do DoI.
* **Minish Cap (GBA):** áreas de tamanhos variados com câmera que rola, como no ALttP; troca por rolagem na borda; muitas áreas pequenas de passagem entre as grandes.
* **The Legend of Zelda (NES):** grade de telas de 256x176, uma tela por sala, a borda aberta onde não há rocha ou árvore; entradas em cavernas, escadas sob pedras e paredes de bomba, como o ALttP herdou.
* Em todos: entrada de lugar fechado escurece ou fecha a tela; troca de área ao ar livre rola; os segredos ficam sob arbustos, pedras e paredes.

## Como medir de novo

```bash
python tools/alttp/owdump.py areas
```

* `areas`: uma linha por área (tamanho, música por fase, entradas, buracos, segredos, inimigos por fase).
* `area 0x2c`: tudo de uma área, com o mapa de atributos em texto (um caractere por 16x16).
* `edges`: aberturas entre vizinhos (posição e largura em px; `swim` para as que pedem nadar).
* `stats`: composição por área (map16 e map32 distintos, porcentagem de cada classe, grupos de arbustos).
* `png 0x2c`, `world --scale 0.25`, `vocab`: imagens da área, do mundo e dos map32 mais usados, em `tools/alttp/out/`.

Lacunas: as cores da renderização seguem a paleta da área sem as trocas por evento (a área volta ao padrão quando a paleta é "a mesma de antes" no jogo); a água animada e as sobreposições (neblina, nuvens, chuva) não são desenhadas; o mundo das trevas e as áreas especiais foram só listados, não estudados.
