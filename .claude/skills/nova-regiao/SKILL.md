---
name: nova-regiao
description: Fluxo completo para fazer uma região (fase) nova do Dungeons of Infinity, da especificação ao commit. Use sempre que o Guilherme pedir uma região, fase, estágio, variante de capítulo ou área nova ("nova região X", "faz o topo do castelo", "gráficos em incoming/x", "spec em docs/regioes/x.md"), e também para um ensaio ou plano de região sem implementar ("ensaio", "só o plano", "o que falta para a região X"). Cobre spec, importação de gráficos, ficha de fase e pools de saída, salas do Tiled, inimigos por arquétipo, testes, validador, documentação e o texto do commit, e para quando a região pede algo que as ferramentas ainda não fazem.
---

# Nova região

Uma região é uma fase jogável inteira, variante de um capítulo da run (o `Depth` da ficha de fase). Esta skill leva da especificação ao commit pelas ferramentas do "Plano de ferramentas" do `docs/roadmap.md` (F3 a F7). Ela não substitui o `CLAUDE.md`: as regras de lá valem (português, sem setas nem travessões, nada de prints nem teclado, o Guilherme faz o commit).

## Regra principal: parar em vez de improvisar

Quando a região pedir algo que as ferramentas ainda não fazem, **pare antes de implementar** e diga ao Guilherme o que falta, qual etapa resolveria e quais as alternativas dentro da direção de design. Não invente meio caminho (um gerador de área externa às pressas, um movimento de inimigo escrito à mão dentro do objeto, templates desenhados por chute). A lista do que falta, com como reconhecer e o que resolve, está em `references/lacunas.md`. Leia-a no começo de todo uso desta skill.

Três tipos de pendência, tratados de jeitos diferentes:

* **Lacuna de ferramenta** (`GAP` no `status.py`): o fluxo não cobre. Pare e reporte.
* **Entrega do Guilherme** (`WAIT`): gráficos em `incoming/<regiao>/`, uma decisão de design. Pare e peça.
* **Código próprio da região** (`todo` com "(novo)" na spec): o que a spec já prevê em "Mudanças no código" e o Guilherme aprovou (ex.: um controlador de clima). Isso é trabalho normal da região, não lacuna; siga.

## Modos

* **Ensaio** ("ensaio", "plano", "o que falta"): faça só os passos 0 e 1, monte o plano completo no formato de `references/plano.md` e entregue. Não mexa em `game/` nem gere salas.
* **Produção** (o pedido normal): passo 0, passo 1 e o plano. O turno acaba no plano quando há lacuna, espera, spec recém-escrita ou prévia visual a aprovar (a spec pede, ou o `CLAUDE.md` pede para tudo o que é grande e visual). Sem nada disso, o plano é só informativo e os passos 2 a 9 seguem na ordem, no mesmo turno.

## Passo 0. Ler e conferir o estado

1. Leia os documentos que o `CLAUDE.md` manda (roadmap, direção, engine-notes, receitas), só as seções que importam, e `references/lacunas.md`.
2. `git status --short` e `git log --oneline -3`: avise se houver mudanças pendentes ou se estiver atrás do `origin/main`.
3. `python tools/region/status.py <regiao>`: lê a spec e o projeto e diz, passo a passo, o que já existe (`ok`), o que fazer (`todo`), o que falta nas ferramentas (`GAP`) e o que o Guilherme precisa entregar (`WAIT`). É o ponto de partida do plano, não a última palavra: leia a spec inteira, porque o script só reconhece os casos conhecidos.
4. Só na produção, antes de mexer em qualquer coisa de `game/` (a importação do passo 2 já mexe): `python tools/test/baseline.py save before` em segundo plano. É a referência do passo 7; feito depois, precisa de uma cópia do commit (receita "Comparar antes e depois").

## Passo 1. Especificação (`docs/regioes/<regiao>.md`)

Receita "Especificação de região" em `docs/dev/receitas.md`; modelo em `docs/regioes/_modelo.md`.

* Sem spec: copie o modelo e preencha a partir do pedido e da direção de design. Mostre ao Guilherme antes de construir (é o primeiro ponto de parada da produção).
* Confira os campos que guiam o fluxo: **Fase** (o membro de `DungeonLevel`), **Capítulo** (`Depth` N, de onde vem, para onde vai), **Pools de saída** (em quais `NextPool` do capítulo anterior entra e com que peso; a `NextPool` dela), **Visual da saída** (`ExitLook`), **Gráficos** (pasta em `incoming/` ou "só assets que já existem").
* Números de inimigos, chefes e itens vêm de `docs/ref/` (`alttp.md`, `doi.md`); se faltar, a ficha vai lá, não na spec.
* Leia a spec com olho de lacuna: tipo área externa, sala que depende da conversão do ALttP, inimigo com movimento que o arquétipo não tem, som novo, tileset novo, conjunto de salas próprio. Cada um está em `references/lacunas.md`.
* Mude o **Estado** para "em produção" quando começar a implementar (não no ensaio).

## Passo 2. Gráficos e música (F6)

Receita "Importar gráficos de uma região"; convenção em `incoming/README.md`.

1. `python tools/import/import_region.py <regiao> --dry-run`; leia o relatório e, no primeiro lote ou com aviso de cor ou contorno, a prévia `tools/import/out/<regiao>/preview.png`.
2. Ajuste o `manifest.json` até não sobrar aviso que importe; prévia ao Guilherme se a conversão mudou muito o original.
3. `python tools/import/import_region.py <regiao>`, depois `python tools/check/validate.py` e `python tools/test/run.py boot`.
4. Prova: `boot` com `RESULT: ok` e o `imported.json` no commit.

Para: `tileset.png` (a faixa não liga ao jogo ainda) e `sounds/` (o importador só lê música). Ver lacunas.

## Passo 3. Ficha de fase e pools de saída (F4, F4b)

Receita "Estágio alternativo" (passos 1 a 3); detalhes em `docs/dev/engine-notes.md` ("Level sheet", "Branched exits").

1. Membro novo no **fim** do `enum DungeonLevel` (`game/scripts/__Dungeon/__Dungeon.gml`) e `_L[DungeonLevel.X] = new Level_Create(...)` mais um bloco `with` em `Levels_Init` (`__Levels.gml`), copiado da fase mais parecida, com o nome em inglês. O `Level_Create` tira vários padrões do índice do enum, que numa fase nova não tem nada a ver com o capítulo; por isso, sempre explícitos: `Depth`, `Next` (padrão: o índice seguinte), `Theme`, `BaseTheme` e `EnemyStats` (de quem é a arte e os números), `StartDir` (padrão pela paridade do índice; use o das outras variantes do capítulo, porque ele decide por qual lado o Link entra e qual parede tem a saída), `Class`, `Song`, `Dark`, `Enemies`, `ExitLook`. A macro `DungeonLevels` (`__Dungeon.gml`) conta as fases e hoje não é usada; acerte o número mesmo assim.
2. `NextPool` de cada fase do capítulo anterior com a fase nova e o peso da spec. Isso já liga os sorteios de `ExitCount` e `ExitHidden` naquelas fases.
3. Visual da saída novo: entrada em `ExitLooks_Init` (`__Doors.gml`) com desenho, sons, `LinkAnim`, `Entrance` e `MapIcon`; o Link acompanha os degraus desenhados. Mostre prévia antes (é visual).
4. Se a fase anterior for o Hyrule Castle e a nova tiver `SaveBefore`, pare: a sala de descanso logo depois do castelo tem um defeito conhecido (roadmap, Ideias).
5. Prova: o validador (confere o `ExitLook`) e, no passo 7, o log `exits main-><fase>` na fase anterior.

## Passo 4. Salas (Tiled e conversor, F5)

Receita "Template de sala no Tiled".

* Reaproveitar os templates de uma classe existente não pede nada: a fase só escolhe `Class` e `Theme`.
* Template novo ou conjunto de salas só da região: hoje é lacuna (ver `templates-novos` e `templates-por-fase`). Pare.
* Quando houver como (ajudante de templates, F8): `python tools/templates/convert.py --summary`, `git diff --stat` mostrando só o arquivo da classe e as linhas das salas novas, validador (acusa Tiled sem conversão).

## Passo 5. Inimigos (F7)

Receitas "Inimigo novo por arquétipo" e "Variante de inimigo por fase".

* Inimigo que já existe: só a lista `Enemies` da ficha. Confira, no `Create` do objeto, o que ele lê de `LevelDef.EnemyStats` (vários decidem tipo, energia ou ataque por ali; `docs/ref/doi.md` lista quem). Outra cor ou outros números pela ficha (`EnemyVariants`) só nos soldados e nos arquétipos; nos outros, escolha o `EnemyStats` da fase ou pare e pergunte (lacunas, armadilhas).
* Inimigo novo simples: arquétipo (`EnemyArch` em `__EnemyArch.gml`, objeto sem eventos filho de `oEnemy_Archetype`, `EnemyDataInit`). Movimentos que existem: `Dir`, `Toward`, `Scuttle`, `Dash`. Atirar, pular, voar em onda e se esconder ainda não existem: pare.
* Chefe com mecânica nova: código próprio, prévia e uma ou duas rodadas de ajuste; avise no plano.
* Prova: cenário com `spawn` e `trace` (como `arch_patterns.json`) e leitura do log.

## Passo 6. Clima, música e regras próprias

O que a spec pede em "Música e som", "Clima e efeitos" e "Regras especiais". Só o que ela prevê em "Mudanças no código"; o resto é pergunta ao Guilherme. Ao mexer em algo compartilhado (ex.: tirar a chuva do `oIntro`), a fase de origem precisa sair igual: cenário de referência dela antes e depois.

## Passo 7. Testes (F3, F3b)

Receitas "Teste automático", "Folha de contato" e "Comparar antes e depois". Nada de prints nem `--show`.

1. O baseline `before` foi feito no passo 0. Se não foi, faça agora numa cópia do commit (receita "Comparar antes e depois").
2. Cenário de referência novo `tools/test/scenarios/ref_NN_<Fase>.json`, copiado do `ref_*` mais parecido (no `probe`, só inimigos da fase).
3. Cenário da região (`<regiao>.json`): começa na fase com semente fixa, `state`, anda até a saída (`exit`), `expect` com `exit_level` (se a fase seguinte tiver `SaveBefore`, o Link passa antes pela sala de descanso). E, na fase anterior, um cenário com `exit` em `main` e `extra` para provar a ligação pela pool.
4. Folha de contato: `python tools/test/run.py --sheet <Fase> --seeds 5`. Olhe o PNG só se for decidir algo.
5. Durante o trabalho, só os cenários afetados (`run.py <regiao> ref_NN_<Fase>`). Antes da entrega, a bateria inteira uma vez em segundo plano: `python tools/test/run.py --all --save after`, e `python tools/test/baseline.py compare before after --handles` (sprites novos mudam os números das sprites e surfaces nos dumps). As fases antigas devem sair iguais, menos: a fase anterior (que agora sorteia saídas), a linha do global `LevelDefs` em todo dump (ganhou uma entrada), globais novos que a região criar e o que a spec mudou de propósito (ex.: a fase de origem de algo compartilhado). Explique cada diferença.

## Passo 8. Validador e documentação

* `python tools/check/validate.py` sem erros. Armadilha nova vira checagem no validador.
* Spec: Estado "pronta" (ou "em produção" se faltar o Guilherme aprovar jogando) e as decisões na seção Decisões.
* `docs/roadmap.md`: Pronto, Próximos passos, Ideias, Decisões. `docs/ref/doi.md`: a fase nova na tabela de níveis e os inimigos. `docs/dev/engine-notes.md` e `docs/dev/receitas.md`: o que foi aprendido. `tools/README.md` se uma ferramenta mudou.
* Se o fluxo desta skill estiver errado ou faltando um caso, corrija a skill e `references/lacunas.md` no mesmo commit.

## Passo 9. Entrega

Formato em `references/plano.md` ("Entrega"): o roteiro de teste para o Guilherme jogar (poucos passos, o que deve aparecer na tela, a linha do log) e o título e a descrição do commit em inglês. O Guilherme faz o commit e o push.
