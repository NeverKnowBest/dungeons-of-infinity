# Roadmap

Estado do projeto, próximos passos e decisões tomadas. Atualize no fim de cada etapa.

## Pronto

* **Santuário (hub):** a run começa e recomeça no Santuário original do ALttP (sala 0x12), com a música da igreja e o fogo animado nas lamparinas do altar. A passagem atrás do altar está fechada.
* **Saída pela porta da frente:** abre o menu de partida: escolher o item inicial (bônus), mexer nos desafios (mesma tela do menu de título antigo) ou ficar.
* **Flute Boy:** fica num canto à esquerda, atrás de uma banca de lado decorada (toalha, vasos, bandeirinhas). Falando com ele, abre o guarda-roupa de skins.
* **Conquistas:** 16 conquistas em 4 estátuas: Armos (bronze), Lanmola e Moldorm (prata), Agahnim (ouro). Elas liberam skins e itens iniciais. Tudo começa bloqueado num usuário novo, e quem já zerou ganha retroativamente as conquistas que uma vitória implica.
* **Hall of Fame:** sala à direita da igreja, com as 4 estátuas na parede de cima. Cada estátua fica em silhueta com "?" até completar as conquistas dela. Falando com uma estátua, abre a galeria dela com as conquistas e o que cada uma pede.
* **Menu de título:** só Start (e Continue). A intro pula com qualquer tecla e para na tela de título.
* **README:** GIF da tela de título com brilho na espada e no logo.
* **Validador estático** (`tools/check/validate.py`): confere o projeto sem GameMaker (recursos do `.yyp`, eventos dos objetos, imagens e sons, funções duplicadas, assets inexistentes no GML, armadilhas conhecidas, dados e estilo das docs). Rodar antes de toda entrega. Etapa F2 do plano de ferramentas.
* **Faxina do código morto** (etapa F1): apagadas as 424 pastas de recursos fora do `Zelda.yyp`, os `.gml` de eventos que os objetos não têm e acertados os 48 caminhos com maiúsculas e minúsculas diferentes. O validador não lista mais órfãos.
* **Conversor de templates em Python** (etapa F5): `tools/templates/convert.py` gera as salas do jogo a partir dos mapas do Tiled em `data/room-templates/`, em uns 10 s, sem GameMaker. A saída é idêntica, pelo conteúdo, ao último `data_r` do projeto GameMaker `editors/room-template-parser`, que foi apagado. O `data_r` único de 46 MB (Git LFS) virou `game/datafiles/data/rooms/<Classe>.json`, um arquivo por classe com um template por linha, em git normal: o diff mostra quais salas mudaram. O jogo lê os dez arquivos (`RoomTemplates_Load`) e registra a contagem no log; o `tools/hub/build3.py` chama o conversor; o validador acusa quando o Tiled muda e as salas não foram geradas de novo. Testado no jogo: título, hub e começo da run.
* **Teste automatizado** (etapa F3): `python tools/test/run.py <cenário>` compila o jogo com o Igor (acha o runtime e a pasta do usuário sozinho), roda um cenário JSON sem ninguém no teclado e mostra o resultado em texto: erros de compilação, o log do teste e `RESULT: ok` ou `FAILED`. O modo de teste do jogo (`scripts/__Test`, objeto `oTest`, ativado por `-test` ou `DOI_TEST`) pula título e menus, não grava nada, aplica semente, fase, itens e cheats, executa os passos (andar, atacar, esperar, ir a uma sala, trocar de fase, criar inimigo, conferir) e registra fase, sala, morte de inimigo, dano, prints e erros de GML com a pilha. Folha de contato: `--sheet Castle --seeds 4` monta todas as salas de N fases num PNG. Cenários `boot` e `smoke` em `tools/test/scenarios/` (o validador confere os cenários). Testado no PC do trabalho: `smoke` passa do começo ao fim e repete igual.
* **Ficha de fase** (etapa F4): tudo o que muda de um nível para outro está em `game/scripts/__Levels/__Levels.gml` (`global.LevelDefs`, lido pela macro `LevelDef`): nome, profundidade na run, próximo nível, tema de tiles e de decoração (`Theme`), classe de dungeon, música, escuridão, água, obstáculos, chefe, conquistas, regras especiais e a lista de inimigos com peso (a tabela de inimigos foi invertida: `EnemyDataInit` não tem mais coluna por nível). Os `switch`/`== DungeonLevel.X` espalhados em 59 arquivos saíram; as regras de decoração ficaram por tema (`switch(LevelDef.Theme)`), então uma fase nova que usa a arte do castelo herda tudo com `Theme: DungeonLevel.Castle`. Conferido pelos 14 cenários de referência (`tools/test/baseline.py`): as 14 fases saem idênticas antes e depois (salas, objetos e variáveis, tiles, folhas de contato, inimigos).
* **Cenários de referência por fase:** `tools/test/scenarios/ref_00_Start` a `ref_13_Aghanim2` (três montagens da fase com dump completo, inimigos que mudam por nível, uma caminhada curta e folha de contato) e `tools/test/baseline.py` (`save <rótulo>`, `compare a b`). Receita em `docs/dev/receitas.md` ("Comparar antes e depois").
* **Fichas de referência e especificação de região** (etapa F9): `docs/ref/alttp.md` (inimigos, chefes e itens do ALttP com vida, dano, velocidade, arquétipo e a função do zelda3), `docs/ref/doi.md` (tudo o que o jogo já tem, com energia, ataque, pesos por nível, soldados por nível, níveis, chefes e clima), `docs/regioes/_modelo.md` (modelo de região) e a primeira spec, `docs/regioes/topo-do-castelo.md` (o piloto). O validador confere as specs.

## Decisões (não desfazer sem conversar)

* As recompensas são segredo, como em Binding of Isaac. Nada mostra o que uma conquista libera antes de você conseguir; só o aviso na hora mostra.
* Itens iniciais e skins bloqueados aparecem como "???" e sem dica.
* As estátuas ficam fisicamente na sala; o jogador anda até cada uma para ver. Nada de girar, nada de estátua gigante no meio da sala, e o Link não passa por trás delas.
* A troca de sala no hub é igual à das dungeons (câmera rola, Link chega na porta e entra).
* Visual sempre com assets do ALttP ou do DoI; recombinar peças da ROM é melhor que desenhar do zero. Nada de copiar uma sala inteira para outro uso.
* A decoração do Flute Boy é comemorativa, não de loja e nem de Natal.
* O tempo de jogo só conta a partir da saída do Santuário. No Santuário, a pausa não mostra o tempo nem "Give Up".
* Jogo em janela nos dois PCs (QoL), via `options.ini`.
* Antes de conteúdo novo grande, investir nas ferramentas do "Plano de ferramentas" abaixo (aprovado em out/2026). Meta: uma região inteira a partir de um prompt, com os gráficos entregues pelo Guilherme numa pasta.
* O Claude pode rodar `tools/test/run.py` por conta própria e conferir pelo texto (log e `RESULT`), sem prints de tela (out/2026, regra no CLAUDE.md). Jogar continua com o Guilherme.
* O código morto pode ser apagado sem backup extra: a faxina vai num commit só dela, que pode ser revertido no GitHub Desktop, e o código 1.2.1 original está no archive.org.

## Plano de ferramentas (fazer antes do conteúdo novo)

Objetivo: deixar o projeto pronto para que uma região inteira (fase com salas, inimigos, chefe, música e clima) saia de um único prompt. Um chat por etapa, na ordem abaixo. Ao terminar uma etapa, marque como pronta aqui e mova o resumo para "Pronto".

**F1. Faxina do código morto** (pronto)
* Apagar os recursos que estão no disco mas não no `Zelda.yyp` (424 pastas: 91 scripts, 87 objetos, 219 sprites, 20 sons e outros). A lista sai de `python tools/check/validate.py --orphans`. Eles nem compilam, mas aparecem em toda busca e confundem (ex.: `_Enemies` e `__Enemies` com `EnemyDataInit` de assinaturas diferentes).
* Apagar também os `.gml` de eventos que o objeto não tem (o validador avisa: "is not an event of the object"); eles nunca rodam.
* Acertar os 48 caminhos que diferem do `.yyp` só em maiúsculas e minúsculas (funciona no Windows, quebra no Linux).
* Pronto quando: o validador não lista órfãos e o jogo roda igual (hub, uma run até o nível 2). Commit só com a faxina.

**F2. Validador estático** (pronto)
* `tools/check/validate.py`. Crescer junto com o projeto: toda armadilha nova do GML ou dos dados vira uma checagem.

**F3. Teste automatizado** (pronto)
* `tools/test/run.py`: compila com o Igor, roda um cenário e mostra o resultado em texto (`--no-build` repete sem compilar em 8 s). Modo de teste no jogo em `scripts/__Test` (`-test` ou `DOI_TEST`), com log em `tools/test/out/log.txt` e prints.
* Folha de contato (`--sheet <fase> --seeds N`) e cheats de debug (`room`, `level`, `spawn`, `give`; em GML `Test_GotoRoom`, `Test_SpawnEnemy`, `Test_GiveItem`).
* Conferido: `boot`, `smoke` (rato morto pela espada, andar, teleporte de sala, troca para os Esgotos, prints) e uma folha de contato do Castelo rodam do começo ao fim sem teclado, e o `smoke` repete igual quadro a quadro. Formato dos cenários em `tools/README.md`; detalhes e armadilhas em `docs/dev/engine-notes.md` ("Automated tests").

**F4. Ficha de fase** (pronto)
* Trocar os `switch`/`case DungeonLevel.X` espalhados (ex.: Mines aparece em 28 arquivos, nas portas, decoração, loja, cachoeira, sorteios) por uma estrutura `global.LevelDefs[nível]` com tudo da fase: classe de dungeon, tema de tiles, piso e decoração, água, música, clima, chefe, regras especiais.
* Inverter a tabela de inimigos: hoje cada `EnemyDataInit` tem um array com uma coluna por nível; passa a ser cada fase listando seus inimigos com peso.
* Pronto quando: todas as fases atuais saem da ficha, o jogo se comporta igual (conferido pelos cenários da F3) e criar uma fase é acrescentar uma entrada.
* Feito: `game/scripts/__Levels/__Levels.gml`. Conferido com os cenários de referência `ref_*` (baseline do commit anterior feito numa cópia do repositório): mesmas salas, objetos, tiles, inimigos e folhas de contato nas 14 fases. Falta o Guilherme jogar uma run.

**F5. Conversor de templates em Python** (pronto)
* `tools/templates/convert.py` substitui o projeto GameMaker `editors/room-template-parser` (apagado). Saída conferida contra o `data_r` real: mesmo conteúdo.
* O `data_r` foi dividido em `game/datafiles/data/rooms/<Classe>.json` (um template por linha, fora do LFS). Jogo, `build3.py`, validador e documentação atualizados.
* Testado no jogo pela linha de comando: as contagens de templates no log batem com o `data_r` antigo, hub e começo da run funcionam. Falta o Guilherme jogar uma run até o nível 2.

**F6. Kit de importação de gráficos**
* Convenção: o Guilherme coloca os gráficos em `incoming/<regiao>/` (sprites com nomes no padrão ou folhas com um `manifest.json`: tamanho do quadro, fps, origem; mais tileset e música).
* `import_region.py` gera os sprites do GameMaker, registra no `.yyp`, ajusta a paleta às regras do `direcao.md` (canais em passos de 8, contorno escuro, limite de cores) e monta uma prévia. Reaproveita o `tools/hub/gm_assets.py`.

**F7. Inimigos por arquétipo**
* Objeto base parametrizado para os padrões comuns de Zelda 2D (anda aleatório, persegue, atira, pula, voa em onda, se esconde). Inimigo simples vira dados (velocidade, padrão, projétil, sprites). Chefes e mecânicas únicas continuam com código próprio.

**F8. Conversão de salas de referência**
* Sala do ALttP (dump do `roomdump.c`) para template do Tiled com colisão, portas e posições de objetos, como ponto de partida para salas recombinadas. Depois o mesmo para o Minish Cap a partir da decompilação da comunidade.

**F9. Referências e especificação de região** (pronto)
* `docs/ref/<jogo>.md`: fichas de inimigos, chefes e itens (vida, velocidade, padrão de ataque, sons), pesquisadas uma vez.
* `docs/regioes/<nome>.md`: modelo que descreve uma região (origem, salas, inimigos, chefe, item, música, clima).

**F10. Skill "nova região"**
* Juntar o fluxo inteiro (especificação, importação, ficha de fase, templates, inimigos, validador, teste) numa skill do Claude com checklist. Prompt esperado: "nova região X, gráficos em `incoming/x`, spec em `docs/regioes/x.md`".

**Piloto:** topo do Castelo de Hyrule (item 1 abaixo, spec em `docs/regioes/topo-do-castelo.md`), feito pelo fluxo novo. Reaproveita inimigos existentes, então testa as ferramentas sem o risco de mecânicas novas.

Expectativa: região com inimigos reaproveitados ou de arquétipo sai de um prompt já testada; região com chefe de mecânica inédita sai quase pronta e pede uma ou duas rodadas de ajuste no chefe.

## Próximos passos de conteúdo (depois do plano de ferramentas)

1. Estágio alternativo do nível 2: topo do Castelo de Hyrule. Mesmos inimigos do castelo, salas novas com o tema do castelo, chuva e relâmpagos como no começo da run. Spec em `docs/regioes/topo-do-castelo.md`; veja também `docs/dev/receitas.md`. É o piloto do plano de ferramentas.
2. Novos NPCs e funções no Santuário, conforme as ideias do Guilherme.
3. Mais conquistas e recompensas quando houver conteúdo novo para premiar.
4. Atualizações maiores com conteúdo de outros Zeldas (ex.: um estágio do Minish Cap), com inimigos, chefes e itens novos portados a partir dos sprites e do código originais.

## Ideias soltas

* Ficha do Minish Cap (`docs/ref/minish-cap.md`) a partir da decompilação `zeldaret/tmc`, quando a região do Minish Cap for planejada.
* Harness em `tools/alttp/` que imprima a tabela de vulnerabilidade por arma do ALttP (`enemy_damage_data`, nos assets da ROM) para completar `docs/ref/alttp.md` (PC de casa).
* Topo do castelo: vento nas passarelas e buraco no telhado que leva ao porão (fora da primeira versão).
* Calar os avisos de som que enchem o log em toda partida (`oCredits` Step e `Intro_ShowLink` pedem um som que não existe). O `run.py` já os filtra, mas eles continuam na saída completa.
* Ficha de fase: escolher o próximo nível por sorteio (`Next` como lista com pesos) para os estágios alternativos, como o topo do castelo no lugar do nível 2.
* Ficha de fase: os soldados só montam a arma nos níveis que o `switch` do `Create` conhece; passar cor, energia e ataque deles para a ficha (ou para a F7) deixaria qualquer fase usar soldados.
* Teste: o cenário de referência da entrada (`ref_00_Start`) não tem folha de contato, porque remontar a fase com o `oIntro` rodando trava o jogo.
* Teste: tornar a fase função só da semente também no meio de uma run (o gerador guarda estado entre fases: tesouros, prisioneiros, lojistas), se a comparação de fases precisar.
* Folha de contato: as salas escuras saem escuras, como no jogo; uma opção para acender tudo ajudaria a ver o layout.
* Teste: rodar o cenário no GitHub Actions não dá (precisa de GameMaker e de uma janela); ficaria só o validador.
* (anote aqui ideias que ainda não viraram etapa)
