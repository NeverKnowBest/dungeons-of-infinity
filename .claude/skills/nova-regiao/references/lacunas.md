# Lacunas conhecidas

O que uma região pode pedir e as ferramentas ainda não fazem (out/2026). Cada lacuna tem a chave que o `tools/region/status.py` imprime (`GAP [chave]`), como reconhecer, por que parar e o que resolveria. Quando uma lacuna for resolvida, apague-a daqui e do `status.py` no mesmo commit; quando aparecer uma nova, acrescente.

Ao reportar uma lacuna ao Guilherme: diga o que a região pede, por que o fluxo não cobre, a etapa que resolveria e, se houver, uma alternativa dentro da direção de design que evita a lacuna (ele escolhe).

## `salas-classe`: salas que o ajudante ainda não escreve

* **Reconhecer:** a spec pede salas próprias de uma classe que não é `Main_Upper` nem `Main_Lower` (escadas internas `Stairs`, obstáculos `Obstacles`, seções `Sections`, celas `Jails`), ou seções numa sala do andar de baixo.
* **Por que falta:** o `tools/templates/make_rooms.py` (F11) escreve meias salas `Main_Upper` (com as seções 1, 2, 9 e 17) e `Main_Lower` (sem seções). O conjunto de salas e o sorteio por conjunto já valem para qualquer classe do sorteio genérico (`RoomTemplates_PickFrom`), mas os mapas dessas classes teriam de ser desenhados no Tiled.
* **Resolveria:** ensinar a classe ao `make_rooms.py` (as camadas de cada classe estão em `convert.py`, `OBJ_TYPES` e `SECTION_OBJ_TYPES`), provado como na F11: comparar a geometria com templates reais da classe e um cenário com o conjunto.
* **Alternativa:** essas salas ficam com os templates compartilhados (`RoomSetFallback`, o padrão), com a aparência do tema da fase. O Guilherme decide.

## `salas-motivo`: disposição de decoração que o catálogo não tem

* **Reconhecer:** a spec pede uma disposição de peças que nenhum motivo de `data/room-templates/motifs.json` faz (`python tools/templates/motifs.py --report`), por exemplo estátuas ladeando uma porta lateral ou tochas no meio do piso; o `make_rooms.py` recusa a peça como "loose piece", ou o motivo pedido "finds no place" com qualquer recuo e tamanho do catálogo.
* **Por que falta:** o catálogo (F11b) só tem o que pelo menos 3 meias salas compartilhadas do DoI fazem, e a checagem recusa o resto de propósito, para nenhuma sala sair com peça solta.
* **Resolveria:** uma fonte nova de motivos para o `motifs.py`: as salas do ALttP pelo `tools/alttp/roomdump.c` (precisa da ROM e do zelda3, nos dois PCs fora do repositório; se faltarem, peça ao Guilherme) ou de outro Zelda top down, medidas com as mesmas âncoras. Ou uma âncora nova (ex.: `door`, ao lado de uma porta) medida nas salas que já existem. Prova como na F11b: o catálogo cobre as salas de origem e a checagem recusa o que continua solto.
* **Alternativa:** um motivo parecido do catálogo (outra âncora ou recuo), ou a sala sem essa peça. O Guilherme decide.

## `arquetipo`: movimento de inimigo que a F7 não tem

* **Reconhecer:** inimigo novo (novo) que atira, pula, voa em onda ou se esconde no chão.
* **Por que falta:** os movimentos do arquétipo são `Dir`, `Toward`, `Scuttle` e `Dash`. `Shoot`, `Hop`, `Wave` e `Hide` estão na lista "Falta" da F7 no roadmap.
* **Resolveria:** o próximo chat da F7, com um inimigo existente convertido como prova (`arch_trace` antes e depois).
* **Alternativa:** inimigo existente do DoI com esse comportamento (ex.: Keese, Octorok). Cor e números vêm do nível do `EnemyStats` da fase, como o `Create` de cada um decide; a variante na ficha não serve para eles (veja as armadilhas).

## `area-externa`: região ao ar livre

* **Reconhecer:** Tipo "área externa" (jardim, campina, floresta), passagem de tela pela borda em vez de portas.
* **Por que falta:** o gerador só monta dungeons (grade de salas com portas). A Rebel Village e as minas são layouts fixos de centro de NPC, não o modelo (decisão "Áreas externas" no roadmap).
* **Resolveria:** a F12b (áreas externas, roadmap), proposta em `docs/design/areas-externas.md`, com a ficha do overworld em `docs/ref/alttp-overworld.md`. Desde a F6b já existem o tileset da região com a classe de cada tile (`owdump.py tiles`, `RegionTiles` na ficha, `RegionTiles_PaintBlock` e `RegionTiles_ClassAt` em `__Tiles`); desde a F12b-1, as salas pintadas tile a tile (`kit` e `painted` no `rooms.json`, receita "Sala pintada com o tileset da região"), a colisão pelas classes e o `Layout` Outdoor com passagem sem moldura. Desde a revisão do topo do castelo (out/2026), também as portas ao ar livre numa sala pintada (trancada com blocos de fechadura, secreta como parede rachada, sem porta que fecha), a entrada e a saída por uma porta pintada na parede com animação (`gate` no kit, `OwnExitLooks`, `ArriveLook`, `ExitWall`), os motivos de natureza e as salas especiais pintadas (`specials`). Faltam a classe de layout aberta própria, a chegada e a saída pela borda da tela, bordas de mão única e a sala de descanso externa (partes seguintes da F12b).

## `f8`: sala que depende da conversão do ALttP

* **Reconhecer:** a spec diz que as salas saem de salas do ALttP convertidas (não só "referência para a F8").
* **Por que falta:** a F8 (dump do `roomdump.c` para template do Tiled) vem depois do piloto.
* **Resolveria:** a F8.

## Entregas do Guilherme (`WAIT`, não é lacuna de ferramenta)

* **Gráficos:** `incoming/<regiao>/` não existe e a spec não diz "só assets que já existem". Extrações da ROM funcionam nos dois PCs (a ROM e o zelda3 ficam fora do repositório; se faltarem no PC, peça ao Guilherme). Peça a pasta seguindo `incoming/README.md`.
* **Decisões:** escolha de alternativa a uma lacuna, peso de pool fora da direção, mecânica nova de chefe. Pergunte.

## Casos que não são lacuna (seguir)

* Salas próprias `Main_Upper` e `Main_Lower` (formas, portas, seções, água, espinhos): conjunto de salas da região pelo `make_rooms.py` e `RoomSet` na ficha (F11, skill passo 4).
* Inimigos que já existem, com os números do nível do `EnemyStats` ou, nos soldados e nos arquétipos, com variante na ficha (`EnemyVariants`).
* `ExitLook` novo: entra em `ExitLooks_Init` sem mexer no gerador (receita "Estágio alternativo", passo 3). Pede prévia, por ser visual.
* Música nova em `incoming/<regiao>/music/`; efeito sonoro novo em `incoming/<regiao>/sounds/` (da ROM pelo `tools/alttp/sfx.py`).
* Tiles próprios: faixa de tema (`tileset.png`, `TilesBand` na ficha) ou tileset da região (`tiles/`, `owdump.py tiles` para peças do overworld do ALttP, `RegionTiles` na ficha). Peças de salas de dungeon do ALttP saem pelo `roomdump.c`.
* Código próprio que a spec prevê em "Mudanças no código" (ex.: `oWeather` no topo do castelo). O clima não é campo da ficha; a região cria o controlador e a ficha pode ganhar um campo para ele.

## Armadilhas conhecidas do fluxo

Pedem cuidado, mas não param, menos a última.

* O `Level_Create` tira padrões do índice do enum, que numa fase nova não bate com o capítulo: `Depth` e `Theme`/`BaseTheme`/`EnemyStats` (o próprio índice), `Next` (o índice seguinte) e `StartDir` (a paridade do índice). Todos explícitos; o `StartDir` igual ao das outras variantes do capítulo.
* `EnemyVariants` na ficha só vale para quem chama `Enemy_ApplyVariant()`: os soldados e os inimigos de arquétipo. Os outros (Keese, Octorok, Bari, Poe...) decidem tipo, cor e números no `Create` pelo `LevelDef.EnemyStats`; o `status.py` avisa quais leem o `EnemyStats`. Passar um deles para variantes está na lista "Falta" da F7.
* Fase com chefe e fases de layout fixo (`Special`) nunca têm saída extra.
* **Esta para:** a sala de descanso logo depois do Hyrule Castle usa a ficha do castelo e o `RunStart` dele (roadmap, Ideias). Se a fase nova vem do castelo e tem `SaveBefore`, é lacuna.
