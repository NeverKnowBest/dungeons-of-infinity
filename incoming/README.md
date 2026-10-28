# Gráficos e músicas para importar

Cada região tem uma pasta aqui, com o mesmo nome da especificação em `docs/regioes/` (ex.: `incoming/topo-do-castelo/` para `docs/regioes/topo-do-castelo.md`). O Claude roda `python tools/import/import_region.py <pasta>`, que converte tudo para as regras de `docs/design/direcao.md`, cria os sprites e sons no projeto e monta uma prévia. Esta pasta vai para o Git junto com o resto: é a fonte dos gráficos, e reimportar refaz tudo igual.

## O que vai na pasta

```
incoming/<regiao>/
  sprites/          imagens .png ou .gif (pode ter subpastas para organizar)
  palettes/         opcional: recolorações de um inimigo para as cores por fase (veja abaixo)
  tileset.png       opcional: faixa de tiles da região, na arrumação de um tema (veja abaixo)
  tiles/            opcional: tileset próprio da região, pintado tile a tile (veja abaixo)
  music/            opcional: músicas .wav
  sounds/           opcional: efeitos sonoros .wav
  manifest.json     opcional: o que não dá para dizer pelo nome do arquivo
```

## Sprites

* **O nome do arquivo é o nome do sprite.** `Enemy_Ropa_Walk_Down.png` vira `sEnemy_Ropa_Walk_Down` (o `s` do começo é posto sozinho). Só letras, números e `_`, começando com letra. Siga o padrão do jogo: `Enemy_<Nome>_<Ação>_<Direção>` para inimigos (`Enemy_Rat_Walk_Down`), `Boss_<Nome>_...` para chefes, `Item_<Nome>`, `Deco_<Nome>` para decoração.
* **Animação**, de três jeitos:
  * um arquivo por quadro, numerado: `Enemy_Ropa_Walk_Down_0.png`, `Enemy_Ropa_Walk_Down_1.png`...
  * uma folha com os quadros lado a lado (ou em linhas), com o tamanho do quadro no `manifest.json` (`"frame": [16, 22]`);
  * um GIF animado (a velocidade do GIF vira a do sprite, se o manifesto não disser outra).
* Fundo transparente. Pode vir de qualquer jogo: as cores são ajustadas sozinhas (veja "O que a importação ajusta").
* Tamanho: o mesmo do original (Link tem 16x24). Deixe 1 pixel livre em volta se o sprite não tiver contorno e for preciso acrescentar um.

## Paletas (cores por fase)

Um inimigo pode ter outra cor em cada fase (como o soldado verde, azul e cinza) sem sprites repetidos: o jogo troca as cores na hora de desenhar. Para isso, pinte de novo **um quadro** de um sprite dele com as cores da variante e ponha em `palettes/<Nome>/`, numerado a partir de 1:

```
palettes/Enemy_Ropa/1.png    o quadro com as cores da variante 1
palettes/Enemy_Ropa/2.png    variante 2
```

* `<Nome>` é o começo do nome dos sprites do inimigo (`Enemy_Ropa` vale para `Enemy_Ropa_Walk_Down`, `Enemy_Ropa_Walk_Up`...). O quadro pintado é o primeiro quadro do primeiro desses sprites em ordem alfabética, ou o que o manifesto disser: `"palettes": {"Enemy_Ropa": {"base": "Enemy_Ropa_Walk_Down", "frame": 0}}`.
* Mesmo tamanho do quadro, mesmos pixels: só as cores mudam. Cada cor do original vira uma cor só na variante (uma cor que vira duas é erro). Cor que não aparece no quadro pintado fica igual em todas as variantes (o relatório avisa).
* A importação cria o sprite `sEnemy_Ropa_Pal`; a variante 0 é o original. Qual variante cada fase usa é dito no jogo (`ColorIndex` da variante do inimigo).

## Tileset

`tileset.png` tem exatamente 1248x48 pixels: uma faixa de tema do `sTiles` (156 x 6 tiles de 8x8), na mesma arrumação de um tema que já existe. É o que as dungeons usam para paredes, piso, portas e decoração de tile. Para começar, peça ao Claude a faixa de um tema como base (`--export-band Castle`) e pinte por cima, sem mudar nada de lugar. Diga no manifesto qual tema serviu de base (`"tileset": {"base": "Castle"}`). A importação grava a faixa no próprio `sTiles`, abaixo das linhas originais (100 em diante, 6 linhas por região), e dá a ela o nome da região; a fase usa com `TilesBand` na ficha (e o `Theme` do tema base, cujas regras de decoração seguem valendo).

## Tileset da região (`tiles/`)

Para o que é pintado tile a tile (as áreas externas), não por colunas fixas: `tiles/tiles.png` (tiles de 8x8 lado a lado, o primeiro vazio) e `tiles/tiles.json`, que dá a **classe** de cada tile, a fonte da colisão: `floor`, `solid`, `slope`, `deep_water`, `shallow_water`, `tall_grass`, `ledge_n`, `ledge_s`, `ledge_w`, `ledge_e`, `ledge_diag`, `bush`, `rock`, `sign`, `big_rock`, `bonk`, `pit`, `stairs`, `entrance`, `dig`, `warp`, `spike`, `grave`, `plaque`, `chest` ou `other`.

```json
{
 "columns": 16,
 "class": ["", "floor", "floor", "solid", "deep_water"],
 "blocks": [[[1, 0], [2, 0], [1, 1], [2, 1]]],
 "animated": [{"name": "Water", "frames": [4, 5, 6, 5]}],
 "animation_speed": 8
}
```

* `class`: uma por tile de `tiles.png`, da esquerda para a direita e de cima para baixo (o tile 0 fica vazio).
* `blocks`: os blocos de 16x16, a unidade de pintura (como o map16 do ALttP): quatro `[tile, giro]`, na ordem cima à esquerda, cima à direita, baixo à esquerda, baixo à direita; giro 0 normal, 1 espelhado, 2 de cabeça para baixo, 3 os dois.
* `animated`: tiles animados, com os quadros (números de tile).
* Peças do overworld do ALttP não precisam ser recortadas à mão: `python tools/alttp/owdump.py tiles <área> --region <regiao>` grava os dois arquivos com as classes tiradas da ROM, e rodar de novo com mais áreas só acrescenta (os números já usados não mudam).

A importação cria o tileset `ts_<Regiao>` (e o sprite `sTileset_<Regiao>`) e o arquivo `datafiles/data/tiles/<Regiao>.json` que o jogo lê; a fase usa com `RegionTiles` na ficha.

## Efeitos sonoros (`sounds/`)

`sounds/<Nome>.wav` (8 ou 16 bits, mono ou estéreo) vira o som `Sound_<Nome>`, no grupo de efeitos (sem `SongIndex`). `<Nome>` começa com maiúscula; letras, números e `_`. Volume opcional no manifesto (`"sounds": {"Thunder": {"volume": 0.7}}`, padrão 0.7). Som ambiente em loop (chuva, vento) é um `.wav` como os outros; quem repete é o código (`audio_play_sound(..., true)`). Efeitos do ALttP saem da ROM: `python tools/alttp/sfx.py <porta> <número> incoming/<regiao>/sounds/<Nome>.wav` (o trovão é `2 0x36`).

## Música

`.wav`, em uma destas formas:

* `music/<Nome>.wav` com o ponto de loop no manifesto (`"music": {"<Nome>": {"loop": 3.52}}`, em segundos): o começo vira a introdução e o resto repete;
* `music/<Nome>_Intro.wav` e `music/<Nome>_Main.wav`, já cortadas;
* só `music/<Nome>.wav`, sem loop: a música inteira repete.

`<Nome>` começa com maiúscula e só tem letras e números (`CastleRoof`). Vira os sons `Music_<Nome>_Intro` e `Music_<Nome>_Main` e a música `SongIndex.<Nome>`, que a ficha de fase usa no campo `Song`.

## manifest.json

Tudo é opcional; sem manifesto valem os padrões. Exemplo:

```json
{
 "name": "CastleRoof",
 "defaults": {"fps": 8, "origin": "center", "colors": 7},
 "sprites": {
  "Enemy_Ropa_Walk_Down": {"frame": [16, 22], "origin": [8, 20]},
  "Enemy_Keese": {"outline": "add"},
  "Deco_Banner": {"origin": "top-left", "colors": 5}
 },
 "palettes": {"Enemy_Ropa": {"base": "Enemy_Ropa_Walk_Down"}},
 "tileset": {"base": "Castle"},
 "music": {"CastleRoof": {"loop": 3.52}},
 "sounds": {"Thunder": {"volume": 0.7}}
}
```

* `name`: nome da região no projeto (pasta `Regions/<name>` no GameMaker). Padrão: o nome da pasta em CamelCase (`topo-do-castelo` vira `TopoDoCastelo`).
* `defaults`: opções que valem para todos os sprites; `sprites`: opções de um sprite (pelo nome do arquivo, com ou sem o `s`).
* Opções de sprite:
  * `frame` `[largura, altura]` corta uma folha; `count` limita o número de quadros (sem ele, células vazias no fim são ignoradas).
  * `fps` velocidade da animação (padrão 8).
  * `origin` ponto de apoio: `"center"` (padrão), `"bottom"` (meio da base, bom para quem fica de pé), `"top-left"` ou `[x, y]`.
  * `colors` limite de cores (padrão 7, contando o contorno; `0` desliga, para cenários grandes).
  * `outline` contorno escuro: `"check"` (padrão, só avisa), `"add"` (acrescenta 1 pixel de contorno por fora), `"darken"` (escurece a borda que já existe) ou `"off"` (pisos e cenário).
  * `outline_color` `[r, g, b]` do contorno (padrão: a cor mais escura do sprite, ou quase preto).
  * `alpha` `"hard"` (padrão: cada pixel é opaco ou transparente) ou `"keep"` (mantém a meia transparência, como as sombras dos tiles).

## O que a importação ajusta

* Cada canal de cor vai para um dos 32 níveis do SNES.
* Transparência sem meio-termo (a não ser com `"alpha": "keep"`; o tileset sempre mantém).
* Cores demais são juntadas: as duas mais parecidas viram uma só, até caber no limite. Nenhuma cor nova é inventada e o contorno fica intacto.
* O contorno é conferido (ou acrescentado, com `"outline": "add"`).
* A prévia (`tools/import/out/<regiao>/preview.png`) mostra cada sprite antes e depois, ao lado do Link na mesma escala, e o tileset embaixo da faixa que serviu de base. O relatório lista tamanho, quadros, origem, cores e avisos.
