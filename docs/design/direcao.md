# Direção de game design

Este documento é o guia para as decisões artísticas e de design. O Guilherme dá liberdade criativa, desde que tudo pareça ter saído de um Zelda 2D, em especial de A Link to the Past. Quando algo não estiver coberto aqui, a pergunta é: "isso existiria no ALttP ou num Zelda 2D da Nintendo?". Se a resposta for não, repense.

## Pilares

1. **Parece ALttP.** Quem jogou o original reconhece salas, sons, menus e o jeito dos personagens.
2. **Roguelike honesto.** Cada run é curta e diferente; o progresso permanente é pequeno e conquistado (skins, itens iniciais, estátuas), nunca comprado nem óbvio.
3. **Segredos como recompensa.** Descobrir é parte da graça (modelo Binding of Isaac): o jogo não explica o que libera, só comemora quando acontece.
4. **Pouco texto, muita clareza visual.** O jogador entende uma sala olhando para ela.

## Visual

* **Escala.** Tela de 256x224, tiles de 8x8 montados em blocos de 16x16, Link com cerca de 16x24. Objetos seguem a escala do original: pote 16x16, estátua de Armos 16x32, baú 16x16, chefes 32x32 ou maiores só quando são chefes. Nada fica "gigante" fora de contexto.
* **Perspectiva.** Vista de cima em 3/4: paredes de cima mostram a face; paredes laterais e de baixo aparecem como borda grossa. Objetos altos têm a parte de cima desenhada sobre o Link quando ele passa atrás, mas no hub preferimos que o Link não passe atrás deles.
* **Paleta.** Cores do SNES (32 níveis por canal, passos de cerca de 8), contorno escuro (quase preto) nos sprites, poucas cores por objeto (4 a 7). Ao trazer sprites de outros jogos (GBA, Game Boy), ajuste para essas regras: contorno escuro, paleta limitada, sem degradês suaves. O kit de importação (`incoming/README.md`) faz esse ajuste sozinho e avisa o que não conseguiu.
* **Assets.** Primeiro a ROM do ALttP, depois o DoI, depois outros Zeldas 2D. Desenhar do zero é o último recurso e deve imitar o estilo (veja os vasos e a toalha da banca do Flute Boy).
* **Salas.** Formas simples e quase sempre simétricas, com o tamanho de 1 ou 2 telas. Portas no meio das paredes. Decoração conta a função da sala: igreja tem bancos e vitrais; galeria tem pedestais e lamparinas; loja tem balcão e prateleiras.
* **Luz e vida.** Elementos animados com moderação (fogo das lamparinas, água, chuva). Nada gira, pisca ou se mexe sem motivo dentro do mundo do jogo.

## Câmera e salas

* Troca de sala sempre no padrão das dungeons: a câmera rola e o Link dá alguns passos para dentro, chegando pela porta. Fade só para mudar de lugar (entrar e sair de um nível).
* Cada sala tem uma função clara. Se uma sala nova serve para a mesma coisa que outra, ela deve parecer diferente.

## Interface e som

* Menus usam as janelas e fontes que o DoI já tem (`sHUD_Window_Curse`, `global.MenuFont`, `global.Font_Small` só com maiúsculas).
* Sons do ALttP para cada ação: cursor (`Sound_Text`), confirmar (`Sound_TextDone`), voltar (`Sound_Throw`), erro (`Sound_Error`), item ganho (`Sound_ItemGet`), segredo (`Sound_Secret`). Não use som de escada para coisas que não são escadas.
* Música: temas do ALttP com intro e loop. O hub usa o tema do Santuário.

## Texto

* Em inglês, curto, no tom da Nintendo dos anos 90: gentil, um pouco engraçado, às vezes enigmático. Sem gírias atuais e sem quebrar a quarta parede além do que o ALttP já faz.
* NPCs falam uma ou duas frases. Dicas são indiretas ("I heard something rumble under the castle...") e nunca dizem a recompensa.
* Nomes de conquistas e itens são curtos e com trocadilho leve quando couber ("Worm Food", "Rich Kid").

## Hub (Santuário)

* É o lugar seguro entre as runs, como a casa do Link ou o santuário do original. Música calma, nenhum inimigo.
* Cresce com o progresso, como o hub de Hades: NPCs e salas novas aparecem conforme o jogador avança. Cada NPC tem uma função só (o Flute Boy cuida das skins).
* Funções novas entram pelo mundo, não por menus soltos: um personagem, um objeto ou uma sala que o jogador visita.

## Progresso, conquistas e segredos

* Recompensas permanentes são pequenas: aparência (skins) ou um empurrão no começo da run (itens iniciais). Nunca algo que deixa o jogo trivial.
* O que uma conquista pede pode ser visto (na galeria); o que ela dá é segredo até acontecer.
* Desafios (vida menor, mais inimigos, escuridão) existem para quem quer dificuldade e podem ser exigidos por conquistas.

## Conteúdo novo

* **Capítulos e variantes.** A run é uma sequência de capítulos, como no Binding of Isaac: cada posição da run (o `Depth` da ficha de fase) é um capítulo, e um capítulo pode ter variantes (o capítulo 2 do Isaac pode ser Caves, Catacombs ou Flooded Caves). Toda região nova diz de qual capítulo é variante. Uma variante pode ser uma área externa da franquia (jardim, campina, floresta), não só uma dungeon.
* **Saídas.** Nada é garantido: pools com pesos sorteiam quantas saídas a fase tem (uma ou duas), se a extra fica escondida e para qual variante do próximo capítulo cada uma leva; muitas runs têm uma saída só. Duas saídas nunca ficam perto: uma de um lado do mapa, a outra do lado oposto, para quem corre muitas vezes nem achar a segunda. A extra pode ficar numa sala secreta atrás de uma parede que abre com bomba; a principal nunca fica escondida, para ninguém ficar preso sem bombas.
* **O visual da saída mostra o destino.** Ele vem da ficha da fase de destino, nunca fixo no gerador: escadaria para baixo é o padrão, escadaria para cima leva ao topo do castelo, e um destino ao ar livre pode ter, por exemplo, uma parede explodida. O jogador aprende a ler a saída antes de entrar. O Link sempre acompanha os degraus desenhados no vão (saindo e chegando), e quem sobe chega por uma escada que desce, como no ALttP.
* **Estágios alternativos** devem ser lugares que fazem sentido no mundo do ALttP ou de outro Zelda (topo do castelo, Palácio do Leste, Torre de Hera...), com inimigos e clima coerentes. Variação de um estágio existente reaproveita os inimigos dele.
* **Outros Zeldas** (Minish Cap, Link's Awakening, Oracle) entram como "regiões" inteiras: tiles, inimigos, chefe e música da mesma origem, convertidos para as regras visuais acima. Não misture um inimigo de Minish Cap num estágio do ALttP sem motivo.
* **Itens novos** seguem a lógica de Zelda: cada item abre uma possibilidade (um caminho, um jeito de lutar), não só aumenta números.

## Evitar

* Copiar uma sala inteira para outro uso.
* Objetos fora de escala, girando, piscando ou com efeitos modernos (brilho, partículas demais, tremer de tela sem motivo).
* Revelar recompensas e segredos antes da hora.
* Decoração de outro tema (natalina, moderna, de loja onde não há loja).
* Menus que substituem coisas que poderiam acontecer no mundo do jogo.
* Textos longos ou explicativos demais.

## Antes de entregar algo visual

1. A prévia passa no teste "isso existiria no ALttP"?
2. A escala está certa em relação ao Link?
3. As cores e o contorno seguem a paleta?
4. O Link anda pela sala sem entrar em paredes nem ficar atrás do que não deveria?
5. Os sons e as transições são os do jogo?
