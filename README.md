# Lab — Persistência: ORM vs JDBC vs Banco

Este laboratório explora, na prática, diferentes estratégias de acesso a dados
em aplicações Java, comparando **ORM**, **JDBC** e **artefatos de banco**.

O objetivo é observar **impactos reais de performance** e discutir
**responsabilidades arquiteturais**, variando o volume de dados e mantendo
o mesmo cenário funcional.

## O que é avaliado

- ORM buscando todos os registros e filtrando em memória
- ORM aplicando filtro diretamente no banco
- JDBC com SQL direto
- JDBC consumindo uma VIEW no banco

Os cenários são executados com volumes crescentes de dados,
sem uso de índices, para evidenciar trade-offs reais.

> Este repositório faz parte de uma série de laboratórios focados em
> decisões técnicas e arquitetura, não em tutoriais de framework.
