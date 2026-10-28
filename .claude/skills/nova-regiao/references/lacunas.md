# Lacunas conhecidas

O que uma região pode pedir e as ferramentas ainda não fazem (out/2026). Cada lacuna tem a chave que o `tools/region/status.py` imprime (`GAP [chave]`), como reconhecer, por que parar e o que resolveria. Quando uma lacuna for resolvida, apague-a daqui e do `status.py` no mesmo commit; quando aparecer uma nova, acrescente.

Ao reportar uma lacuna ao Guilherme: diga o que a região pede, por que o fluxo não cobre, a etapa que resolveria e, se houver, uma alternativa dentro da direção de design que evita a lacuna (ele escolhe).

## `salas-classe`: salas que o ajudante ainda não escreve

* **Reconhecer:** a spec pede salas próprias de uma classe que não é `Main_Upper` nem `Main_Lower` (escadas internas `Stairs`, obstáculos `Obstacles`, seções `Sections`, celas `Jails`), ou seções numa sala do andar de baixo.
* **Por que falta:** o `tools/templates/make_rooms.py` (F11) escreve meias salas `Main_Upper` (com as seções 1, 2, 9 e 17) e `Main_Lower` (sem seções). O conjunto de salas e o sorteio por conjunto já valem para qualquer classe do sorteio genérico (`RoomTemplates_PickFrom`), mas os mapas dessas classes teriam de ser desenhados no Tiled.
* **Resolveria:** ensinar a classe ao `make_rooms.py` (as camadas de cada classe estão em `convert.py`, `OBJ_TYPES` e `SECTION_OBJ_TYPES`), provado como na F11: comparar a geometria com templates reais da classe e um cenário com o conjunto.
* **Alternativa:** essas salas ficam com os templates compartilhados (`RoomSetFallback`, o padrão), com a aparência do tema da fase. O Guilherme decide.

## `tileset`: tiles próprios da região

* **Reconhecer:** `incoming/<regiao>/tileset.png`, ou a spec pede paredes, piso ou decoração de tile que nenhum tema tem (o `Theme` de outra fase não serve).
* **Por que falta:** o `sTiles` está cheio (100 linhas) e o `LevelTilesY` deriva do índice do tema; o importador grava a faixa como `sTiles_<Regiao>`, mas nada liga essa faixa ao tileset do jogo (roadmap, Ideias, "Tileset de região").
* **Resolveria:** a etapa F6b (PC de casa): aumentar a imagem do `sTiles`, acertar o `tile_count` do `tilesets/Tileset`, mapear o tema novo para a faixa nova e fazer o importador escrever nela. Os 14 de referência devem sair iguais.
* **Alternativa:** usar o tema de uma fase existente (como o Castelo) e pôr o que for único em sprites de decoração (objetos), que o importador já faz.

## `sfx`: efeito sonoro novo

* **Reconhecer:** a spec cita `Sound_X` (novo).
* **Por que falta:** o importador só lê `music/*.wav` (vira `Music_X` e entra no `SongIndex`); não há `sounds/`. Em `tools/alttp/` o `musicdump.c` renderiza músicas, não os efeitos dos bancos de som.
* **Resolveria:** a etapa F6b (PC de casa): `sounds/*.wav` no importador (vira `Sound_X`, sem `SongIndex`) e, para tirar da ROM, um modo de efeito no `musicdump.c` (PC de casa, que tem a ROM).
* **Alternativa:** o Guilherme entrega o `.wav` gravado de outra forma, e o som entra com `gm_assets.sound(...)` à mão; ou a região fica sem o som na primeira versão.

## `arquetipo`: movimento de inimigo que a F7 não tem

* **Reconhecer:** inimigo novo (novo) que atira, pula, voa em onda ou se esconde no chão.
* **Por que falta:** os movimentos do arquétipo são `Dir`, `Toward`, `Scuttle` e `Dash`. `Shoot`, `Hop`, `Wave` e `Hide` estão na lista "Falta" da F7 no roadmap.
* **Resolveria:** o próximo chat da F7, com um inimigo existente convertido como prova (`arch_trace` antes e depois).
* **Alternativa:** inimigo existente do DoI com esse comportamento (ex.: Keese, Octorok). Cor e números vêm do nível do `EnemyStats` da fase, como o `Create` de cada um decide; a variante na ficha não serve para eles (veja as armadilhas).

## `area-externa`: região ao ar livre

* **Reconhecer:** Tipo "área externa" (jardim, campina, floresta), passagem de tela pela borda em vez de portas.
* **Por que falta:** o gerador só monta dungeons (grade de salas com portas). A Rebel Village é o único precedente.
* **Resolveria:** a etapa futura "Áreas externas" (roadmap, Ideias).

## `f8`: sala que depende da conversão do ALttP

* **Reconhecer:** a spec diz que as salas saem de salas do ALttP convertidas (não só "referência para a F8").
* **Por que falta:** a F8 (dump do `roomdump.c` para template do Tiled) vem depois do piloto.
* **Resolveria:** a F8.

## `rom-externo`: gráficos do mundo externo do ALttP

* **Reconhecer:** a spec quer peças do overworld do ALttP (exterior do castelo, telhados, campina) como tiles. O `status.py` não detecta; leia a seção Visual.
* **Por que falta:** em `tools/alttp/`, o `roomdump.c` e o `z3room.py` renderizam salas de dungeon e o `sprdump.c` só os sprites (OBJ) de uma área externa; nada renderiza o fundo (BG, map16) do overworld.
* **Resolveria:** um `owdump.c` no PC de casa (com a ROM), no molde do `roomdump.c`. Ou o Guilherme recorta as peças de outra fonte e entrega em `incoming/`.
* **Alternativa:** peças de salas de dungeon (ex.: a entrada da Torre de Agahnim, que é sala de dungeon e o `roomdump.c` já tira).

## Entregas do Guilherme (`WAIT`, não é lacuna de ferramenta)

* **Gráficos:** `incoming/<regiao>/` não existe e a spec não diz "só assets que já existem". Extrações da ROM são no PC de casa. Peça a pasta seguindo `incoming/README.md`.
* **Decisões:** escolha de alternativa a uma lacuna, peso de pool fora da direção, mecânica nova de chefe. Pergunte.

## Casos que não são lacuna (seguir)

* Salas próprias `Main_Upper` e `Main_Lower` (formas, portas, seções, água, espinhos): conjunto de salas da região pelo `make_rooms.py` e `RoomSet` na ficha (F11, skill passo 4).
* Inimigos que já existem, com os números do nível do `EnemyStats` ou, nos soldados e nos arquétipos, com variante na ficha (`EnemyVariants`).
* `ExitLook` novo: entra em `ExitLooks_Init` sem mexer no gerador (receita "Estágio alternativo", passo 3). Pede prévia, por ser visual.
* Música nova em `incoming/<regiao>/music/`.
* Código próprio que a spec prevê em "Mudanças no código" (ex.: `oWeather` no topo do castelo). O clima não é campo da ficha; a região cria o controlador e a ficha pode ganhar um campo para ele.

## Armadilhas conhecidas do fluxo

Pedem cuidado, mas não param, menos a última.

* O `Level_Create` tira padrões do índice do enum, que numa fase nova não bate com o capítulo: `Depth` e `Theme`/`BaseTheme`/`EnemyStats` (o próprio índice), `Next` (o índice seguinte) e `StartDir` (a paridade do índice). Todos explícitos; o `StartDir` igual ao das outras variantes do capítulo.
* `EnemyVariants` na ficha só vale para quem chama `Enemy_ApplyVariant()`: os soldados e os inimigos de arquétipo. Os outros (Keese, Octorok, Bari, Poe...) decidem tipo, cor e números no `Create` pelo `LevelDef.EnemyStats`; o `status.py` avisa quais leem o `EnemyStats`. Passar um deles para variantes está na lista "Falta" da F7.
* Fase com chefe e fases de layout fixo (`Special`) nunca têm saída extra.
* **Esta para:** a sala de descanso logo depois do Hyrule Castle usa a ficha do castelo e o `RunStart` dele (roadmap, Ideias). Se a fase nova vem do castelo e tem `SaveBefore`, é lacuna.
