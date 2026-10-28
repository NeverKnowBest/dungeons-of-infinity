# Instruções para o Claude

Este repositório é a continuação do Dungeons of Infinity 1.2.1 (GameMaker, CC BY-NC, por Justin Bohemier): um roguelike no estilo de Zelda: A Link to the Past. É um projeto pessoal do Guilherme. Ele não programa: o Claude escreve, testa e entrega tudo pronto.

Leia antes de começar qualquer tarefa:

1. `docs/roadmap.md`: o que está pronto, o que vem a seguir e as decisões já tomadas.
2. `docs/design/direcao.md`: a direção de game design que guia as escolhas artísticas.
3. `docs/dev/engine-notes.md`: como o motor funciona.
4. `docs/dev/receitas.md`: passo a passo das tarefas que se repetem.

Quando a tarefa envolver inimigos, chefes, itens ou uma região, leia também `docs/ref/` (fichas com os números do ALttP e do que já existe no DoI) e a especificação da região em `docs/regioes/` (modelo em `docs/regioes/_modelo.md`). Região nova (ou ensaio de uma): use a skill `nova-regiao` (`.claude/skills/nova-regiao/`).

## Regras de trabalho

* Respostas em português, sem setas (→) e sem travessões (—) em listas e explicações. Textos dentro do jogo em inglês.
* Os dois PCs (casa e trabalho) são iguais: o Claude Code abre direto na pasta do repositório, os dois têm GameMaker e Git LFS. Grave os arquivos lá. Não existe mais entrega por zip.
* **Quem joga o jogo é o Guilherme**, porque jogar pelo Claude (prints e teclas) consome muito. O Claude não abre o jogo pelo IDE nem tira prints de tela por conta própria; só faz isso se o Guilherme pedir. Em vez disso, entrega um roteiro de teste curto (veja "Como testar").
* **Exceção aprovada (out/2026):** o Claude pode rodar `python tools/test/run.py` por conta própria (compilar, rodar cenários, folha de contato) e conferir o resultado pelo texto (log e `RESULT`). Sem prints de tela; olhar um PNG do `tools/test/out/` só quando ajudar a decidir algo. Mesmo assim, entrega o roteiro de teste para o Guilherme jogar.
* **Quais cenários rodar (F3b):** durante o trabalho, rode só os cenários que a mudança afeta (ex.: `run.py smoke arch_trace`, ou `baseline.py save after --only Mines`). Antes da entrega, rode a bateria inteira uma vez: `python tools/test/run.py --all --save after` (todos os cenários, os 14 de referência inclusive, uma compilação, uns 15 min em segundo plano) e compare com o baseline de antes (`baseline.py compare before after`). O jogo de teste roda numa área de trabalho escondida, sem piscar nem roubar o foco, então pode rodar com o Guilherme usando o PC. Só use `--show` (jogo na tela) se ele pedir.

  | PC | Repositório | GameMaker |
  |----|-------------|-----------|
  | Casa | `E:\Services\GitHub\dungeons-of-infinity` | `E:\Services\GameMaker-LTS2026` |
  | Trabalho | `C:\Users\Sistemas-PC\Documents\GitHub\dungeons-of-infinity` | `C:\Program Files\GameMaker-LTS2026` |

* No fim de cada entrega, passe o **título e a descrição do commit** (em inglês). O Guilherme faz o commit e o push.
* Mantenha uma lista de tarefas durante o trabalho.
* **Rode `python tools/check/validate.py` antes de toda entrega** e corrija os erros. Ele funciona sem GameMaker, inclusive no ambiente do Claude.
* Ele dá liberdade artística: decida os detalhes seguindo `docs/design/direcao.md` e pergunte só quando algo fugir dela ou for difícil de desfazer.
* Prints não são necessários na resposta; mostre imagens só quando ajudarem a decidir algo.
* **Alimente a documentação sempre.** É ela que substitui o histórico do chat, então todo chat deixa a base melhor do que encontrou:
  * Descobriu como algo do motor funciona, uma armadilha do GML ou do GameMaker, ou um jeito de testar: registre em `docs/dev/engine-notes.md` na hora.
  * Fez uma tarefa que vai se repetir (sala, inimigo, item, extração da ROM): escreva ou melhore a receita em `docs/dev/receitas.md`.
  * O Guilherme aprovou, recusou ou corrigiu algo de design ou de visual: registre em `docs/roadmap.md` (Decisões) e, se for uma regra geral, em `docs/design/direcao.md`.
  * Criou ou mudou um script de ferramenta: atualize `tools/README.md`.
  * No fim da etapa: atualize Pronto, Próximos passos e Ideias no `docs/roadmap.md`, e entregue a documentação junto com o código (no mesmo commit).
* Se algum documento estiver errado ou desatualizado, corrija em vez de contornar.

## Começo de um chat novo

O Guilherme diz qual é a etapa (e, se importar, em qual PC está). Leia os documentos acima, confira no `git log` o estado do repositório e comece. Se ele disser só "próxima etapa", é a primeira etapa ainda não pronta do "Plano de ferramentas" no `docs/roadmap.md`. Se o pedido for vago, decida pela direção de design; se for grande e visual, mostre uma prévia antes.

## Git

* O Guilherme faz o commit e o push no fim da entrega (GitHub Desktop). Repositório: `github.com/NeverKnowBest/dungeons-of-infinity`.
* Ao trocar de PC, ele faz pull antes de começar. Se o `git status` mostrar mudanças pendentes ou o `git log` estiver atrás do `origin/main`, avise antes de editar.
* Não crie branch nem faça commit por conta própria.

## Economia

* Um chat por etapa ou funcionalidade. O histórico fica nestes documentos, não na conversa.
* Antes de construir algo grande e visual, mostre uma prévia (imagem montada) e só então implemente.
* Antes de entregar, confira tudo o que dá sem o jogo: validador, scripts de comparação, leitura cuidadosa do GML alterado. Rodadas de "deu erro, olha o print" são o que mais gasta, então revise bem antes.
* Defina antes o que prova que a tarefa funcionou e pare quando tiver essa prova. Nada de "só mais um teste" que não verifica nada novo.
* Saída de comando sempre filtrada (`grep`, `head`, `tail -n`, `--stat`); nunca listar arquivos, logs ou diffs inteiros sem necessidade.
* Leia só os trechos necessários dos documentos e arquivos grandes (busque antes, leia depois com intervalo de linhas).
* Comando que vai se repetir vira script em `tools/` em vez de ser colado de novo a cada vez.
* Se o Guilherme pedir para o Claude rodar o jogo: prints em escala reduzida (0.3 a 0.5), ampliando só a região que importa, e prefira conferir pelo log do jogo.

## Como testar

* No fim de cada entrega, passe um **roteiro de teste** para o Guilherme: poucos passos, o que deve aparecer na tela e, quando houver, a linha que deve aparecer na saída do GameMaker (ex.: `Room templates loaded: ...`). Inclua só o que a mudança pode ter quebrado.
* Se ele relatar um problema, peça a mensagem de erro ou a saída do GameMaker em texto antes de pedir prints.
* As notas abaixo servem para o Guilherme e para quando ele pedir que o Claude rode o jogo.
* GameMaker LTS 2026 (caminho de cada PC na tabela acima). O projeto é `game/Zelda.yyp`.
* Ao gravar arquivos com o projeto aberto, o GameMaker mostra "Diretório do projeto modificado": clique em Recarregar. Ele volta à tela inicial; abra o projeto "Zelda" de novo em Projetos recentes.
* Rodar: botão Executar (triângulo) na barra de ferramentas. A janela do jogo é o processo `Runner.exe` (precisa de permissão própria no controle do computador).
* Rodar sem o IDE: `python tools/test/run.py <cenário> [<cenário> ...]` (ou `--all`) compila com o Igor, roda os cenários de teste sozinho (sem teclado, fora da tela) e mostra os erros e o log em texto; `--sheet <fase>` monta a folha de contato. Formato em `tools/README.md` ("test/"), receita em `docs/dev/receitas.md`.
* O jogo roda em janela por causa de `%LOCALAPPDATA%\Zelda\options.ini` (`Fullscreen="0"` em `[Screen]`, `AltTabPause="0"`). O Guilherme quer manter assim nos dois PCs. Se o arquivo não existir, o jogo abre em tela cheia: crie a partir de `game/datafiles/options.ini` com esses dois valores.
* Scripts Python: o validador e o conversor só usam a biblioteca padrão; os de `tools/hub/` precisam de `python -m pip install --user pillow numpy`.
* Teclas: setas movem, Alt fala/age, Ctrl espada, Enter abre menus e confirma, Esc pausa e volta. Para o jogo registrar a tecla, segure por cerca de 0.15 s em vez de um toque instantâneo.
* Para fechar o jogo, use o menu de pausa (Quit to Desktop). Não clique no canto superior direito da tela: ali fica o botão Stop do app do Claude.

## Ferramentas

* `.claude/skills/nova-regiao/`: skill com o fluxo de uma região nova, da spec ao commit (ensaio ou produção); `tools/region/status.py <regiao>` mostra onde a região está e o que falta.
* `tools/check/validate.py`: validador estático do projeto (veja `tools/README.md`). `--orphans` lista os recursos que estão no disco mas não no projeto. Também confere as especificações de região (seções do modelo, estado, assets citados).
* `tools/test/`: `run.py` (teste automatizado e folha de contato, precisa do GameMaker instalado) e os cenários em `scenarios/`. O jogo tem um modo de teste (`scripts/__Test`) que não grava nada no usuário.
* `tools/import/`: `import_region.py` importa os gráficos e músicas de uma região que o Guilherme pôs em `incoming/<regiao>/` (convenção em `incoming/README.md`): ajusta as cores, cria sprites e sons, registra no `.yyp` e monta uma prévia.
* `tools/templates/`: `convert.py` gera as salas do jogo (`game/datafiles/data/rooms/<Classe>.json`, um template por linha) a partir dos mapas do Tiled; `compare.py` compara duas versões pelo conteúdo. Nunca edite os arquivos de `rooms/` à mão.
* `tools/hub/`: scripts Python que geram as salas do hub, sprites e dados (Tiled, `data_d`, e chamam o conversor). Veja `tools/README.md`.
* `tools/alttp/`: utilitários em C que usam o código do zelda3 (reimplementação de ALttP) para extrair salas, sprites e músicas da ROM. A ROM nunca vai para o repositório.
