# A Link to the Past

Fonte: código do zelda3 (github.com/snesrev/zelda3), lido em out/2026. Vida e dano de contato vêm de `kSpriteInit_Health` e `kSpriteInit_BumpDamage` (`src/sprite.c`), com as trocas por variante das funções `SpritePrep_*` (`src/sprite_main.c`). O dano em corações sai de `kPlayerDamages`. As unidades estão em `README.md`.

A coluna **Dano** é o dano de contato; projéteis (pedras, flechas, lasers, bolas de fogo) são sprites próprios. A coluna **id** é o tipo do sprite no ALttP (hexadecimal) e a coluna **função** é a função do zelda3 com o comportamento, para conferir qualquer detalhe.

## Regras gerais

* Link começa com 3 corações e chega a 20. Quatro pedaços de coração formam um coração.
* A barra de magia tem 128 unidades. A meia magia e o quarto de magia dividem os custos por 2 e por 4.
* Vida 255 e os inimigos marcados "na tabela" dependem da vulnerabilidade por arma para morrer ou não (veja Lacunas em `README.md`).
* Inimigo atingido pisca e é empurrado; sons comuns a todos: acerto (`Sound_Enemy_Hit`), morte (`Sound_Enemy_Kill`). Chefe: `Sound_Boss_Hit` e `Sound_Boss_Destroy`.
* Variantes do Mundo das Trevas costumam ter mais vida e mais dano (rato 2 e 8 de vida, morcego 1 e 4, cobra 4 e 8, Octorok 2 e 4).

### Dano das armas (classe padrão)

Vale para a maioria dos inimigos comuns. Inimigos especiais e chefes têm tabela própria (veja Lacunas em `README.md`). Valores de 249 para cima no código são efeitos, não dano: 249 transforma, de 251 a 255 atordoa (estado 11 do sprite).

| Arma | Dano | Observação |
|------|------|------------|
| Espada de luta (1) | 2 | golpe giratório: 4 |
| Master Sword (2) | 4 | giratório: 8. Com vida cheia, dispara o raio |
| Espada temperada (3) | 8 | giratório: 16 |
| Espada dourada (4) | 16 | giratório: 16 |
| Estocada (toque com a espada) | metade do golpe normal | com a espada 1, igual ao golpe |
| Bumerangue | 1 | |
| Gancho (Hookshot) | 0 | atordoa |
| Flecha | 4 | |
| Flecha de prata | 100 | mata quase tudo |
| Bomba | 4 | |
| Martelo | 8 | vira inimigos de casco (Terrorpin) |
| Bastão de fogo | 8 | queima |
| Bastão de gelo | 8 | congela |
| Bombos | 16 | tela inteira |
| Ether | atordoa | tela inteira; o inimigo pula e fica parado |
| Quake | 32 | tela inteira |
| Pó mágico | transforma | (Buzzblob vira Cukeman, por exemplo) |

### Armaduras (dano recebido, em corações)

Classe de dano do inimigo e quanto ele tira com cada túnica. A coluna "Dano" das fichas abaixo usa a verde.

| Classe | Verde | Azul | Vermelha |
|--------|-------|------|----------|
| 0 | 1/4 | 1/8 | 1/8 |
| 1 | 1/2 | 1/2 | 1/2 |
| 3 | 1 | 1/2 | 1/4 |
| 4 | 1 | 1 | 1 |
| 5 | 2 | 1 | 1/2 |
| 6 | 4 | 2 | 1 |
| 7 | 4 | 3 | 2 |
| 8 | 3 | 2 | 1 |
| 9 | 8 | 6 | 3 |

A classe 2 não causa dano (Hoarder, interruptores).

## Arquétipos

Usados nas fichas daqui e do `doi.md`, e na etapa F7 (inimigos por arquétipo).

* **Andarilho:** anda em direções aleatórias, muda ao bater na parede.
* **Patrulheiro:** anda numa linha, olha para os lados e passa a perseguir ao ver o Link.
* **Perseguidor:** vai direto ao Link.
* **Investida:** anda devagar e avança rápido em linha quando se alinha com o Link.
* **Atirador:** para e dispara um projétil na direção do Link.
* **Saltador:** se move pulando.
* **Voador:** ignora o chão (buracos, água) e às vezes as paredes; trajetória em onda ou curva.
* **Emboscada:** fica escondido (areia, arbusto, teto, água) e aparece perto do Link.
* **Torre:** fixo, gira ou espera e dispara.
* **Armadilha:** invulnerável, se move em trilho (rola, desliza, gira).
* **Divisor:** se divide ao ser atingido ou ao morrer.
* **Blindado:** só é vulnerável por um lado ou num estado (olho aberto, de costas, virado).

## Inimigos

| Inimigo | id | Vida | Dano | Velocidade | Arquétipo e padrão | Função |
|---------|----|------|------|------------|--------------------|--------|
| Soldado verde (Green Soldier) | 42 | 4 | 1/2 | 0.5 patrulha, 1 perseguindo | Patrulheiro; espada | `Sprite_41_BlueGuard` |
| Soldado azul (Blue Soldier) | 41 | 6 | 1/2 | 0.5, 1 | Patrulheiro; espada | `Sprite_41_BlueGuard` |
| Soldado de lança vermelho | 43 | 8 | 1 | 0.5, 1 | Patrulheiro; lança | `Sprite_41_BlueGuard` |
| Soldado azul corredor | 44 | 6 | 1/2 | 1.1 | Perseguidor; corre de espada em riste | `Sprite_44_BluesainBolt` |
| Soldado de lança verde | 45 | 8 | 1 | 1.1 | Perseguidor | `Sprite_45_HogSpearMan` |
| Arqueiro azul | 46 | 6 | 1/2 | ~0.5 | Atirador; mantém distância, flechas | `Sprite_46_BlueArcher` |
| Soldado do arbusto verde | 47 | 4 | 1/2 | ~0.5 | Emboscada; sai do arbusto e atira | `Sprite_47_GreenBushGuard` |
| Soldado de dardo vermelho | 48 | 8 | 1 | ~0.5 | Atirador; arremessa lanças | `Sprite_48_RedJavelinGuard` |
| Soldado do arbusto vermelho | 49 | 8 | 1 | ~0.5 | Emboscada e atirador | `Sprite_49_RedBushGuard` |
| Soldado bombardeiro | 4A | 8 | 1 | ~0.5 | Atirador; arremessa bombas | `Sprite_4A_BombGuard` |
| Soldado recruta (faca) | 4B | 4 | 1/2 | ~0.5 | Patrulheiro fraco | `Sprite_4B_GreenKnifeGuard` |
| Soldado do mangual (Ball and Chain) | 6A | 16 | 1 | lento | Perseguidor; gira o mangual com alcance longo | `Sprite_6A_BallNChain` |
| Rato | 6D | 2 | 1/4 | 1.5 | Andarilho; corre e para | `Sprite_6D_Rat` |
| Morcego (Keese) | 6F | 1 | 1/4 | ~1 | Voador; arcos aleatórios, pousa | `Sprite_6F_Keese` |
| Cobra (Rope) | 6E | 4 | 1/2 | ~0.5, investida rápida | Investida | `Sprite_6E_Rope` |
| Octorok | 08 | 2 | 1 | ~0.5, pedra ~1.5 | Andarilho e atirador | `Sprite_08_Octorok` |
| Buzzblob | 0D | 3 | 1/2 | ~0.15 | Andarilho lento; dá choque se atingido com espada | `Sprite_0D_Buzzblob` |
| Snapdragon | 0E | 12 | 3 | ~0.5 a 1 | Saltador em diagonal | `Sprite_0E_Snapdragon` |
| Hinox | 11 | 20 | 3 | ~0.5 | Andarilho; arremessa bombas | `Sprite_11_Hinox` |
| Moblin | 12 | 4 | 2 | ~0.5 | Andarilho e atirador (lança) | `Sprite_12_Moblin` |
| Mini Helmasaur | 13 | 4 | 1 | ~1 | Investida; blindado na frente | `Sprite_13_MiniHelmasaur` |
| Antifada (Bubble) | 15 | invulnerável | 1 | ~1 | Armadilha; quica em diagonal nas paredes | `Sprite_15_Antifairy` |
| Hoarder | 17 | 2 | 0 | ~0.75 a 1 | Foge quando o Link chega; solta rupias | `Sprite_17_Hoarder` |
| Mini Moldorm | 18 | 3 | 1 | ~0.5 a 1 | Andarilho em curvas | `Sprite_18_MiniMoldorm` |
| Poe | 19 | 8 | 2 | ~0.5 a 1 | Voador; atravessa paredes em direção ao Link | `Sprite_19_Poe` |
| Ropa | 22 | 8 | 2 | ~1 | Saltador; pula em direção ao Link | `Sprite_22_Ropa` |
| Bari vermelho | 23 | 2 | 1 | ~0.5 a 1 | Voador e divisor (vira 2 mini Bari); choque | `Sprite_23_RedBari` |
| Bari azul | 24 | 2 | 1/2 | ~0.5 a 1 | Voador; choque | `Sprite_23_RedBari` |
| Besouro capacete (Hardhat Beetle) | 26 | 6 ou 32 | 1 (com 6 de vida) ou 2 (com 32) | ~0.5 | Andarilho; empurra o Link (para buracos) | `Sprite_26_HardhatBeetle` |
| Deadrock | 27 | invulnerável | 1 | ~2 | Andarilho; vira pedra ao ser atingido | `Sprite_27_Deadrock` |
| Geldman | 4C | 4 | 1 | ~1 | Emboscada na areia, persegue | `Sprite_4C_Geldman` |
| Popo | 4E | 2 | 1/2 | lento | Andarilho | `Sprite_4E_Popo` |
| Estátua Armos | 51 | 8 | 1/2 | ~0.75 | Emboscada; desperta ao toque e pula atrás do Link | `Sprite_51_ArmosStatue` |
| Caranguejo | 58 | 2 | 2 | ~0.75 | Andarilho de lado | `Sprite_58_Crab` |
| Faísca (Spark) | 5B | invulnerável | 1 | ~1 | Armadilha; contorna as paredes | `Sprite_5B_Spark_Clockwise` |
| Rolo de espinhos (Roller) | 5D | invulnerável | 3 | 1 | Armadilha; rola de parede a parede | `Sprite_5D_Roller_VerticalDownFirst` |
| Beamos | 61 | invulnerável | 1 | laser 7 | Torre; gira e dispara laser ao ver o Link | `Sprite_61_Beamos` |
| Leever | 71 | 4 | 1/2 | ~1 | Emboscada na areia, persegue | `Sprite_71_Leever` |
| Stalfos | A7 | 4 | 1/2 | pulo 1 a 2 | Saltador | `Sprite_A7_Stalfos` |
| Stalfos amarelo | 85 | 8 | 1/2 | ~1 | Emboscada; cai do teto | `Sprite_85_YellowStalfos` |
| Firebar (barra de fogo) | 7E | invulnerável | 1 | gira | Armadilha; barra de fogo girando | `Sprite_7E_Firebar_Clockwise` |
| Hover | 81 | 4 | 1 | desliza | Voador lento na água | `Sprite_81_Hover` |
| Eyegore verde | 83 | 16 | 1 | ~1 | Blindado; vulnerável com o olho aberto | `Sprite_83_GreenEyegore` |
| Eyegore vermelho | 84 | 8 | 1 | ~1.5 | Blindado; só flechas | `Sprite_83_GreenEyegore` |
| Kodongo | 86 | 0 na tabela | 1 | ~1.5 | Andarilho; cospe fogo | `Sprite_86_Kodongo` |
| Bloco de espinhos (Spike Block) | 8A | 32 na tabela | 1 | 1 a 2 | Armadilha; desliza num eixo | `Sprite_8A_SpikeBlock` |
| Gibdo | 8B | 32 | 2 | ~1 | Perseguidor lento | `Sprite_8B_Gibdo` |
| Terrorpin | 8E | 8 | 1 | ~0.5 a 0.75 | Blindado; só depois de virado pelo martelo | `Sprite_8E_Terrorpin` |
| Zol (Blob) | 8F | 4 | 2 | ~1 | Emboscada (cai do teto) e saltador | `Sprite_8F_Blob` |
| Wallmaster | 90 | 8 | 1/4 | cai | Emboscada; agarra e leva o Link de volta à entrada | `Sprite_90_Wallmaster` |
| Pirogusu | 94 | 2 | 2 | ~1.5 | Investida | `Sprite_94_Pirogusu` |
| Pengator | 99 | 16 | 2 | ~0.75 | Investida deslizando no gelo | `Sprite_99_Pengator` |
| Kyameron | 9A | 4 | 1 | 2 | Armadilha; gota que quica e estoura | `Sprite_9A_Kyameron` |
| Wizzrobe | 9B | 2 | 4 | raio 2 | Atirador; aparece, atira e some | `Sprite_9B_Wizzrobe` |
| Zoro | 9C | 4 | 2 | 2 | Voador em bando | `Sprite_9C_Zoro` |
| Freezor | A1 | 16 | 4 | ~1 | Emboscada na parede; só fogo | `Sprite_A1_Freezor` |
| Zazak azul | A5 | 4 | 2 | 1 | Andarilho; cospe fogo | `Sprite_Zazak_Main` |
| Zazak vermelho | A6 | 8 | 2 | 1 | Andarilho; cospe fogo | `Sprite_Zazak_Main` |
| Zirro verde | A8 | 4 | 2 | ~0.75 | Voador; ataca de cima | `Sprite_A8_GreenZirro` |
| Zirro azul | A9 | 8 | 1 | ~0.75 | Voador; ataca de cima | `Sprite_A8_GreenZirro` |
| Pikit | AA | 12 | 2 | pulo ~0.5 | Saltador; rouba itens com a língua | `Sprite_AA_Pikit` |
| Pokey | C7 | 32 | 4 | ~1 | Andarilho | `Sprite_C7_Pokey` |
| Tektite | C9 | 8 | 2 | pulo 1 a 2 | Saltador | `Sprite_C9_Tektite` |
| Chain Chomp | CA | 5 na tabela | 4 | bote 4 | Torre presa por corrente; dá botes | `Sprite_CA_ChainChomp` |
| Lynel | D0 | 24 | 4 | ~1 | Perseguidor e atirador (fogo) | `Sprite_D0_Lynel` |
| Stal | D3 | 4 | 1 | ~0.75 | Emboscada (crânio no chão) | `Sprite_D3_Stal` |
| Medusa (estátua) | C5 | 0 na tabela (estátua, não é atacável) | contato 1/4; a bola de fogo é outro sprite | bola ~1.5 | Torre; dispara bolas de fogo | `Sprite_C5_Medusa` |
| Canhão de parede | 66 | invulnerável | bala 1/2 (sprite 50) | bala ~0.5 | Torre; atira balas de canhão | `Sprite_66_WallCannonVerticalLeft` |

## Chefes

Vida da tabela de inicialização. Os chefes têm vulnerabilidade própria (veja Lacunas), então não divida a vida pelo dano da espada para estimar os golpes.

| Chefe | id | Vida | Dano | Padrão | Música e sons | Função |
|-------|----|------|------|--------|---------------|--------|
| Cavaleiros Armos (6) | 53 | 48 cada | 1/2 | Pulam em formação; o último fica vermelho e pula sobre o Link | `Music_Boss_*`; tremor ao cair | `Sprite_53_ArmosKnight` |
| Lanmolas (3) | 54 | 16 cada | 1 | Saem da areia em arco, soltam pedras ao mergulhar | areia e tremor | `Sprite_54_Lanmolas` |
| Moldorm | 09 | 12 | 1 | Anda em curvas, acelera; só a cauda é vulnerável; joga o Link para o andar de baixo | `Sound_MoldormSkitter` | `Sprite_09_GiantMoldorm` |
| Agahnim | 7A | 96 | 1 | Teleporta, bolas de energia (rebater com a espada), relâmpagos; cópias na segunda luta | `Sound_AghanimCharge`, `Sound_AghanimEnergyBeam` | `Sprite_7A_Agahnim` |
| Helmasaur King | 92 | 48 | 2 | Máscara quebra com bombas e martelo; cauda; bolas de fogo | | `Sprite_92_HelmasaurKing` |
| Arrghus | 8C | 32 (13 Arrghi de 8) | 2 | Puxar os Arrghi com o gancho; depois quica | | `Sprite_8C_Arrghus` |
| Mothula | 88 | 32 | 2 | Voa, raios; chão com esteiras e espinhos | | `Sprite_88_Mothula` |
| Blind | CE | 90 | 2 | Precisa da luz do teto aberto; a cabeça se solta e voa disparando | | `Sprite_CE_Blind` |
| Kholdstare | A2 | 64 (casca 64) | 4 | Casca de gelo derrete com fogo; olhos se dividem | | `Sprite_A2_Kholdstare` |
| Vitreous | BD | 128 (olhos 48) | 4 | Olhos saem do pântano; raios | | `Sprite_BD_Vitreous` |
| Trinexx | CB | 40 por cabeça | 4 | Cabeças de fogo e gelo, depois o corpo | | `Sprite_CB_TrinexxRockHead` |
| Ganon | D6 | invulnerável | 8 | Tridente, morcegos de fogo, escuridão; termina com flecha de prata | `Music_Boss_Final_*` | `Sprite_D6_Ganon` |

## Itens

| Item | O que faz | Números | No DoI (`ItemClass`) |
|------|-----------|---------|----------------------|
| Espada (4 níveis) | Golpe, giratório (segurar), raio com vida cheia a partir da Master Sword | dano 2, 4, 8, 16 | `Sword` (6 níveis: Basic, Steel, Long, Dragon, Blood, Master; só a Master tem raio) |
| Escudo (3 níveis) | Bloqueia projéteis de frente: pedras e flechas; o de fogo, bolas de fogo; o espelhado, lasers | | `Shield` (Wooden, Triforce, Mirror, Golden) |
| Túnica (verde, azul, vermelha) | Reduz o dano recebido | tabela de armaduras acima | `Tunic` |
| Botas de Pégaso | Corrida em linha; derruba coisas ao bater | | |
| Luva e luva de titã | Levanta pedras leves e pesadas | | `Gloves` (3 níveis) |
| Nadadeiras | Nadar em águas fundas | | |
| Pérola da Lua | Mantém a forma de Link no Mundo das Trevas | | `MoonPearl` |
| Arco e flechas de prata | Projétil em linha | flecha 4, prata 100 | `Bow` (normal e triplo), `Arrows`, `ArrowQuiver` |
| Bumerangue (azul, vermelho) | Atordoa e busca itens; o vermelho vai mais longe e mais rápido | dano 1 | `Boomerang` (atira em 8 direções) |
| Gancho (Hookshot) | Puxa o Link até blocos e baús; atordoa | | `Hookshot` |
| Bombas | Explodem paredes rachadas e inimigos | dano 4 | `Bombs`, `BombBag` |
| Lanterna | Acende tochas e ilumina | 4 de magia | `Lamp` (vela e lampião) |
| Pó mágico | Transforma alguns inimigos | 8 de magia | `Powder` |
| Martelo | Dano alto; afunda estacas, vira cascos | dano 8 | |
| Bastão de fogo | Bola de fogo; acende tochas | dano 8, 16 de magia | `Rod` (Fire) |
| Bastão de gelo | Raio que congela | dano 8, 16 de magia | `Rod` (Ice) |
| Bengala de Somaria | Cria um bloco | 8 de magia | |
| Bengala de Byrna | Escudo giratório de invulnerabilidade | gasta magia enquanto ativo | |
| Capa mágica | Invisível e intocável | gasta magia enquanto ativa | `Cape` |
| Espelho mágico | Volta do Mundo das Trevas | | `Mirror` |
| Medalhões (Bombos, Ether, Quake) | Ataque de tela inteira; abrem entradas | 32 de magia | `Medallion` (só Bombos) |
| Livro de Mudora | Lê inscrições antigas | | (o `Book` do DoI é outro livro, da vila) |
| Garrafa | Guarda poção, fada ou abelha | | `Potion` |
| Poções (vermelha, verde, azul) | Vida, magia, os dois | | `Potion` (mais antídoto e Lon Lon Milk) |
| Fada | Revive com 7 corações quando a vida acaba | | `Fairy` |
| Coração, pedaço de coração | Recupera um coração; quatro pedaços formam um coração | | `Heart`, `HeartPiece` (no DoI aparece como Heart Container) |

Itens do DoI sem equivalente no ALttP (vindos de Minish Cap ou próprios): `Kinstone`, `Gem`, `WishStone`, `Coupon`, `Food`, `Pop`, `Ring` (converte magia), `Orb`, `Pendant` (equipável, com efeito), `Star`, `Stopwatch`, `MasterKey`, `Letter`, `Cane` (Rupees, Bombs, Hearts) e os bastões Stone, Bombs, Hearts e Wealth.
