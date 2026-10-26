# Fichas de referência

Números e comportamentos de inimigos, chefes e itens, pesquisados uma vez e guardados aqui para não precisar pesquisar de novo a cada região. Uma especificação de região (`docs/regioes/`) aponta para estas fichas em vez de repetir os dados.

| Arquivo | Conteúdo | Fonte |
|---------|----------|-------|
| `alttp.md` | A Link to the Past: inimigos, chefes, itens | código do zelda3 (snesrev), tabelas de `src/sprite.c`, `src/player.c`, `src/ancilla.c` |
| `doi.md` | O que já existe no jogo: cada inimigo e chefe com os números da tabela `EnemyDataInit`, onde aparece, velocidade e equivalente no ALttP | código do jogo (`game/scripts/__Enemies`, objetos `oEnemy_*` e `oBoss_*`) |

## Unidades

* **Vida (ALttP):** pontos de vida do sprite. 255 costuma ser invulnerável, mas quem decide se a arma mata é a vulnerabilidade por arma (veja Lacunas).
* **Dano:** em corações, com a túnica verde. A azul e a vermelha reduzem (veja a tabela de armaduras em `alttp.md`).
* **Velocidade (ALttP):** em pixels por quadro, a 60 quadros por segundo. No código do SNES a velocidade é guardada em 1/16 de pixel; 16 no código é 1 px por quadro. Os soldados batem com o DoI (patrulha 0.5, perseguição 1), então os números do DoI estão na mesma escala.
* **Velocidade (DoI):** os valores do `Create` do objeto (`Speed`, `WalkSpeed`, `RunSpeed`...), já em px por quadro.
* **Energia (DoI):** o DoI não usa a vida do ALttP. Cada inimigo tem um índice de energia que diz quantos golpes de espada ele aguenta (`global.EnemyHitsToKill`). Veja `doi.md`.

## Lacunas conhecidas

* **Vulnerabilidade por arma no ALttP.** O dano que cada arma causa depende de uma tabela por inimigo (`enemy_damage_data`, 16 classes de arma por sprite) que fica nos assets extraídos da ROM, não no código do zelda3. As fichas usam a classe padrão (a da maioria dos inimigos comuns). Para chefes e inimigos especiais, os golpes reais podem ser bem diferentes de vida dividida pelo dano. Para preencher: um harness em `tools/alttp/` que carregue o `zelda3_assets.dat` e imprima `enemy_damage_data` (precisa da ROM, então só no PC de casa).
* **Velocidades marcadas com "~"** foram lidas das tabelas de velocidade da função do sprite e podem variar por estado. A função do zelda3 de cada inimigo está na ficha para conferir.

## Como acrescentar um jogo novo

1. Crie `docs/ref/<jogo>.md` com as mesmas seções de `alttp.md` (Regras gerais, Inimigos, Chefes, Itens) e as mesmas colunas, para as fichas poderem ser comparadas.
2. Prefira a fonte mais exata: decompilação ou reimplementação (Minish Cap: `zeldaret/tmc`; Link's Awakening: `zladx/LADX-Disassembly`), depois a ROM, depois wikis. Diga a fonte no topo do arquivo.
3. Para cada inimigo, anote também o arquétipo (lista em `alttp.md`), porque é ele que decide se o inimigo vira dados (F7) ou precisa de código próprio.
4. Acrescente o arquivo na tabela acima.
