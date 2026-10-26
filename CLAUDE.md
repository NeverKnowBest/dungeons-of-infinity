# Instruções para o Claude

Este repositório é a continuação do Dungeons of Infinity 1.2.1 (GameMaker, CC BY-NC, por Justin Bohemier): um roguelike no estilo de Zelda: A Link to the Past. É um projeto pessoal do Guilherme. Ele não programa: o Claude escreve, testa e entrega tudo pronto.

Leia antes de começar qualquer tarefa:

1. `docs/roadmap.md`: o que está pronto, o que vem a seguir e as decisões já tomadas.
2. `docs/design/direcao.md`: a direção de game design que guia as escolhas artísticas.
3. `docs/dev/engine-notes.md`: como o motor funciona.
4. `docs/dev/receitas.md`: passo a passo das tarefas que se repetem.

## Regras de trabalho

* Respostas em português, sem setas (→) e sem travessões (—) em listas e explicações. Textos dentro do jogo em inglês.
* **Quando o Guilherme estiver no PC do trabalho, não alterar nenhum arquivo no computador dele.** Nesse caso, trabalhe só no seu ambiente e entregue um zip.
* No PC de casa (vinculado ao chat), trabalhe direto na pasta do projeto: `E:\Services\GitHub\dungeons-of-infinity`. Grave os arquivos lá, rode no GameMaker, jogue e corrija antes de entregar (veja "Como testar").
* Quando não der para gravar direto, entregue um zip com só os arquivos alterados, dentro de uma pasta `dungeons-of-infinity/` com a mesma estrutura do repositório.
* No fim de cada entrega, passe o **título e a descrição do commit** (em inglês). O Guilherme faz o commit.
* Mantenha uma lista de tarefas durante o trabalho.
* Ele dá liberdade artística: decida os detalhes seguindo `docs/design/direcao.md` e pergunte só quando algo fugir dela ou for difícil de desfazer.
* Prints não são necessários na resposta; mostre imagens só quando ajudarem a decidir algo.
* No fim de cada etapa, atualize `docs/roadmap.md` (estado e decisões) e, se aprendeu algo do motor, `docs/dev/engine-notes.md` ou `docs/dev/receitas.md`. É isso que substitui o histórico do chat.

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

* `tools/hub/`: scripts Python que geram as salas do hub, sprites e dados (`data_r`, `data_d`, Tiled). Veja `tools/README.md`.
* `tools/alttp/`: utilitários em C que usam o código do zelda3 (reimplementação de ALttP) para extrair salas, sprites e músicas da ROM. A ROM nunca vai para o repositório.
