# Região: Topo do Castelo

Piloto do plano de ferramentas: a primeira região feita pelo fluxo novo (spec, importação, ficha de fase, templates, inimigos, validador, teste). Reaproveita os inimigos do castelo, então o risco fica nas ferramentas e não em mecânicas novas.

* **Estado:** especificada
* **Origem:** ALttP, Castelo de Hyrule na noite da chuva (abertura do jogo), parte de fora e alta do castelo
* **Tipo:** dungeon, parte de fora e alta do castelo (ALttP)
* **Fase:** `DungeonLevel.CastleTop` (novo), nome no jogo "Castle Rooftops"
* **Capítulo:** variante do capítulo 2 (`Depth` 2), ao lado do Castle Basement. Vem depois do capítulo 1 (Hyrule Castle, a entrada do castelo) e segue para o capítulo 3 (Castle Prison, com o chefe)
* **Pools de saída:** entra na `NextPool` do Hyrule Castle com peso 1, ao lado do Castle Basement com peso 2 (cada saída do castelo leva ao topo em 1 de cada 3 sorteios). A `NextPool` dele é só o Castle Prison; `ExitCount` e `ExitHidden` no padrão da ficha
* **Visual da saída:** escadaria para cima (`StairsUp`, já existe: é a escada da entrada de toda fase)
* **Gráficos:** `incoming/topo-do-castelo/` (novo): ameias, telhado e piso de pedra externa extraídos da ROM no PC de casa (área do castelo no mundo da luz e a entrada da Torre de Agahnim)

## Ideia

Em vez de entrar pelos corredores, o Link sobe pelos telhados e passarelas do castelo, debaixo da tempestade da abertura. É o mesmo castelo e os mesmos guardas, mas ao ar livre: chuva caindo sobre a tela, relâmpagos que clareiam tudo por um instante e o trovão logo depois. Chega-se a ele por uma escadaria que sobe, e no fim uma escada desce de volta para dentro, rumo à prisão.

## Visual

* Paredes viram ameias (muretas com vãos) e o piso vira pedra externa molhada; nas bordas, o telhado inclinado faz o papel das paredes laterais. Escadas de torre ligam as alturas.
* Base: tiles do tema do castelo do DoI (linha de `LevelTilesY` do castelo) para portas e escadas, mais as peças da ROM em `incoming/topo-do-castelo/` para ameias, telhado e piso. Recombinar peças da ROM, nada desenhado do zero sem necessidade.
* A noite é a mesma da entrada (nível `Start`): tela azulada e escura, clareada pelos relâmpagos.
* Decoração: estandartes molhados, tochas apagadas pela chuva, poças. Nada animado além da chuva, dos respingos e do relâmpago.
* Prévia obrigatória antes de implementar: uma sala 1x1 e uma 2x1 montadas, com o Link na escala.

## Salas

* Mesma classe de dungeon e mesmos layouts do castelo (`DungeonClass.Castle`, `data_d`); muda só o conjunto de templates de sala, que ganha uma subclasse "Rooftop" (novo) no Tiled.
* Primeira versão: 6 a 8 templates (1x1, 2x1, 1x2 e um 2x2), cada um com função clara: passarela estreita, pátio entre torres, telhado aberto cercado de ameias, sala da escada de descida. Sem torres de parede (Beamos, canhão), como no castelo.
* Salas especiais: entrada (Link chega subindo a escada da torre), saída (escada que desce para a prisão); as demais salas especiais (tesouro e outras que o castelo sorteie) iguais às do castelo.
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
* Trovão: som novo `Sound_Thunder` (novo), extraído da ROM. No ALttP é o efeito 0x36 do banco 1, tocado pelo `OverworldOverlay_HandleRain` (zelda3, `src/overworld.c`).

## Clima e efeitos

* Chuva e relâmpago já existem no `oIntro` (gotas `oRainDrop`, respingos `oRainSplash`, flash branco de 2 ou 3 quadros a cada 30 a 180). Extrair essa parte para um controlador reaproveitável, `oWeather` (novo), usado pela entrada e por esta região, e deixar o `oIntro` só com a introdução.
* Ritmo do ALttP como referência: no original o céu pisca nos quadros 3 a 5, 36 a 44 e 88 a 90 de um ciclo de 256, e o trovão toca no quadro 36. Manter o sorteio do DoI, mas com o trovão alguns quadros depois do flash.
* Com o desafio de escuridão ligado, o relâmpago segue a regra que o `oIntro` já tem.

## Regras especiais

Nenhuma na primeira versão. Ideias para depois (não fazer agora): vento que empurra o Link nas passarelas, buraco no telhado que leva direto à prisão.

## Mudanças no código

A ficha de fase (F4) e os caminhos ramificados (F4b) já existem, então a região é uma entrada nova na ficha:

* `DungeonLevel` ganha o membro do topo (novo) e `Levels_Init` a entrada: `Depth` 2, `Next` e `NextPool` no Castle Prison, `Theme` e `EnemyStats` do castelo, `ExitLook` "StairsUp", a música e a lista de inimigos acima.
* `NextPool` do Hyrule Castle: `[[DungeonLevel.CastleBasement, 2], [<topo>, 1]]`. Só isso liga o sorteio de saídas no castelo (quantas, escondida, destino); nenhuma outra fase muda.
* Salas: subclasse Rooftop (novo) no Tiled e a escolha de templates por ela (`Dungeon_PickTemplateIndex` e o carregamento de templates).
* Clima: criar `oWeather` (novo) no começo da fase e passar o `oIntro` a usá-lo para a chuva e o relâmpago.
* Os soldados: confirmar se usam os números do castelo (`EnemyStats` do castelo, como decidido) agora que a fase está no capítulo 2, onde o porão usa os dele.
* `tools/check/validate.py` e `docs/dev/engine-notes.md`: registrar o que for aprendido.

## Pronto quando

* Em várias runs, o capítulo 2 aparece às vezes como o topo do castelo (por uma escadaria para cima no Hyrule Castle), com salas Rooftop, chuva, relâmpago e trovão, e o capítulo seguinte é a prisão normal.
* Cenários de teste da F3: começar no topo do castelo com semente fixa, andar até a escada de saída e conferir no log que as salas carregaram, os soldados apareceram e nada deu erro; folha de contato com 5 sementes mostrando as salas.
* O validador passa e a entrada (nível `Start`) continua igual com o `oWeather` (novo).
* O Guilherme joga uma run e aprova o visual.

## Decisões

* Mesmos inimigos do castelo, chuva e relâmpagos como no começo da run (roadmap, out/2026).
* É o piloto do plano de ferramentas: só começa depois das etapas F1 a F10, para testar o fluxo inteiro.
* Chance de 1 em 3 e o morcego com peso 1 foram escolhas do Claude dentro da direção de design; mudar se o Guilherme preferir.
* É variante do capítulo 2 (`Depth` 2, no lugar do Castle Basement), entre o Hyrule Castle e o Castle Prison, e a saída que leva a ele é a escadaria para cima (Guilherme, out/2026). A versão anterior desta spec o punha no lugar do Hyrule Castle; isso foi corrigido.
