# Região: Nome da região

Copie este arquivo para `docs/regioes/<nome>.md` (minúsculas, com hífens) e preencha. Uma região é um lugar jogável inteiro, e toda região é variante de um capítulo da run (veja `docs/design/direcao.md`, "Capítulos e variantes"): um capítulo é uma posição da run, o `Depth` da ficha de fase. O validador (`tools/check/validate.py`) confere se todas as seções e todos os campos abaixo existem e se os assets citados existem no projeto. Para citar um asset que ainda vai ser criado, escreva "(novo)" na mesma linha.

* **Estado:** ideia | especificada | em produção | pronta
* **Origem:** jogo e lugar de onde a região vem (ex.: ALttP, Torre de Hera)
* **Tipo:** dungeon ou área externa (jardim, campina, floresta); diga também se é região de outro Zelda
* **Capítulo:** de qual capítulo ela é variante (`Depth` N, ao lado de quais fases), de qual capítulo se chega a ela e para qual capítulo ela segue
* **Pools de saída:** em quais fases do capítulo anterior ela entra na `NextPool` e com que peso (é o que decide a chance de aparecer); a `NextPool` dela (variantes do próximo capítulo e pesos); `ExitCount` e `ExitHidden` se fugirem do padrão da ficha
* **Visual da saída:** como é a saída que leva até ela (`ExitLook`): `StairsDown` (padrão), `StairsUp` ou um visual novo (novo), que entra em `ExitLooks_Init`
* **Gráficos:** pasta `incoming/<nome>/` com o que o Guilherme entregou, ou "só assets que já existem"

## Ideia

Duas a quatro frases: o que o jogador vê e sente, e por que esse lugar faz sentido no mundo do jogo (passa no teste "isso existiria no ALttP?").

## Visual

* Tema de paredes e piso (tiles do DoI ou novos), decoração característica, iluminação.
* Assets de origem (ROM do ALttP, DoI, outro jogo) e o que precisa de ajuste de paleta.
* Prévia: imagem montada antes de implementar (`tools/hub/preview/` ou a pasta da região).

## Salas

* Classe de dungeon e templates (do Tiled) usados ou novos; quantas salas por nível.
* Salas especiais: entrada, saída, tesouro, loja, chefe.
* Salas de referência (ALttP ou outro jogo) para a conversão da F8.

## Inimigos

| Objeto | Peso | Variante (energia, ataque, cor) | Ficha |
|--------|------|---------------------------------|-------|
| `oEnemy_Exemplo` (novo) | 3 | energia 1, ataque 0.5 | `docs/ref/doi.md` |

Peso é o número de cópias no sorteio do nível (como as colunas de `EnemyDataInit`). Inimigo novo: diga o arquétipo e a ficha de origem em `docs/ref/`.

## Chefe

"Nenhum" ou: objeto, sala, padrão de ataque, vida (energia), música e recompensa. Mecânica inédita precisa de prévia e uma ou duas rodadas de ajuste.

## Itens e recompensas

O que pode aparecer em baús e lojas, o que não pode, e se a região libera alguma conquista (a recompensa continua segredo).

## Música e som

Faixa do nível (`SongIndex`), faixas novas (fonte e intro e loop), sons ambientes e sons novos.

## Clima e efeitos

Chuva, neve, escuridão, relâmpagos, água. Diga o que já existe e o que é novo.

## Regras especiais

Regras próprias do lugar (gelo que escorrega, água funda, buracos que levam ao andar de baixo). "Nenhuma" se não houver.

## Mudanças no código

Lista do que muda e onde: a entrada na ficha de fase (`__Levels.gml`), as `NextPool` das fases do capítulo anterior, o visual da saída se for novo e o que mais a região pedir. Passo a passo em `docs/dev/receitas.md`, "Estágio alternativo".

## Pronto quando

Critérios de aceite: o que precisa funcionar, quais cenários de teste (F3) passam, e como o Guilherme confere jogando.

## Decisões

Decisões tomadas com o Guilherme sobre esta região. Decisões gerais vão também para `docs/roadmap.md`.
