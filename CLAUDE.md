# Instruções para o Claude

Este repositório é a continuação do Dungeons of Infinity 1.2.1 (GameMaker, CC BY-NC, por Justin Bohemier): um roguelike no estilo de Zelda: A Link to the Past. É um projeto pessoal do Guilherme. Ele não programa: o Claude escreve, testa e entrega tudo pronto.

Leia antes de começar qualquer tarefa:

1. `docs/roadmap.md`: o que está pronto, o que vem a seguir e as decisões já tomadas.
2. `docs/design/direcao.md`: a direção de game design que guia as escolhas artísticas.
3. `docs/dev/engine-notes.md`: como o motor funciona.
4. `docs/dev/receitas.md`: passo a passo das tarefas que se repetem.

Quando a tarefa envolver inimigos, chefes, itens ou uma região, leia também `docs/ref/` (fichas com os números do ALttP e do que já existe no DoI) e a especificação da região em `docs/regioes/` (modelo em `docs/regioes/_modelo.md`).

## Regras de trabalho

* Respostas em português, sem setas (→) e sem travessões (—) em listas e explicações. Textos dentro do jogo em inglês.
* **Quando o Guilherme estiver no PC do trabalho, não alterar nenhum arquivo no computador dele.** Nesse caso, trabalhe só no seu ambiente e entregue um zip.
* No PC de casa (vinculado ao chat), trabalhe direto na pasta do projeto: `E:\Services\GitHub\dungeons-of-infinity`. Grave os arquivos lá, rode no GameMaker, jogue e corrija antes de entregar (veja "Como testar").
* Quando não der para gravar direto, entregue um zip com só os arquivos alterados, dentro de uma pasta `dungeons-of-infinity/` com a mesma estrutura do repositório.
* No fim de cada entrega, passe o **título e a descrição do commit** (em inglês). O Guilherme faz o commit.
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

O Guilherme diz se está no PC de casa (vinculado ao chat) ou no do trabalho, e qual é a etapa. Leia os documentos acima, confira no `git log` o estado do repositório e comece. Se ele disser só "próxima etapa", é a primeira etapa ainda não pronta do "Plano de ferramentas" no `docs/roadmap.md`. Se o pedido for vago, decida pela direção de design; se for grande e visual, mostre uma prévia antes.

## Git

* O Guilherme faz os commits (GitHub Desktop). Repositório: `github.com/NeverKnowBest/dungeons-of-infinity`.
* Mudanças gravadas direto no PC de casa ficam pendentes até ele commitar. Se ele commitar o mesmo conteúdo de outro lugar, oriente a descartar as pendências antes do pull.

## Economia

* Um chat por etapa ou funcionalidade. O histórico fica nestes documentos, não na conversa.
* Antes de construir algo grande e visual, mostre uma prévia (imagem montada) e só então implemente.
* Teste no jogo antes de entregar. Rodadas de "deu erro, olha o print" são o que mais gasta.
* Screenshots de teste em escala reduzida (0.3 a 0.5), ampliando só a região que importa.

## Como testar no PC de casa

* GameMaker LTS 2026 em `E:\Services\GameMaker-LTS2026`. O projeto é `game/Zelda.yyp`.
* Ao gravar arquivos com o projeto aberto, o GameMaker mostra "Diretório do projeto modificado": clique em Recarregar. Ele volta à tela inicial; abra o projeto "Zelda" de novo em Projetos recentes.
* Rodar: botão Executar (triângulo) na barra de ferramentas. A janela do jogo é o processo `Runner.exe` (precisa de permissão própria no controle do computador).
* O jogo roda em janela por causa de `%LOCALAPPDATA%\Zelda\options.ini` (`Fullscreen="0"`, `AltTabPause="0"`). O Guilherme quer manter assim.
* Teclas: setas movem, Alt fala/age, Ctrl espada, Enter abre menus e confirma, Esc pausa e volta. Para o jogo registrar a tecla, segure por cerca de 0.15 s em vez de um toque instantâneo.
* Para fechar o jogo, use o menu de pausa (Quit to Desktop). Não clique no canto superior direito da tela: ali fica o botão Stop do app do Claude.
* `game/datafiles/data/data_r` tem mais de 30 MB e não passa pela transferência de arquivos para o PC. O jogo funciona com a versão que já está lá se a mudança no `data_r` não for essencial; senão entregue no zip.

## Ferramentas

* `tools/check/validate.py`: validador estático do projeto (veja `tools/README.md`). `--orphans` lista os recursos que estão no disco mas não no projeto. Também confere as especificações de região (seções do modelo, estado, assets citados).
* `tools/templates/`: `convert.py` gera o `data_r` a partir dos mapas do Tiled (vai substituir o `editors/room-template-parser` depois da comparação da F5); `compare.py` compara dois `data_r`.
* `tools/hub/`: scripts Python que geram as salas do hub, sprites e dados (`data_r`, `data_d`, Tiled). Veja `tools/README.md`.
* `tools/alttp/`: utilitários em C que usam o código do zelda3 (reimplementação de ALttP) para extrair salas, sprites e músicas da ROM. A ROM nunca vai para o repositório.
