# Região: Nome da região

Copie este arquivo para `docs/regioes/<nome>.md` (minúsculas, com hífens) e preencha. Uma região é um lugar jogável inteiro: um estágio alternativo de um nível que já existe, um nível novo ou uma região de outro Zelda. O validador (`tools/check/validate.py`) confere se todas as seções abaixo existem e se os assets citados existem no projeto. Para citar um asset que ainda vai ser criado, escreva "(novo)" na mesma linha.

* **Estado:** ideia | especificada | em produção | pronta
* **Origem:** jogo e lugar de onde a região vem (ex.: ALttP, Torre de Hera)
* **Tipo:** estágio alternativo do nível N | nível novo | região de outro Zelda
* **Posição na run:** qual nível ela substitui ou onde entra, e a chance de ser sorteada
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

Lista do que muda e onde. Enquanto a ficha de fase (F4) não existir, inclua os `switch` por nível que precisam do caso novo (`docs/dev/receitas.md`, "Estágio alternativo").

## Pronto quando

Critérios de aceite: o que precisa funcionar, quais cenários de teste (F3) passam, e como o Guilherme confere jogando.

## Decisões

Decisões tomadas com o Guilherme sobre esta região. Decisões gerais vão também para `docs/roadmap.md`.
