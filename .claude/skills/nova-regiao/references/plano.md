# Formato do plano e da entrega

## Plano (ensaio, ou começo da produção)

Em português, curto, sem setas nem travessões. Um bloco por passo da skill, na ordem, cada item marcado como pronto, a fazer, lacuna ou espera:

```
Plano: <Região> (`DungeonLevel.X`), variante do capítulo N
Estado da spec: <estado>. Resultado do status.py: <READY | STOP: chaves | WAIT>

1. Spec: <o que está pronto, o que ajustar>
2. Gráficos (F6): <pasta, o que importar, prévia>
3. Ficha e saídas (F4, F4b): <entrada nova com os campos; NextPool das fases do capítulo anterior com pesos; ExitLook>
4. Salas (F5): <classe e templates; o que é novo>
5. Inimigos (F7): <lista com objeto, peso, variante e de onde vêm os números>
6. Clima, música, regras: <o que a spec prevê em "Mudanças no código">
7. Testes (F3, F3b): <ref_NN_X, cenário da região, cenário da fase anterior, folha de contato, bateria e compare>
8. Validador e docs: <arquivos de docs que mudam>
9. Entrega: <o que o Guilherme vai jogar>

O que falta (para aqui):
* [chave] <o que a região pede> / <por que o fluxo não cobre> / <etapa que resolveria> / <alternativa, se houver>

Decisões para o Guilherme:
* <pergunta curta, com a recomendação do Claude>
```

Se não houver lacuna nem espera, a última parte é "Nada falta; sigo para o passo 2", ou, quando a spec acabou de ser escrita ou há prévia visual, "Nada falta nas ferramentas; espero a aprovação da spec (ou da prévia)".

## Entrega (fim da produção)

1. **Roteiro de teste** para o Guilherme: poucos passos, o que deve aparecer na tela e a linha do log quando houver. Ex.: "Comece uma run; no Hyrule Castle, procure a escadaria para cima (sai em 1 de cada 3 saídas, então pode levar algumas runs; às vezes são duas saídas, uma de cada lado do mapa). Subindo, o nome da fase nova aparece na tela." Para não depender da sorte, diga também qual semente e qual cenário mostram o caminho (o Claude roda o cenário e confere pelo log). Inclua só o que a mudança pode ter quebrado (a fase anterior, a fase de origem de algo compartilhado).
2. **Resultado dos testes** em texto: cenários rodados, `RESULT`, o `compare` da bateria e a explicação de cada diferença.
3. **Commit** (em inglês, o Guilherme faz):

```
Levels: <Region> as a chapter N variant (<short what>)

<Two to five lines: the level sheet entry and where the exits lead, the rooms, the enemies,
weather and music, the new tests, and what was checked (scenarios, compare against the
baseline). Mention docs updated.>
```

O prefixo segue o `git log` (`Levels:`, `Enemies:`, `Tools:`).
