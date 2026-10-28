# Gráficos e músicas para importar

Cada região tem uma pasta aqui, com o mesmo nome da especificação em `docs/regioes/` (ex.: `incoming/topo-do-castelo/` para `docs/regioes/topo-do-castelo.md`). O Claude roda `python tools/import/import_region.py <pasta>`, que converte tudo para as regras de `docs/design/direcao.md`, cria os sprites e sons no projeto e monta uma prévia. Esta pasta vai para o Git junto com o resto: é a fonte dos gráficos, e reimportar refaz tudo igual.

## O que vai na pasta

```
incoming/<regiao>/
  sprites/          imagens .png ou .gif (pode ter subpastas para organizar)
  tileset.png       opcional: faixa de tiles da região (veja abaixo)
  music/            opcional: músicas .wav
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

## Tileset

`tileset.png` tem exatamente 1248x48 pixels: uma faixa de tema do `sTiles` (156 x 6 tiles de 8x8), na mesma arrumação de um tema que já existe. Para começar, peça ao Claude a faixa de um tema como base (`--export-band Castle`) e pinte por cima, sem mudar nada de lugar. Diga no manifesto qual tema serviu de base (`"tileset": {"base": "Castle"}`). Por enquanto a faixa vira o sprite `sTiles_<Regiao>`; ligá-la ao tileset do jogo fica para a primeira região que tiver tiles próprios.

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
 "tileset": {"base": "Castle"},
 "music": {"CastleRoof": {"loop": 3.52}}
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
