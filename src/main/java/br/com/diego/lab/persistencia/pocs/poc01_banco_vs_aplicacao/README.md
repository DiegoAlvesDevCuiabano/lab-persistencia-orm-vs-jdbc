# POC01 — Banco vs Aplicação

## Acesso e filtragem de dados em diferentes volumes

Este laboratório avalia **estratégias de acesso e filtragem de dados em diferentes volumes**, comparando decisões de arquitetura comuns em sistemas Java:

* ORM com filtro aplicado **na aplicação**
* ORM com filtro aplicado **no banco**
* JDBC puro
* VIEW no banco

⚠️ **Escopo:**
Este experimento avalia **apenas consultas (`SELECT`)**.
Cenários de `INSERT`, `UPDATE` e `DELETE` **não foram testados**.

---

## Objetivo

Demonstrar, de forma prática, **onde cada abordagem faz sentido**, seus **trade-offs reais** e os **riscos escondidos** que surgem quando o volume cresce.

Um objetivo adicional é evidenciar **problemas arquiteturais comuns que passam despercebidos em ambientes pequenos**, especialmente quando código é **copiado ou gerado automaticamente (incluindo por LLMs) sem entendimento completo do impacto de escala**.

---

## Stack utilizada

* Java 21
* Spring Boot 3.5.9
* JPA / Hibernate 6.6
* JdbcTemplate
* MySQL 8.4 (Docker)
* Flyway 11.7

---

## Estrutura do experimento

Foram criados três volumes de dados, com distribuição controlada:

| Volume | Registros totais | Ativos (~70%) |
|--------|------------------|---------------|
| 50k    | 50.000          | 35.000        |
| 500k   | 500.000         | 350.000       |
| 5kk    | 5.000.000       | 3.500.000     |

Em todos os cenários, o critério lógico é o mesmo (`ativo = true`).
O que varia é **onde o filtro acontece** e **como os dados são materializados na aplicação**.

---

## Resultados

### 50k registros
```
ORM sem filtro       -> 751ms
ORM com filtro       -> 440ms
JDBC                 -> 224ms
VIEW                 -> 222ms
```

### 500k registros
```
ORM sem filtro       -> 4,95s
ORM com filtro       -> 3,39s
JDBC                 -> 2,14s
VIEW                 -> 2,12s
```

### 5kk registros
```
ORM sem filtro       -> 53,27s
ORM com filtro       -> 36,70s
JDBC                 -> 22,75s
VIEW                 -> 27,72s
```

---

## Análise dos cenários

### ❌ Cenário A — ORM sem filtro (anti-pattern)

* Busca todos os registros no banco (`findAll`)
* Filtro aplicado em memória
* Grande volume de dados trafegando desnecessariamente

**Status: Nunca usar**

Este padrão costuma **passar despercebido em ambientes de desenvolvimento**, onde:

* o volume de dados é pequeno
* a instância do banco é mais simples
* a aplicação atende poucos usuários

Nesses cenários, o custo de trazer todos os dados para a aplicação não se manifesta de forma clara.

O problema surge quando o sistema escala ou é executado em ambientes mais robustos (HMG/PROD), com:

* maior volume de dados
* mais concorrência
* mais memória disponível no banco

Nesse ponto, o custo de materialização em memória passa a ser o gargalo principal e o problema "explode".

Esse cenário é comum em código copiado sem análise arquitetural, inclusive código gerado por IA que "funciona" em DEV, mas falha ao escalar.

---

### ✅ Cenário B — ORM com filtro correto

* Filtro aplicado no banco via JPA
* Entidades completas
* Objetos prontos para manipulação

**Status: Melhor custo-benefício geral**

Não à toa, **é o padrão recomendado para a maioria dos casos**.
Equilibra legibilidade, manutenabilidade e performance previsível mesmo em volumes grandes.

---

### ⚠️ Cenário C — JDBC puro

* SQL explícito
* Filtro no banco
* Materialização manual via `RowMapper`
* Mesmo shape de dados do ORM

**Status: Otimização consciente**

Aqui entra explicitamente o trade-off:

> **manutenibilidade vs performance**

O JDBC elimina o custo estrutural do ORM (gerenciamento de entidades, dirty checking, cache de primeiro nível) e, por isso, apresenta melhor performance em grandes volumes.
Em contrapartida, o código se torna mais verboso e mais caro de manter.

**Faz sentido quando há:**

* pouca ou nenhuma manipulação posterior dos dados
* leitura bruta para exportação
* geração direta de JSON
* integrações simples
* relatórios

**O ponto crítico:** JDBC é mais rápido **na busca**, mas se você precisar **manipular esses dados depois** (aplicar regras de negócio, enriquecer objetos, fazer cálculos), o ganho desaparece.

Com ORM, você já tem objetos prontos com comportamento encapsulado.
Com JDBC, você precisa construir tudo manualmente - e aí o tempo economizado na query é perdido no código.

**A pergunta não é "qual é mais rápido".**
**É "o que eu vou fazer com esses dados depois".**

---

### ⚠️ Cenário D — VIEW no banco

* Acesso via JdbcTemplate
* Mesmo shape de dados do JDBC
* Execução semelhante ao SQL direto

**Status: Decisão arquitetural**

A VIEW é, na prática, **um JDBC executado no banco**.
O custo computacional é equivalente ao JDBC direto, com variações marginais devido a warming do buffer pool.

O diferencial **não é performance**, mas **arquitetura**:

* menos código na aplicação
* regra deslocada para o banco
* impacto direto em governança e versionamento

**Valor específico em cenários multi-base:**

Em ambientes com múltiplas bases ou schemas (DEV/HOM/PROD, multi-tenant), a VIEW elimina a necessidade de:

* SQL condicional no código (`if (ambiente == PROD)`)
* Sinônimos de banco
* Lógica de roteamento por ambiente

A view centraliza essa complexidade no banco, mantendo o código da aplicação estável.

**Faz sentido para:**

* relatórios
* integrações diretas via banco
* acessos por perfis específicos
* ambientes com múltiplos schemas

**Deve ser usada conscientemente, pois transfere complexidade da aplicação para o banco.**

---

## Análise comparativa

### Performance absoluta (5kk registros)

| Estratégia | Tempo | Comparado ao baseline |
|------------|-------|-----------------------|
| ORM sem filtro | 53,27s | **+45% vs ORM com filtro** |
| ORM com filtro | 36,70s | Baseline |
| JDBC | 22,75s | **-38% vs baseline** |
| VIEW | 27,72s | **-24% vs baseline** |

### Principais conclusões

1. **Filtro em memória é erro arquitetural**
    - Escala de forma extremamente ruim
    - Pode ser quase 2,4x mais lento que JDBC

2. **ORM bem utilizado resolve a maioria dos sistemas**
    - Código limpo
    - Manutenção simples
    - Objetos prontos para uso
    - Performance previsível

3. **JDBC ganha por eliminar custo estrutural**
    - Sem contexto de persistência
    - Sem gerenciamento de entidades
    - Menos overhead de abstração
    - **Mas cobra em verbosidade e risco se houver manipulação posterior**

4. **VIEW reforça o trade-off arquitetural**
    - Performance equivalente ao JDBC
    - Menos código na aplicação
    - Mais responsabilidade no banco
    - Útil em cenários multi-ambiente

---

## Limitações do experimento

* Execuções realizadas de forma sequencial no mesmo ambiente
* MySQL 8+ não possui Query Cache, mas utiliza Buffer Pool e cache do sistema operacional
* Dados já acessados permanecem em memória
* Warming do buffer pool pode influenciar execuções subsequentes

Este experimento **não tem caráter de benchmark científico**, mas sim comparativo e didático.
O efeito de cache impacta todos os cenários de forma semelhante e não invalida as conclusões relativas aos custos de materialização e abstração.

---

## Conclusão final

O principal custo observado **não está no banco**, mas **na forma como os dados são materializados e utilizados pela aplicação**.

* ORM cobra por entregar objetos prontos e consistentes
* JDBC elimina esse custo na busca, mas transfere responsabilidade para o código
* VIEW desloca essa responsabilidade para o banco

**A decisão correta depende do uso posterior dos dados, não apenas da consulta:**

* **Pouca ou nenhuma manipulação:** JDBC ou VIEW
* **Manipulação complexa e regra de negócio:** JPA
* **Filtro em memória:** nunca

---

## Próximas POCs

* **POC02 — Índices:** impacto de índices simples e compostos
* **POC03 — Custo de construção:** quando o ganho do JDBC se perde ao manipular dados

---

## Mensagem final

> Abstração tem custo.
> Performance sem contexto vira dívida técnica.
> Medir antes de decidir é engenharia.