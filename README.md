# Lab — Engenharia de Dados e Persistência

Este repositório faz parte de um conjunto de **laboratórios técnicos**
voltados à **engenharia de dados e persistência em aplicações Java**.

O objetivo deste lab é demonstrar, de forma prática e reproduzível,
**decisões arquiteturais envolvendo banco de dados, ORM e acesso a dados**,
explorando trade-offs reais de performance, responsabilidade e manutenção.

## 🎯 Propósito do Lab

Este lab existe para provar:

- Domínio de banco de dados em cenários reais
- Uso consciente de ORM (JPA / Hibernate)
- Capacidade de decidir entre lógica no banco ou na aplicação
- Análise crítica de impacto de volume, custo e arquitetura

> O foco **não é framework**, mas **engenharia**.

## 🧱 Estrutura Geral

- Repositório único representando o lab
- Cada experimento isolado em uma **POC**
- Cada POC executável via `main` ou contexto simples
- Código voltado à **observação de comportamento**, não abstração excessiva
- README curto explicando a intenção e o trade-off de cada POC

## 🧪 Tipos de POCs abordadas neste Lab

As POCs deste repositório exploram temas como:

- Banco vs aplicação (WHERE no SQL vs filtro em memória)
- ORM: quando ajuda e quando atrapalha
- JDBC e SQL explícito
- Views e outros artefatos de banco
- Impacto de volume de dados e ausência de índices
- Responsabilidade arquitetural e custo oculto

Cada POC busca responder **uma pergunta técnica clara**, com execução prática
e análise objetiva dos resultados.

## 🚫 O que este Lab NÃO é

- Não é tutorial de JPA, Hibernate ou Spring
- Não é benchmark acadêmico
- Não é código de produção

Este repositório é um **laboratório de decisão técnica**,
voltado a aprendizado profundo e comunicação clara de trade-offs.
