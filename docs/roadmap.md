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
* **Conversor de templates em Python** (etapa F5): `tools/templates/convert.py` gera as salas do jogo a partir dos mapas do Tiled em `data/room-templates/`, em uns 10 s, sem GameMaker. A saída é idêntica, pelo conteúdo, ao último `data_r` do projeto GameMaker `editors/room-template-parser`, que foi apagado. O `data_r` único de 46 MB (Git LFS) virou `game/datafiles/data/rooms/<Classe>.json`, um arquivo por classe com um template por linha, em git normal: o diff mostra quais salas mudaram. O jogo lê os dez arquivos (`RoomTemplates_Load`) e registra a contagem no log; o `tools/hub/build3.py` chama o conversor; o validador acusa quando o Tiled muda e as salas não foram geradas de novo. Testado no jogo: título, hub e começo da run; o Guilherme jogou uma run até o nível 2 (out/2026) e tudo funcionou.
* **Teste automatizado** (etapa F3): `python tools/test/run.py <cenário>` compila o jogo com o Igor (acha o runtime e a pasta do usuário sozinho), roda um cenário JSON sem ninguém no teclado e mostra o resultado em texto: erros de compilação, o log do teste e `RESULT: ok` ou `FAILED`. O modo de teste do jogo (`scripts/__Test`, objeto `oTest`, ativado por `-test` ou `DOI_TEST`) pula título e menus, não grava nada, aplica semente, fase, itens e cheats, executa os passos (andar, atacar, esperar, ir a uma sala, trocar de fase, criar inimigo, conferir) e registra fase, sala, morte de inimigo, dano, prints e erros de GML com a pilha. Folha de contato: `--sheet Castle --seeds 4` monta todas as salas de N fases num PNG. Cenários `boot` e `smoke` em `tools/test/scenarios/` (o validador confere os cenários). Testado no PC do trabalho: `smoke` passa do começo ao fim e repete igual.
* **Ficha de fase** (etapa F4): tudo o que muda de um nível para outro está em `game/scripts/__Levels/__Levels.gml` (`global.LevelDefs`, lido pela macro `LevelDef`): nome, profundidade na run, próximo nível, tema de tiles e de decoração (`Theme`), classe de dungeon, música, escuridão, água, obstáculos, chefe, conquistas, regras especiais e a lista de inimigos com peso (a tabela de inimigos foi invertida: `EnemyDataInit` não tem mais coluna por nível). Os `switch`/`== DungeonLevel.X` espalhados em 59 arquivos saíram; as regras de decoração ficaram por tema (`switch(LevelDef.Theme)`), então uma fase nova que usa a arte do castelo herda tudo com `Theme: DungeonLevel.Castle`. Conferido pelos 14 cenários de referência (`tools/test/baseline.py`): as 14 fases saem idênticas antes e depois (salas, objetos e variáveis, tiles, folhas de contato, inimigos). O Guilherme jogou uma run até o nível 2 (out/2026) e tudo funcionou.
* **Cenários de referência por fase:** `tools/test/scenarios/ref_00_Start` a `ref_13_Aghanim2` (três montagens da fase com dump completo, inimigos que mudam por nível, uma caminhada curta e folha de contato) e `tools/test/baseline.py` (`save <rótulo>`, `compare a b`). Receita em `docs/dev/receitas.md` ("Comparar antes e depois").
* **Caminhos ramificados** (etapa F4b): a run é uma sequência de capítulos (o `Depth`) com variantes. A ficha de fase tem as pools com pesos das saídas (`NextPool`, `ExitCount`, `ExitHidden`) e o visual da saída que leva a cada fase (`ExitLook`: escadaria para baixo ou para cima, e visuais novos sem mexer no gerador). O gerador põe a saída extra longe da principal, do outro lado do mapa, às vezes numa sala secreta que abre com bomba. Nenhuma fase ramifica ainda (o piloto será a primeira); testado com uma ramificação temporária no cenário `branch_exits`, e as 14 fases atuais saem iguais.
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
* **Capítulos e variantes (out/2026):** as fases funcionam como os capítulos do Binding of Isaac. Cada posição da run (o `Depth` da ficha) é um capítulo que pode ter variantes, como o capítulo 2 do Isaac pode ser Caves, Catacombs ou Flooded Caves. Toda região nova diz de qual capítulo é variante. Uma variante pode ser uma área externa da franquia (jardim, campina, floresta), não só dungeon.
* **Saídas por sorteio (out/2026):** nada nas saídas é garantido. Uma pool com pesos sorteia quantas saídas a fase tem (uma ou duas), outra sorteia se a saída extra fica escondida e outra sorteia para qual variante do próximo capítulo cada saída leva. Muitas runs terão só uma saída, e isso é normal.
* **Duas saídas ficam longe (out/2026):** uma de um lado do mapa e a outra do lado oposto, de modo que quem corre (speedrun) muitas vezes nem descobre a segunda. A saída extra pode cair numa sala secreta, atrás de uma parede que abre com bomba (as paredes secretas que o jogo já tem). A saída principal nunca fica escondida, para o jogador sem bombas não ficar preso.
* **Visual da saída é variável (out/2026):** é um campo da ficha da fase de destino (como é a saída que leva até ela), com a escadaria para baixo como padrão. Ex.: a saída para o topo do castelo é a escadaria para cima; no futuro, a saída para um jardim pode ser uma parede explodida. Visual novo entra sem mudar o gerador: acrescenta-se o visual e a ficha aponta para ele.
* **Ordem do plano (out/2026):** depois da F4b, F6, F7, F10, o piloto (topo do castelo) e só então a F8, antes da primeira região com arquitetura que o DoI não tem (ex.: Palácio do Leste, Minish Cap).

## Plano de ferramentas (fazer antes do conteúdo novo)

Objetivo: deixar o projeto pronto para que uma região inteira (fase com salas, inimigos, chefe, música e clima) saia de um único prompt. Um chat por etapa, na ordem abaixo (as prontas primeiro; depois F6, F7, F10, piloto e F8, ordem decidida pelo Guilherme em out/2026). Ao terminar uma etapa, marque como pronta aqui e mova o resumo para "Pronto".

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
* Feito: `game/scripts/__Levels/__Levels.gml`. Conferido com os cenários de referência `ref_*` (baseline do commit anterior feito numa cópia do repositório): mesmas salas, objetos, tiles, inimigos e folhas de contato nas 14 fases. O Guilherme jogou uma run até o nível 2 (out/2026): tudo funcionou.

**F4b. Caminhos ramificados** (pronto; falta o Guilherme olhar a folha de contato e revisar os pesos)
* Objetivo: cada capítulo da run pode ter variantes, e as saídas de uma fase sorteiam para qual variante do próximo capítulo levam (decisões de out/2026 acima).
* Ficha de fase (`__Levels.gml`): `NextPool` (para onde cada saída leva, `[[fase, peso], ...]`; sem ela, `[[Next, 1]]`), `ExitCount` (quantas saídas), `ExitHidden` (se a extra fica numa sala secreta), `ExitMinDistance` e `ExitLook` (o visual da saída que leva até a fase, um nome de `global.ExitLooks`). Os sorteios só acontecem quando a `NextPool` pode levar a mais de uma fase; hoje nenhuma pode, então as fases atuais não sorteiam nada.
* Gerador (`Dungeon_PlanExits` em `__Dungeon.gml`): a saída principal é a do layout e nunca fica escondida. A extra vai numa porta no meio da parede de cima ou de baixo de uma sala sem nada atrás dessa parede, a pelo menos 2 colunas da principal e do outro lado do meio do mapa; escondida, vai numa sala especial de uma porta, que vira secreta e abre com bomba (rachadura ou parede lisa, nunca a de ilusão). Sem lugar, a escondida vira visível e, sem lugar nenhum, a fase fica com uma saída. Fase com chefe e fases de layout fixo (vila, minas, Agahnim) nunca têm saída extra (ela pularia o chefe).
* Visual da saída (`ExitLooks_Init` em `__Doors.gml`): `StairsDown` (a escadaria de sempre) e `StairsUp` (a escadaria por onde o Link chega em toda fase). Visual novo é uma entrada nova ali, com o desenho, o som de saída, a animação do Link (saída e chegada), o som de chegada e o ícone do mapa; nem o gerador nem o Link mudam. Não foi preciso template novo no Tiled: a saída é uma porta, não uma sala (a classe Stairs é das escadas internas).
* A fase escolhida passa pela sala de descanso e vai no save (`global.RunPath`, `SaveData.NextLevel`).
* **Correção (out/2026):** na `StairsUp` o Link fazia a animação de descer e a chegada tocava sempre o som de descida. Agora o visual tem `LinkAnim` (o nome das sprites `LinkSpr_<LinkAnim>_Top1/Bottom1/Top2/Bottom2`) e `ArriveSound`; a `StairsUp` usa as sprites `Ascending` e `Sound_StairsUp` nas duas pontas. O caminho vem do zelda3 (`HandleLinkOnSpiralStairs` e `SpiralStairs_FindLandingSpot`): na escada em espiral que desce, o Link entra e anda para a esquerda na mesma altura (o que o DoI já fazia); na que sobe, entra, vira para a direita e sobe na diagonal até sumir atrás da parede, e na chegada vem da esquerda na mesma altura. Como no ALttP, quem sobe chega numa escada que desce: o visual tem `Entrance` (o vão por onde o Link chega na fase seguinte), e a `StairsUp` desenha ali a escada de descida. Regra: o Link sempre acompanha os degraus desenhados no vão. Por isso as `Ascending` são os quadros de descida espelhados, percorrendo os mesmos degraus no sentido contrário (`LinkSprite_Remix` em `__LinkSprites.gml`): em cima, a saída sobe na diagonal e a chegada vem nivelada; na parede de baixo (que o ALttP não tem), o espelho puro já segue os degraus.
* Pulinho no fim da chegada (antigo, em toda chegada pela porta de cima, notado pelo Guilherme na sala de descanso): a pose final da `Descending_Top2` ficava 4 px acima da pose parada, e o Link caía de uma vez ao começar a andar; ela também cortava o alto da cabeça. Agora a sprite tem 8 px a mais em cima (o corte do vão só vale nos quadros de lado) e os dois últimos quadros descem esses 4 px em dois passos.
* Segunda versão (corrigida pelo Guilherme): a chegada vinha nivelada mas a entrada ainda mostrava a escada de subida, e o Link não acompanhava os degraus; na parede de baixo a saída ia nivelada, contra a inclinação da escada. O Link guarda o visual da saída que tomou (`oLink.ExitLook`, definido em `CheckDoors`) até a chegada.
* Primeira versão desta correção (recusada pelo Guilherme): só deslocava os quadros de descida para cima e, por um erro de ordem (`UpdateState` troca a sprite antes do `switch` do estado), a saída continuava usando as sprites de descida. Testado com `branch_exits` e prints da saída por cima, da saída por baixo e da chegada por cima. As 14 fases de referência foram conferidas na primeira versão (imagens e logs iguais; os dumps só ganham as 4 globais das sprites novas, com `baseline.py compare --handles`, opção nova que ignora os números de sprite e surface).
* Teste: `tools/test/scenarios/branch_exits.json` cria uma ramificação temporária só no teste (Hyrule Castle leva ao Castle Basement ou às Catacombs, que fazem o papel de variante com a escadaria para cima). Folha de contato das sementes 5 (uma saída), 3 (duas saídas em lados opostos), 6 (extra numa sala secreta) e 8 (escadaria para cima e extra secreta); depois o Link desce pela extra (chega ao Castle Basement) e, noutra montagem, pela principal (passa pela sala de descanso e chega às Catacombs). Os 14 cenários de referência saem iguais aos da F4 (SAME nos 14; com o PC ocupado, a linha do `oMusic` pode variar por causa do tempo real do áudio, veja `tools/README.md`).
* **Pesos iniciais (escolha do Claude, para o Guilherme revisar):**
  * `ExitCount` `[[1, 2], [2, 1]]`: uma saída em 2 de cada 3 fases que ramificam, duas em 1 de cada 3.
  * `ExitHidden` `[[false, 1], [true, 1]]`: metade das saídas extras numa sala secreta.
  * `ExitMinDistance` 2: as duas saídas a pelo menos 2 colunas de distância, cada uma de um lado do meio do mapa. Nos layouts do castelo quase sempre cabe; nos do porão (salas muito juntas) quase nunca, e aí fica uma saída.
  * `NextPool`: cada fase sorteia o destino de cada saída de forma independente (as duas podem levar ao mesmo lugar). Para o piloto, o Hyrule Castle fica com `[[CastleBasement, 2], [topo, 1]]`: cada saída leva ao topo em 1 de cada 3.
  * Os valores ficam no `Level_Create` (padrão de todas as fases) e cada fase pode ter os seus.

**F5. Conversor de templates em Python** (pronto)
* `tools/templates/convert.py` substitui o projeto GameMaker `editors/room-template-parser` (apagado). Saída conferida contra o `data_r` real: mesmo conteúdo.
* O `data_r` foi dividido em `game/datafiles/data/rooms/<Classe>.json` (um template por linha, fora do LFS). Jogo, `build3.py`, validador e documentação atualizados.
* Testado no jogo pela linha de comando: as contagens de templates no log batem com o `data_r` antigo, hub e começo da run funcionam. O Guilherme jogou uma run até o nível 2 (out/2026): tudo funcionou.

**F9. Referências e especificação de região** (pronto)
* `docs/ref/<jogo>.md`: fichas de inimigos, chefes e itens (vida, velocidade, padrão de ataque, sons), pesquisadas uma vez.
* `docs/regioes/<nome>.md`: modelo que descreve uma região (origem, salas, inimigos, chefe, item, música, clima).

**F6. Kit de importação de gráficos**
* Convenção: o Guilherme coloca os gráficos em `incoming/<regiao>/` (sprites com nomes no padrão ou folhas com um `manifest.json`: tamanho do quadro, fps, origem; mais tileset e música).
* `import_region.py` gera os sprites do GameMaker, registra no `.yyp`, ajusta a paleta às regras do `direcao.md` (canais em passos de 8, contorno escuro, limite de cores) e monta uma prévia. Reaproveita o `tools/hub/gm_assets.py`.

**F7. Inimigos por arquétipo**
* Objeto base parametrizado para os padrões comuns de Zelda 2D (anda aleatório, persegue, atira, pula, voa em onda, se esconde). Inimigo simples vira dados (velocidade, padrão, projétil, sprites). Chefes e mecânicas únicas continuam com código próprio.

**F10. Skill "nova região"**
* Juntar o fluxo inteiro (especificação, importação, ficha de fase, templates, inimigos, validador, teste) numa skill do Claude com checklist. Prompt esperado: "nova região X, gráficos em `incoming/x`, spec em `docs/regioes/x.md`".

**Piloto:** topo do Castelo de Hyrule (item 1 abaixo, spec em `docs/regioes/topo-do-castelo.md`), feito pelo fluxo novo. Reaproveita inimigos existentes, então testa as ferramentas sem o risco de mecânicas novas.

**F8. Conversão de salas de referência** (depois do piloto, antes da primeira região com arquitetura que o DoI não tem, como o Palácio do Leste ou o Minish Cap)
* Sala do ALttP (dump do `roomdump.c`) para template do Tiled com colisão, portas e posições de objetos, como ponto de partida para salas recombinadas. Depois o mesmo para o Minish Cap a partir da decompilação da comunidade.

Expectativa: região com inimigos reaproveitados ou de arquétipo sai de um prompt já testada; região com chefe de mecânica inédita sai quase pronta e pede uma ou duas rodadas de ajuste no chefe.

## Próximos passos de conteúdo (depois do plano de ferramentas)

1. Topo do Castelo de Hyrule, variante do capítulo 2 (`Depth` 2, no lugar do Castle Basement): vem depois do Hyrule Castle (capítulo 1), segue para o Castle Prison (capítulo 3, com o chefe) e a saída que leva a ele é a escadaria para cima. Mesmos inimigos do castelo, salas novas com o tema do castelo, chuva e relâmpagos como no começo da run. Spec em `docs/regioes/topo-do-castelo.md`; veja também `docs/dev/receitas.md`. É o piloto do plano de ferramentas.
2. Novos NPCs e funções no Santuário, conforme as ideias do Guilherme.
3. Mais conquistas e recompensas quando houver conteúdo novo para premiar.
4. Atualizações maiores com conteúdo de outros Zeldas (ex.: um estágio do Minish Cap), com inimigos, chefes e itens novos portados a partir dos sprites e do código originais.

## Ideias soltas

* Ficha do Minish Cap (`docs/ref/minish-cap.md`) a partir da decompilação `zeldaret/tmc`, quando a região do Minish Cap for planejada.
* Harness em `tools/alttp/` que imprima a tabela de vulnerabilidade por arma do ALttP (`enemy_damage_data`, nos assets da ROM) para completar `docs/ref/alttp.md` (PC de casa).
* Topo do castelo: vento nas passarelas e buraco no telhado que leva direto à prisão (fora da primeira versão).
* Calar os avisos de som que enchem o log em toda partida (`oCredits` Step e `Intro_ShowLink` pedem um som que não existe). O `run.py` já os filtra, mas eles continuam na saída completa.
* Mapa (bússola): a escadaria para cima usa o mesmo ícone da de baixo (`sLargeMap_Down`); um ícone próprio por visual de saída ajudaria a ler o mapa (campo `MapIcon` do visual).
* Saída extra nas paredes laterais: hoje ela só vai na parede de cima ou de baixo, porque a descida do Link só existe nesses dois sentidos. Nos layouts do porão quase nunca há lugar.
* Etapa futura "Áreas externas": gerador e templates para áreas abertas (jardim, campina, floresta), com passagem de uma tela para outra pela borda em vez de portas, tendo a Rebel Village como precedente. Decidir depois do piloto.
* Ficha de fase: os soldados só montam a arma nos níveis que o `switch` do `Create` conhece; passar cor, energia e ataque deles para a ficha (ou para a F7) deixaria qualquer fase usar soldados.
* Teste: o cenário de referência da entrada (`ref_00_Start`) não tem folha de contato, porque remontar a fase com o `oIntro` rodando trava o jogo.
* Teste: tornar a fase função só da semente também no meio de uma run (o gerador guarda estado entre fases: tesouros, prisioneiros, lojistas), se a comparação de fases precisar.
* Folha de contato: as salas escuras saem escuras, como no jogo; uma opção para acender tudo ajudaria a ver o layout.
* Teste: rodar o cenário no GitHub Actions não dá (precisa de GameMaker e de uma janela); ficaria só o validador.
* Chegada depois da escadaria para cima: a entrada da fase de destino continua desenhada como escadaria para cima (o Link sai subindo de uma escada que sobe). Se incomodar, o visual da saída também desenharia a entrada da fase seguinte.
* Sala de descanso logo depois do Hyrule Castle (só acontece num ramo, como o do cenário `branch_exits`): ela usa a ficha da fase anterior (`LevelDef`), e o `RunStart` do castelo faz o Link entrar como no início da run (devagar, atrás da parede da entrada, invisível) em vez de descer a escada. Corrigir antes de o castelo ramificar para uma fase com `SaveBefore`.
* (anote aqui ideias que ainda não viraram etapa)
